import 'dart:async';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../state/consultation_step_states.dart';
import 'consultation_step_cubit.dart';

const _overrideReasonRequired = 'OverrideReasonRequired';

/// The backend's `NutritionalCare:DefaultTargetParameters`.
const _defaultDeficit = '500';
const _defaultProteinPerKg = '1.6';
const _defaultFatPercent = '30';

/// Step 3, calculated targets. Calculated automatically from the baseline and the measurement (default parameters).
/// "Change parameters" recalculates the same draft; "Accept targets" prescribes them as is; "Enter my own values"
/// requires a reason (`OverrideReasonRequired`). On resume with targets already calculated, nothing is recalculated.
class TargetsStepCubit extends ConsultationStepCubit<TargetsState> {
  TargetsStepCubit(
    GetConsultationInProgressUseCase getInProgress,
    this._proposeTargets,
    this._prescribeTargets,
    ConnectivityObserver connectivity, {
    required super.patientId,
  }) : super(const TargetsState(), getInProgress, connectivity) {
    unawaited(_load());
  }

  final ProposeConsultationTargetsUseCase _proposeTargets;
  final PrescribeConsultationTargetsUseCase _prescribeTargets;

  /// The last failure (recalculate or prescribe), for "Retry".
  void Function()? _lastAttempt;

  @override
  void onConnectivityChanged(bool online) {
    emit(state.copyWith(load: state.load.copyWith(isOffline: !online)));
    if (online && state.load.loadFailed) unawaited(_load());
  }

  void onRetry() {
    if (consultation == null) {
      unawaited(_load());
    } else {
      _calculate(null);
    }
  }

  // ----- "Change parameters" -----

  void onChangeParameters() {
    final basis = state.proposal?.basis;
    emit(
      state.copyWith(
        showParameters: true,
        parametersInvalid: false,
        parameters:
            state.parameters ??
            ParametersForm(
              equation: basis?.equation ?? EnergyEquation.mifflinStJeor,
              deficitKind: basis?.deficitKind ?? DeficitKind.fixedKcal,
              deficit: basis == null ? _defaultDeficit : formFormat(basis.deficitValue),
              proteinPerKg: _defaultProteinPerKg,
              fatPercent: _defaultFatPercent,
            ),
      ),
    );
  }

  void onParametersChange(ParametersForm form) => emit(state.copyWith(parameters: form, parametersInvalid: false));

  void onParametersDismissed() => emit(state.copyWith(showParameters: false));

  void onApplyParameters() {
    final form = state.parameters;
    if (form == null) return;
    final parameters = _toParameters(form);
    if (parameters == null) {
      emit(state.copyWith(parametersInvalid: true));
      return;
    }
    emit(state.copyWith(showParameters: false));
    _calculate(parameters);
  }

  // ----- "Accept targets" -----

  void onAccept() {
    final current = consultation;
    if (current == null) return;
    final saved = current.targets;
    if (saved != null && saved.prescribed != null && !saved.isOverridden && saved.proposal == state.proposal?.proposal) {
      sendEvent(const StepContinue());
      return;
    }
    _prescribe(const AcceptedAsProposed());
  }

  // ----- "Enter my own values" -----

  void onWriteOwnValues() {
    final proposal = state.proposal?.proposal;
    emit(
      state.copyWith(
        showOverride: true,
        overrideProblems: const {},
        ownValues: state.ownValues == const OverrideForm() && proposal != null
            ? OverrideForm(
                energy: wholeFormat(proposal.energyKcal),
                protein: wholeFormat(proposal.proteinG),
                carb: wholeFormat(proposal.carbG),
                fat: wholeFormat(proposal.fatG),
              )
            : state.ownValues,
      ),
    );
  }

  void onOverrideChange(OverrideForm form) => emit(
    state.copyWith(
      ownValues: form,
      overrideProblems: {
        for (final field in state.overrideProblems)
          if (!_isFilledIn(field, form)) field,
      },
    ),
  );

  void onOverrideDismissed() => emit(state.copyWith(showOverride: false));

  void onSaveOverride() {
    final form = state.ownValues;
    switch (validateOverride(
      energy: form.energy,
      protein: form.protein,
      carb: form.carb,
      fat: form.fat,
      reason: form.reason,
    )) {
      case InvalidOverride(:final problems):
        emit(state.copyWith(overrideProblems: problems));
      case ValidOverride(:final prescription):
        _prescribe(prescription);
    }
  }

  void onSaveFailureDismissed() => emit(state.copyWith(saveFailure: null));

  void onRetrySave() {
    emit(state.copyWith(saveFailure: null));
    _lastAttempt?.call();
  }

  void _prescribe(TargetPrescription prescription) {
    if (consultation == null || state.isSaving) return;
    _lastAttempt = () => _prescribe(prescription);
    unawaited(_doPrescribe(prescription));
  }

  Future<void> _doPrescribe(TargetPrescription prescription) async {
    final current = consultation!;
    emit(state.copyWith(isSaving: true));
    final result = await _prescribeTargets(current.id, prescription);
    if (isClosed) return;
    emit(state.copyWith(isSaving: false));
    final updated = result.valueOrNull;
    final error = result.errorOrNull;
    if (updated != null) {
      consultation = updated;
      emit(state.copyWith(showOverride: false));
      sendEvent(const StepContinue());
    } else if (closesConsultation(error)) {
      sendEvent(const StepConsultationClosed());
    } else if (error == const Validation(_overrideReasonRequired)) {
      emit(state.copyWith(showOverride: true, overrideProblems: const {OverrideField.reason}));
    } else if (error == const Validation(stepOutOfOrder)) {
      sendEvent(const StepBack());
    } else {
      emit(state.copyWith(saveFailure: SaveFailure(isNetwork: error is Network)));
    }
  }

  void _calculate(TargetParameters? parameters) {
    if (consultation == null) return;
    _lastAttempt = () => _calculate(parameters);
    unawaited(_doCalculate(parameters));
  }

  Future<void> _doCalculate(TargetParameters? parameters) async {
    final current = consultation!;
    emit(state.copyWith(isCalculating: true, proposalFailed: false));
    final result = await _proposeTargets(current.id, parameters);
    if (isClosed) return;
    final error = result.errorOrNull;
    final hadProposal = state.proposal != null;
    emit(
      state.copyWith(
        isCalculating: false,
        proposal: result.valueOrNull ?? state.proposal,
        proposalFailed: result.isFailure && !hadProposal,
        // With a proposal on screen a failed recalculation is a notice, and the proposal stays.
        saveFailure: result.isFailure && hadProposal && !closesConsultation(error)
            ? SaveFailure(isNetwork: error is Network)
            : state.saveFailure,
      ),
    );
    if (closesConsultation(error)) {
      sendEvent(const StepConsultationClosed());
    } else if (error == const Validation(stepOutOfOrder)) {
      sendEvent(const StepBack());
    }
  }

  Future<void> _load() async {
    emit(state.copyWith(load: state.load.copyWith(isLoading: true, loadFailed: false)));
    final result = await readInProgress();
    if (isClosed) return;
    if (result.isFailure) {
      emit(
        state.copyWith(
          load: state.load.copyWith(
            isLoading: false,
            loadFailed: true,
            isOffline: state.load.isOffline || result.errorOrNull is Network,
          ),
        ),
      );
      return;
    }
    final inProgress = result.valueOrNull;
    if (inProgress == null) return;
    final measurement = inProgress.measurement;
    if (measurement == null || inProgress.diagnosis == null) {
      sendEvent(const StepBack());
      return;
    }
    consultation = inProgress;
    emit(state.copyWith(load: state.load.copyWith(isLoading: false, loadFailed: false)));
    final saved = inProgress.targets;
    if (saved != null) {
      // Resume: shows the targets already calculated (the prescribed draft cannot be recalculated).
      emit(
        state.copyWith(
          proposal: TargetProposal(
            basis: saved.basis,
            proposal: saved.proposal,
            inputs: TargetInputs(
              sex: measurement.sex,
              ageYears: measurement.ageYears,
              heightCm: measurement.heightCm,
              weightKg: measurement.weightKg,
              activityLevel: measurement.activityLevel,
            ),
          ),
        ),
      );
    } else if (state.proposal == null) {
      _calculate(null);
    }
  }

  TargetParameters? _toParameters(ParametersForm form) {
    final deficit = DecimalText.parse(form.deficit);
    final protein = DecimalText.parse(form.proteinPerKg);
    final fat = DecimalText.parse(form.fatPercent);
    if (deficit == null || protein == null || fat == null) return null;
    final valid =
        deficit >= 0 &&
        deficit <= form.deficitKind.maximum &&
        protein >= TargetParameters.proteinMin &&
        protein <= TargetParameters.proteinMax &&
        fat >= TargetParameters.fatMin &&
        fat <= TargetParameters.fatMax;
    if (!valid) return null;
    return TargetParameters(
      equation: form.equation,
      deficitKind: form.deficitKind,
      deficitValue: deficit,
      proteinGramsPerKg: protein,
      fatPercentOfEnergy: fat,
    );
  }

  static bool _isFilledIn(OverrideField field, OverrideForm form) => switch (field) {
    OverrideField.energy => form.energy.trim().isNotEmpty,
    OverrideField.protein => form.protein.trim().isNotEmpty,
    OverrideField.carb => form.carb.trim().isNotEmpty,
    OverrideField.fat => form.fat.trim().isNotEmpty,
    OverrideField.reason => form.reason.trim().isNotEmpty,
  };
}

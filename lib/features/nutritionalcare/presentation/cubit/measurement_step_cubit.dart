import 'dart:async';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/entity/patient_baseline.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../state/consultation_step_states.dart';
import 'consultation_step_cubit.dart';

const _implausibleMeasurement = 'ImplausibleMeasurement';

/// Step 1, today's measurement. Rehydrates what the in-progress consultation saved (resume) and reads the baseline for
/// the "Baseline" card and the live BMI (height is not asked again). If the input matches what is already saved,
/// "Continue to diagnosis" does not resend it: repeating step 1 would force redoing the diagnosis.
class MeasurementStepCubit extends ConsultationStepCubit<MeasurementState> {
  MeasurementStepCubit(
    GetConsultationInProgressUseCase getInProgress,
    this._getBaseline,
    this._recordMeasurement,
    this._discardConsultation,
    ConnectivityObserver connectivity, {
    required super.patientId,
  }) : super(const MeasurementState(), getInProgress, connectivity) {
    unawaited(_load());
  }

  final GetPatientBaselineUseCase _getBaseline;
  final RecordConsultationMeasurementUseCase _recordMeasurement;
  final DiscardConsultationUseCase _discardConsultation;

  double? _heightCm;

  @override
  void onConnectivityChanged(bool online) {
    emit(state.copyWith(load: state.load.copyWith(isOffline: !online)));
    // The load that failed for lack of a connection runs again when it is back.
    if (online && state.load.loadFailed) unawaited(_load());
  }

  void onRetry() => unawaited(_load());

  /// After editing the baseline it is reread (height changes the BMI).
  Future<void> onResume() async {
    if (consultation == null) return;
    final baseline = (await _getBaseline(patientId)).valueOrNull;
    if (baseline != null && !isClosed) _applyBaseline(baseline);
  }

  void onWeightChange(String text) => _updateForm(MeasurementField.weight, (form) => form.copyWith(weight: text));
  void onWaistChange(String text) => _updateForm(MeasurementField.waist, (form) => form.copyWith(waist: text));
  void onBodyFatChange(String text) => _updateForm(MeasurementField.bodyFat, (form) => form.copyWith(bodyFat: text));
  void onMealsPerDayChange(String text) =>
      _updateForm(MeasurementField.mealsPerDay, (form) => form.copyWith(mealsPerDay: text));
  void onWaterChange(String text) => _updateForm(MeasurementField.water, (form) => form.copyWith(waterLiters: text));
  void onMealsOutChange(String text) => _updateForm(MeasurementField.mealsOut, (form) => form.copyWith(mealsOut: text));
  void onGlucoseChange(String text) => _updateForm(MeasurementField.glucose, (form) => form.copyWith(glucose: text));
  void onCholesterolChange(String text) =>
      _updateForm(MeasurementField.cholesterol, (form) => form.copyWith(cholesterol: text));
  void onTriglyceridesChange(String text) =>
      _updateForm(MeasurementField.triglycerides, (form) => form.copyWith(triglycerides: text));

  void onProtocolToggle(ProtocolCheck check) => _updateForm(
    MeasurementField.protocol,
    (form) => form.copyWith(
      protocolChecks: form.protocolChecks.contains(check)
          ? ({...form.protocolChecks}..remove(check))
          : {...form.protocolChecks, check},
    ),
  );

  void onActivityChange(ActivityLevel level) =>
      _updateForm(MeasurementField.activity, (form) => form.copyWith(activityLevel: level));

  void onToggleHabits() => emit(state.copyWith(habitsExpanded: !state.habitsExpanded));

  void onToggleBiochemistry() => emit(state.copyWith(biochemistryExpanded: !state.biochemistryExpanded));

  /// "‹" on step 1 opens the exit dialog.
  void onBack() => emit(state.copyWith(showExitDialog: true));

  void onStay() => emit(state.copyWith(showExitDialog: false));

  /// "Exit and continue later": what is saved stays saved (each step persists on continue).
  void onExit() {
    emit(state.copyWith(showExitDialog: false));
    sendEvent(const StepExit());
  }

  void onSaveFailureDismissed() => emit(state.copyWith(saveFailure: null));

  /// "Delete consultation" trash can (opened by mistake): asks for confirmation first.
  void onDiscard() {
    if (consultation == null || state.isDiscarding) return;
    emit(state.copyWith(showDiscardDialog: true));
  }

  void onDiscardDismissed() => emit(state.copyWith(showDiscardDialog: false));

  void onDiscardFailureDismissed() => emit(state.copyWith(discardFailure: null));

  /// Confirmed: the consultation is discarded and it returns to the patient file.
  Future<void> onDiscardConfirmed() async {
    final current = consultation;
    if (current == null || state.isDiscarding) return;
    emit(state.copyWith(showDiscardDialog: false, discardFailure: null, isDiscarding: true));
    final result = await _discardConsultation(current.id);
    if (isClosed) return;
    emit(state.copyWith(isDiscarding: false));
    final error = result.errorOrNull;
    if (result.isSuccess) {
      sendEvent(const StepExit());
    } else if (closesConsultation(error)) {
      // It was no longer in progress (another device closed it): nothing to delete.
      sendEvent(const StepConsultationClosed());
    } else {
      emit(state.copyWith(discardFailure: SaveFailure(isNetwork: error is Network)));
    }
  }

  Future<void> onContinue() async {
    final current = consultation;
    if (current == null || state.isSaving) return;
    final MeasurementValidation validation = state.form.validate();
    final NewMeasurement measurement;
    switch (validation) {
      case InvalidMeasurement(:final problems):
        emit(
          state.copyWith(
            problems: problems,
            habitsExpanded: state.habitsExpanded || problems.keys.any(_isHabitField),
            biochemistryExpanded: state.biochemistryExpanded || problems.keys.any(_isLabField),
          ),
        );
        return;
      case ValidMeasurement(measurement: final valid):
        measurement = valid;
    }
    final saved = current.measurement;
    if (saved != null && measurement.sameAs(saved)) {
      sendEvent(const StepContinue());
      return;
    }
    emit(state.copyWith(isSaving: true, problems: const {}));
    final result = await _recordMeasurement(current.id, measurement);
    if (isClosed) return;
    emit(state.copyWith(isSaving: false));
    final updated = result.valueOrNull;
    final error = result.errorOrNull;
    if (updated != null) {
      consultation = updated;
      sendEvent(const StepContinue());
    } else if (closesConsultation(error)) {
      sendEvent(const StepConsultationClosed());
    } else if (error == const Validation(_implausibleMeasurement)) {
      emit(state.copyWith(problems: const {MeasurementField.weight: FieldProblem.outOfRange}));
    } else {
      emit(state.copyWith(saveFailure: SaveFailure(isNetwork: error is Network)));
    }
  }

  void _updateForm(MeasurementField field, MeasurementForm Function(MeasurementForm) change) {
    final form = change(state.form);
    emit(state.copyWith(form: form, problems: {...state.problems}..remove(field), bmi: _liveBmi(form.weight)));
  }

  /// BMI from the typed weight and the baseline height; `null` while the weight is invalid.
  double? _liveBmi(String weightText) {
    final height = _heightCm;
    if (height == null) return null;
    final weight = ClinicalRange.weightKg.parse(weightText);
    return weight is ValidNumber ? BodyMassIndex.of(weight.value, height).value : null;
  }

  Future<void> _load() async {
    emit(state.copyWith(load: state.load.copyWith(isLoading: true, loadFailed: false)));
    final baselineCall = _getBaseline(patientId);
    final result = await readInProgress();
    final baseline = (await baselineCall).valueOrNull;
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
    consultation = inProgress;
    if (baseline != null) _applyBaseline(baseline);
    final saved = inProgress.measurement;
    if (_heightCm == null && saved != null) _heightCm = saved.heightCm;
    final form = saved == null ? state.form : _toForm(saved);
    emit(
      state.copyWith(
        load: state.load.copyWith(isLoading: false, loadFailed: false),
        checkIn: inProgress.patientCheckIn,
        form: form,
        bmi: _liveBmi(form.weight),
        habitsExpanded: saved?.habits != null,
        biochemistryExpanded: saved?.biochemistry != null,
      ),
    );
  }

  void _applyBaseline(PatientBaseline baseline) {
    _heightCm = baseline.heightCm;
    emit(
      state.copyWith(
        baseline: BaselineSummary(
          sex: baseline.sex,
          ageYears: baseline.ageYears,
          heightCm: baseline.heightCm,
          conditions: baseline.conditions,
        ),
        bmi: _liveBmi(state.form.weight),
      ),
    );
  }

  MeasurementForm _toForm(ConsultationMeasurement saved) => MeasurementForm(
    weight: formFormat(saved.weightKg),
    waist: saved.waistCm == null ? '' : formFormat(saved.waistCm!),
    bodyFat: saved.bodyFatPercentage == null ? '' : formFormat(saved.bodyFatPercentage!),
    protocolChecks: saved.protocolChecks,
    activityLevel: saved.activityLevel,
    mealsPerDay: saved.habits?.mealsPerDay?.toString() ?? '',
    waterLiters: saved.habits?.waterLitersPerDay == null ? '' : formFormat(saved.habits!.waterLitersPerDay!),
    mealsOut: saved.habits?.mealsOutPerWeek?.toString() ?? '',
    glucose: saved.biochemistry?.glucoseMgDl == null ? '' : formFormat(saved.biochemistry!.glucoseMgDl!),
    cholesterol: saved.biochemistry?.totalCholesterolMgDl == null
        ? ''
        : formFormat(saved.biochemistry!.totalCholesterolMgDl!),
    triglycerides: saved.biochemistry?.triglyceridesMgDl == null
        ? ''
        : formFormat(saved.biochemistry!.triglyceridesMgDl!),
  );

  static bool _isHabitField(MeasurementField field) =>
      field == MeasurementField.mealsPerDay || field == MeasurementField.water || field == MeasurementField.mealsOut;

  static bool _isLabField(MeasurementField field) =>
      field == MeasurementField.glucose ||
      field == MeasurementField.cholesterol ||
      field == MeasurementField.triglycerides;
}

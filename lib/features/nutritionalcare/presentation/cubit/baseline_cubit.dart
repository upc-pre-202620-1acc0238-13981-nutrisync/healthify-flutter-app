import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../../domain/entity/patient_baseline.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../state/baseline_state.dart';

const _invalidBirthDate = 'InvalidBirthDate';
const _invalidHeight = 'InvalidHeight';

/// Baseline. The first time it is recorded (`POST`) and "Save and start consultation" goes straight to step 1; when
/// editing (from Summary or Record) it is preloaded and saved with `PUT`. Age comes from the phone clock.
class BaselineCubit extends Cubit<BaselineState> {
  BaselineCubit(
    this._getPatientBaseline,
    this._savePatientBaseline,
    this._startOrResumeConsultation,
    ConnectivityObserver connectivityObserver,
    this._now, {
    required this.patientId,
    required this.editing,
  }) : _alreadyRecorded = editing,
       super(BaselineState(editing: editing, isLoading: editing)) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (!isClosed) emit(state.copyWith(isOffline: !online));
    });
    if (editing) _prefill();
  }

  final GetPatientBaselineUseCase _getPatientBaseline;
  final SavePatientBaselineUseCase _savePatientBaseline;
  final StartOrResumeConsultationUseCase _startOrResumeConsultation;
  final DateTime Function() _now;
  final int patientId;
  final bool editing;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<BaselineEvent>();

  Stream<BaselineEvent> get events => _events.stream;

  /// If it is already recorded (editing, or an earlier `POST` that succeeded), it is saved with `PUT`.
  bool _alreadyRecorded;

  /// The last thing saved: a retry of "start consultation" does not resend it.
  NewBaseline? _saved;

  /// Whether the save that is running (or failed) was "Save and start", so "Retry" repeats that one and not the other.
  bool _startsConsultation = false;

  DateTime get _today {
    final now = _now();
    return DateTime(now.year, now.month, now.day);
  }

  void onBirthDateChange(DateTime date) {
    final today = _today;
    emit(
      state.copyWith(
        birthDate: date,
        ageYears: BirthDate.isPlausible(date, today) ? BirthDate.ageOn(date, today) : null,
        problems: {...state.problems}..removeAll({BaselineProblem.birthDateRequired, BaselineProblem.birthDateImplausible}),
      ),
    );
  }

  void onSexChange(BiologicalSex sex) =>
      emit(state.copyWith(sex: sex, problems: {...state.problems}..remove(BaselineProblem.sexRequired)));

  void onHeightChange(String text) => emit(
    state.copyWith(
      heightText: text,
      problems: {...state.problems}..removeAll({BaselineProblem.heightRequired, BaselineProblem.heightOutOfRange}),
    ),
  );

  void onConditionToggle(MedicalCondition condition) => emit(
    state.copyWith(
      conditions: state.conditions.contains(condition)
          ? ({...state.conditions}..remove(condition))
          : {...state.conditions, condition},
    ),
  );

  /// "Save and start consultation" (first time only).
  Future<void> onSaveAndStart() => _save(startConsultation: true);

  /// "Save and exit" (and "Save changes" when editing).
  Future<void> onSaveAndExit() => _save(startConsultation: false);

  void onSaveFailureDismissed() => emit(state.copyWith(saveFailed: false));

  Future<void> onRetrySave() {
    emit(state.copyWith(saveFailed: false));
    return _save(startConsultation: _startsConsultation);
  }

  Future<void> _save({required bool startConsultation}) async {
    if (state.isSaving) return;
    _startsConsultation = startConsultation;
    final validation = validateBaseline(
      birthDate: state.birthDate,
      sex: state.sex,
      heightText: state.heightText,
      conditions: state.conditions,
      today: _today,
    );
    final NewBaseline baseline;
    switch (validation) {
      case InvalidBaseline(:final problems):
        emit(state.copyWith(problems: problems));
        return;
      case ValidBaseline(baseline: final valid):
        baseline = valid;
    }
    emit(state.copyWith(isSaving: true, problems: const {}));
    if (_saved != baseline) {
      final result = await _savePatientBaseline(patientId, baseline, alreadyRecorded: _alreadyRecorded);
      if (isClosed) return;
      final error = result.errorOrNull;
      if (error != null) {
        emit(_withSaveError(state.copyWith(isSaving: false), error));
        return;
      }
      _alreadyRecorded = true;
      _saved = baseline;
    }
    if (!startConsultation) {
      emit(state.copyWith(isSaving: false));
      _events.emit(const BaselineSaved());
      return;
    }
    final consultation = await _startOrResumeConsultation(patientId);
    if (isClosed) return;
    emit(state.copyWith(isSaving: false));
    final started = consultation.valueOrNull;
    if (started != null) {
      _events.emit(ConsultationStarted(started.currentStep));
    } else {
      emit(state.copyWith(saveFailed: true));
    }
  }

  /// `400 InvalidBirthDate`/`InvalidHeight` flag their field; anything else is a notice with "Retry".
  BaselineState _withSaveError(BaselineState state, DomainError error) => switch (error) {
    Validation(:final code) when code == _invalidBirthDate => state.copyWith(
      problems: const {BaselineProblem.birthDateImplausible},
    ),
    Validation(:final code) when code == _invalidHeight => state.copyWith(
      problems: const {BaselineProblem.heightOutOfRange},
    ),
    _ => state.copyWith(saveFailed: true),
  };

  Future<void> _prefill() async {
    final baseline = (await _getPatientBaseline(patientId)).valueOrNull;
    if (isClosed) return;
    if (baseline == null) {
      // With no saved baseline (or unable to read it), it is recorded as the first time.
      _alreadyRecorded = false;
      emit(state.copyWith(isLoading: false));
      return;
    }
    emit(
      state.copyWith(
        isLoading: false,
        birthDate: baseline.birthDate,
        sex: baseline.sex,
        // The preloaded height is written the way the practitioner would ("168" or "168.5").
        heightText: NumberFormat('0.#', 'en').format(baseline.heightCm),
        conditions: baseline.conditions,
        ageYears: baseline.ageYears,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

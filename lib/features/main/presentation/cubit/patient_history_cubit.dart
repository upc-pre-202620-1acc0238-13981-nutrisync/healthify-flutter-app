import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import '../../../nutritionalcare/presentation/state/patient_tab_states.dart';
import '../state/patient_history_state.dart';

/// Record tab ("Historia"): the baseline (`GET baseline`), the clinical record (`GET record`: weight, BMI, targets,
/// adherence, active diagnosis, referrals and assessments) and the consultation in progress, read in parallel. Reread
/// on returning to the tab or from the baseline and when the connection comes back.
///
/// The record is a section of its own: if it cannot be read, the baseline still works. Tapping an assessment reads its
/// detail (`GET nutritional-assessments/{id}`) into a sheet.
class PatientHistoryCubit extends Cubit<PatientHistoryState> {
  PatientHistoryCubit(
    this._getPatientBaseline,
    this._getConsultationInProgress,
    this._getPractitionerRecord,
    this._getEvaluationDetail,
    ConnectivityObserver connectivityObserver, {
    required this.patientId,
  }) : super(const PatientHistoryState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (isClosed) return;
      final wasOffline = state.isOffline;
      emit(state.copyWith(isOffline: !online));
      if (online && wasOffline) _load();
    });
    _load();
  }

  final GetPatientBaselineUseCase _getPatientBaseline;
  final GetConsultationInProgressUseCase _getConsultationInProgress;
  final GetPractitionerRecordUseCase _getPractitionerRecord;
  final GetEvaluationDetailUseCase _getEvaluationDetail;
  final int patientId;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<PatientTabEvent>();
  int _loadId = 0;
  int _evaluationId = 0;
  int? _selectedAssessmentId;

  Stream<PatientTabEvent> get events => _events.stream;

  void onRetry() => _load();

  void onResume() {
    if (state.data != null) _load();
  }

  void onEditBaseline() => _events.emit(const OpenBaseline(editing: true));

  void onEvaluationSelected(int assessmentId) {
    _selectedAssessmentId = assessmentId;
    _loadEvaluation(assessmentId);
  }

  void onEvaluationRetry() {
    final id = _selectedAssessmentId;
    if (id != null) _loadEvaluation(id);
  }

  void onEvaluationDismissed() {
    // A reply that is still on its way finds a newer id and is dropped.
    _evaluationId++;
    _selectedAssessmentId = null;
    emit(state.copyWith(evaluationSheet: null));
  }

  Future<void> _loadEvaluation(int assessmentId) async {
    final id = ++_evaluationId;
    emit(state.copyWith(evaluationSheet: const EvaluationLoading()));
    final result = await _getEvaluationDetail(assessmentId);
    if (isClosed || id != _evaluationId) return;
    final detail = result.valueOrNull;
    emit(state.copyWith(evaluationSheet: detail == null ? const EvaluationFailed() : EvaluationLoaded(detail)));
  }

  Future<void> _load() async {
    final loadId = ++_loadId;
    emit(state.copyWith(isLoading: state.data == null, loadFailed: false));
    final (baseline, inProgress, record) = await (
      _getPatientBaseline(patientId),
      _getConsultationInProgress(patientId),
      _getPractitionerRecord(patientId),
    ).wait;
    if (isClosed || loadId != _loadId) return;
    final error = baseline.errorOrNull ?? inProgress.errorOrNull;
    if (error != null) {
      emit(
        state.copyWith(
          isLoading: false,
          // A refresh that fails keeps the last read.
          loadFailed: state.data == null,
          isOffline: state.isOffline || error is Network,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        isLoading: false,
        data: HistoryData(
          baseline: baseline.valueOrNull,
          record: record.valueOrNull ?? state.data?.record,
          recordFailed: record.isFailure,
          inProgress: inProgress.valueOrNull,
        ),
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

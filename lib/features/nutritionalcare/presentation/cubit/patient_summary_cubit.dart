import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../state/patient_tab_states.dart';

const _baselineRequired = 'BaselineRequired';

/// Summary tab. Not stored on the phone: offline and without a previous read in memory, it asks for a connection. It
/// reloads on returning to the tab ([onResume]), on returning from the baseline or the consultation and when the
/// connection comes back. The pinned button changes with what was read: "Record baseline data", "Continue consultation"
/// or "New consultation".
class PatientSummaryCubit extends Cubit<PatientSummaryState> {
  PatientSummaryCubit(
    this._getPatientSummary,
    this._startOrResumeConsultation,
    ConnectivityObserver connectivityObserver,
    this._now, {
    required this.patientId,
  }) : super(const PatientSummaryState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (isClosed) return;
      final wasOffline = state.isOffline;
      emit(state.copyWith(isOffline: !online));
      if (online && wasOffline) _load();
    });
    _load();
  }

  final GetPatientSummaryUseCase _getPatientSummary;
  final StartOrResumeConsultationUseCase _startOrResumeConsultation;
  final DateTime Function() _now;
  final int patientId;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<PatientTabEvent>();
  int _loadId = 0;

  Stream<PatientTabEvent> get events => _events.stream;

  void onRetry() => _load();

  /// The tab is visible again: refresh what is already on screen. Before the first read there is nothing to refresh.
  void onResume() {
    if (state.summary != null) _load();
  }

  /// The pinned button: no baseline -> baseline form; consultation in progress -> its step; otherwise starts one.
  void onPrimaryAction() {
    final summary = state.summary;
    if (summary == null) return;
    final inProgress = summary.consultationInProgress;
    if (!summary.hasBaseline) {
      _events.emit(const OpenBaseline(editing: false));
    } else if (inProgress != null) {
      _events.emit(OpenConsultation(inProgress.step));
    } else {
      _startConsultation();
    }
  }

  void onEditBaseline() => _events.emit(const OpenBaseline(editing: true));

  void onStartErrorDismissed() => emit(state.copyWith(showStartError: false));

  void onRetryStart() {
    emit(state.copyWith(showStartError: false));
    _startConsultation();
  }

  Future<void> _startConsultation() async {
    if (state.isStartingConsultation) return;
    final summary = state.summary;
    if (summary == null) return;
    // The consultation is linked to the appointment only if it is today (so the appointment is "done" on publish).
    final next = summary.nextFollowUp;
    final now = _now();
    final scheduled = next?.scheduledFor.toLocal();
    final isToday = scheduled != null && scheduled.year == now.year && scheduled.month == now.month && scheduled.day == now.day;
    emit(state.copyWith(isStartingConsultation: true));
    final result = await _startOrResumeConsultation(patientId, scheduledFollowUpId: isToday ? next!.followUpId : null);
    if (isClosed) return;
    emit(state.copyWith(isStartingConsultation: false));
    final consultation = result.valueOrNull;
    if (consultation != null) {
      _events.emit(OpenConsultation(consultation.currentStep));
    } else if (result.errorOrNull == const Validation(_baselineRequired)) {
      _events.emit(const OpenBaseline(editing: false));
    } else {
      emit(state.copyWith(showStartError: true));
    }
  }

  Future<void> _load() async {
    final loadId = ++_loadId;
    emit(state.copyWith(isLoading: state.summary == null, loadFailed: false));
    final result = await _getPatientSummary(patientId);
    // A newer load took over (retry, resume, reconnection): its answer is the one that counts.
    if (isClosed || loadId != _loadId) return;
    result.fold(
      (summary) => emit(state.copyWith(isLoading: false, summary: summary)),
      (error) => emit(
        state.copyWith(
          isLoading: false,
          // A refresh that fails keeps the last summary.
          loadFailed: state.summary == null,
          isOffline: state.isOffline || error is Network,
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

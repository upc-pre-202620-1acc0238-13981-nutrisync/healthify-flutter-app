import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../state/patient_tab_states.dart';

const _baselineRequired = 'BaselineRequired';

/// Plan tab: the history of published versions and whether the patient saw the current ones (`targets-read-status`,
/// in parallel). "Adjust plan" opens the guided consultation (it starts or resumes it). Reread on returning to the tab
/// and when the connection comes back.
class PatientPlanCubit extends Cubit<PatientPlanState> {
  PatientPlanCubit(
    this._getPlanHistory,
    this._getLinkTargetsReadStatus,
    this._startOrResumeConsultation,
    ConnectivityObserver connectivityObserver, {
    required this.patientId,
    required this.careLinkId,
  }) : super(const PatientPlanState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (isClosed) return;
      final wasOffline = state.isOffline;
      emit(state.copyWith(isOffline: !online));
      if (online && wasOffline) _load();
    });
    _load();
  }

  final GetPlanHistoryUseCase _getPlanHistory;
  final GetLinkTargetsReadStatusUseCase _getLinkTargetsReadStatus;
  final StartOrResumeConsultationUseCase _startOrResumeConsultation;
  final int patientId;
  final int careLinkId;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<PatientTabEvent>();
  int _loadId = 0;

  Stream<PatientTabEvent> get events => _events.stream;

  void onRetry() => _load();

  void onResume() {
    if (state.history != null) _load();
  }

  Future<void> onAdjustPlan() async {
    if (state.isStartingConsultation) return;
    emit(state.copyWith(isStartingConsultation: true, showStartError: false));
    final result = await _startOrResumeConsultation(patientId);
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

  void onStartErrorDismissed() => emit(state.copyWith(showStartError: false));

  Future<void> _load() async {
    final loadId = ++_loadId;
    emit(state.copyWith(isLoading: state.history == null, loadFailed: false));
    final (history, status) = await (_getPlanHistory(patientId), _getLinkTargetsReadStatus(careLinkId)).wait;
    if (isClosed || loadId != _loadId) return;
    history.fold(
      (value) => emit(state.copyWith(isLoading: false, history: value, readStatus: status.valueOrNull)),
      (error) => emit(
        state.copyWith(
          isLoading: false,
          // A refresh that fails keeps the last history.
          loadFailed: state.history == null,
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

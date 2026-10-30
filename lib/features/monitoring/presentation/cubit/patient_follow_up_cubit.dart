import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/monitoring_use_cases.dart';
import '../state/patient_follow_up_state.dart';

/// Patient follow-up tab, with the AI summary requested in parallel. Read-only. If the summary does not arrive (no
/// patient AI consent, feature off, quota, error), the card is hidden and the panel still shows. Reread on returning
/// to the tab and when the connection comes back.
class PatientFollowUpCubit extends Cubit<PatientFollowUpState> {
  PatientFollowUpCubit(
    this._getMonitoringPanel,
    this._getMonitoringSummary,
    ConnectivityObserver connectivityObserver, {
    required this.patientId,
  }) : super(const PatientFollowUpState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (isClosed) return;
      final wasOffline = state.isOffline;
      emit(state.copyWith(isOffline: !online));
      if (online && wasOffline) _load();
    });
    _load();
  }

  final GetMonitoringPanelUseCase _getMonitoringPanel;
  final GetMonitoringSummaryUseCase _getMonitoringSummary;
  final int patientId;

  late final StreamSubscription<bool> _connectivity;
  int _loadId = 0;

  void onRetry() => _load();

  void onResume() {
    if (state.panel != null) _load();
  }

  Future<void> _load() async {
    final loadId = ++_loadId;
    emit(state.copyWith(isLoading: state.panel == null, loadFailed: false));
    final (panel, summary) = await (_getMonitoringPanel(patientId), _getMonitoringSummary(patientId)).wait;
    if (isClosed || loadId != _loadId) return;
    panel.fold(
      (value) => emit(state.copyWith(isLoading: false, panel: value, aiSummary: summary.valueOrNull?.text)),
      (error) => emit(
        state.copyWith(
          isLoading: false,
          // A refresh that fails keeps the last panel.
          loadFailed: state.panel == null,
          isOffline: state.isOffline || error is Network,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../iam/application/usecase/session_use_cases.dart';
import '../../application/usecase/practitioner_care_link_use_cases.dart';
import '../state/patient_roster_state.dart';

/// My roster (plus loading, empty and offline states). The roster is not stored on the phone: offline and without a
/// previous read in memory the offline state shows. It reloads on returning to the tab ([onResume]) and when the
/// connection comes back. The search and the expanded "Up to date" row are screen-only: they ask nothing from the
/// backend.
class PatientRosterCubit extends Cubit<PatientRosterState> {
  PatientRosterCubit(this._observeCurrentUser, this._getPatientRoster, this._connectivityObserver)
    : super(const PatientRosterState()) {
    unawaited(_start());
  }

  final ObserveCurrentUserUseCase _observeCurrentUser;
  final GetPatientRosterUseCase _getPatientRoster;
  final ConnectivityObserver _connectivityObserver;

  StreamSubscription<bool>? _connectivity;
  int? _practitionerId;
  int _loadId = 0;

  Future<void> _start() async {
    final user = await _observeCurrentUser().first;
    if (isClosed || user == null) return;
    _practitionerId = user.id.value;
    _connectivity = _connectivityObserver.isOnline.listen((online) {
      if (isClosed) return;
      final wasOffline = state.isOffline;
      emit(state.copyWith(isOffline: !online));
      if (online && wasOffline) _load();
    });
    _load();
  }

  void onRetry() => _load();

  void onQueryChange(String query) => emit(state.copyWith(query: query));

  void onToggleUpToDate() => emit(state.copyWith(isUpToDateExpanded: !state.isUpToDateExpanded));

  /// The tab is visible again: refresh what is already on screen. Before the first read there is nothing to refresh.
  void onResume() {
    if (state.patients != null) _load();
  }

  Future<void> _load() async {
    final id = _practitionerId;
    if (id == null) return;
    final loadId = ++_loadId;
    emit(state.copyWith(isLoading: state.patients == null, loadFailed: false));
    final result = await _getPatientRoster(id);
    // A newer load took over (retry, resume, reconnection): its answer is the one that counts.
    if (isClosed || loadId != _loadId) return;
    result.fold(
      (roster) => emit(state.copyWith(isLoading: false, patients: roster.patients.map(RosterItem.of).toList())),
      (error) => emit(
        state.copyWith(
          isLoading: false,
          // A refresh that fails keeps the last list.
          loadFailed: state.patients == null,
          isOffline: state.isOffline || error is Network,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _connectivity?.cancel();
    return super.close();
  }
}

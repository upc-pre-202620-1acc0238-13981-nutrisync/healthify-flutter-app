import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../carerelationship/application/usecase/find_active_care_link_use_case.dart';
import '../../../iam/application/usecase/session_use_cases.dart';
import '../../application/usecase/practitioner_agenda_use_cases.dart';
import '../state/practitioner_agenda_states.dart';

/// Agenda: the visits scheduled from now on. Re-read on returning to the tab (snackbar after scheduling) and when the
/// connection returns.
///
/// Tapping a visit opens a sheet with "Reschedule", "View patient" and "Cancel visit". Cancelling asks for confirmation
/// and does not close the care link.
class PractitionerAgendaCubit extends Cubit<AgendaState> {
  PractitionerAgendaCubit(
    this._observeCurrentUser,
    this._getUpcomingFollowUps,
    this._cancelFollowUp,
    this._findActiveRosterPatient,
    this._connectivityObserver,
  ) : super(const AgendaState()) {
    unawaited(_start());
  }

  final ObserveCurrentUserUseCase _observeCurrentUser;
  final GetUpcomingFollowUpsUseCase _getUpcomingFollowUps;
  final CancelFollowUpUseCase _cancelFollowUp;
  final FindActiveRosterPatientUseCase _findActiveRosterPatient;
  final ConnectivityObserver _connectivityObserver;

  StreamSubscription<bool>? _connectivity;
  final _events = OneShotEvents<AgendaEvent>();
  int? _practitionerId;
  int _loadId = 0;

  Stream<AgendaEvent> get events => _events.stream;

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

  /// The tab is visible again: refresh what is already on screen. Before the first read there is nothing to refresh.
  void onResume() {
    if (state.visits != null) _load();
  }

  void onVisitSelected(AgendaRow row) => emit(state.copyWith(selected: row));

  void onSheetDismissed() => emit(state.copyWith(selected: null));

  void onReschedule() {
    final row = state.selected;
    if (row == null) return;
    emit(state.copyWith(selected: null));
    _events.emit(OpenReschedule(row));
  }

  void onCancelRequested() => emit(state.copyWith(dialog: AgendaDialog.confirmCancel));

  /// "View patient": the care link is looked up in the roster, as the patient file needs it.
  Future<void> onViewPatient() async {
    final row = state.selected;
    if (row == null || state.isOpeningPatient) return;
    emit(state.copyWith(selected: null, isOpeningPatient: true));
    final result = await _findActiveRosterPatient(row.patientId);
    if (isClosed) return;
    emit(state.copyWith(isOpeningPatient: false));
    final patient = result.valueOrNull;
    if (result.isFailure) {
      emit(state.copyWith(dialog: AgendaDialog.serverError, selected: row));
    } else if (patient == null) {
      emit(state.copyWith(dialog: AgendaDialog.noActiveLink));
    } else {
      _events.emit(
        OpenAgendaPatient(patientId: patient.patientId, careLinkId: patient.careLinkId.value, patientName: patient.fullName),
      );
    }
  }

  /// A dialog is closed; the confirmation keeps the selected visit (its sheet comes back), the rest do not.
  void onDialogDismissed() =>
      emit(state.copyWith(dialog: null, selected: state.dialog == AgendaDialog.confirmCancel ? state.selected : null));

  /// "Yes, cancel" (or "Retry" after a network/server failure).
  Future<void> onCancelConfirmed() async {
    final row = state.selected;
    if (row == null || state.isCancelling) return;
    emit(state.copyWith(isCancelling: true));
    final result = await _cancelFollowUp(row.followUpId);
    if (isClosed) return;
    emit(state.copyWith(isCancelling: false));
    final error = result.errorOrNull;
    switch (error) {
      case null:
        emit(
          state.copyWith(
            dialog: null,
            selected: null,
            visits: state.visits?.where((visit) => visit.followUpId != row.followUpId).toList(),
          ),
        );
        _events.emit(const VisitCancelled());
        _load();
      case NotFound() || Conflict() || Forbidden():
        emit(state.copyWith(dialog: AgendaDialog.notCancellable));
        _load();
      default:
        emit(state.copyWith(dialog: AgendaDialog.serverError));
    }
  }

  Future<void> _load() async {
    final id = _practitionerId;
    if (id == null) return;
    final loadId = ++_loadId;
    emit(state.copyWith(isLoading: state.visits == null, loadFailed: false));
    final result = await _getUpcomingFollowUps(id);
    // A newer load took over (retry, resume, reconnection): its answer is the one that counts.
    if (isClosed || loadId != _loadId) return;
    result.fold(
      (visits) => emit(state.copyWith(isLoading: false, visits: visits.map(AgendaRow.of).toList())),
      (error) => emit(
        state.copyWith(
          isLoading: false,
          // A refresh that fails keeps the last list.
          loadFailed: state.visits == null,
          isOffline: state.isOffline || error is Network,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _connectivity?.cancel();
    _events.close();
    return super.close();
  }
}

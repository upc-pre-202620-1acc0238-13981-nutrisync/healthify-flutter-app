import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'practitioner_shell_state.freezed.dart';

/// Practitioner shell: the main menu header and whether the menu is open.
@freezed
abstract class PractitionerShellState with _$PractitionerShellState {
  const factory PractitionerShellState({
    @Default('') String fullName,
    @Default('') String avatarInitial,
    @Default(false) bool isMenuOpen,
  }) = _PractitionerShellState;
}

/// Snackbar that another screen requests on return to the shell (and the tab opened to show it).
sealed class PractitionerShellMessage {
  const PractitionerShellMessage();
}

/// The discharge returned to Patients: "Discharge recorded: {name} is no longer in your roster."
final class PatientDischarged extends PractitionerShellMessage {
  const PatientDischarged(this.patientName);

  final String patientName;
}

/// The review item was resolved: "Signal resolved. {name} is no longer in your inbox." Back on the Inbox tab.
final class SignalResolved extends PractitionerShellMessage {
  const SignalResolved(this.patientName);

  final String? patientName;
}

/// A visit was scheduled or rescheduled from the Agenda: "Consultation scheduled: thu 18 sep, 10:00". Back on the Agenda
/// tab. (From the patient file the snackbar belongs to the file: `FollowUpScheduled`.)
final class AgendaVisitScheduled extends PractitionerShellMessage {
  const AgendaVisitScheduled({required this.scheduledFor, required this.rescheduled});

  final DateTime scheduledFor;
  final bool rescheduled;
}

/// Hand-off between full-screen routes and the shell underneath them (the equivalent of Android's `SavedStateHandle`
/// message). Broadcast: a message posted while the shell is not listening is dropped, but the shell stays alive under
/// every route that posts.
class PractitionerShellMessages {
  final _controller = StreamController<PractitionerShellMessage>.broadcast();

  Stream<PractitionerShellMessage> get stream => _controller.stream;

  void post(PractitionerShellMessage message) => _controller.add(message);
}

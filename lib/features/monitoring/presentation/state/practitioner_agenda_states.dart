import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/practitioner_agenda.dart';
import '../../domain/entity/referral.dart';
import '../../domain/valueobject/monitoring_values.dart';

part 'practitioner_agenda_states.freezed.dart';

/// A row of "Upcoming visits".
@freezed
abstract class AgendaRow with _$AgendaRow {
  const factory AgendaRow({
    required int followUpId,
    required int patientId,
    required String? patientName,
    required DateTime scheduledFor,
    required Set<PreparationCode> preparation,
  }) = _AgendaRow;

  factory AgendaRow.of(AgendaVisit visit) => AgendaRow(
    followUpId: visit.id,
    patientId: visit.patientId.value,
    patientName: visit.patientFullName,
    scheduledFor: visit.scheduledFor,
    preparation: {
      for (final instruction in visit.preparation)
        if (instruction is CatalogPreparation) instruction.code,
    },
  );
}

/// Agenda notices.
enum AgendaDialog {
  confirmCancel,

  /// `404`/`409`: no longer scheduled (past, completed or already cancelled).
  notCancellable,

  /// The patient has no active care link in the roster: their file cannot be opened.
  noActiveLink,
  serverError,
}

/// Agenda (its snackbars are shown by the shell and the screen). `visits == null` = not read yet. The agenda is not
/// stored on the phone: offline with no previous read -> offline state.
@freezed
abstract class AgendaState with _$AgendaState {
  const AgendaState._();

  const factory AgendaState({
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    List<AgendaRow>? visits,

    /// Tapped visit: sheet with "Reschedule", "View patient" and "Cancel visit".
    AgendaRow? selected,
    AgendaDialog? dialog,
    @Default(false) bool isCancelling,
    @Default(false) bool isOpeningPatient,
  }) = _AgendaState;

  bool get isEmpty => visits?.isEmpty ?? false;
  bool get needsConnection => visits == null && loadFailed && isOffline;
}

/// What the agenda asks of its screen.
sealed class AgendaEvent {
  const AgendaEvent();
}

/// "Reschedule" -> the schedule form with the visit prefilled.
final class OpenReschedule extends AgendaEvent {
  const OpenReschedule(this.row);

  final AgendaRow row;
}

/// "Visit cancelled" snackbar.
final class VisitCancelled extends AgendaEvent {
  const VisitCancelled();
}

/// "View patient" -> the patient file.
final class OpenAgendaPatient extends AgendaEvent {
  const OpenAgendaPatient({required this.patientId, required this.careLinkId, required this.patientName});

  final int patientId;
  final int careLinkId;
  final String patientName;
}

/// Patient selectable in the schedule form's "Patient" field (from the roster, with an active care link).
@freezed
abstract class PatientOption with _$PatientOption {
  const factory PatientOption({required int patientId, required String fullName}) = _PatientOption;
}

/// Why the schedule form's patient is not valid.
enum SchedulePatientError {
  missing,

  /// `409 PatientAlreadyHasActiveScheduledFollowUp`: "This patient already has a visit on the agenda."
  alreadyScheduled,

  /// `403 ActiveCareLinkRequired`: "You don't have an active care link with this patient".
  noActiveLink,
}

/// Why the schedule form's date/time is not valid.
enum ScheduleMomentError {
  missing,

  /// "Pick a future date and time" (`400 ScheduledForMustBeInFuture`).
  notInFuture,
}

/// Schedule a visit (with validation and error states). With [rescheduleId] it is the same screen to reschedule an agenda
/// visit (fixed patient). [failed] = "Could not schedule" (what was written is kept).
@freezed
abstract class ScheduleFollowUpState with _$ScheduleFollowUpState {
  const ScheduleFollowUpState._();

  const factory ScheduleFollowUpState({
    PatientOption? patient,
    @Default(false) bool patientFixed,
    List<PatientOption>? patients,
    @Default(false) bool isLoadingPatients,

    /// Wall-clock date (time of day ignored) and time in the phone's time zone.
    DateTime? date,
    TimeOfDay? time,
    @Default(<PreparationCode>{}) Set<PreparationCode> preparation,
    SchedulePatientError? patientError,
    ScheduleMomentError? momentError,
    @Default(false) bool isSaving,
    @Default(false) bool failed,
    @Default(false) bool isOffline,
    int? rescheduleId,
  }) = _ScheduleFollowUpState;

  bool get isRescheduling => rescheduleId != null;
}

/// The schedule form's route arguments.
typedef ScheduleFollowUpArgs = ({
  int patientId,
  String patientName,
  int followUpId,
  DateTime? scheduledFor,
  Set<PreparationCode> preparation,
});

/// The form saved: back to where it was opened, with the snackbar.
final class FollowUpSaved {
  const FollowUpSaved({required this.scheduledFor, required this.rescheduled});

  final DateTime scheduledFor;
  final bool rescheduled;
}

/// Record a referral (with validation and error states). [failed] = "There was an error" (what was written is kept).
@freezed
abstract class RecordReferralState with _$RecordReferralState {
  const factory RecordReferralState({
    @Default('') String specialty,
    @Default('') String reason,
    @Default(<ReferralField>{}) Set<ReferralField> missing,
    @Default(false) bool isSaving,
    @Default(false) bool failed,
    @Default(false) bool noActiveLink,
    @Default(false) bool isOffline,
  }) = _RecordReferralState;
}

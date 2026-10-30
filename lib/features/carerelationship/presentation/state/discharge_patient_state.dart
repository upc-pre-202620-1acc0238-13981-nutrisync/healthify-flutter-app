import 'package:freezed_annotation/freezed_annotation.dart';

part 'discharge_patient_state.freezed.dart';

/// Discharge screen notices.
enum DischargeDialog {
  /// Confirmation "DISCHARGE?".
  confirm,

  /// `409 DischargedLinkCannotBeReactivated`: "This patient had already been discharged."
  alreadyDischarged,

  /// `403`/`404`: the care link does not belong to this practitioner or no longer exists.
  noActiveLink,
  serverError,
}

/// Clinical discharge (plus its confirmation).
@freezed
abstract class DischargePatientState with _$DischargePatientState {
  const factory DischargePatientState({
    @Default('') String reason,
    @Default(false) bool reasonMissing,
    DischargeDialog? dialog,
    @Default(false) bool isDischarging,
    @Default(false) bool isOffline,
  }) = _DischargePatientState;
}

sealed class DischargePatientEvent {
  const DischargePatientEvent();
}

/// Back to the roster, with the "Discharge recorded" snackbar.
final class Discharged extends DischargePatientEvent {
  const Discharged(this.patientName);

  final String patientName;
}

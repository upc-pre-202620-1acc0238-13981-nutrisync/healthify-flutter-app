import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../carerelationship/domain/entity/targets_read_status.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/valueobject/clinical_codes.dart';

part 'patient_tab_states.freezed.dart';

/// What the patient file's tabs ask of it (baseline form, the consultation or a notice).
sealed class PatientTabEvent {
  const PatientTabEvent();
}

/// Record or edit the baseline.
final class OpenBaseline extends PatientTabEvent {
  const OpenBaseline({required this.editing});

  final bool editing;
}

/// The step the consultation is on.
final class OpenConsultation extends PatientTabEvent {
  const OpenConsultation(this.step);

  final ConsultationStep step;
}

/// Why a referral could not be closed.
enum ReferralClosureFailure {
  /// `404`: it does not exist or another practitioner recorded it.
  notFound,
  network,
  other,
}

/// The referral was not closed: the file shows the snackbar.
final class ReferralClosureFailed extends PatientTabEvent {
  const ReferralClosureFailed(this.failure);

  final ReferralClosureFailure failure;
}

/// Summary tab. `summary.baseline == null` means no baseline yet. None of this is stored on the phone: offline with no
/// previous read, it asks for a connection.
@freezed
abstract class PatientSummaryState with _$PatientSummaryState {
  const factory PatientSummaryState({
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    PatientSummary? summary,
    @Default(false) bool isStartingConsultation,
    @Default(false) bool showStartError,
  }) = _PatientSummaryState;
}

/// Plan tab. [readStatus] tells whether the patient saw the published targets ("Ana saw them the same day"); if it
/// could not be read, that line is hidden.
@freezed
abstract class PatientPlanState with _$PatientPlanState {
  const factory PatientPlanState({
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    PlanHistory? history,
    TargetsReadStatus? readStatus,
    @Default(false) bool isStartingConsultation,
    @Default(false) bool showStartError,
  }) = _PatientPlanState;
}

import '../../../nutritionalcare/domain/valueobject/clinical_codes.dart';
import '../../../nutritionalcare/presentation/state/patient_tab_states.dart';

/// Patient file snackbars (and tab changes) that another screen requests on return: the screen it opened pops with one of
/// these and the patient file shows it, over its own tab bar. One of them is not a message but a hand-over: the baseline
/// asks the file to open the guided consultation.
sealed class PatientSnackbarRequest {
  const PatientSnackbarRequest();
}

/// The baseline was saved with "Save and start consultation": the file opens the consultation at [step], so it is the
/// screen that gets what the consultation ends with.
final class ContinueToConsultation extends PatientSnackbarRequest {
  const ContinueToConsultation(this.step);

  final ConsultationStep step;
}

/// "Plan published; the patient can now see their targets." Back on the Summary tab. Comes from the guided consultation.
final class PlanPublished extends PatientSnackbarRequest {
  const PlanPublished();
}

/// "Referral recorded", with "View" (-> Record tab). Comes from the referral screen.
final class ReferralRegistered extends PatientSnackbarRequest {
  const ReferralRegistered(this.specialty);

  final String specialty;
}

/// The referral could not be closed. Comes from the referral sheet of the Record tab.
final class ReferralNotClosed extends PatientSnackbarRequest {
  const ReferralNotClosed(this.failure);

  final ReferralClosureFailure failure;
}

/// Scheduling opened from the summary: "Consultation scheduled: thu 18 sep, 10:00". Back on the Summary tab.
final class FollowUpScheduled extends PatientSnackbarRequest {
  const FollowUpScheduled(this.scheduledFor);

  final DateTime scheduledFor;
}

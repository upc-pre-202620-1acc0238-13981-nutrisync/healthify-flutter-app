import '../../../../core/common/error/result.dart';
import '../entity/issued_invitation.dart';
import '../entity/patient_roster.dart';
import '../entity/targets_read_status.dart';
import '../valueobject/care_link_id.dart';
import '../valueobject/clinical_reason.dart';

/// The nutritionist side of CareRelationship. Nothing is stored on the phone: the roster is not available offline and
/// an invitation token is shown only once.
abstract interface class PractitionerCareLinkRepository {
  /// `GET /practitioners/{uid}/patient-roster`. `403 AccessNotAllowed` if it is not the caller's own roster.
  Future<Result<PatientRoster>> getRoster(int practitionerId);

  /// `POST /invitations`. `400 ExpirationDateRequired` if [expiresAt] is not in the future.
  Future<Result<IssuedInvitation>> issueInvitation(DateTime expiresAt);

  /// `POST /care-links/{id}/discharge`. `400 ClinicalReasonRequired`, `403 PractitionerOnly`, `404 CareLinkNotFound`
  /// and `409 DischargedLinkCannotBeReactivated` (already discharged).
  Future<Result<void>> discharge(CareLinkId careLinkId, ClinicalReason reason);

  /// `GET /care-links/{id}/targets-read-status`.
  Future<Result<TargetsReadStatus>> getTargetsReadStatus(CareLinkId careLinkId);
}

import '../../../../core/common/error/result.dart';
import '../../domain/entity/issued_invitation.dart';
import '../../domain/entity/patient_roster.dart';
import '../../domain/entity/targets_read_status.dart';
import '../../domain/repository/practitioner_care_link_repository.dart';
import '../../domain/valueobject/care_link_id.dart';
import '../../domain/valueobject/clinical_reason.dart';
import '../../domain/valueobject/invitation_validity.dart';

/// The signed-in nutritionist's patient roster.
class GetPatientRosterUseCase {
  const GetPatientRosterUseCase(this._repository);

  final PractitionerCareLinkRepository _repository;

  Future<Result<PatientRoster>> call(int practitionerUserId) => _repository.getRoster(practitionerUserId);
}

/// Issues an invitation that expires [InvitationValidity] from now ("Generate another code" issues a new one).
class IssueInvitationUseCase {
  const IssueInvitationUseCase(this._repository, this._now);

  final PractitionerCareLinkRepository _repository;
  final DateTime Function() _now;

  Future<Result<IssuedInvitation>> call(InvitationValidity validity) =>
      _repository.issueInvitation(validity.expiresAt(_now()));
}

/// "Yes, discharge": the clinical reason is required (the rule lives in [ClinicalReason]).
class DischargePatientUseCase {
  const DischargePatientUseCase(this._repository);

  final PractitionerCareLinkRepository _repository;

  Future<Result<void>> call(int careLinkId, ClinicalReason reason) =>
      _repository.discharge(CareLinkId(careLinkId), reason);
}

/// Whether the patient saw the published targets ("Ana saw them the same day"), read through the care link.
class GetLinkTargetsReadStatusUseCase {
  const GetLinkTargetsReadStatusUseCase(this._repository);

  final PractitionerCareLinkRepository _repository;

  Future<Result<TargetsReadStatus>> call(int careLinkId) => _repository.getTargetsReadStatus(CareLinkId(careLinkId));
}

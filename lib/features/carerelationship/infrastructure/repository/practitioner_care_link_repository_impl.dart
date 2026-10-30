import '../../../../core/common/error/result.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/network/iso_dates.dart';
import '../../domain/entity/issued_invitation.dart';
import '../../domain/entity/patient_roster.dart';
import '../../domain/entity/targets_read_status.dart';
import '../../domain/repository/practitioner_care_link_repository.dart';
import '../../domain/valueobject/care_link_id.dart';
import '../../domain/valueobject/clinical_reason.dart';
import '../mapper/practitioner_care_link_mappers.dart';
import '../remote/dto/practitioner_dtos.dart';
import '../remote/practitioner_care_link_service.dart';

/// Mappers run inside `apiCall`: an unreadable response becomes `Unexpected('MALFORMED_RESPONSE')`.
class PractitionerCareLinkRepositoryImpl implements PractitionerCareLinkRepository {
  const PractitionerCareLinkRepositoryImpl(this._service);

  final PractitionerCareLinkService _service;

  @override
  Future<Result<PatientRoster>> getRoster(int practitionerId) =>
      apiCall(() async => (await _service.getRoster(practitionerId)).toRoster());

  @override
  Future<Result<IssuedInvitation>> issueInvitation(DateTime expiresAt) => apiCall(() async {
    final dto = await _service.issueInvitation(IssueInvitationRequestDto(expiresAt: toIsoSecondsUtc(expiresAt)));
    return dto.toDomain();
  });

  @override
  Future<Result<void>> discharge(CareLinkId careLinkId, ClinicalReason reason) => apiCall<void>(
    () => _service.discharge(careLinkId.value, DischargePatientRequestDto(clinicalReason: reason.text)),
  );

  @override
  Future<Result<TargetsReadStatus>> getTargetsReadStatus(CareLinkId careLinkId) =>
      apiCall(() async => (await _service.getTargetsReadStatus(careLinkId.value)).toDomain());
}

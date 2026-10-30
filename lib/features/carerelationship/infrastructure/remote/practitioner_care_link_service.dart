import '../../../../core/network/api_client.dart';
import 'dto/practitioner_dtos.dart';

/// The nutritionist's roster and invitations.
class PractitionerCareLinkService {
  const PractitionerCareLinkService(this._api);

  final ApiClient _api;

  Future<List<PatientRosterItemDto>> getRoster(int practitionerId) async {
    final json = await _api.get('practitioners/$practitionerId/patient-roster') as List<dynamic>;
    return [for (final item in json) PatientRosterItemDto.fromJson(item as Map<String, dynamic>)];
  }

  /// `201` with the token (the only time it leaves the server).
  Future<InvitationDto> issueInvitation(IssueInvitationRequestDto body) async =>
      InvitationDto.fromJson(await _api.post('invitations', body: body.toJson()) as Map<String, dynamic>);

  /// Clinical discharge: `200` with the closed `CareLinkResource` (cancels appointments and turns off the link's AI).
  /// The body is not read: the screen only needs to know it worked.
  Future<void> discharge(int careLinkId, DischargePatientRequestDto body) =>
      _api.post('care-links/$careLinkId/discharge', body: body.toJson());

  /// Whether the patient saw the published targets.
  Future<TargetsReadStatusDto> getTargetsReadStatus(int careLinkId) async => TargetsReadStatusDto.fromJson(
    await _api.get('care-links/$careLinkId/targets-read-status') as Map<String, dynamic>,
  );
}

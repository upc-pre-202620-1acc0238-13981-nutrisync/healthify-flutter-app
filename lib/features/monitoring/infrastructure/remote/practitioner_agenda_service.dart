import '../../../../core/network/api_client.dart';
import 'dto/practitioner_agenda_dtos.dart';

/// The nutritionist's agenda and referrals.
class PractitionerAgendaService {
  const PractitionerAgendaService(this._api);

  final ApiClient _api;

  Future<List<ScheduledFollowUpDto>> getAgenda(int practitionerId, String? state, String? from) async {
    final json =
        await _api.get('practitioners/$practitionerId/scheduled-follow-ups', query: {'state': state, 'from': from})
            as List<dynamic>;
    return [for (final item in json) ScheduledFollowUpDto.fromJson(item as Map<String, dynamic>)];
  }

  Future<ScheduledFollowUpDto> schedule(ScheduleFollowUpRequestDto body) async => ScheduledFollowUpDto.fromJson(
    await _api.post('scheduled-follow-ups', body: body.toJson()) as Map<String, dynamic>,
  );

  /// `204 No Content`.
  Future<void> cancel(int followUpId, CancelFollowUpRequestDto body) =>
      _api.post('scheduled-follow-ups/$followUpId/cancellation', body: body.toJson());

  Future<ScheduledFollowUpDto> reschedule(int followUpId, RescheduleFollowUpRequestDto body) async =>
      ScheduledFollowUpDto.fromJson(
        await _api.post('scheduled-follow-ups/$followUpId/rescheduling', body: body.toJson()) as Map<String, dynamic>,
      );

  /// `201` with the `ReferralResource` (unused: the patient file is re-read on return).
  Future<void> recordReferral(RecordReferralRequestDto body) => _api.post('referrals', body: body.toJson());
}

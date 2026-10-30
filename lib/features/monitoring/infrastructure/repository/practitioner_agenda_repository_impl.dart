import '../../../../core/common/error/result.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/network/iso_dates.dart';
import '../../domain/entity/practitioner_agenda.dart';
import '../../domain/entity/referral.dart';
import '../../domain/repository/practitioner_agenda_repository.dart';
import '../mapper/practitioner_agenda_mappers.dart';
import '../remote/dto/practitioner_agenda_dtos.dart';
import '../remote/practitioner_agenda_service.dart';

/// Mappers run inside `apiCall`: an unreadable response becomes `Unexpected('MALFORMED_RESPONSE')`.
/// Scheduling, moving or cancelling a visit also calls [_onAgendaChanged], which reschedules the local reminders.
class PractitionerAgendaRepositoryImpl implements PractitionerAgendaRepository {
  const PractitionerAgendaRepositoryImpl(this._service, {this._onAgendaChanged = _ignore});

  final PractitionerAgendaService _service;
  final void Function() _onAgendaChanged;

  static void _ignore() {}

  @override
  Future<Result<List<AgendaVisit>>> getAgenda(int practitionerId, FollowUpState? state, DateTime? from) => apiCall(
    () async => [
      for (final dto in await _service.getAgenda(
        practitionerId,
        state?.code,
        from == null ? null : toIsoSecondsUtc(from),
      ))
        ?dto.toDomainOrNull(),
    ],
  );

  @override
  Future<Result<AgendaVisit>> schedule(NewFollowUp followUp) =>
      apiCall(() async => (await _service.schedule(followUp.toDto())).toDomain()).then(_changingAgenda);

  @override
  Future<Result<void>> cancel(int followUpId, CancellationReason? reason) =>
      apiCall<void>(
        () => _service.cancel(followUpId, CancelFollowUpRequestDto(reason: reason?.text)),
      ).then(_changingAgenda);

  @override
  Future<Result<AgendaVisit>> reschedule(int followUpId, DateTime scheduledFor, FollowUpPreparation preparation) =>
      apiCall(
        () async => (await _service.reschedule(followUpId, rescheduleDto(scheduledFor, preparation))).toDomain(),
      ).then(_changingAgenda);

  @override
  Future<Result<void>> recordReferral(NewReferral referral) =>
      apiCall<void>(() => _service.recordReferral(referral.toDto()));

  Result<T> _changingAgenda<T>(Result<T> result) => result.onSuccess((_) => _onAgendaChanged());
}

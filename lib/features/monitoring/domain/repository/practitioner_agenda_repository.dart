import '../../../../core/common/error/result.dart';
import '../entity/practitioner_agenda.dart';
import '../entity/referral.dart';

/// The nutritionist's agenda and referrals. Not stored on the phone: offline, the offline state is shown.
abstract interface class PractitionerAgendaRepository {
  /// `GET /practitioners/{uid}/scheduled-follow-ups?state=&from=` (own agenda only).
  Future<Result<List<AgendaVisit>>> getAgenda(int practitionerId, FollowUpState? state, DateTime? from);

  /// `POST /scheduled-follow-ups`. `400 ScheduledForMustBeInFuture`, `403 ActiveCareLinkRequired` and
  /// `409 PatientAlreadyHasActiveScheduledFollowUp` (one agenda visit per patient).
  Future<Result<AgendaVisit>> schedule(NewFollowUp followUp);

  /// `POST /scheduled-follow-ups/{id}/cancellation` (`204`). Only while it is scheduled.
  Future<Result<void>> cancel(int followUpId, CancellationReason? reason);

  /// `POST /scheduled-follow-ups/{id}/rescheduling`: another future moment; the preparation is replaced.
  Future<Result<AgendaVisit>> reschedule(int followUpId, DateTime scheduledFor, FollowUpPreparation preparation);

  /// `POST /referrals` (`201`). `400 SpecialtyAndReasonRequired`, `403 ActiveCareLinkRequired`.
  Future<Result<void>> recordReferral(NewReferral referral);
}

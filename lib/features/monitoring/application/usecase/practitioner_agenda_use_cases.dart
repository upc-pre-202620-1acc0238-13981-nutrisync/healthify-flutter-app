import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/error/result.dart';
import '../../domain/entity/practitioner_agenda.dart';
import '../../domain/entity/referral.dart';
import '../../domain/repository/practitioner_agenda_repository.dart';

/// Backend code for a moment that is not in the future.
const scheduledForMustBeInFuture = 'ScheduledForMustBeInFuture';

/// "Upcoming visits": the scheduled ones (`state=Scheduled`) from now on, nearest first.
class GetUpcomingFollowUpsUseCase {
  const GetUpcomingFollowUpsUseCase(this._repository, this._now);

  final PractitionerAgendaRepository _repository;
  final DateTime Function() _now;

  Future<Result<List<AgendaVisit>>> call(int practitionerId) async {
    final result = await _repository.getAgenda(practitionerId, FollowUpState.scheduled, _now());
    return result.map((visits) => [...visits]..sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor)));
  }
}

/// "Schedule". The moment arrives already validated as future ([FollowUpMoment]); if the time passed between validating
/// and sending, the phone rejects it with the same code as the backend.
class ScheduleFollowUpUseCase {
  const ScheduleFollowUpUseCase(this._repository, this._now);

  final PractitionerAgendaRepository _repository;
  final DateTime Function() _now;

  Future<Result<AgendaVisit>> call(NewFollowUp followUp) => followUp.scheduledFor.isAfter(_now())
      ? _repository.schedule(followUp)
      : Future.value(const Result.failure(Validation(scheduledForMustBeInFuture)));
}

/// Reschedule mode (from an Agenda visit): same patient, another future moment.
class RescheduleFollowUpUseCase {
  const RescheduleFollowUpUseCase(this._repository, this._now);

  final PractitionerAgendaRepository _repository;
  final DateTime Function() _now;

  Future<Result<AgendaVisit>> call(int followUpId, DateTime scheduledFor, FollowUpPreparation preparation) =>
      scheduledFor.isAfter(_now())
      ? _repository.reschedule(followUpId, scheduledFor, preparation)
      : Future.value(const Result.failure(Validation(scheduledForMustBeInFuture)));
}

/// "Cancel visit" (not a judgment of the patient and does not close the care link).
class CancelFollowUpUseCase {
  const CancelFollowUpUseCase(this._repository);

  final PractitionerAgendaRepository _repository;

  Future<Result<void>> call(int followUpId, [CancellationReason? reason]) => _repository.cancel(followUpId, reason);
}

/// Record a referral.
class RecordReferralUseCase {
  const RecordReferralUseCase(this._repository);

  final PractitionerAgendaRepository _repository;

  Future<Result<void>> call(NewReferral referral) => _repository.recordReferral(referral);
}

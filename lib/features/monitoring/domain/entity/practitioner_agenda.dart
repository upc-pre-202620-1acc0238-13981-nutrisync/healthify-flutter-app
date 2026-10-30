import '../valueobject/monitoring_values.dart';

/// State of a scheduled visit (`ScheduledFollowUpResource.state`). A missed visit does not close the care link.
enum FollowUpState {
  scheduled('Scheduled'),
  completed('Completed'),
  missed('Missed'),
  cancelled('Cancelled');

  const FollowUpState(this.code);

  final String code;

  static FollowUpState? fromCode(String? code) {
    final normalized = code?.trim().toLowerCase();
    for (final state in values) {
      if (state.code.toLowerCase() == normalized) return state;
    }
    return null;
  }
}

/// A visit on the nutritionist's agenda (read model *Practitioner Agenda*).
final class AgendaVisit {
  /// Throws [ArgumentError] if [id] is not positive.
  AgendaVisit({
    required this.id,
    required this.patientId,
    required this.patientFullName,
    required this.scheduledFor,
    required this.state,
    required this.preparation,
    required this.modality,
  }) {
    if (id <= 0) throw ArgumentError.value(id, 'id', 'A follow up id is positive');
  }

  final int id;
  final PatientId patientId;
  final String? patientFullName;
  final DateTime scheduledFor;
  final FollowUpState state;
  final List<PreparationInstruction> preparation;
  final ConsultationModality modality;

  /// Only a scheduled visit can be cancelled or rescheduled.
  bool get canBeChanged => state == FollowUpState.scheduled;
}

/// "How should they prepare?" instructions: a closed list, several at once.
final class FollowUpPreparation {
  const FollowUpPreparation(this.codes);

  final Set<PreparationCode> codes;

  /// In catalog order, as the backend expects them.
  List<PreparationCode> get orderedCodes => [for (final code in PreparationCode.values) if (codes.contains(code)) code];
}

/// A new visit (`ScheduleFollowUpResource`): the moment already went through [FollowUpMoment.of].
final class NewFollowUp {
  const NewFollowUp({
    required this.patientId,
    required this.scheduledFor,
    required this.preparation,
    this.modality = ConsultationModality.inPerson,
  });

  final PatientId patientId;
  final DateTime scheduledFor;
  final FollowUpPreparation preparation;
  final ConsultationModality modality;
}

/// Date and time from the schedule form -> the visit moment. **Must be in the future** (`400 ScheduledForMustBeInFuture`):
/// checked on the phone before sending ("Pick a future date and time"), and the backend checks it again.
sealed class FollowUpMoment {
  const FollowUpMoment();

  /// [date] and [time] are wall-clock values in the phone's time zone.
  static FollowUpMoment of(DateTime? date, ({int hour, int minute})? time, DateTime now) {
    if (date == null || time == null) return const IncompleteMoment();
    final instant = DateTime(date.year, date.month, date.day, time.hour, time.minute).toUtc();
    return instant.isAfter(now) ? ValidMoment(instant) : const MomentNotInFuture();
  }
}

final class ValidMoment extends FollowUpMoment {
  const ValidMoment(this.instant);

  final DateTime instant;
}

/// Date or time missing.
final class IncompleteMoment extends FollowUpMoment {
  const IncompleteMoment();
}

/// The chosen date and time already passed (or are right now).
final class MomentNotInFuture extends FollowUpMoment {
  const MomentNotInFuture();
}

/// Optional cancellation reason (`CancelFollowUpResource.reason`, at most 30 characters).
final class CancellationReason {
  const CancellationReason._(this.text);

  static const maxLength = 30;

  /// `null` if empty; trims to [maxLength] (the backend answers `400` if it is longer).
  static CancellationReason? ofOptional(String? text) {
    final trimmed = text?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return CancellationReason._(trimmed.length > maxLength ? trimmed.substring(0, maxLength) : trimmed);
  }

  final String text;
}

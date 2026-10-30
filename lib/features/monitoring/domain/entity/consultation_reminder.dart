/// Local reminder for a visit on the nutritionist's agenda: a day before and an hour before. It only carries the time
/// and the patient's name; never clinical data.
final class ConsultationReminder {
  const ConsultationReminder({required this.followUpId, required this.scheduledFor, this.patientFullName});

  final int followUpId;
  final DateTime scheduledFor;
  final String? patientFullName;

  /// How far ahead the reminder fires.
  static const leads = [Duration(hours: 24), Duration(hours: 1)];

  /// Reminders that have not passed yet, soonest first.
  List<ReminderTrigger> triggersAfter(DateTime now) =>
      [for (final lead in leads) ReminderTrigger(lead, scheduledFor.subtract(lead))]
          .where((trigger) => trigger.at.isAfter(now))
          .toList()
        ..sort((a, b) => a.at.compareTo(b.at));

  @override
  bool operator ==(Object other) =>
      other is ConsultationReminder &&
      other.followUpId == followUpId &&
      other.scheduledFor == scheduledFor &&
      other.patientFullName == patientFullName;

  @override
  int get hashCode => Object.hash(followUpId, scheduledFor, patientFullName);

  @override
  String toString() => 'ConsultationReminder(followUpId=$followUpId, scheduledFor=$scheduledFor)';
}

/// One [ConsultationReminder] reminder: [lead] before the visit, at [at].
final class ReminderTrigger {
  const ReminderTrigger(this.lead, this.at);

  final Duration lead;
  final DateTime at;

  @override
  bool operator ==(Object other) => other is ReminderTrigger && other.lead == lead && other.at == at;

  @override
  int get hashCode => Object.hash(lead, at);

  @override
  String toString() => 'ReminderTrigger(lead=$lead, at=$at)';
}

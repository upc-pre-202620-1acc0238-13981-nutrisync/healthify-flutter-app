import '../entity/consultation_reminder.dart';

/// Local reminders for upcoming visits on this phone (there is no push: the phone schedules them from what it last
/// read). Never throws: a reminder that cannot be scheduled is just not shown.
abstract interface class ConsultationReminderScheduler {
  /// Asks for the notification permission (Android 13+). If it was denied the system may not show the dialog again.
  Future<void> requestPermission();

  /// Replaces all scheduled reminders with [reminders].
  Future<void> replaceAll(List<ConsultationReminder> reminders);

  /// Removes all reminders, scheduled and shown (signed out or session expired).
  Future<void> cancelAll();
}

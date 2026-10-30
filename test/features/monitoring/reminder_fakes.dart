import 'package:healthify/features/monitoring/application/usecase/consultation_reminder_use_cases.dart';
import 'package:healthify/features/monitoring/domain/entity/consultation_reminder.dart';
import 'package:healthify/features/monitoring/domain/repository/consultation_reminder_scheduler.dart';
import 'package:mocktail/mocktail.dart';

/// Records what would reach the notifications plugin.
class FakeConsultationReminderScheduler implements ConsultationReminderScheduler {
  final replaced = <List<ConsultationReminder>>[];
  int permissionRequests = 0;
  int cancelAllCalls = 0;

  List<ConsultationReminder>? get scheduled => replaced.isEmpty ? null : replaced.last;

  @override
  Future<void> requestPermission() async => permissionRequests++;

  @override
  Future<void> replaceAll(List<ConsultationReminder> reminders) async => replaced.add(reminders);

  @override
  Future<void> cancelAll() async => cancelAllCalls++;
}

class _MockConsultationRemindersSync extends Mock implements ConsultationRemindersSync {}

/// A sync that does nothing, for screens whose tests are not about reminders.
ConsultationRemindersSync idleReminders() {
  final sync = _MockConsultationRemindersSync();
  when(sync.onShellEntered).thenAnswer((_) async {});
  when(sync.requestRefresh).thenAnswer((_) async {});
  return sync;
}

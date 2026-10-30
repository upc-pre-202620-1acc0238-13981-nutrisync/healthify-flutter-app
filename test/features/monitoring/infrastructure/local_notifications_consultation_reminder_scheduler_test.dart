import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/network/app_language_provider.dart';
import 'package:healthify/features/monitoring/domain/entity/consultation_reminder.dart';
import 'package:healthify/features/monitoring/infrastructure/local/local_notifications_consultation_reminder_scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/timezone.dart' as tz;

typedef _Scheduled = ({
  int id,
  String? title,
  String? body,
  tz.TZDateTime at,
  AndroidNotificationDetails? details,
  AndroidScheduleMode mode,
});

/// Records each `zonedSchedule` (and the calls around it, in order); the rest is stubbed with mocktail.
class _MockPlugin extends Mock implements AndroidFlutterLocalNotificationsPlugin {
  final scheduled = <_Scheduled>[];
  final calls = <String>[];
  int? rejectedId;

  @override
  Future<void> zonedSchedule({
    required int id,
    String? title,
    String? body,
    required tz.TZDateTime scheduledDate,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
    AndroidNotificationDetails? notificationDetails,
    AndroidScheduleMode scheduleMode = AndroidScheduleMode.exact,
  }) async {
    calls.add('zonedSchedule $id');
    if (id == rejectedId) throw PlatformException(code: 'error');
    scheduled.add((
      id: id,
      title: title,
      body: body,
      at: scheduledDate,
      details: notificationDetails,
      mode: scheduleMode,
    ));
  }
}

class _Language implements AppLanguageProvider {
  _Language(this.language);

  String language;

  @override
  String currentLanguage() => language;
}

final _now = DateTime.utc(2026, 10, 30, 12);

void main() {
  late _MockPlugin plugin;
  late _Language language;
  late LocalNotificationsConsultationReminderScheduler scheduler;

  setUpAll(() async {
    registerFallbackValue(const AndroidInitializationSettings('icon'));
    await initializeDateFormatting();
  });

  setUp(() {
    plugin = _MockPlugin();
    language = _Language('es');
    scheduler = LocalNotificationsConsultationReminderScheduler(plugin, language, () => _now);
    when(() => plugin.initialize(settings: any(named: 'settings'))).thenAnswer((_) async => true);
    when(plugin.cancelAllPendingNotifications).thenAnswer((_) async => plugin.calls.add('cancelAllPending'));
    when(plugin.cancelAll).thenAnswer((_) async {});
    when(plugin.requestNotificationsPermission).thenAnswer((_) async => true);
  });

  String localTime(DateTime instant, String language) => DateFormat.jm(language).format(instant.toLocal());

  test('a visit gets a reminder a day before and another an hour before, at those instants in UTC', () async {
    final visit = DateTime.utc(2026, 11, 2, 15);

    await scheduler.replaceAll([
      ConsultationReminder(followUpId: 7, scheduledFor: visit, patientFullName: 'Ana Flores'),
    ]);

    expect(plugin.calls, ['cancelAllPending', 'zonedSchedule 14', 'zonedSchedule 15']);
    final calls = plugin.scheduled;
    expect(calls.map((call) => call.title), ['Consulta mañana', 'Consulta en una hora']);
    expect(calls.map((call) => call.body).toSet(), {'Con Ana Flores a las ${localTime(visit, 'es')}.'});
    expect(calls.map((call) => call.at.toUtc()), [DateTime.utc(2026, 11, 1, 15), DateTime.utc(2026, 11, 2, 14)]);
    expect(calls.map((call) => call.at.location.name).toSet(), {tz.UTC.name});
    final details = calls.first.details!;
    expect(details.channelId, 'consultations');
    expect(details.channelName, 'Consultas');
    expect(details.icon, 'ic_notification');
    expect(details.visibility, NotificationVisibility.private);
    expect(calls.map((call) => call.mode).toSet(), {AndroidScheduleMode.inexactAllowWhileIdle});
  });

  test('in English, and without a patient name', () async {
    language.language = 'en';
    final visit = DateTime.utc(2026, 10, 30, 14);

    await scheduler.replaceAll([ConsultationReminder(followUpId: 2, scheduledFor: visit, patientFullName: '  ')]);

    final call = plugin.scheduled.single;
    expect(call.title, 'Consultation in one hour');
    expect(call.body, 'With your patient at ${localTime(visit, 'en')}.');
    expect(call.details!.channelName, 'Consultations');
  });

  test('reminders already passed and ids that do not fit 32 bits are not scheduled', () async {
    await scheduler.replaceAll([
      ConsultationReminder(followUpId: 1, scheduledFor: _now.add(const Duration(minutes: 30))),
      ConsultationReminder(followUpId: 0x7FFFFFFF, scheduledFor: DateTime.utc(2026, 11, 2, 15)),
    ]);

    expect(plugin.calls, ['cancelAllPending']);
  });

  test('a reminder the plugin rejects does not stop the others, nor reach the caller', () async {
    plugin.rejectedId = 2;

    await scheduler.replaceAll([ConsultationReminder(followUpId: 1, scheduledFor: DateTime.utc(2026, 11, 2, 15))]);

    expect(plugin.calls, ['cancelAllPending', 'zonedSchedule 2', 'zonedSchedule 3']);
    expect(plugin.scheduled.map((call) => call.id), [3]);
  });

  test('without the plugin (tests, other platforms) nothing is thrown', () async {
    when(plugin.cancelAll).thenThrow(MissingPluginException());
    when(plugin.requestNotificationsPermission).thenThrow(MissingPluginException());

    await scheduler.cancelAll();
    await scheduler.requestPermission();
  });

  test('the plugin is initialized once, with the notification icon', () async {
    await scheduler.requestPermission();
    await scheduler.cancelAll();

    final settings = verify(() => plugin.initialize(settings: captureAny(named: 'settings'))).captured;
    expect(settings.map((value) => (value as AndroidInitializationSettings).defaultIcon), ['ic_notification']);
    verify(plugin.requestNotificationsPermission).called(1);
    verify(plugin.cancelAll).called(1);
  });

  test('two ids per visit, one per lead', () {
    expect(LocalNotificationsConsultationReminderScheduler.notificationId(7, const Duration(hours: 24)), 14);
    expect(LocalNotificationsConsultationReminderScheduler.notificationId(7, const Duration(hours: 1)), 15);
    expect(
      LocalNotificationsConsultationReminderScheduler.notificationId(0x40000000, const Duration(hours: 1)),
      isNull,
    );
  });
}

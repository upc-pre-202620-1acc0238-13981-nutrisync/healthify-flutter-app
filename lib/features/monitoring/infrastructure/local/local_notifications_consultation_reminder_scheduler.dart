import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/network/app_language_provider.dart';
import '../../domain/entity/consultation_reminder.dart';
import '../../domain/repository/consultation_reminder_scheduler.dart';

/// [ConsultationReminderScheduler] over `flutter_local_notifications`: one alarm per reminder, rescheduled by the plugin
/// after a reboot. Inexact like Android's WorkManager (it may arrive a few minutes late), so no exact-alarm permission.
///
/// "Consultation tomorrow · With Ana Flores at 10:00". The texts are written when scheduling, in the app's language at
/// that time; a language change reschedules them. On a secure lock screen the system hides the text (the plugin has no
/// public version to show instead).
class LocalNotificationsConsultationReminderScheduler implements ConsultationReminderScheduler {
  LocalNotificationsConsultationReminderScheduler(this._plugin, this._languageProvider, this._now);

  static const _channelId = 'consultations';
  static const _icon = 'ic_notification';
  static const _dayBeforeFrom = Duration(hours: 12);

  final AndroidFlutterLocalNotificationsPlugin _plugin;
  final AppLanguageProvider _languageProvider;
  final DateTime Function() _now;
  Future<void>? _initialized;

  /// Two notification ids per visit, one per lead; `null` if it does not fit the 32-bit id Android takes.
  static int? notificationId(int followUpId, Duration lead) {
    final id = followUpId * ConsultationReminder.leads.length + ConsultationReminder.leads.indexOf(lead);
    return id > 0x7FFFFFFF ? null : id;
  }

  @override
  Future<void> requestPermission() => _bestEffort(() async {
    await _initialize();
    await _plugin.requestNotificationsPermission();
  });

  @override
  Future<void> replaceAll(List<ConsultationReminder> reminders) => _bestEffort(() async {
    await _initialize();
    await _plugin.cancelAllPendingNotifications();
    final language = _languageProvider.currentLanguage();
    await initializeDateFormatting(language);
    final texts = lookupAppLocalizations(Locale(language));
    final time = DateFormat.jm(language);
    final details = AndroidNotificationDetails(
      _channelId,
      texts.consultationReminderChannelName,
      channelDescription: texts.consultationReminderChannelDescription,
      icon: _icon,
      category: AndroidNotificationCategory.event,
      visibility: NotificationVisibility.private,
    );
    final now = _now();
    for (final reminder in reminders) {
      final at = time.format(reminder.scheduledFor.toLocal());
      final name = reminder.patientFullName?.trim() ?? '';
      for (final trigger in reminder.triggersAfter(now)) {
        final id = notificationId(reminder.followUpId, trigger.lead);
        if (id == null) continue;
        // One at a time: a reminder that cannot be scheduled does not take the others with it.
        await _bestEffort(
          () => _plugin.zonedSchedule(
            id: id,
            title: trigger.lead >= _dayBeforeFrom
                ? texts.consultationReminderTitleDay
                : texts.consultationReminderTitleHour,
            body: name.isEmpty ? texts.consultationReminderTextNoName(at) : texts.consultationReminderText(name, at),
            scheduledDate: tz.TZDateTime.from(trigger.at, tz.UTC),
            notificationDetails: details,
            scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          ),
        );
      }
    }
  });

  @override
  Future<void> cancelAll() => _bestEffort(() async {
    await _initialize();
    await _plugin.cancelAll();
  });

  Future<void> _initialize() =>
      _initialized ??= _plugin.initialize(settings: const AndroidInitializationSettings(_icon));

  /// Reminders are a convenience: a platform failure (no plugin on this platform, a moment that just passed) is
  /// swallowed instead of reaching the screen that triggered the refresh.
  static Future<void> _bestEffort(Future<void> Function() action) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await action();
    } catch (error) {
      debugPrint('Consultation reminders: $error');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/monitoring/domain/entity/referral.dart';
import 'package:healthify/features/monitoring/domain/valueobject/monitoring_values.dart';
import 'package:healthify/features/monitoring/presentation/screen/practitioner_agenda_screen.dart';
import 'package:healthify/features/monitoring/presentation/screen/record_referral_screen.dart';
import 'package:healthify/features/monitoring/presentation/screen/schedule_follow_up_screen.dart';
import 'package:healthify/features/monitoring/presentation/state/practitioner_agenda_states.dart';

import '../../../core/designsystem/test_fonts.dart';

/// The agenda, the schedule form and the referral form must lay out without overflow on a small phone, in both languages.
void main() {
  setUpAll(loadAppFonts);

  Future<void> pump(WidgetTester tester, Widget screen, {String language = 'es'}) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: HealthifyTheme.light(),
        locale: Locale(language),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: screen,
      ),
    );
    await tester.pump();
  }

  void noop([Object? _]) {}

  Widget agendaScreen(AgendaState state) => Scaffold(
    body: PractitionerAgendaContent(
      state: state,
      onSchedule: noop,
      onRetry: noop,
      onVisitSelected: noop,
      onCancelConfirmed: noop,
      onDialogDismissed: noop,
    ),
  );

  Widget scheduleScreen(ScheduleFollowUpState state) => ScheduleFollowUpContent(
    state: state,
    onBack: noop,
    onPatientFieldClick: noop,
    onDateFieldClick: noop,
    onTimeFieldClick: noop,
    onPreparationToggle: (_, _) {},
    onSubmit: noop,
    onBackToForm: noop,
  );

  Widget referralScreen(RecordReferralState state) => RecordReferralContent(
    state: state,
    onBack: noop,
    onSpecialtyChange: noop,
    onReasonChange: noop,
    onSubmit: noop,
    onBackToForm: noop,
    onNoActiveLinkDismissed: noop,
  );

  AgendaRow row(int id, String? name, DateTime when) =>
      AgendaRow(followUpId: id, patientId: id, patientName: name, scheduledFor: when, preparation: const {});

  final visits = [
    row(1, 'Ana Flores', DateTime(2026, 11, 18, 10)),
    row(2, 'María de los Ángeles Fernández-Villalobos de la Cruz', DateTime(2026, 12, 1, 15, 30)),
    row(3, null, DateTime(2027, 1, 5, 8)),
  ];

  final fullSchedule = ScheduleFollowUpState(
    patient: const PatientOption(patientId: 1, fullName: 'María de los Ángeles Fernández-Villalobos de la Cruz'),
    date: DateTime(2026, 11, 18),
    time: const TimeOfDay(hour: 10, minute: 30),
    preparation: PreparationCode.values.toSet(),
  );

  for (final language in ['es', 'en']) {
    group('agenda ($language)', () {
      for (final (name, state) in <(String, AgendaState)>[
        ('list', AgendaState(isLoading: false, visits: visits)),
        ('list offline', AgendaState(isLoading: false, isOffline: true, visits: visits)),
        ('loading', const AgendaState()),
        ('empty', const AgendaState(isLoading: false, visits: [])),
        ('offline', const AgendaState(isLoading: false, isOffline: true, loadFailed: true)),
        ('error', const AgendaState(isLoading: false, loadFailed: true)),
        for (final dialog in AgendaDialog.values)
          ('the ${dialog.name} dialog', AgendaState(isLoading: false, visits: visits, selected: visits.first, dialog: dialog)),
        (
          'cancelling',
          AgendaState(
            isLoading: false,
            visits: visits,
            selected: visits.first,
            dialog: AgendaDialog.confirmCancel,
            isCancelling: true,
          ),
        ),
      ]) {
        testWidgets(name, (tester) async {
          await pump(tester, agendaScreen(state), language: language);

          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('the date badge and the weekday are shown in the language of the app', (tester) async {
        await pump(tester, agendaScreen(AgendaState(isLoading: false, visits: [visits.first])), language: language);

        expect(find.text('18'), findsOneWidget);
        expect(find.text('NOV'), findsOneWidget);
        expect(find.textContaining(language == 'es' ? 'Miércoles' : 'Wednesday'), findsOneWidget);
      });

      testWidgets('offline the visits cannot be opened and "Schedule" is off', (tester) async {
        var tapped = false;
        await pump(
          tester,
          Scaffold(
            body: PractitionerAgendaContent(
              state: AgendaState(isLoading: false, isOffline: true, visits: visits),
              onSchedule: () => tapped = true,
              onRetry: noop,
              onVisitSelected: (_) => tapped = true,
              onCancelConfirmed: noop,
              onDialogDismissed: noop,
            ),
          ),
          language: language,
        );

        await tester.tap(find.text('Ana Flores'));
        await tester.tap(find.text(language == 'es' ? 'Agendar consulta' : 'Schedule consultation'));
        await tester.pump();

        expect(tapped, isFalse);
      });
    });

    group('schedule form ($language)', () {
      for (final (name, state) in <(String, ScheduleFollowUpState)>[
        ('empty', const ScheduleFollowUpState()),
        ('filled', fullSchedule),
        ('rescheduling', fullSchedule.copyWith(rescheduleId: 4, patientFixed: true)),
        ('offline', fullSchedule.copyWith(isOffline: true)),
        ('saving', fullSchedule.copyWith(isSaving: true)),
        (
          'every error',
          const ScheduleFollowUpState(
            patientError: SchedulePatientError.alreadyScheduled,
            momentError: ScheduleMomentError.notInFuture,
          ),
        ),
        ('patient missing', const ScheduleFollowUpState(patientError: SchedulePatientError.missing)),
        ('no active link', const ScheduleFollowUpState(patientError: SchedulePatientError.noActiveLink)),
        ('moment missing', const ScheduleFollowUpState(momentError: ScheduleMomentError.missing)),
        ('failed', fullSchedule.copyWith(failed: true)),
      ]) {
        testWidgets(name, (tester) async {
          await pump(tester, scheduleScreen(state), language: language);

          expect(tester.takeException(), isNull);
        });
      }
    });

    group('referral form ($language)', () {
      for (final (name, state) in <(String, RecordReferralState)>[
        ('empty', const RecordReferralState()),
        ('filled', RecordReferralState(specialty: 'Endocrinología', reason: 'Hipotiroidismo sin control.\n' * 12)),
        ('missing fields', const RecordReferralState(missing: {ReferralField.specialty, ReferralField.reason})),
        ('saving', const RecordReferralState(specialty: 'x', reason: 'y', isSaving: true)),
        ('offline', const RecordReferralState(isOffline: true)),
        ('failed', const RecordReferralState(failed: true)),
        ('no active link', const RecordReferralState(noActiveLink: true)),
      ]) {
        testWidgets(name, (tester) async {
          await pump(tester, referralScreen(state), language: language);

          expect(tester.takeException(), isNull);
        });
      }
    });
  }
}

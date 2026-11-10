import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/monitoring/domain/entity/patient_monitoring_panel.dart';
import 'package:healthify/features/monitoring/domain/valueobject/monitoring_values.dart';
import 'package:healthify/features/monitoring/presentation/screen/patient_follow_up_tab.dart';
import 'package:healthify/features/monitoring/presentation/state/patient_follow_up_state.dart';

import '../../../core/designsystem/test_fonts.dart';

/// The Follow-up tab after the compact redesign, on a small phone (360x640): the six sections stay reachable, the legend
/// lists the four outcomes, the accordions open and close, and the empty, loading, error and offline states render. In
/// both languages, with no overflow.

Future<void> pumpApp(WidgetTester tester, Widget screen, {String language = 'es', Size size = const Size(360, 640)}) async {
  await tester.binding.setSurfaceSize(size);
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
      home: Scaffold(body: screen),
    ),
  );
}

void main() {
  setUpAll(loadAppFonts);

  const small = Size(360, 640);

  List<PanelDay> week(List<ComplianceOutcome> outcomes) => [
    for (var i = 0; i < outcomes.length; i++) PanelDay(DateTime(2026, 9, 28 + i), outcomes[i]),
  ];

  PatientMonitoringPanel panel({
    List<ComplianceOutcome>? outcomes,
    List<PanelDiaryEntry>? diary,
    PanelWeightTrend? weightTrend = const PanelWeightTrend(4, -0.3),
    DaysRatio? loggedDays,
    PanelClinicalMeasurement? measurement,
    bool withMeasurement = true,
  }) {
    final days =
        outcomes ??
        [
          ComplianceOutcome.met,
          ComplianceOutcome.met,
          ComplianceOutcome.exceeded,
          ComplianceOutcome.short,
          ComplianceOutcome.met,
          ComplianceOutcome.unlogged,
          ComplianceOutcome.met,
        ];
    return PatientMonitoringPanel(
      date: DateTime(2026, 10, 7),
      week: PanelWeek(
        days: week(days),
        metDays: days.where((o) => o == ComplianceOutcome.met).length,
        totalDays: days.length,
      ),
      loggedDays: loggedDays ?? DaysRatio(6, 7),
      weightTrend: weightTrend,
      diary:
          diary ??
          [
            PanelDiaryEntry(
              id: 1,
              localTimestamp: DateTime(2026, 10, 7, 13, 15),
              foodName: 'Lomo saltado',
              grams: 300,
              provenance: PanelEntryProvenance.photo,
              isAwaitingConfirmation: false,
            ),
            PanelDiaryEntry(
              id: 2,
              localTimestamp: DateTime(2026, 10, 7, 14, 10),
              foodName: 'Ceviche',
              grams: 280,
              provenance: PanelEntryProvenance.photo,
              isAwaitingConfirmation: true,
            ),
          ],
      lastClinicalMeasurement: !withMeasurement
          ? null
          : measurement ??
                PanelClinicalMeasurement(
                  takenAt: DateTime(2026, 9, 3, 10),
                  weightKg: 74.2,
                  protocolChecks: const [PanelProtocolCheck.fasting, PanelProtocolCheck.noShoes],
                ),
    );
  }

  const ai = 'Cumple sus metas casi todos los días. El jueves registró menos energía de la indicada.';

  Future<void> pump(WidgetTester tester, PatientFollowUpState state, {String language = 'es', VoidCallback? onRetry}) {
    return pumpApp(
      tester,
      PatientFollowUpContent(state: state, onRetry: onRetry ?? () {}),
      language: language,
      size: small,
    );
  }

  for (final language in ['es', 'en']) {
    final es = language == 'es';
    group('the six sections ($language)', () {
      testWidgets('are reachable on a small phone without overflow', (tester) async {
        await pump(
          tester,
          PatientFollowUpState(isLoading: false, panel: panel(), aiSummary: ai),
          language: language,
        );

        expect(tester.takeException(), isNull);
        // 1. Weekly compliance
        expect(find.text(es ? 'Esta semana' : 'This week'), findsOneWidget);
        // 2. Weight trend, 3. Logging, 6. Last clinical measurement: the indicator row
        expect(find.text(es ? 'Peso' : 'Weight'), findsOneWidget);
        expect(find.text(es ? 'Registro' : 'Logging'), findsOneWidget);
        expect(find.text(es ? 'Medición' : 'Measure'), findsOneWidget);
        // 4. AI summary, 5. Today's diary
        expect(find.text(es ? 'Resumen generado con IA' : 'AI-generated summary'), findsOneWidget);
        expect(find.text(ai), findsOneWidget);
        expect(find.text(es ? 'Diario de hoy' : "Today's diary"), findsOneWidget);
        expect(find.textContaining('Ceviche'), findsOneWidget);
      });

      testWidgets('the indicators show their values and the protocol is not lost', (tester) async {
        await pump(tester, PatientFollowUpState(isLoading: false, panel: panel()), language: language);

        expect(find.text(es ? '6 de 7' : '6 of 7'), findsOneWidget);
        expect(find.text(es ? 'días' : 'days'), findsOneWidget);
        expect(find.text(es ? 'kg/sem · 4 sem' : 'kg/wk · 4 wk'), findsOneWidget);
        expect(find.text(es ? 'kg · 3 sept' : 'kg · 3 Sep'), findsOneWidget);
        expect(
          find.textContaining(es ? 'en ayunas, sin zapatos' : 'fasting, no shoes'),
          findsOneWidget,
        );
      });

      testWidgets('the legend lists the four outcomes even when the week has only one', (tester) async {
        final onlyUnlogged = panel(outcomes: List.filled(7, ComplianceOutcome.unlogged));
        await pump(tester, PatientFollowUpState(isLoading: false, panel: onlyUnlogged), language: language);

        for (final label in es
            ? ['Dentro de metas', 'Por encima', 'Por debajo', 'Sin registro']
            : ['Within targets', 'Above', 'Below', 'Not logged']) {
          expect(find.text(label), findsOneWidget, reason: label);
        }
      });
    });
  }

  group('accordions', () {
    testWidgets('the AI summary folds and opens again, keeping its badge', (tester) async {
      await pump(tester, PatientFollowUpState(isLoading: false, panel: panel(), aiSummary: ai));
      expect(find.text(ai), findsOneWidget);

      await tester.ensureVisible(find.text('Resumen generado con IA'));
      await tester.tap(find.text('Resumen generado con IA'));
      await tester.pumpAndSettle();
      expect(find.text(ai), findsNothing);
      expect(find.text('Resumen generado con IA'), findsOneWidget);

      await tester.tap(find.text('Resumen generado con IA'));
      await tester.pumpAndSettle();
      expect(find.text(ai), findsOneWidget);
    });

    testWidgets('the diary folds but its header still says how many are pending', (tester) async {
      await pump(tester, PatientFollowUpState(isLoading: false, panel: panel(), aiSummary: ai));

      await tester.ensureVisible(find.text('Diario de hoy'));
      await tester.tap(find.text('Diario de hoy'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Ceviche'), findsNothing);
      expect(find.text('1 por confirmar'), findsOneWidget);
    });

    testWidgets('the header announces Show or Hide to a screen reader', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, PatientFollowUpState(isLoading: false, panel: panel(), aiSummary: ai));

      expect(tester.getSemantics(find.text('Diario de hoy')), isNotNull);
      expect(find.bySemanticsLabel(RegExp('Diario de hoy')), findsWidgets);
      handle.dispose();
    });
  });

  group('data that is missing', () {
    testWidgets('a day without meals says so and a missing measurement shows a dash', (tester) async {
      await pump(
        tester,
        PatientFollowUpState(
          isLoading: false,
          panel: PatientMonitoringPanel(
            date: DateTime(2026, 10, 7),
            week: PanelWeek(days: week(List.filled(7, ComplianceOutcome.unlogged)), metDays: 0, totalDays: 7),
            diary: const [],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Todavía no hay comidas registradas hoy.'), findsOneWidget);
      // Weight, logging and measurement have no value: three dashes.
      expect(find.text('—'), findsNWidgets(3));
    });

    testWidgets('the AI card is hidden without a summary', (tester) async {
      await pump(tester, PatientFollowUpState(isLoading: false, panel: panel(), aiSummary: null));

      expect(find.text('Resumen generado con IA'), findsNothing);
      expect(find.text('Diario de hoy'), findsOneWidget);
    });

    testWidgets('a long AI summary fits on a small phone', (tester) async {
      const long =
          'El paciente registró solo un día durante la semana, el jueves, en el cual excedió la meta de energía en el '
          'almuerzo y tuvo una entrada fuera del plan. Los otros seis días del periodo permanecieron sin registro. No se '
          'realizaron pesajes en el hogar durante esta semana.';
      await pump(tester, PatientFollowUpState(isLoading: false, panel: panel(diary: const []), aiSummary: long));

      expect(tester.takeException(), isNull);
      expect(find.text(long), findsOneWidget);
    });
  });

  group('states of the tab', () {
    testWidgets('loading shows no sections', (tester) async {
      await pump(tester, const PatientFollowUpState());

      expect(find.text('Esta semana'), findsNothing);
      expect(find.text('Diario de hoy'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('an error offers retry', (tester) async {
      var retried = 0;
      await pump(
        tester,
        const PatientFollowUpState(isLoading: false, loadFailed: true),
        onRetry: () => retried++,
      );

      await tester.tap(find.text('Reintentar'));

      expect(retried, 1);
    });

    testWidgets('offline explains and offers retry', (tester) async {
      await pump(tester, const PatientFollowUpState(isLoading: false, isOffline: true, loadFailed: true));

      expect(find.text('Necesitas conexión'), findsWidgets);
      expect(find.text('Reintentar'), findsOneWidget);
    });
  });
}

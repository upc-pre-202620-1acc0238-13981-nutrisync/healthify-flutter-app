import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/main/presentation/screen/patient_history_tab.dart';
import 'package:healthify/features/main/presentation/state/patient_history_state.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_record.dart';
import 'package:healthify/features/nutritionalcare/presentation/components/record_detail_sheets.dart';

import '../../../core/designsystem/test_fonts.dart';
import '../../nutritionalcare/fakes.dart';

void main() {
  setUpAll(loadAppFonts);

  Future<void> pump(WidgetTester tester, Widget child, {String language = 'es', double width = 320}) async {
    await tester.binding.setSurfaceSize(Size(width, 800));
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
        home: Scaffold(body: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  final referral = ReferralSummary(
    id: 1,
    specialty: 'Endocrinología',
    issuedAt: DateTime.utc(2026, 9, 8, 15),
    isOpen: true,
    reason: 'Descartar hipotiroidismo.',
  );

  PatientHistoryState state({PractitionerPatientRecord? record, bool recordFailed = false}) => PatientHistoryState(
    isLoading: false,
    data: HistoryData(baseline: baseline(), record: record, recordFailed: recordFailed),
  );

  Widget content(
    PatientHistoryState state, {
    ValueChanged<ReferralSummary>? onReferral,
    ValueChanged<int>? onEvaluation,
    VoidCallback? onRetry,
  }) => PatientHistoryContent(
    state: state,
    onEditBaseline: () {},
    onRetry: onRetry ?? () {},
    onSelectReferral: onReferral ?? (_) {},
    onSelectEvaluation: onEvaluation ?? (_) {},
  );

  group('Record tab sections', () {
    testWidgets('Spanish: indicators, diagnosis, referral and assessments, without overflow at 320 dp', (tester) async {
      await pump(tester, content(state(record: practitionerRecord(referrals: [referral]))));

      expect(find.text('Peso clínico'), findsOneWidget);
      expect(find.text('74,2 kg'), findsOneWidget);
      expect(find.textContaining('−1,8 kg desde marzo'), findsOneWidget);
      expect(find.text('IMC'), findsOneWidget);
      expect(find.text('Metas vigentes'), findsOneWidget);
      expect(find.text('1.796 kcal'), findsOneWidget);
      expect(find.text('Cumplimiento'), findsOneWidget);
      expect(find.text('5 de 7 días'), findsOneWidget);
      expect(find.text('Diagnóstico activo'), findsOneWidget);
      expect(find.textContaining('solo profesional'), findsOneWidget);
      expect(find.text('Derivación a Endocrinología'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('EVALUACIONES'), 200, scrollable: find.byType(Scrollable).first);
      expect(find.textContaining('primera evaluación'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('English renders the same sections', (tester) async {
      await pump(tester, content(state(record: practitionerRecord(referrals: [referral]))), language: 'en');

      expect(find.text('Clinical weight'), findsOneWidget);
      expect(find.text('Current targets'), findsOneWidget);
      expect(find.text('Active diagnosis'), findsOneWidget);
      expect(find.textContaining('practitioner only'), findsOneWidget);
      expect(find.text('Referral to Endocrinología'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a record with nothing in it shows the empty copy of each card', (tester) async {
      await pump(tester, content(state(record: const PractitionerPatientRecord())));

      expect(find.text('Aún sin medición'), findsNWidgets(2));
      expect(find.text('Aún sin plan'), findsOneWidget);
      expect(find.textContaining('Aún sin diagnóstico'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Aún sin evaluaciones'), 200, scrollable: find.byType(Scrollable).first);
      expect(find.text('Aún sin evaluaciones'), findsOneWidget);
    });

    testWidgets('tapping a referral and an assessment reports them', (tester) async {
      ReferralSummary? tappedReferral;
      int? tappedEvaluation;
      await pump(
        tester,
        content(
          state(record: practitionerRecord(referrals: [referral])),
          onReferral: (r) => tappedReferral = r,
          onEvaluation: (id) => tappedEvaluation = id,
        ),
      );

      await tester.tap(find.text('Derivación a Endocrinología'));
      expect(tappedReferral!.id, 1);
      await tester.scrollUntilVisible(find.textContaining('primera evaluación'), 200, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.textContaining('primera evaluación'));
      expect(tappedEvaluation, 1);
    });

    testWidgets('a record that could not be read says so and retries; the baseline is still there', (tester) async {
      var retried = 0;
      await pump(tester, content(state(recordFailed: true), onRetry: () => retried++));

      expect(find.text('No pudimos cargar el expediente.'), findsOneWidget);
      await tester.tap(find.text('Reintentar'));
      expect(retried, 1);
      expect(find.text('Datos base'), findsWidgets);
    });
  });

  group('Detail sheets', () {
    testWidgets('assessment: measurements, BMI category, activity, protocol and habits', (tester) async {
      await pump(tester, EvaluationSheetContent(detail: evaluationDetail(), onRetry: () {}));

      expect(find.text('Evaluación'), findsOneWidget);
      expect(find.textContaining('31 años'), findsOneWidget);
      expect(find.text('74,2 kg'), findsOneWidget);
      expect(find.text('168 cm'), findsOneWidget);
      expect(find.text('Hábitos alimentarios'), findsOneWidget);
      expect(find.text('Datos bioquímicos'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('assessment: failed shows the retry', (tester) async {
      var retried = 0;
      await pump(tester, EvaluationSheetContent(failed: true, onRetry: () => retried++));

      await tester.tap(find.text('Reintentar'));
      expect(retried, 1);
    });

    testWidgets('referral: status, dates and the practitioner reason as written', (tester) async {
      await pump(tester, ReferralSheetContent(referral: referral));

      expect(find.text('Derivaciones'), findsOneWidget);
      expect(find.text('Derivación a Endocrinología'), findsOneWidget);
      expect(find.text('En curso'), findsOneWidget);
      expect(find.text('Descartar hipotiroidismo.'), findsOneWidget);
    });

    testWidgets('referral without a reason says so', (tester) async {
      await pump(
        tester,
        ReferralSheetContent(
          referral: ReferralSummary(id: 2, specialty: 'Cardiología', issuedAt: DateTime.utc(2026, 8, 1), isOpen: false),
        ),
      );

      expect(find.text('Cerrada'), findsOneWidget);
      expect(find.text('Sin motivo registrado.'), findsOneWidget);
    });
  });
}

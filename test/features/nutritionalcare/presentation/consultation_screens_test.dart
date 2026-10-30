import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/designsystem/component/offline_banner.dart';
import 'package:healthify/core/designsystem/component/skeleton.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/di/service_locator.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/diagnosis_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/measurement_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/publication_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/targets_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/screen/diagnosis_step_screen.dart';
import 'package:healthify/features/nutritionalcare/presentation/screen/measurement_step_screen.dart';
import 'package:healthify/features/nutritionalcare/presentation/screen/publication_step_screen.dart';
import 'package:healthify/features/nutritionalcare/presentation/screen/targets_step_screen.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/consultation_step_states.dart';

import '../../../core/designsystem/test_fonts.dart';
import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakeConsultationRepository consultations;
  late FakePatientBaselineRepository baselines;
  late FakeConnectivity connectivity;
  final events = <ConsultationStepEvent>[];

  setUpAll(loadAppFonts);

  setUp(() async {
    await getIt.reset();
    consultations = FakeConsultationRepository();
    baselines = FakePatientBaselineRepository()..getResult = Result.success(baseline());
    connectivity = FakeConnectivity();
    events.clear();
    getIt
      ..registerFactoryParam<MeasurementStepCubit, int, void>(
        (id, _) => MeasurementStepCubit(
          GetConsultationInProgressUseCase(consultations),
          GetPatientBaselineUseCase(baselines),
          RecordConsultationMeasurementUseCase(consultations),
          DiscardConsultationUseCase(consultations),
          connectivity,
          patientId: id,
        ),
      )
      ..registerFactoryParam<DiagnosisStepCubit, int, void>(
        (id, _) => DiagnosisStepCubit(
          GetConsultationInProgressUseCase(consultations),
          SuggestDiagnosisUseCase(consultations),
          IssueConsultationDiagnosisUseCase(consultations),
          connectivity,
          patientId: id,
        ),
      )
      ..registerFactoryParam<TargetsStepCubit, int, void>(
        (id, _) => TargetsStepCubit(
          GetConsultationInProgressUseCase(consultations),
          ProposeConsultationTargetsUseCase(consultations),
          PrescribeConsultationTargetsUseCase(consultations),
          connectivity,
          patientId: id,
        ),
      )
      ..registerFactoryParam<PublicationStepCubit, int, void>(
        (id, _) => PublicationStepCubit(
          GetConsultationInProgressUseCase(consultations),
          SuggestGuidelinesUseCase(consultations),
          SavePublicationDraftUseCase(consultations),
          PublishConsultationUseCase(consultations),
          IdempotencyKeyStore(),
          connectivity,
          patientId: id,
        ),
      );
  });

  tearDown(() => getIt.reset());

  Future<void> pump(
    WidgetTester tester,
    Widget screen, {
    String language = 'es',
    Size size = const Size(360, 800),
    bool settle = true,
  }) async {
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
        home: screen,
      ),
    );
    settle ? await tester.pumpAndSettle() : await tester.pump();
  }

  MeasurementStepScreen measurement() => MeasurementStepScreen(
    patientId: 7,
    patientName: 'Ana Flores',
    resumePath: '/m',
    onEvent: (_, event) => events.add(event),
    onEditBaseline: () {},
  );

  DiagnosisStepScreen diagnosis() =>
      DiagnosisStepScreen(patientId: 7, onBack: () {}, onEvent: (_, event) => events.add(event));

  TargetsStepScreen targets() =>
      TargetsStepScreen(patientId: 7, onBack: () {}, onEvent: (_, event) => events.add(event));

  PublicationStepScreen publication() => PublicationStepScreen(patientId: 7, onEvent: (_, event) => events.add(event));

  const languages = ['es', 'en'];
  String t(String language, String es, String en) => language == 'es' ? es : en;

  group('Step 1 · measurement', () {
    testWidgets('fits a small phone in both languages, with the check-in, baseline and live BMI', (tester) async {
      consultations.inProgressResult = Result.success(
        consultation(
          checkIn: PatientCheckIn(
            feeling: 'Fair',
            difficulties: const ['Dinners', 'Weekends'],
            questions: const ['¿Puedo comer fuera los viernes?'],
            submittedAt: DateTime.utc(2026, 9, 15, 15),
          ),
        ),
      );
      for (final language in languages) {
        await pump(tester, measurement(), language: language, size: const Size(320, 568));

        expect(find.text(t(language, 'CONSULTA DE HOY', "TODAY'S CONSULTATION")), findsOneWidget);
        expect(
          find.text(t(language, 'PASO 1 DE 4 · MEDICIÓN DE HOY', 'STEP 1 OF 4 · TODAY\'S MEASUREMENT')),
          findsOneWidget,
        );
        expect(find.text(t(language, 'Antes de la consulta, Ana contó', 'Before the consultation, Ana shared')), findsOneWidget);
        expect(find.text('• ${t(language, 'Pregunta', 'Question')}: ¿Puedo comer fuera los viernes?'), findsOneWidget);
        expect(find.text(t(language, 'Continuar a diagnóstico', 'Continue to diagnosis')), findsOneWidget);

        await tester.enterText(find.byType(EditableText).first, language == 'es' ? '74,2' : '74.2');
        await tester.pumpAndSettle();
        expect(find.text(language == 'es' ? '26,3 kg/m²' : '26.3 kg/m²'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('an empty form marks protocol, activity and weight when continuing', (tester) async {
      consultations.inProgressResult = Result.success(freshConsultation());
      await pump(tester, measurement());

      await tester.tap(find.text('Continuar a diagnóstico'));
      await tester.pumpAndSettle();

      expect(find.text('Escribe el peso en kg.'), findsOneWidget);
      expect(find.text('Marca al menos una casilla del protocolo.'), findsOneWidget);
      expect(find.text('Elige la actividad física actual.'), findsOneWidget);
      expect(consultations.measurements, isEmpty);
    });

    testWidgets('out-of-range values show their range under the field, in the decimal the language uses', (tester) async {
      consultations.inProgressResult = Result.success(freshConsultation());
      await pump(tester, measurement(), language: 'en');
      await tester.enterText(find.byType(EditableText).first, '351');
      await tester.tap(find.text('Continue to diagnosis'));
      await tester.pumpAndSettle();

      expect(find.text('Weight goes from 20 to 350 kg.'), findsOneWidget);
    });

    testWidgets('habits and biochemistry expand with their own fields and units', (tester) async {
      consultations.inProgressResult = Result.success(freshConsultation());
      await pump(tester, measurement());

      await tester.ensureVisible(find.text('Hábitos alimentarios'));
      await tester.tap(find.text('Hábitos alimentarios'));
      await tester.pumpAndSettle();
      expect(find.text('Comidas al día'), findsOneWidget);
      expect(find.text('L/día'), findsOneWidget);

      await tester.ensureVisible(find.text('Datos bioquímicos'));
      await tester.tap(find.text('Datos bioquímicos'));
      await tester.pumpAndSettle();
      expect(find.text('Glucosa en ayunas'), findsOneWidget);
      expect(find.text('mg/dL'), findsNWidgets(3));
    });

    testWidgets('without a connection: the banner shows and "Continue" is off', (tester) async {
      consultations.inProgressResult = Result.success(freshConsultation());
      connectivity = FakeConnectivity(online: false);
      await pump(tester, measurement());

      expect(find.byType(OfflineBanner), findsOneWidget);
      await tester.tap(find.text('Continuar a diagnóstico'));
      await tester.pumpAndSettle();
      expect(consultations.measurements, isEmpty);
    });

    testWidgets('a load that failed offline says the connection is needed, with retry', (tester) async {
      consultations.inProgressResult = const Result.failure(Network());
      await pump(tester, measurement());

      expect(find.text('Necesitas conexión'), findsOneWidget);
      expect(find.text('Necesitas conexión para continuar la consulta. Lo que ya guardaste no se pierde.'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('a server failure while loading is the error state with retry', (tester) async {
      consultations.inProgressResult = const Result.failure(Unexpected('HTTP_500'));
      await pump(tester, measurement());

      expect(find.text('Reintentar'), findsOneWidget);
      expect(find.text('Continuar a diagnóstico'), findsNothing);
    });

    testWidgets('shows the skeleton while the consultation loads', (tester) async {
      consultations
        ..inProgressResult = Result.success(freshConsultation())
        ..inProgressGate = Completer<void>();
      await pump(tester, measurement(), settle: false);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SkeletonCard), findsNWidgets(2));
      expect(find.text('Continuar a diagnóstico'), findsNothing);

      consultations.inProgressGate!.complete();
      await tester.pumpAndSettle();
      expect(find.byType(SkeletonCard), findsNothing);
      expect(find.text('Continuar a diagnóstico'), findsOneWidget);
    });
  });

  group('Step 2 · diagnosis', () {
    setUp(() => consultations.inProgressResult = Result.success(consultationAtDiagnosis()));

    testWidgets('the AI suggestion carries its mark, rationale and disclaimer; both languages fit a small phone', (tester) async {
      for (final language in languages) {
        await pump(tester, diagnosis(), language: language, size: const Size(320, 568));

        expect(find.text(t(language, 'Sugerencia de IA', 'AI suggestion')), findsOneWidget);
        expect(find.text('IMC 26.3 kg/m2 (rango 25 a 29.9).'), findsOneWidget);
        expect(find.text('Revisa antes de usar.'), findsOneWidget);
        expect(find.text(t(language, 'Usar sugerencia', 'Use suggestion')), findsOneWidget);
        expect(find.text(t(language, 'Continuar a metas', 'Continue to targets')), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('the rule suggestion is not labeled AI', (tester) async {
      consultations.suggestDiagnosisResult = Result.success(diagnosisSuggestion(fromAi: false));
      await pump(tester, diagnosis());

      expect(find.text('Sugerencia de IA'), findsNothing);
      expect(find.text('Sugerencia según el IMC'), findsOneWidget);
    });

    testWidgets('while the AI works it says so, and the list can already be used', (tester) async {
      consultations.suggestDiagnosisGate = Completer<void>();
      await pump(tester, diagnosis(), settle: false);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Generando con IA. Puede tardar hasta un minuto.'), findsOneWidget);
      await tester.tap(find.text('Peso normal'));
      await tester.pump();

      consultations.suggestDiagnosisGate!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Generando con IA. Puede tardar hasta un minuto.'), findsNothing);
      expect(find.text('Sugerencia de IA'), findsOneWidget);
    });

    testWidgets('when the AI fails the card says so with retry, and retry brings the suggestion', (tester) async {
      consultations.suggestDiagnosisResult = const Result.failure(Network());
      await pump(tester, diagnosis());

      expect(find.text('No pudimos generar la sugerencia de IA'), findsOneWidget);
      expect(find.text('Sugerencia de IA'), findsNothing);
      // The closed list keeps working.
      await tester.tap(find.text('Bajo peso'));
      await tester.pump();

      consultations.suggestDiagnosisResult = Result.success(diagnosisSuggestion());
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text('No pudimos generar la sugerencia de IA'), findsNothing);
      expect(find.text('Sugerencia de IA'), findsOneWidget);
    });

    testWidgets('continuing without choosing asks for a diagnosis', (tester) async {
      await pump(tester, diagnosis());

      await tester.tap(find.text('Continuar a metas'));
      await tester.pumpAndSettle();

      expect(find.text('Elige un diagnóstico para continuar.'), findsOneWidget);
    });

    testWidgets('"Use suggestion" turns into "Suggestion chosen"', (tester) async {
      await pump(tester, diagnosis());

      await tester.tap(find.text('Usar sugerencia'));
      await tester.pumpAndSettle();

      expect(find.text('Sugerencia elegida'), findsOneWidget);
    });
  });

  group('Step 3 · targets', () {
    setUp(() => consultations.inProgressResult = Result.success(consultationAtTargets()));

    testWidgets('shows what it was calculated with, the energy, the macros with their share and the method', (tester) async {
      for (final language in languages) {
        await pump(tester, targets(), language: language, size: const Size(320, 568));

        expect(
          find.text(
            t(
              language,
              'Mujer · 31 años · 168 cm · 74,2 kg · actividad moderada',
              'Woman · 31 years · 168 cm · 74.2 kg · moderate activity',
            ),
          ),
          findsOneWidget,
        );
        expect(find.text(t(language, 'kcal por día', 'kcal per day')), findsOneWidget);
        expect(find.text('119 g'), findsOneWidget);
        expect(find.text(t(language, 'Proteína · 27 %', 'Protein · 27 %')), findsOneWidget);
        expect(find.text(t(language, 'Carbohid. · 43 %', 'Carbs · 43 %')), findsOneWidget);
        expect(find.text(t(language, 'Grasa · 30 %', 'Fat · 30 %')), findsOneWidget);
        expect(
          find.text(
            t(
              language,
              'Mifflin-St Jeor · déficit de 500 kcal · factor de actividad 1,55',
              'Mifflin-St Jeor · 500 kcal deficit · activity factor 1.55',
            ),
          ),
          findsOneWidget,
        );
        expect(find.text(t(language, 'Aceptar metas', 'Accept targets')), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('while calculating it says so; a failure with nothing to show is the error with retry', (tester) async {
      consultations.proposeTargetsResult = const Result.failure(Unexpected('HTTP_500'));
      await pump(tester, targets());

      expect(find.text('Reintentar'), findsOneWidget);
      expect(find.text('Aceptar metas'), findsNothing);
    });

    testWidgets('"Change parameters" opens the sheet prefilled; invalid values show the guidance and valid ones recalculate', (
      tester,
    ) async {
      await pump(tester, targets());

      await tester.tap(find.text('Cambiar parámetros'));
      await tester.pumpAndSettle();
      expect(find.text('Ecuación'), findsOneWidget);
      expect(find.text('Katch-McArdle'), findsOneWidget);

      await tester.enterText(find.byType(EditableText).at(1), '4');
      await tester.ensureVisible(find.text('Recalcular metas'));
      await tester.tap(find.text('Recalcular metas'));
      await tester.pumpAndSettle();
      expect(
        find.text('Revisa los valores: déficit de 0 a 1500 kcal o de 0 a 40 %, proteína de 0,5 a 3 g/kg y grasa de 15 a 45 %.'),
        findsOneWidget,
      );

      await tester.enterText(find.byType(EditableText).at(1), '1,8');
      await tester.ensureVisible(find.text('Recalcular metas'));
      await tester.tap(find.text('Recalcular metas'));
      await tester.pumpAndSettle();
      expect(find.text('Ecuación'), findsNothing);
      expect(consultations.parametersSent.last!.proteinGramsPerKg, 1.8);
    });

    testWidgets('"Write my own values" asks for the reason and saves', (tester) async {
      await pump(tester, targets());

      await tester.tap(find.text('Escribir mis propios valores'));
      await tester.pumpAndSettle();
      expect(find.text('Tus propios valores'), findsOneWidget);

      await tester.ensureVisible(find.text('Guardar y continuar'));
      await tester.tap(find.text('Guardar y continuar'));
      await tester.pumpAndSettle();
      expect(find.text('Escribe la razón del cambio: queda en el expediente.'), findsOneWidget);
      expect(consultations.prescriptions, isEmpty);

      await tester.enterText(find.byType(EditableText).last, 'Su ritmo de trabajo');
      await tester.ensureVisible(find.text('Guardar y continuar'));
      await tester.tap(find.text('Guardar y continuar'));
      await tester.pumpAndSettle();

      expect(consultations.prescriptions, hasLength(1));
      expect(find.text('Tus propios valores'), findsNothing);
    });
  });

  group('Step 4 · publication', () {
    setUp(() => consultations.inProgressResult = Result.success(consultationAtPublication()));

    testWidgets('restrictions, guidelines with their AI mark and the message fit a small phone in both languages', (
      tester,
    ) async {
      for (final language in languages) {
        await pump(tester, publication(), language: language, size: const Size(320, 568));

        expect(find.text(t(language, 'Restricciones', 'Restrictions')), findsOneWidget);
        expect(find.text(t(language, 'Sugeridas por IA según el diagnóstico', 'Suggested by AI based on the diagnosis')), findsOneWidget);
        expect(find.text(t(language, 'Publicar y cerrar consulta', 'Publish and close consultation')), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text(t(language, 'Mensaje para tu paciente', 'Message for your patient')),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('the rule suggestions are not labeled AI', (tester) async {
      consultations.suggestGuidelinesResult = Result.success(guidelineSuggestions(fromAi: false));
      await pump(tester, publication());

      expect(find.text('Sugeridas por IA según el diagnóstico'), findsNothing);
      expect(find.text('Sugeridas según el diagnóstico'), findsOneWidget);
    });

    testWidgets('while the AI works the form is already there; a failure offers retry on the suggestions only', (tester) async {
      consultations.suggestGuidelinesGate = Completer<void>();
      await pump(tester, publication(), settle: false);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Restricciones'), findsOneWidget);
      expect(find.text('Generando con IA. Puede tardar hasta un minuto.'), findsOneWidget);

      consultations.suggestGuidelinesResult = const Result.failure(Network());
      consultations.suggestGuidelinesGate!.complete();
      await tester.pumpAndSettle();
      expect(
        find.text('No pudimos cargar las indicaciones sugeridas por IA. Puedes elegir las tuyas o volver a intentarlo.'),
        findsOneWidget,
      );
      expect(find.text('Restricciones'), findsOneWidget);

      consultations.suggestGuidelinesResult = Result.success(guidelineSuggestions());
      await tester.ensureVisible(find.text('Reintentar'));
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.text('Sugeridas por IA según el diagnóstico'), findsOneWidget);
    });

    testWidgets('"Other guideline" explains its limits', (tester) async {
      await pump(tester, publication());

      await tester.ensureVisible(find.text('Otra indicación'));
      await tester.tap(find.text('Otra indicación'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText).at(0), 'ab');
      await tester.ensureVisible(find.text('Agregar indicación'));
      await tester.tap(find.text('Agregar indicación'));
      await tester.pumpAndSettle();

      expect(find.text('Escribe de 3 a 140 caracteres.'), findsOneWidget);
    });

    testWidgets('a message past 500 characters is flagged and turns publishing off', (tester) async {
      await pump(tester, publication());

      await tester.scrollUntilVisible(find.text('Mensaje (opcional)'), 100, scrollable: find.byType(Scrollable).first);
      await tester.enterText(find.byType(EditableText).last, 'x' * 501);
      await tester.pumpAndSettle();

      expect(find.text('Usa como máximo 500 caracteres.'), findsOneWidget);
    });

    testWidgets('a publish failure is the full-screen error that blames no one, and retry publishes', (tester) async {
      consultations.publishResults.addAll([const Result.failure(Network()), Result.success(consultation())]);
      await pump(tester, publication());

      await tester.tap(find.text('Publicar y cerrar consulta'));
      await tester.pumpAndSettle();

      expect(find.text('HUBO UN ERROR'), findsOneWidget);
      expect(find.text('No pudimos publicar el plan. Lo que escribiste no se perdió.'), findsOneWidget);

      await tester.tap(find.text('Volver a intentarlo'));
      await tester.pumpAndSettle();
      expect(consultations.published, hasLength(2));
      expect(events.whereType<StepPublished>(), hasLength(1));
    });
  });
}

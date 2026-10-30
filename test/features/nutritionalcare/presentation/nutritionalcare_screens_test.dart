import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/designsystem/component/healthify_icon_button.dart';
import 'package:healthify/core/designsystem/component/read_only_clickable_field.dart';
import 'package:healthify/core/di/service_locator.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/baseline_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/screen/baseline_screen.dart';

import '../../../core/designsystem/test_fonts.dart';
import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakePatientBaselineRepository baselines;
  late FakeConsultationRepository consultations;
  late FakeConnectivity connectivity;
  final calls = <String>[];

  setUpAll(loadAppFonts);

  setUp(() async {
    await getIt.reset();
    baselines = FakePatientBaselineRepository();
    consultations = FakeConsultationRepository();
    connectivity = FakeConnectivity();
    calls.clear();
    getIt.registerFactoryParam<BaselineCubit, ({int patientId, bool editing}), void>(
      (args, _) => BaselineCubit(
        GetPatientBaselineUseCase(baselines),
        SavePatientBaselineUseCase(baselines),
        StartOrResumeConsultationUseCase(consultations),
        connectivity,
        () => DateTime(2026, 10, 30, 9),
        patientId: args.patientId,
        editing: args.editing,
      ),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pump(
    WidgetTester tester,
    Widget screen, {
    String language = 'es',
    Size size = const Size(360, 800),
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
    await tester.pumpAndSettle();
  }

  BaselineScreen baselineScreen({bool editing = false}) => BaselineScreen(
    patientId: 7,
    editing: editing,
    onBack: () => calls.add('back'),
    onSaved: () => calls.add('saved'),
    onStartConsultation: (step) => calls.add('start:${step.code}'),
  );

  group('Baseline', () {
    testWidgets('first time: the form, with the two buttons and no overflow on a small phone, in both languages', (
      tester,
    ) async {
      for (final language in ['es', 'en']) {
        await pump(tester, baselineScreen(), language: language, size: const Size(320, 568));
        expect(find.byType(TextField), findsNWidgets(2));
        expect(
          find.text(language == 'es' ? 'Guardar e iniciar consulta' : 'Save and start consultation'),
          findsOneWidget,
        );
        expect(find.text(language == 'es' ? 'Guardar y salir' : 'Save and exit'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text(language == 'es' ? 'Gota' : 'Gout'),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        expect(tester.takeException(), isNull, reason: language);
      }
    });

    testWidgets('saving an empty form shows what is missing and sends nothing', (tester) async {
      await pump(tester, baselineScreen());

      await tester.tap(find.text('Guardar y salir'));
      await tester.pumpAndSettle();

      expect(find.text('Elige la fecha de nacimiento.'), findsOneWidget);
      expect(find.text('Elige el sexo biológico.'), findsOneWidget);
      expect(find.text('Escribe la talla en cm.'), findsOneWidget);
      expect(baselines.calls, isEmpty);
      expect(calls, isEmpty);
    });

    testWidgets('an out of range height is refused with its message, which goes away when it is fixed', (tester) async {
      await pump(tester, baselineScreen());

      await tester.enterText(find.byType(TextField).last, '300');
      await tester.tap(find.text('Guardar y salir'));
      await tester.pumpAndSettle();
      expect(find.text('La talla va de 50 a 250 cm.'), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, '168');
      await tester.pumpAndSettle();
      expect(find.text('La talla va de 50 a 250 cm.'), findsNothing);
    });

    testWidgets('the birth date opens a date picker, and cancelling leaves it empty', (tester) async {
      await pump(tester, baselineScreen());

      await tester.tap(find.byType(ReadOnlyClickableField));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsNothing);
      expect(find.textContaining('Edad:'), findsNothing);
    });

    testWidgets('with everything but the birth date filled, only the date is asked for', (tester) async {
      await pump(tester, baselineScreen());

      await tester.tap(find.text('Femenino'));
      await tester.enterText(find.byType(TextField).last, '168,5');
      await tester.ensureVisible(find.text('Hipotiroidismo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hipotiroidismo'));
      await tester.ensureVisible(find.text('Guardar y salir'));
      await tester.tap(find.text('Guardar y salir'));
      await tester.pumpAndSettle();

      expect(find.text('Elige el sexo biológico.'), findsNothing);
      expect(find.text('Escribe la talla en cm.'), findsNothing);
      expect(find.text('Elige la fecha de nacimiento.'), findsOneWidget);
      expect(baselines.calls, isEmpty);
    });

    testWidgets('editing: preloaded, one "Save changes" button, saved with PUT', (tester) async {
      baselines.getResult = Result.success(baseline(heightCm: 168.5));
      await pump(tester, baselineScreen(editing: true));

      expect(find.text('Guardar cambios'), findsOneWidget);
      expect(find.text('Guardar e iniciar consulta'), findsNothing);
      expect(find.text('168.5'), findsOneWidget);
      expect(find.text('Edad: 31 años (se actualiza sola)'), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, '170');
      await tester.tap(find.text('Guardar cambios'));
      await tester.pumpAndSettle();

      expect(baselines.calls, ['get', 'update']);
      expect(calls, ['saved']);
    });

    testWidgets('a save that fails shows the server notice and retry sends it again', (tester) async {
      baselines.getResult = Result.success(baseline());
      baselines.updateResult = const Result.failure(Unexpected('HTTP_500'));
      await pump(tester, baselineScreen(editing: true));

      await tester.tap(find.text('Guardar cambios'));
      await tester.pumpAndSettle();
      expect(find.text('ALGO FALLÓ'), findsOneWidget);

      baselines.updateResult = Result.success(baseline());
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(baselines.calls, ['get', 'update', 'update']);
      expect(calls, ['saved']);
    });

    testWidgets('offline the save buttons are disabled and the banner shows', (tester) async {
      await pump(tester, baselineScreen());

      connectivity.set(false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar y salir'));
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión. Necesitas conexión para continuar.'), findsOneWidget);
      expect(baselines.calls, isEmpty);
      expect(find.text('Elige la fecha de nacimiento.'), findsNothing);
    });

    testWidgets('back goes back', (tester) async {
      await pump(tester, baselineScreen());

      await tester.tap(find.byType(HealthifyIconButton));
      expect(calls, ['back']);
    });
  });
}

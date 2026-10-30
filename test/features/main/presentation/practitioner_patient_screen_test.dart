import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/designsystem/component/healthify_button.dart';
import 'package:healthify/core/designsystem/component/healthify_icon_button.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/di/service_locator.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import 'package:healthify/features/main/presentation/cubit/patient_history_cubit.dart';
import 'package:healthify/features/main/presentation/navigation/patient_snackbar_request.dart';
import 'package:healthify/features/main/presentation/navigation/shell_routes.dart';
import 'package:healthify/features/main/presentation/screen/practitioner_patient_screen.dart';
import 'package:healthify/features/monitoring/application/usecase/monitoring_use_cases.dart';
import 'package:healthify/features/monitoring/presentation/cubit/patient_follow_up_cubit.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_summary.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/patient_plan_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/patient_summary_cubit.dart';

import '../../../core/designsystem/test_fonts.dart';
import '../../carerelationship/fakes.dart';
import '../../monitoring/fakes.dart';
import '../../nutritionalcare/fakes.dart';

/// The patient file with the real cubits over fake repositories.
void main() {
  late FakePatientSummaryRepository summaries;
  late FakePatientBaselineRepository baselines;
  late FakeConsultationRepository consultations;
  late FakeNutritionPlanRepository plans;
  late FakePractitionerMonitoringRepository monitoring;
  late FakePractitionerRecordRepository records;
  late FakePractitionerCareLinkRepository careLinks;
  late FakeConnectivity connectivity;

  final opened = <String>[];
  PatientSnackbarRequest? requestOnReturn;

  setUpAll(loadAppFonts);

  setUp(() async {
    await getIt.reset();
    summaries = FakePatientSummaryRepository();
    baselines = FakePatientBaselineRepository()..getResult = Result.success(baseline());
    consultations = FakeConsultationRepository();
    plans = FakeNutritionPlanRepository();
    monitoring = FakePractitionerMonitoringRepository();
    records = FakePractitionerRecordRepository();
    careLinks = FakePractitionerCareLinkRepository();
    connectivity = FakeConnectivity();
    opened.clear();
    requestOnReturn = null;
    getIt
      ..registerFactoryParam<PatientSummaryCubit, int, void>(
        (id, _) => PatientSummaryCubit(
          GetPatientSummaryUseCase(summaries),
          StartOrResumeConsultationUseCase(consultations),
          connectivity,
          () => DateTime(2026, 10, 30, 9),
          patientId: id,
        ),
      )
      ..registerFactoryParam<PatientFollowUpCubit, int, void>(
        (id, _) => PatientFollowUpCubit(
          GetMonitoringPanelUseCase(monitoring, () => DateTime(2026, 10, 7)),
          GetMonitoringSummaryUseCase(monitoring),
          connectivity,
          patientId: id,
        ),
      )
      ..registerFactoryParam<PatientHistoryCubit, int, void>(
        (id, _) => PatientHistoryCubit(
          GetPatientBaselineUseCase(baselines),
          GetConsultationInProgressUseCase(consultations),
          GetPractitionerRecordUseCase(records),
          GetEvaluationDetailUseCase(records),
          connectivity,
          patientId: id,
        ),
      )
      ..registerFactoryParam<PatientPlanCubit, ({int patientId, int careLinkId}), void>(
        (args, _) => PatientPlanCubit(
          GetPlanHistoryUseCase(plans),
          GetLinkTargetsReadStatusUseCase(careLinks),
          StartOrResumeConsultationUseCase(consultations),
          connectivity,
          patientId: args.patientId,
          careLinkId: args.careLinkId,
        ),
      );
  });

  tearDown(() => getIt.reset());

  Future<void> pumpScreen(WidgetTester tester, {String language = 'es', Size size = const Size(360, 800)}) async {
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
        home: PractitionerPatientScreen(
          route: const PractitionerPatientRoute(patientId: 7, careLinkId: 107, patientName: 'Ana Flores'),
          onBack: () => opened.add('back'),
          onOpenBaseline: (editing) async {
            opened.add('baseline:$editing');
            return requestOnReturn;
          },
          onOpenConsultation: (step) async {
            opened.add('consultation:${step.code}');
            return requestOnReturn;
          },
          onSchedule: () async {
            opened.add('schedule');
            return requestOnReturn;
          },
          onReferral: () async {
            opened.add('referral');
            return requestOnReturn;
          },
          onDischarge: () => opened.add('discharge'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(find.descendant(of: find.byType(TabBar), matching: find.text(label)));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the patient name, four tabs 48 dp tall and the summary first', (tester) async {
    await pumpScreen(tester);

    expect(find.text('ANA FLORES'), findsOneWidget);
    for (final label in ['Resumen', 'Seguimiento', 'Historia', 'Plan']) {
      final tab = find.descendant(of: find.byType(TabBar), matching: find.text(label));
      expect(tab, findsOneWidget, reason: label);
      expect(tester.getSize(find.ancestor(of: tab, matching: find.byType(Tab))).height, 48);
    }
    expect(find.text('Datos base'), findsOneWidget);
    expect(find.text('Plan versión 3 · en tu cartera desde el 12 mar 2026'), findsOneWidget);
  });

  testWidgets('English texts and no overflow on a small phone', (tester) async {
    await pumpScreen(tester, language: 'en', size: const Size(320, 568));

    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('Follow-up'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Baseline data'), findsOneWidget);
    for (final label in ['Follow-up', 'History', 'Plan', 'Summary']) {
      await openTab(tester, label);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('each tab loads when it is first shown, not before', (tester) async {
    await pumpScreen(tester);
    expect(summaries.calls, 1);
    expect(monitoring.panelCalls, 0);
    expect(consultations.inProgressCalls, 0);
    expect(plans.calls, 0);

    await openTab(tester, 'Seguimiento');
    expect(monitoring.panelCalls, 1);
    await openTab(tester, 'Historia');
    expect(consultations.inProgressCalls, 1);
    await openTab(tester, 'Plan');
    expect(plans.calls, 1);
  });

  testWidgets('coming back to a tab refreshes it', (tester) async {
    await pumpScreen(tester);
    await openTab(tester, 'Seguimiento');
    expect(summaries.calls, 1);

    await openTab(tester, 'Resumen');
    expect(summaries.calls, 2);
    expect(monitoring.panelCalls, 1);

    await openTab(tester, 'Seguimiento');
    expect(monitoring.panelCalls, 2);
  });

  testWidgets('the follow-up tab shows the week, the trend and the AI summary', (tester) async {
    await pumpScreen(tester);
    await openTab(tester, 'Seguimiento');

    expect(find.text('Esta semana'), findsOneWidget);
    expect(find.text('4 de 7 días'), findsOneWidget);
    expect(find.text('−0,3 kg/sem'), findsOneWidget);
    expect(find.text('Cumple casi todos los días.'), findsOneWidget);
    expect(find.text('Última medición clínica'), findsOneWidget);
    expect(find.textContaining('Solo lectura'), findsOneWidget);
  });

  testWidgets('the summary trend card jumps to the follow-up tab', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Peso (autopesaje)'));
    await tester.pumpAndSettle();

    expect(find.text('Esta semana'), findsOneWidget);
  });

  testWidgets('"Edit" on the summary opens the baseline form to edit', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();

    expect(opened, ['baseline:true']);
  });

  testWidgets('discharge opens its screen', (tester) async {
    await pumpScreen(tester);

    await tester.scrollUntilVisible(find.text('Dar de alta'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Dar de alta'));
    await tester.pumpAndSettle();

    expect(opened, ['discharge']);
  });

  testWidgets('a patient without baseline shows the empty state and no management', (tester) async {
    summaries.result = Result.success(summary(withBaseline: false, activePlanVersion: null));
    await pumpScreen(tester);

    expect(find.text('Aún no tiene datos base'), findsOneWidget);
    expect(find.text('Nuevo ingreso'), findsOneWidget);
    expect(find.text('Dar de alta'), findsNothing);
  });

  testWidgets('offline with nothing read asks for a connection and retries', (tester) async {
    summaries.result = const Result.failure(Network());
    await pumpScreen(tester);

    expect(find.text('Necesitas conexión'), findsOneWidget);
    expect(find.text('Sin conexión. Necesitas conexión para continuar.'), findsOneWidget);

    summaries.result = Result.success(summary());
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Datos base'), findsOneWidget);
  });

  testWidgets('a server error shows the error state', (tester) async {
    summaries.result = const Result.failure(Unexpected('HTTP_500'));
    await pumpScreen(tester);

    expect(find.text('ALGO FALLÓ'), findsOneWidget);
  });

  group('Summary tab pinned button', () {
    testWidgets('"New consultation" starts one and opens its step', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Nueva consulta'));
      await tester.pumpAndSettle();

      expect(consultations.startedWith, [null]);
      expect(opened, ['consultation:Measurement']);
    });

    testWidgets('with a consultation in progress the button continues it', (tester) async {
      summaries.result = Result.success(
        summary(
          inProgress: ConsultationInProgress(
            id: ConsultationId(9),
            step: ConsultationStep.targets,
            lastSavedAt: DateTime.now(),
          ),
        ),
      );
      await pumpScreen(tester);

      expect(find.text('Consulta en curso'), findsOneWidget);
      await tester.tap(find.text('Continuar consulta'));
      await tester.pumpAndSettle();

      expect(consultations.startedWith, isEmpty);
      expect(opened, ['consultation:Targets']);
    });

    testWidgets('without a baseline the button records it', (tester) async {
      summaries.result = Result.success(summary(withBaseline: false, activePlanVersion: null));
      await pumpScreen(tester);

      await tester.tap(find.text('Registrar datos base'));
      await tester.pumpAndSettle();

      expect(opened, ['baseline:false']);
    });

    testWidgets('a failed start shows the server error notice and retry starts again', (tester) async {
      consultations.startResult = const Result.failure(Unexpected('HTTP_500'));
      await pumpScreen(tester);

      await tester.tap(find.text('Nueva consulta'));
      await tester.pumpAndSettle();
      expect(find.text('ALGO FALLÓ'), findsOneWidget);

      consultations.startResult = Result.success(consultation());
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(opened, ['consultation:Measurement']);
    });

    testWidgets('offline the button is disabled', (tester) async {
      await pumpScreen(tester);

      connectivity.set(false);
      await tester.pumpAndSettle();

      final button = tester.widget<HealthifyButton>(find.widgetWithText(HealthifyButton, 'Nueva consulta'));
      expect(button.enabled, isFalse);
    });

    testWidgets('it stays in the Summary tab: Record and the rest do not show it', (tester) async {
      await pumpScreen(tester);
      await openTab(tester, 'Historia');

      expect(find.widgetWithText(HealthifyButton, 'Nueva consulta'), findsNothing);
    });

    testWidgets('English label and no overflow on a small phone', (tester) async {
      await pumpScreen(tester, language: 'en', size: const Size(320, 568));

      expect(find.text('New consultation'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Record tab', () {
    testWidgets('shows the baseline, the record and no visits section', (tester) async {
      await pumpScreen(tester);
      await openTab(tester, 'Historia');

      expect(find.text('Datos base'), findsOneWidget);
      expect(find.text('Mujer · 31 años · 168 cm · hipotiroidismo'), findsOneWidget);
      expect(find.text('CONSULTAS'), findsNothing);
    });

    testWidgets('shows the consultation in progress, with no button', (tester) async {
      consultations.inProgressResult = Result.success(consultation(step: ConsultationStep.targets));
      await pumpScreen(tester);
      await openTab(tester, 'Historia');

      expect(find.text('Consulta en curso'), findsOneWidget);
      expect(find.text('Paso 3 de 4 · Metas · se guardó hoy'), findsOneWidget);
      expect(find.text('Continuar consulta'), findsNothing);
    });

    testWidgets('"Edit" opens the baseline form', (tester) async {
      await pumpScreen(tester);
      await openTab(tester, 'Historia');

      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();

      expect(opened, ['baseline:true']);
    });

    testWidgets('offline "Edit" is disabled', (tester) async {
      await pumpScreen(tester);
      await openTab(tester, 'Historia');

      connectivity.set(false);
      await tester.pumpAndSettle();

      expect(tester.widget<HealthifyButton>(find.widgetWithText(HealthifyButton, 'Editar')).enabled, isFalse);
      expect(find.text('Sin conexión. Necesitas conexión para continuar.'), findsWidgets);
    });
  });

  group('Plan tab', () {
    testWidgets('shows the targets, whether the patient saw them, the guidelines and the history', (tester) async {
      await pumpScreen(tester);
      await openTab(tester, 'Plan');

      expect(find.text('Metas vigentes'), findsOneWidget);
      expect(find.text('Versión 3'), findsWidgets);
      expect(find.textContaining('Publicadas el 4 sept'), findsOneWidget);
      expect(find.textContaining('Ana las vio el mismo día.'), findsNothing);
      expect(find.text('Prioriza vegetales'), findsOneWidget);
      expect(find.text('Caminar 20 minutos'), findsOneWidget);
      expect(find.text('Sin mariscos'), findsOneWidget);
      expect(find.text('HISTORIAL DEL PLAN'), findsOneWidget);
      expect(find.text('Ajustar plan'), findsOneWidget);
    });

    testWidgets('a history row opens the version detail, and there is no versions screen', (tester) async {
      await pumpScreen(tester);
      await openTab(tester, 'Plan');

      await tester.ensureVisible(find.text('Versión 2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Versión 2'));
      await tester.pumpAndSettle();
      expect(find.text('Publicada el 12 jun 2026'), findsOneWidget);
      expect(find.text('Mensaje al paciente'), findsNothing);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Versión 3').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Versión 3').last);
      await tester.pumpAndSettle();
      expect(find.text('Mensaje al paciente'), findsOneWidget);
      expect(find.text('Vamos muy bien.'), findsOneWidget);
      expect(find.text('Qué cambió en esta versión'), findsNothing);
    });

    testWidgets('"Adjust plan" opens the consultation', (tester) async {
      await pumpScreen(tester);
      await openTab(tester, 'Plan');

      await tester.tap(find.text('Ajustar plan'));
      await tester.pumpAndSettle();

      expect(opened, ['consultation:Measurement']);
    });

    testWidgets('without a published plan it shows the empty state and no button', (tester) async {
      plans.result = Result.success(planHistory(withActive: false));
      await pumpScreen(tester);
      await openTab(tester, 'Plan');

      expect(find.text('Aún sin plan'), findsOneWidget);
      expect(find.text('Ajustar plan'), findsNothing);
    });
  });

  group('snackbars and tab changes after an action', () {
    testWidgets('a published plan goes back to the summary with the confirmation', (tester) async {
      requestOnReturn = const PlanPublished();
      await pumpScreen(tester);
      await openTab(tester, 'Plan');

      await tester.tap(find.text('Ajustar plan'));
      await tester.pumpAndSettle();

      expect(find.text('Plan publicado. Ana Flores ya puede ver sus metas.'), findsOneWidget);
      expect(find.text('Datos base'), findsOneWidget);
      // It goes away on its own.
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('Plan publicado. Ana Flores ya puede ver sus metas.'), findsNothing);
    });

    testWidgets('a recorded referral offers "View", which opens the record tab', (tester) async {
      requestOnReturn = const ReferralRegistered('Endocrinología');
      await pumpScreen(tester);

      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();
      expect(find.text('Derivación a Endocrinología registrada.'), findsOneWidget);
      // The summary stays where it is until the action is tapped.
      expect(find.text('Datos base'), findsOneWidget);
      expect(find.text('EVALUACIONES'), findsNothing);

      await tester.tap(find.text('Ver'));
      await tester.pumpAndSettle();

      expect(find.text('EVALUACIONES'), findsOneWidget);
      expect(find.text('Derivación a Endocrinología registrada.'), findsNothing);
    });

    testWidgets('a scheduled consultation goes back to the summary with the day and time', (tester) async {
      requestOnReturn = FollowUpScheduled(DateTime(2026, 9, 18, 10));
      await pumpScreen(tester);
      await openTab(tester, 'Plan');

      await tester.tap(find.text('Ajustar plan'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Consulta agendada: vie 18 sept'), findsOneWidget);
      expect(find.text('Datos base'), findsOneWidget);
    });

    testWidgets('a new snackbar replaces the one on screen', (tester) async {
      requestOnReturn = const ReferralRegistered('Cardiología');
      await pumpScreen(tester);
      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();

      requestOnReturn = const PlanPublished();
      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Derivación a'), findsNothing);
      expect(find.textContaining('Plan publicado'), findsOneWidget);
    });
  });

  testWidgets('back goes back', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byType(HealthifyIconButton));
    await tester.pumpAndSettle();

    expect(opened, ['back']);
  });
}

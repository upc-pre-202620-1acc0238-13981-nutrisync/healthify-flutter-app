import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/connectivity/connectivity_observer.dart';
import 'package:healthify/core/designsystem/component/healthify_icon_button.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/di/service_locator.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/carerelationship/application/usecase/find_active_care_link_use_case.dart';
import 'package:healthify/features/carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import 'package:healthify/features/carerelationship/domain/entity/patient_roster.dart';
import 'package:healthify/features/carerelationship/domain/repository/practitioner_care_link_repository.dart';
import 'package:healthify/features/carerelationship/infrastructure/di/care_relationship_module.dart';
import 'package:healthify/features/carerelationship/presentation/cubit/discharge_patient_cubit.dart';
import 'package:healthify/features/carerelationship/presentation/cubit/invite_patient_cubit.dart';
import 'package:healthify/features/carerelationship/presentation/cubit/patient_roster_cubit.dart';
import 'package:healthify/features/iam/application/usecase/account_use_cases.dart';
import 'package:healthify/features/iam/application/usecase/session_use_cases.dart';
import 'package:healthify/features/iam/application/usecase/sign_out_use_case.dart';
import 'package:healthify/features/iam/domain/repository/authentication_repository.dart';
import 'package:healthify/features/iam/domain/valueobject/preferred_language.dart';
import 'package:healthify/features/main/presentation/cubit/patient_history_cubit.dart';
import 'package:healthify/features/main/presentation/cubit/practitioner_settings_cubit.dart';
import 'package:healthify/features/main/presentation/cubit/practitioner_shell_cubit.dart';
import 'package:healthify/features/main/presentation/cubit/sign_out_cubit.dart';
import 'package:healthify/features/main/presentation/navigation/patient_snackbar_request.dart';
import 'package:healthify/features/main/presentation/state/practitioner_shell_state.dart';
import 'package:healthify/features/monitoring/application/usecase/monitoring_use_cases.dart';
import 'package:healthify/features/monitoring/application/usecase/practitioner_agenda_use_cases.dart';
import 'package:healthify/features/monitoring/domain/valueobject/monitoring_values.dart'
    show CatalogPreparation, PreparationCode;
import 'package:healthify/features/monitoring/presentation/cubit/practitioner_agenda_cubit.dart';
import 'package:healthify/features/monitoring/presentation/cubit/record_referral_cubit.dart';
import 'package:healthify/features/monitoring/presentation/cubit/schedule_follow_up_cubit.dart';
import 'package:healthify/features/monitoring/presentation/state/practitioner_agenda_states.dart';
import 'package:healthify/features/monitoring/presentation/cubit/patient_follow_up_cubit.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/review_inbox_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation_commands.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_proposal.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/review_values.dart' show ConsistencyEscalation;
import 'package:healthify/features/nutritionalcare/presentation/cubit/adjust_proposal_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/baseline_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/diagnosis_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/measurement_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/patient_plan_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/patient_summary_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/review_inbox_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/review_item_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/publication_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/targets_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/navigation/nutritional_care_routes.dart';
import 'package:healthify/navigation/app_router.dart';
import 'package:healthify/navigation/session_gate.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/designsystem/test_fonts.dart';
import '../features/carerelationship/fakes.dart';
import '../features/monitoring/agenda_fakes.dart';
import '../features/monitoring/fakes.dart';
import '../features/monitoring/reminder_fakes.dart';
import '../features/nutritionalcare/fakes.dart';
import '../features/nutritionalcare/review_fakes.dart';

class _MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class _MockGetLanguage extends Mock implements GetAppLanguageUseCase {}

class _MockApplyLanguage extends Mock implements ApplyAppLanguageUseCase {}

class _MockChangeLanguage extends Mock implements ChangePreferredLanguageUseCase {}

/// The practitioner shell wired with the real router and screens, over a fake backend.
void main() {
  late FakePractitionerCareLinkRepository repository;
  late FakeConnectivity connectivity;
  late FakePatientSummaryRepository summaries;
  late FakePatientBaselineRepository baselines;
  late FakeConsultationRepository consultations;
  late FakeNutritionPlanRepository plans;
  late FakePractitionerMonitoringRepository monitoring;
  late FakePractitionerRecordRepository records;
  late _MockGetLanguage getLanguage;
  late _MockApplyLanguage applyLanguage;
  late _MockChangeLanguage changeLanguage;
  late FakeReviewInboxRepository inbox;
  late FakePractitionerAgendaRepository agenda;
  late SessionGate gate;
  GoRouter? router;

  setUpAll(loadAppFonts);

  setUpAll(() => registerFallbackValue(PreferredLanguage.spanish));

  setUp(() async {
    await getIt.reset();
    repository = FakePractitionerCareLinkRepository()
      ..rosterResult = Result.success(
        PatientRoster([
          rosterPatient(1, 'Ana Flores', hasOpenReviewItem: true),
          rosterPatient(2, 'Jorge Salas'),
        ]),
      );
    connectivity = FakeConnectivity();
    summaries = FakePatientSummaryRepository();
    baselines = FakePatientBaselineRepository()..getResult = Result.success(baseline());
    consultations = FakeConsultationRepository();
    plans = FakeNutritionPlanRepository();
    monitoring = FakePractitionerMonitoringRepository();
    records = FakePractitionerRecordRepository();
    inbox = FakeReviewInboxRepository();
    agenda = FakePractitionerAgendaRepository();
    getLanguage = _MockGetLanguage();
    applyLanguage = _MockApplyLanguage();
    changeLanguage = _MockChangeLanguage();
    when(getLanguage.call).thenReturn(PreferredLanguage.spanish);
    when(() => applyLanguage(any())).thenAnswer((_) async => true);
    when(() => changeLanguage(any())).thenAnswer((_) async => const Result.success(null));
    final session = FakeSessionRepository(practitionerUser());
    final authentication = _MockAuthenticationRepository();
    when(authentication.signOutRemotely).thenAnswer((_) async => const Result.success(null));
    getIt
      ..registerSingleton<ConnectivityObserver>(connectivity)
      ..registerSingleton<PractitionerCareLinkRepository>(repository)
      ..registerSingleton<PractitionerShellMessages>(PractitionerShellMessages())
      ..registerFactory(() => ObserveCurrentUserUseCase(session))
      ..registerFactory(() => PatientRosterCubit(getIt(), GetPatientRosterUseCase(repository), connectivity))
      ..registerFactory(
        () => InvitePatientCubit(IssueInvitationUseCase(repository, DateTime.now), connectivity, DateTime.now),
      )
      ..registerFactoryParam<DischargePatientCubit, DischargeArgs, void>(
        (args, _) => DischargePatientCubit(
          DischargePatientUseCase(repository),
          connectivity,
          careLinkId: args.careLinkId,
          patientName: args.patientName,
        ),
      )
      ..registerFactoryParam<PatientSummaryCubit, int, void>(
        (id, _) => PatientSummaryCubit(
          GetPatientSummaryUseCase(summaries),
          StartOrResumeConsultationUseCase(consultations),
          connectivity,
          DateTime.now,
          patientId: id,
        ),
      )
      ..registerFactoryParam<PatientFollowUpCubit, int, void>(
        (id, _) => PatientFollowUpCubit(
          GetMonitoringPanelUseCase(monitoring, DateTime.now),
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
          GetLinkTargetsReadStatusUseCase(repository),
          StartOrResumeConsultationUseCase(consultations),
          connectivity,
          patientId: args.patientId,
          careLinkId: args.careLinkId,
        ),
      )
      ..registerFactoryParam<BaselineCubit, ({int patientId, bool editing}), void>(
        (args, _) => BaselineCubit(
          GetPatientBaselineUseCase(baselines),
          SavePatientBaselineUseCase(baselines),
          StartOrResumeConsultationUseCase(consultations),
          connectivity,
          DateTime.now,
          patientId: args.patientId,
          editing: args.editing,
        ),
      )
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
      )
      ..registerFactory(() => ReviewInboxCubit(GetOpenReviewItemsUseCase(inbox), connectivity))
      ..registerFactoryParam<ReviewItemCubit, int, void>(
        (id, _) => ReviewItemCubit(
          GetOpenReviewItemUseCase(inbox),
          AwaitPlanProposalUseCase(inbox, wait: (_) async {}),
          ResolveReviewItemUseCase(inbox),
          AcceptPlanProposalUseCase(inbox),
          FindActiveRosterPatientUseCase(getIt(), GetPatientRosterUseCase(repository)),
          connectivity,
          reviewItemId: id,
        ),
      )
      ..registerFactoryParam<AdjustProposalCubit, int, void>(
        (id, _) => AdjustProposalCubit(
          GetOpenReviewItemUseCase(inbox),
          AwaitPlanProposalUseCase(inbox, wait: (_) async {}),
          GetPlanHistoryUseCase(plans),
          AcceptPlanProposalUseCase(inbox),
          connectivity,
          reviewItemId: id,
        ),
      )
      ..registerFactory(
        () => PractitionerAgendaCubit(
          getIt(),
          GetUpcomingFollowUpsUseCase(agenda, _now),
          CancelFollowUpUseCase(agenda),
          FindActiveRosterPatientUseCase(getIt(), GetPatientRosterUseCase(repository)),
          connectivity,
        ),
      )
      ..registerFactoryParam<ScheduleFollowUpCubit, ScheduleFollowUpArgs, void>(
        (args, _) => ScheduleFollowUpCubit(
          ScheduleFollowUpUseCase(agenda, _now),
          RescheduleFollowUpUseCase(agenda, _now),
          GetPatientRosterUseCase(repository),
          getIt(),
          connectivity,
          _now,
          args: args,
        ),
      )
      ..registerFactoryParam<RecordReferralCubit, int, void>(
        (id, _) => RecordReferralCubit(RecordReferralUseCase(agenda), connectivity, patientId: id),
      )
      ..registerFactory(() => PractitionerShellCubit(getIt(), getIt<PractitionerShellMessages>(), idleReminders()))
      ..registerFactory(
        () => PractitionerSettingsCubit(
          ObserveCurrentUserUseCase(session),
          getLanguage,
          applyLanguage,
          changeLanguage,
          connectivity,
        ),
      )
      ..registerFactory(() => SignOutCubit(SignOutUseCase(authentication, session)));
    gate = SessionGate(ObserveIsLoggedInUseCase(session), ObserveSessionExpiredUseCase(session));
  });

  tearDown(() async {
    router?.dispose();
    router = null;
    gate.dispose();
    await getIt.reset();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    tester.binding.platformDispatcher.defaultRouteNameTestValue = patientsPathForTest;
    addTearDown(() {
      tester.binding.setSurfaceSize(null);
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue();
    });
    final created = router = createAppRouter(gate);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: created,
        theme: HealthifyTheme.light(),
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lands on the roster with the three tabs', (tester) async {
    await pumpApp(tester);

    expect(find.text('MIS PACIENTES'), findsOneWidget);
    expect(find.text('Ana Flores'), findsOneWidget);
    expect(find.text('Señal por revisar'), findsOneWidget);
    expect(find.text('Pacientes'), findsOneWidget);
    expect(find.text('Bandeja'), findsOneWidget);
    expect(find.text('Agenda'), findsOneWidget);
  });

  testWidgets('the tabs switch and Patients is reloaded when the person comes back to it', (tester) async {
    await pumpApp(tester);
    expect(repository.rosterCalls, 1);

    await tester.tap(find.text('Bandeja'));
    await tester.pumpAndSettle();
    expect(find.text('BANDEJA'), findsOneWidget);
    expect(find.text('Ana Flores · desviación sostenida'), findsOneWidget);
    expect(inbox.itemsCalls, 1);
    expect(repository.rosterCalls, 1);

    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();
    expect(find.text('AGENDA'), findsOneWidget);
    expect(find.text('Próximas consultas'), findsOneWidget);
    expect(agenda.agendaCalls, 1);

    await tester.tap(find.text('Pacientes'));
    await tester.pumpAndSettle();
    expect(find.text('MIS PACIENTES'), findsOneWidget);
    expect(repository.rosterCalls, 2);
  });

  testWidgets('the menu opens from the top bar and offers Settings and Sign out', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byType(HealthifyIconButton));
    await tester.pumpAndSettle();

    expect(find.text('Lucía Paredes'), findsOneWidget);
    expect(find.text('Nutricionista'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Cerrar sesión'), findsOneWidget);
  });

  testWidgets('Sign out opens its confirmation over the shell and cancel returns', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(HealthifyIconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('¿CERRAR SESIÓN?'), findsOneWidget);
    expect(find.textContaining('Tus pacientes y sus datos quedan guardados'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('MIS PACIENTES'), findsOneWidget);
    expect(find.text('¿CERRAR SESIÓN?'), findsNothing);
  });

  group('settings', () {
    Future<void> openSettings(WidgetTester tester) async {
      await pumpApp(tester);
      await tester.tap(find.byType(HealthifyIconButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ajustes'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows the account, the language and Sign out', (tester) async {
      await openSettings(tester);

      expect(find.text('AJUSTES'), findsOneWidget);
      expect(find.text('Mi cuenta'), findsOneWidget);
      expect(find.textContaining('Lucía Paredes'), findsWidgets);
      expect(find.text('Idioma'), findsOneWidget);
      expect(find.text('Español'), findsOneWidget);
      expect(find.text('Cerrar sesión'), findsOneWidget);
    });

    testWidgets('the language sheet applies the choice, saves it and closes', (tester) async {
      await openSettings(tester);

      await tester.tap(find.text('Idioma'));
      await tester.pumpAndSettle();
      expect(find.text('IDIOMA'), findsOneWidget);

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      verify(() => applyLanguage(PreferredLanguage.english)).called(1);
      verify(() => changeLanguage(PreferredLanguage.english)).called(1);
      expect(find.text('IDIOMA'), findsNothing);
      expect(find.text('AJUSTES'), findsOneWidget);
    });

    testWidgets('"Sign out" opens the confirmation and cancelling comes back to Settings', (tester) async {
      await openSettings(tester);

      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('¿CERRAR SESIÓN?'), findsOneWidget);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.text('AJUSTES'), findsOneWidget);
    });

    testWidgets('the back arrow returns to the tab the person was on', (tester) async {
      await openSettings(tester);

      await tester.tap(find.byType(HealthifyIconButton));
      await tester.pumpAndSettle();

      expect(find.text('MIS PACIENTES'), findsOneWidget);
    });
  });

  group('system back', () {
    Future<void> systemBack(WidgetTester tester) async {
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
    }

    Future<void> openMenu(WidgetTester tester) async {
      await pumpApp(tester);
      await tester.tap(find.byType(HealthifyIconButton));
      await tester.pumpAndSettle();
    }

    testWidgets('Settings returns to the tab', (tester) async {
      await openMenu(tester);
      await tester.tap(find.text('Ajustes'));
      await tester.pumpAndSettle();

      await systemBack(tester);

      expect(find.text('AJUSTES'), findsNothing);
      expect(find.text('MIS PACIENTES'), findsOneWidget);
    });

    testWidgets('the language sheet closes first, then Settings', (tester) async {
      await openMenu(tester);
      await tester.tap(find.text('Ajustes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Idioma'));
      await tester.pumpAndSettle();

      await systemBack(tester);
      expect(find.text('IDIOMA'), findsNothing);
      expect(find.text('AJUSTES'), findsOneWidget);

      await systemBack(tester);
      expect(find.text('MIS PACIENTES'), findsOneWidget);
    });

    testWidgets('the open menu closes before anything else', (tester) async {
      await openMenu(tester);
      // The menu stays mounted and slides in from the right; closed, it is off the 360 dp screen.
      expect(tester.getTopLeft(find.text('Nutricionista')).dx, lessThan(360));

      await systemBack(tester);

      expect(tester.getTopLeft(find.text('Nutricionista')).dx, greaterThanOrEqualTo(360));
      expect(find.text('MIS PACIENTES'), findsOneWidget);
    });

    testWidgets('Sign out confirmation returns to the tab', (tester) async {
      await openMenu(tester);
      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('¿CERRAR SESIÓN?'), findsOneWidget);

      await systemBack(tester);

      expect(find.text('¿CERRAR SESIÓN?'), findsNothing);
      expect(find.text('MIS PACIENTES'), findsOneWidget);
    });

    testWidgets('Invite patient returns to the roster', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Invitar paciente'));
      await tester.pumpAndSettle();

      await systemBack(tester);

      expect(find.text('MIS PACIENTES'), findsOneWidget);
    });

    testWidgets('the baseline form returns to the patient file, and the file to the roster', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Ana Flores'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();
      expect(find.text('DATOS BASE'), findsOneWidget);

      await systemBack(tester);
      expect(find.text('ANA FLORES'), findsOneWidget);

      await systemBack(tester);
      expect(find.text('MIS PACIENTES'), findsOneWidget);
    });
  });

  testWidgets('Invite patient shows the QR code, and coming back reloads the roster', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Invitar paciente'));
    await tester.pumpAndSettle();
    expect(find.text('INVITAR PACIENTE'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(repository.issuedExpirations, hasLength(1));
    expect(repository.rosterCalls, 1);

    await tester.tap(find.byType(HealthifyIconButton));
    await tester.pumpAndSettle();
    expect(find.text('MIS PACIENTES'), findsOneWidget);
    expect(repository.rosterCalls, 2);
  });

  testWidgets('a patient opens the typed route with its care link and name', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Ana Flores'));
    await tester.pumpAndSettle();

    // A pushed screen keeps its own location list; the shell's base location stays under it.
    final top = router!.routerDelegate.currentConfiguration.last;
    final uri = top is ImperativeRouteMatch ? top.matches.uri : router!.routerDelegate.currentConfiguration.uri;
    expect(uri.path, '/patients/1');
    expect(uri.queryParameters, {'careLinkId': '101', 'patientName': 'Ana Flores'});
    expect(find.text('ANA FLORES'), findsOneWidget);
  });

  testWidgets('editing the baseline opens its form and coming back refreshes the file', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Ana Flores'));
    await tester.pumpAndSettle();
    expect(summaries.calls, 1);

    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    expect(find.text('DATOS BASE'), findsOneWidget);
    expect(find.text('Guardar cambios'), findsOneWidget);
    expect(router!.routerDelegate.currentConfiguration.last.matchedLocation, '/patients/1/baseline');

    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(baselines.calls, ['get', 'update']);
    expect(find.text('ANA FLORES'), findsOneWidget);
    expect(summaries.calls, 2);
  });

  testWidgets('the baseline screen goes back without saving', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Ana Flores'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(HealthifyIconButton));
    await tester.pumpAndSettle();

    expect(find.text('ANA FLORES'), findsOneWidget);
    expect(baselines.calls, ['get']);
  });

  group('guided consultation', () {
    String location() => router!.routerDelegate.currentConfiguration.last.matchedLocation;

    Future<void> openPatient(WidgetTester tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Ana Flores'));
      await tester.pumpAndSettle();
    }

    /// "New consultation" from the Summary tab; the backend then has the consultation in progress at step 1.
    Future<void> startConsultation(WidgetTester tester) async {
      await openPatient(tester);
      consultations.inProgressResult = Result.success(freshConsultation());
      await tester.tap(find.text('Nueva consulta'));
      await tester.pumpAndSettle();
    }

    Future<void> tapText(WidgetTester tester, String text) async {
      await tester.ensureVisible(find.text(text));
      await tester.pumpAndSettle();
      await tester.tap(find.text(text));
      await tester.pumpAndSettle();
    }

    Future<void> back(WidgetTester tester) async {
      await tester.tap(find.byType(HealthifyIconButton).first);
      await tester.pumpAndSettle();
    }

    testWidgets('"New consultation" opens step 1; leaving asks first and returns to the file', (tester) async {
      await startConsultation(tester);

      expect(find.text('CONSULTA DE HOY'), findsOneWidget);
      expect(find.text('PASO 1 DE 4 · MEDICIÓN DE HOY'), findsOneWidget);
      expect(location(), '/patients/1/consultation/measurement');

      await back(tester);
      expect(find.text('¿SALIR DE LA CONSULTA?'), findsOneWidget);
      await tester.tap(find.text('Seguir aquí'));
      await tester.pumpAndSettle();
      expect(location(), '/patients/1/consultation/measurement');

      await back(tester);
      await tester.tap(find.text('Salir y continuar después'));
      await tester.pumpAndSettle();
      expect(find.text('ANA FLORES'), findsOneWidget);
      expect(location(), '/patients/1');
      // The Summary tab is the one on screen, and it refreshed on the way back.
      expect(summaries.calls, 2);
    });

    testWidgets('the four steps in a row publish the plan and return to the file with the snackbar', (tester) async {
      await startConsultation(tester);

      // Step 1: the measurement.
      await tester.enterText(find.byType(EditableText).first, '74,2');
      await tapText(tester, 'En ayunas');
      await tapText(tester, 'Moderada');
      consultations.inProgressResult = Result.success(consultationAtDiagnosis());
      await tapText(tester, 'Continuar a diagnóstico');
      expect(consultations.measurements.single.weightKg, 74.2);
      expect(find.text('PASO 2 DE 4 · DIAGNÓSTICO'), findsOneWidget);
      expect(location(), '/patients/1/consultation/diagnosis');

      // "‹" goes back to step 1 with what was saved, and continuing without changes does not resend it.
      await back(tester);
      expect(location(), '/patients/1/consultation/measurement');
      consultations.inProgressResult = Result.success(consultationAtDiagnosis());
      await tapText(tester, 'Continuar a diagnóstico');
      expect(consultations.measurements, hasLength(1));
      expect(location(), '/patients/1/consultation/diagnosis');

      // Step 2: the AI suggestion, accepted.
      expect(find.text('Sugerencia de IA'), findsOneWidget);
      await tapText(tester, 'Usar sugerencia');
      consultations.inProgressResult = Result.success(consultationAtTargets());
      await tapText(tester, 'Continuar a metas');
      expect(consultations.diagnoses.single, isA<AcceptAiSuggestion>());
      expect(find.text('PASO 3 DE 4 · METAS'), findsOneWidget);

      // Step 3: the calculated targets, accepted.
      expect(find.text('kcal por día'), findsOneWidget);
      consultations.inProgressResult = Result.success(consultationAtPublication());
      await tapText(tester, 'Aceptar metas');
      expect(consultations.prescriptions.single, isA<AcceptedAsProposed>());
      expect(find.text('PASO 4 DE 4 · INDICACIONES Y PUBLICACIÓN'), findsOneWidget);

      // Step 4: publish.
      await tapText(tester, 'Publicar y cerrar consulta');
      expect(consultations.published, hasLength(1));
      expect(find.text('ANA FLORES'), findsOneWidget);
      expect(location(), '/patients/1');
      expect(find.text('Plan publicado. Ana Flores ya puede ver sus metas.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('opened at step 3, "‹" goes to step 2 and leaving returns to the file in one go', (tester) async {
      await openPatient(tester);
      consultations.inProgressResult = Result.success(consultationAtTargets());

      unawaited(
        router!.push(
          const ConsultationRoute(patientId: 1, patientName: 'Ana Flores', step: ConsultationStep.targets).location,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('PASO 3 DE 4 · METAS'), findsOneWidget);

      await back(tester);
      expect(location(), '/patients/1/consultation/diagnosis');
      expect(find.text('PASO 2 DE 4 · DIAGNÓSTICO'), findsOneWidget);

      await back(tester);
      expect(location(), '/patients/1/consultation/measurement');

      // Step 1 has nothing before it: it asks, and leaving pops every step at once.
      await back(tester);
      await tester.tap(find.text('Salir y continuar después'));
      await tester.pumpAndSettle();
      expect(location(), '/patients/1');
      expect(find.text('ANA FLORES'), findsOneWidget);
    });

    testWidgets('deleting the consultation asks first, deletes it and returns to the file', (tester) async {
      await startConsultation(tester);

      await tester.tap(find.bySemanticsLabel('Borrar la consulta'));
      await tester.pumpAndSettle();
      expect(find.text('¿BORRAR ESTA CONSULTA?'), findsOneWidget);
      await tester.tap(find.text('Conservar'));
      await tester.pumpAndSettle();
      expect(consultations.discarded, isEmpty);

      await tester.tap(find.bySemanticsLabel('Borrar la consulta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Borrar consulta'));
      await tester.pumpAndSettle();

      expect(consultations.discarded, [ConsultationId(9)]);
      expect(find.text('ANA FLORES'), findsOneWidget);
      expect(location(), '/patients/1');
    });

    testWidgets('a consultation that is no longer in progress sends the step back to the file', (tester) async {
      await openPatient(tester);
      consultations.inProgressResult = const Result.success(null);

      unawaited(
        router!.push(
          const ConsultationRoute(patientId: 1, patientName: 'Ana Flores', step: ConsultationStep.diagnosis).location,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ANA FLORES'), findsOneWidget);
      expect(location(), '/patients/1');
    });

    testWidgets('the baseline hands over to the consultation through the file, which still gets "Plan published"', (
      tester,
    ) async {
      baselines.getResult = const Result.success(null);
      summaries.result = Result.success(summary(withBaseline: false, activePlanVersion: null));
      await openPatient(tester);
      await tester.tap(find.text('Registrar datos base'));
      await tester.pumpAndSettle();
      expect(location(), '/patients/1/baseline');

      // What the baseline's "Save and start consultation" does once it saved.
      consultations.inProgressResult = Result.success(freshConsultation());
      router!.pop(const ContinueToConsultation(ConsultationStep.measurement));
      await tester.pumpAndSettle();
      expect(location(), '/patients/1/consultation/measurement');

      consultations.inProgressResult = Result.success(consultationAtPublication());
      unawaited(
        router!.push(
          const ConsultationRoute(patientId: 1, patientName: 'Ana Flores', step: ConsultationStep.publication).location,
          extra: 'fromPreviousStep',
        ),
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Publicar y cerrar consulta');

      expect(location(), '/patients/1');
      expect(find.text('Plan publicado. Ana Flores ya puede ver sus metas.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
    });
  });

  testWidgets('the baseline and consultation links with a broken id fall back to the roster', (tester) async {
    await pumpApp(tester);

    for (final path in ['/patients/abc/baseline', '/patients/x/consultation']) {
      router!.go(path);
      await tester.pumpAndSettle();
      expect(router!.routerDelegate.currentConfiguration.last.matchedLocation, '/patients', reason: path);
    }
  });

  testWidgets('a patient link with a broken id falls back to the roster', (tester) async {
    await pumpApp(tester);

    router!.go('/patients/abc?careLinkId=x');
    await tester.pumpAndSettle();

    expect(router!.routerDelegate.currentConfiguration.last.matchedLocation, '/patients');
    expect(find.text('MIS PACIENTES'), findsOneWidget);
  });

  testWidgets('discharging returns to the roster with the snackbar and a fresh list', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Ana Flores'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Dar de alta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dar de alta'));
    await tester.pumpAndSettle();
    expect(find.text('DAR DE ALTA'), findsOneWidget);

    // Without a reason the confirmation does not open.
    await tester.tap(find.text('Dar de alta'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe el motivo clínico del alta'), findsOneWidget);
    expect(find.text('¿DAR DE ALTA?'), findsNothing);

    await tester.enterText(find.byType(TextField), 'Objetivos alcanzados');
    await tester.tap(find.text('Dar de alta'));
    await tester.pumpAndSettle();
    expect(find.text('¿DAR DE ALTA?'), findsOneWidget);

    repository.rosterResult = Result.success(PatientRoster([rosterPatient(2, 'Jorge Salas')]));
    await tester.tap(find.text('Sí, dar de alta'));
    await tester.pumpAndSettle();

    expect(repository.discharges, [(101, 'Objetivos alcanzados')]);
    expect(router!.routerDelegate.currentConfiguration.last.matchedLocation, '/patients');
    expect(find.text('Alta registrada: Ana Flores ya no está en tu cartera.'), findsOneWidget);
    expect(find.text('Ana Flores'), findsNothing);
    expect(repository.rosterCalls, 2);
  });

  group('review inbox', () {
    String location() => router!.routerDelegate.currentConfiguration.last.matchedLocation;

    Future<void> openInbox(WidgetTester tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Bandeja'));
      await tester.pumpAndSettle();
    }

    testWidgets('lists the open items with the patient, the signal and the date', (tester) async {
      inbox.itemsResult = Result.success([
        reviewItem(id: 4),
        reviewItem(id: 5, name: 'Jorge Salas', signal: const ConsistencyEscalation()),
      ]);

      await openInbox(tester);

      expect(find.text('Ana Flores · desviación sostenida'), findsOneWidget);
      expect(find.text('Jorge Salas · señal de consistencia'), findsOneWidget);
      expect(find.text('2 ítems pendientes por revisar'), findsOneWidget);
      expect(inbox.states.single.code, 'Open');
    });

    testWidgets('an empty inbox says it is up to date', (tester) async {
      inbox.itemsResult = const Result.success([]);

      await openInbox(tester);

      expect(find.text('Bandeja al día'), findsOneWidget);
    });

    testWidgets('resolving an item returns to the inbox with the snackbar and a fresh list', (tester) async {
      inbox.itemsResult = Result.success([reviewItem(id: 4)]);
      await openInbox(tester);

      await tester.tap(find.text('Ana Flores · desviación sostenida'));
      await tester.pumpAndSettle();
      expect(location(), '/review-items/4');
      expect(find.text('REVISAR SEÑAL'), findsOneWidget);
      expect(find.textContaining('Ana Flores registró en promedio 40 % menos de su meta de energía'), findsOneWidget);
      expect(find.textContaining('Los días sin registro no cuentan.'), findsOneWidget);

      // Without Yes or No it does not send.
      await tapScrolled(tester, find.text('Resolver'));
      await tester.pumpAndSettle();
      expect(find.text('Responde Sí o No'), findsOneWidget);
      expect(inbox.resolutions, isEmpty);

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();
      inbox.itemsResult = const Result.success([]);
      await tapScrolled(tester, find.text('Resolver'));
      await tester.pumpAndSettle();

      expect(inbox.resolutions.single.$1, 4);
      expect(inbox.resolutions.single.$2.resolvedWithAdjustment, isFalse);
      expect(location(), '/inbox');
      expect(find.text('Señal resuelta. Ana Flores ya no aparece en tu bandeja.'), findsOneWidget);
      expect(find.text('Bandeja al día'), findsOneWidget);
    });

    testWidgets('an item that is gone shows the notice and goes back to a fresh inbox', (tester) async {
      inbox.itemsResult = Result.success([reviewItem(id: 4)]);
      await openInbox(tester);
      await tester.tap(find.text('Ana Flores · desviación sostenida'));
      await tester.pumpAndSettle();

      inbox.resolveResult = const Result.failure(NotFound('ReviewItemNotFound'));
      inbox.itemsResult = const Result.success([]);
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();
      await tapScrolled(tester, find.text('Resolver'));
      await tester.pumpAndSettle();
      expect(find.text('Ítem no disponible'), findsOneWidget);

      await tester.tap(find.text('Volver a la bandeja'));
      await tester.pumpAndSettle();

      expect(location(), '/inbox');
      expect(find.text('Bandeja al día'), findsOneWidget);
    });

    testWidgets('an item that vanished before opening says it is not available', (tester) async {
      inbox.itemsResult = Result.success([reviewItem(id: 4)]);
      await openInbox(tester);
      inbox.itemsResult = const Result.success([]);

      unawaited(router!.push('/review-items/4'));
      await tester.pumpAndSettle();

      expect(find.text('Este ítem ya no está disponible.'), findsOneWidget);
      await tester.tap(find.text('Volver a la bandeja'));
      await tester.pumpAndSettle();
      expect(location(), '/inbox');
    });

    testWidgets('"Adjust the plan now" opens the patient file, and back keeps the item open', (tester) async {
      inbox.itemsResult = Result.success([reviewItem(id: 4)]);
      await openInbox(tester);
      await tester.tap(find.text('Ana Flores · desviación sostenida'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ajustar el plan ahora'));
      await tester.pumpAndSettle();

      expect(find.text('ANA FLORES'), findsOneWidget);
      expect(location(), '/patients/1');
      expect(inbox.resolutions, isEmpty);

      await tester.tap(find.byType(HealthifyIconButton).first);
      await tester.pumpAndSettle();
      expect(location(), '/review-items/4');
      expect(find.text('REVISAR SEÑAL'), findsOneWidget);
    });

    group('with an AI proposal', () {
      Future<void> openProposal(WidgetTester tester) async {
        inbox.itemsResult = Result.success([reviewItem(id: 4, hasPlanProposal: true)]);
        inbox.proposalAnswers
          ..clear()
          ..add(Result.success(ProposalReady(proposal(reviewItemId: 4))));
        await openInbox(tester);
        await tester.tap(find.text('Ana Flores · desviación sostenida'));
        await tester.pumpAndSettle();
      }

      testWidgets('shows the proposal and "Resolve" assigns it as is', (tester) async {
        await openProposal(tester);

        expect(find.text('Plan propuesto por IA'), findsOneWidget);
        expect(find.text('Ajustar la energía y reforzar las cenas'), findsOneWidget);
        expect(find.text('1.796 → 1.650 kcal'), findsOneWidget);
        expect(find.text('Cena con proteína y vegetales'), findsOneWidget);
        expect(find.text('Se quita la indicación'), findsOneWidget);
        expect(find.text('Revisar de nuevo en 7 días'), findsOneWidget);
        expect(find.text('Responde Sí o No'), findsNothing);

        inbox.itemsResult = const Result.success([]);
        await tapScrolled(tester, find.text('Resolver'));
        await tester.pumpAndSettle();

        expect(inbox.acceptances.single.$2, isA<AcceptAsIs>());
        expect(location(), '/inbox');
        expect(find.text('Señal resuelta. Ana Flores ya no aparece en tu bandeja.'), findsOneWidget);
      });

      testWidgets('"Resolve without assigning this plan" shows the plain form', (tester) async {
        await openProposal(tester);

        await tapScrolled(tester, find.text('Resolver sin asignar este plan'));
        await tester.pumpAndSettle();

        expect(find.text('¿Ajustaste el plan por esta señal?'), findsOneWidget);
        expect(find.text('Plan propuesto por IA'), findsOneWidget);
      });

      testWidgets('"Adjust" opens the prefilled form and "Assign adjusted plan" sends the edits', (tester) async {
        await openProposal(tester);

        await tapScrolled(tester, find.text('Ajustar'));
        await tester.pumpAndSettle();
        expect(location(), '/review-items/4/adjust');
        expect(find.text('AJUSTAR PLAN'), findsOneWidget);
        expect(find.text('Antes: 1.796 kcal'), findsOneWidget);

        await tester.enterText(find.byType(EditableText).first, '1600');
        inbox.itemsResult = const Result.success([]);
        await tapScrolled(tester, find.text('Asignar plan ajustado'));
        await tester.pumpAndSettle();

        final edits = (inbox.acceptances.single.$2 as AcceptWithEdits).edits;
        expect(edits.targets.energyKcal, 1600);
        expect(edits.targets.proteinG, 119);
        expect(location(), '/inbox');
        expect(find.text('Señal resuelta. Ana Flores ya no aparece en tu bandeja.'), findsOneWidget);
      });

      testWidgets('an energy below the safe minimum is flagged on the form', (tester) async {
        await openProposal(tester);
        await tapScrolled(tester, find.text('Ajustar'));
        await tester.pumpAndSettle();
        inbox.acceptResult = const Result.failure(Validation('PlanProposalOutOfSafetyBounds'));

        await tapScrolled(tester, find.text('Asignar plan ajustado'));
        await tester.pumpAndSettle();

        expect(find.text('Está por debajo del mínimo seguro de energía para este paciente.'), findsOneWidget);
        expect(location(), '/review-items/4/adjust');
      });
    });

    testWidgets('links with a broken item id fall back to the inbox', (tester) async {
      await pumpApp(tester);

      router!.go('/review-items/abc');
      await tester.pumpAndSettle();
      expect(location(), '/inbox');

      router!.go('/review-items/0/adjust');
      await tester.pumpAndSettle();
      expect(location(), '/inbox');
    });
  });

  group('agenda', () {
    String location() => router!.routerDelegate.currentConfiguration.last.matchedLocation;

    Future<void> openAgenda(WidgetTester tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Agenda'));
      await tester.pumpAndSettle();
    }

    Future<void> pickDateAndTime(WidgetTester tester) async {
      // The Material pickers need more room than the 360 dp phone frame of the other tests.
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fecha'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('31'));
      await tester.tap(find.text('ACEPTAR'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hora'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ACEPTAR'));
      await tester.pumpAndSettle();
    }

    testWidgets('lists the upcoming visits with the date badge, the patient, the weekday and the time', (tester) async {
      agenda.agendaResult = Result.success([
        agendaVisit(id: 1, scheduledFor: DateTime(2026, 11, 18, 10)),
        agendaVisit(id: 2, name: 'Jorge Salas', patientId: 12, scheduledFor: DateTime(2026, 12, 1, 15, 30)),
      ]);

      await openAgenda(tester);

      expect(find.text('Próximas consultas'), findsOneWidget);
      expect(find.text('Ana Flores'), findsOneWidget);
      expect(find.textContaining('Miércoles · '), findsOneWidget);
      expect(find.text('18'), findsOneWidget);
      expect(find.text('NOV'), findsOneWidget);
      expect(find.text('Jorge Salas'), findsOneWidget);
      expect(find.text('Agendar consulta'), findsOneWidget);
      expect(agenda.agendaRequests.single.$2?.code, 'Scheduled');
    });

    testWidgets('an empty agenda keeps "Schedule consultation" available', (tester) async {
      agenda.agendaResult = const Result.success([]);

      await openAgenda(tester);

      expect(find.text('Sin consultas agendadas'), findsOneWidget);
      expect(find.text('Agendar consulta'), findsOneWidget);
    });

    testWidgets('coming back to the tab reloads the agenda', (tester) async {
      await openAgenda(tester);
      expect(agenda.agendaCalls, 1);

      await tester.tap(find.text('Pacientes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Agenda'));
      await tester.pumpAndSettle();

      expect(agenda.agendaCalls, 2);
    });

    testWidgets('a visit opens its sheet; cancelling asks first and shows the snackbar', (tester) async {
      await openAgenda(tester);
      await tester.tap(find.text('Ana Flores'));
      await tester.pumpAndSettle();
      expect(find.text('Reprogramar'), findsOneWidget);
      expect(find.text('Ver paciente'), findsOneWidget);

      await tester.tap(find.text('Cancelar consulta'));
      await tester.pumpAndSettle();
      expect(find.text('¿CANCELAR ESTA CONSULTA?'), findsOneWidget);

      agenda.agendaResult = const Result.success([]);
      await tester.tap(find.text('Sí, cancelar'));
      await tester.pumpAndSettle();

      expect(agenda.cancelled.single.$1, 1);
      expect(find.text('Consulta cancelada'), findsOneWidget);
      expect(find.text('Sin consultas agendadas'), findsOneWidget);
    });

    testWidgets('keeping the visit on the cancel confirmation brings its sheet back', (tester) async {
      await openAgenda(tester);
      await tester.tap(find.text('Ana Flores'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar consulta'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('¿CANCELAR ESTA CONSULTA?'), findsNothing);
      expect(find.text('Reprogramar'), findsOneWidget);
      expect(agenda.cancelled, isEmpty);
    });

    testWidgets('"View patient" of someone outside the roster says there is no active link', (tester) async {
      await openAgenda(tester);
      await tester.tap(find.text('Ana Flores'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ver paciente'));
      await tester.pumpAndSettle();

      expect(find.text('Sin vínculo activo'), findsOneWidget);
      expect(location(), '/agenda');
    });

    testWidgets('"View patient" for a patient of the roster opens their file', (tester) async {
      agenda.agendaResult = Result.success([agendaVisit(patientId: 1)]);
      await openAgenda(tester);
      await tester.tap(find.text('Ana Flores'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ver paciente'));
      await tester.pumpAndSettle();

      expect(location(), '/patients/1');
      expect(find.text('ANA FLORES'), findsOneWidget);
    });

    testWidgets('"Reschedule" opens the form with the visit prefilled and moves it', (tester) async {
      agenda.agendaResult = Result.success([
        agendaVisit(
          id: 8,
          patientId: 1,
          scheduledFor: DateTime(2026, 11, 18, 10),
          preparation: const [CatalogPreparation(PreparationCode.fasting)],
        ),
      ]);
      await openAgenda(tester);
      await tester.tap(find.text('Ana Flores'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reprogramar'));
      await tester.pumpAndSettle();

      expect(find.text('REPROGRAMAR CONSULTA'), findsOneWidget);
      expect(location(), '/schedule-follow-up');
      expect(find.text('Ana Flores'), findsOneWidget);

      await tester.tap(find.text('Reprogramar'));
      await tester.pumpAndSettle();

      expect(agenda.rescheduled.single.$1, 8);
      expect(agenda.rescheduled.single.$2, DateTime(2026, 11, 18, 10).toUtc());
      expect(agenda.rescheduled.single.$3.orderedCodes, [PreparationCode.fasting]);
      expect(location(), '/agenda');
      expect(find.textContaining('Consulta reprogramada: '), findsOneWidget);
    });

    testWidgets('"Schedule consultation" picks a patient, a date and a time and returns with the snackbar', (tester) async {
      agenda.agendaResult = const Result.success([]);
      await openAgenda(tester);

      await tester.tap(find.text('Agendar consulta'));
      await tester.pumpAndSettle();
      expect(find.text('AGENDAR CONSULTA'), findsOneWidget);
      expect(location(), '/schedule-follow-up');

      // With nothing chosen it asks for the patient and the moment.
      await tapScrolled(tester, find.text('Agendar'));
      await tester.pumpAndSettle();
      expect(find.text('Elige un paciente'), findsOneWidget);
      expect(find.text('Elige la fecha y la hora'), findsOneWidget);
      expect(agenda.scheduled, isEmpty);

      await tester.tap(find.text('Paciente'));
      await tester.pumpAndSettle();
      expect(find.text('PACIENTE'), findsOneWidget);
      await tester.tap(find.text('Jorge Salas'));
      await tester.pumpAndSettle();

      await pickDateAndTime(tester);
      await tapScrolled(tester, find.text('Ropa ligera'));
      await tester.pumpAndSettle();

      agenda.agendaResult = Result.success([agendaVisit(patientId: 2, name: 'Jorge Salas')]);
      await tapScrolled(tester, find.text('Agendar'));
      await tester.pumpAndSettle();

      final sent = agenda.scheduled.single;
      expect(sent.patientId.value, 2);
      expect(sent.scheduledFor, DateTime(2026, 10, 31, 9).toUtc());
      expect(sent.preparation.orderedCodes, [PreparationCode.lightClothing]);
      expect(location(), '/agenda');
      expect(find.textContaining('Consulta agendada: sáb 31 oct, '), findsOneWidget);
    });

    testWidgets('a patient who already has a visit is flagged on the patient field', (tester) async {
      agenda.agendaResult = const Result.success([]);
      agenda.scheduleResult = const Result.failure(Conflict('PatientAlreadyHasActiveScheduledFollowUp'));
      await openAgenda(tester);
      await tester.tap(find.text('Agendar consulta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Paciente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Jorge Salas'));
      await tester.pumpAndSettle();
      await pickDateAndTime(tester);

      await tapScrolled(tester, find.text('Agendar'));
      await tester.pumpAndSettle();

      expect(find.text('Este paciente ya tiene una consulta en agenda.'), findsOneWidget);
      expect(location(), '/schedule-follow-up');
    });

    testWidgets('a failed scheduling keeps what was written behind "Try again"', (tester) async {
      agenda.agendaResult = const Result.success([]);
      agenda.scheduleResult = const Result.failure(Network());
      await openAgenda(tester);
      await tester.tap(find.text('Agendar consulta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Paciente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Jorge Salas'));
      await tester.pumpAndSettle();
      await pickDateAndTime(tester);

      await tapScrolled(tester, find.text('Agendar'));
      await tester.pumpAndSettle();
      expect(find.text('NO SE PUDO AGENDAR'), findsOneWidget);

      await tester.tap(find.text('Volver a intentarlo'));
      await tester.pumpAndSettle();

      expect(find.text('Jorge Salas'), findsOneWidget);
      expect(location(), '/schedule-follow-up');
    });
  });

  group('from the patient file', () {
    String location() => router!.routerDelegate.currentConfiguration.last.matchedLocation;

    Future<void> openFile(WidgetTester tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Ana Flores'));
      await tester.pumpAndSettle();
    }

    Future<void> tapManagement(WidgetTester tester, String text) async {
      await tester.ensureVisible(find.text(text));
      await tester.pumpAndSettle();
      await tester.tap(find.text(text));
      await tester.pumpAndSettle();
    }

    testWidgets('"Schedule consultation" opens the form for that patient and returns to the file with the snackbar', (
      tester,
    ) async {
      await openFile(tester);

      await tapManagement(tester, 'Agendar consulta');

      expect(find.text('AGENDAR CONSULTA'), findsOneWidget);
      expect(location(), '/schedule-follow-up');

      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fecha'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('31'));
      await tester.tap(find.text('ACEPTAR'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hora'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ACEPTAR'));
      await tester.pumpAndSettle();
      await tapScrolled(tester, find.text('Agendar'));
      await tester.pumpAndSettle();

      expect(agenda.scheduled.single.patientId.value, 1);
      expect(location(), '/patients/1');
      expect(find.text('ANA FLORES'), findsOneWidget);
      expect(find.textContaining('Consulta agendada: sáb 31 oct, '), findsOneWidget);
    });

    testWidgets('"Record referral" validates, records and returns to the file with "View"', (tester) async {
      await openFile(tester);

      await tapManagement(tester, 'Registrar derivación');
      expect(find.text('REGISTRAR DERIVACIÓN'), findsOneWidget);
      expect(location(), '/patients/1/referral');

      await tapScrolled(tester, find.text('Registrar'));
      await tester.pumpAndSettle();
      expect(find.text('Completa la especialidad'), findsOneWidget);
      expect(find.text('Completa el motivo clínico de la derivación'), findsOneWidget);
      expect(agenda.referrals, isEmpty);

      await tester.enterText(find.byType(EditableText).at(0), 'Endocrinología');
      await tester.enterText(find.byType(EditableText).at(1), 'Hipotiroidismo sin control');
      await tapScrolled(tester, find.text('Registrar'));
      await tester.pumpAndSettle();

      expect(agenda.referrals.single.specialty.text, 'Endocrinología');
      expect(location(), '/patients/1');
      expect(find.text('Derivación a Endocrinología registrada.'), findsOneWidget);
      expect(find.text('Ver'), findsOneWidget);
    });

    testWidgets('a failed referral keeps what was written behind "Try again"', (tester) async {
      agenda.referralResult = const Result.failure(Network());
      await openFile(tester);
      await tapManagement(tester, 'Registrar derivación');
      await tester.enterText(find.byType(EditableText).at(0), 'Endocrinología');
      await tester.enterText(find.byType(EditableText).at(1), 'Hipotiroidismo');

      await tapScrolled(tester, find.text('Registrar'));
      await tester.pumpAndSettle();
      expect(find.text('HUBO UN ERROR'), findsOneWidget);

      await tester.tap(find.text('Volver a intentarlo'));
      await tester.pumpAndSettle();

      expect(find.text('Endocrinología'), findsOneWidget);
      expect(find.text('Hipotiroidismo'), findsOneWidget);
      expect(location(), '/patients/1/referral');
    });

    testWidgets('the referral link with a broken patient id falls back to the roster', (tester) async {
      await pumpApp(tester);

      router!.go('/patients/abc/referral');
      await tester.pumpAndSettle();

      expect(location(), '/patients');
    });
  });

  test('every practitioner path needs a session and the public ones do not', () {
    for (final path in [
      '/patients',
      '/patients/1',
      '/patients/1/baseline',
      '/patients/1/consultation',
      '/patients/1/consultation/diagnosis',
      '/inbox',
      '/agenda',
      '/review-items/3',
      '/review-items/3/adjust',
      '/schedule-follow-up',
      '/patients/1/referral',
      '/invite-patient',
      '/care-links/8/discharge',
      '/settings',
      '/sign-out',
      '/shell-loading',
      '/practitioner-only',
    ]) {
      expect(routeRequiresSession(path), isTrue, reason: path);
    }
    for (final path in ['/', '/welcome', '/sign-in', '/sign-up', '/forgot-password', '/session-expired', '/patientsX']) {
      expect(routeRequiresSession(path), isFalse, reason: path);
    }
  });
}

const patientsPathForTest = '/patients';

/// Taps a widget that may sit below the fold of a scrolling screen.
Future<void> tapScrolled(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// The phone's clock in the router tests: noon on 30 October 2026.
DateTime _now() => DateTime(2026, 10, 30, 12);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:healthify/core/connectivity/connectivity_observer.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/di/service_locator.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/features/carerelationship/presentation/cubit/discharge_patient_cubit.dart';
import 'package:healthify/features/carerelationship/presentation/cubit/invite_patient_cubit.dart';
import 'package:healthify/features/carerelationship/presentation/cubit/patient_roster_cubit.dart';
import 'package:healthify/features/foodcatalog/presentation/cubit/add_local_food_cubit.dart';
import 'package:healthify/features/foodcatalog/presentation/cubit/food_catalog_cubit.dart';
import 'package:healthify/features/iam/application/usecase/session_use_cases.dart';
import 'package:healthify/features/iam/domain/repository/session_repository.dart';
import 'package:healthify/features/main/presentation/cubit/patient_history_cubit.dart';
import 'package:healthify/features/main/presentation/cubit/practitioner_settings_cubit.dart';
import 'package:healthify/features/main/presentation/cubit/practitioner_shell_cubit.dart';
import 'package:healthify/features/main/presentation/cubit/sign_out_cubit.dart';
import 'package:healthify/features/main/presentation/navigation/shell_routes.dart';
import 'package:healthify/features/monitoring/domain/valueobject/monitoring_values.dart' show PreparationCode;
import 'package:healthify/features/monitoring/presentation/cubit/patient_follow_up_cubit.dart';
import 'package:healthify/features/monitoring/presentation/cubit/practitioner_agenda_cubit.dart';
import 'package:healthify/features/monitoring/presentation/cubit/record_referral_cubit.dart';
import 'package:healthify/features/monitoring/presentation/cubit/schedule_follow_up_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/adjust_proposal_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/baseline_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/diagnosis_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/measurement_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/patient_plan_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/patient_summary_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/publication_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/review_inbox_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/review_item_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/targets_step_cubit.dart';
import 'package:healthify/main.dart';
import 'package:healthify/navigation/app_router.dart';
import 'package:healthify/navigation/session_gate.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/designsystem/test_fonts.dart';
import '../features/carerelationship/fakes.dart';

const _patientId = 7;

http.Response _json(int status, Object? body) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

/// `PatientSummaryResource` as `PractitionerPatientDtos.kt` reads it: a patient with a baseline and no consultation open.
Map<String, Object?> _summaryJson({Map<String, Object?>? nextFollowUp}) => {
  'patientId': _patientId,
  'fullName': 'Ana Flores',
  'linkedSince': '2026-03-12T10:00:00-05:00',
  'linkStatus': 'Active',
  'activePlanVersion': null,
  'baseline': {'biologicalSex': 'Female', 'ageYears': 31, 'heightCm': 168.0, 'conditions': <String>[]},
  'nextFollowUp': nextFollowUp,
  'consultationInProgress': null,
  'sinceLastConsultation': {'fromDate': '2026-09-30', 'weightSlopeKgPerWeek': null, 'trendWeeks': 0, 'compliance': null},
};

/// `ConsultationResource` of a consultation just started, as `ConsultationDtos.kt` reads it: everything optional comes
/// null, and the fields the app does not read are there too.
Map<String, Object?> _startedConsultationJson() => {
  'consultationId': 9,
  'patientId': _patientId,
  'state': 'InProgress',
  'currentStep': 'Measurement',
  'stepNumber': 1,
  'startedAt': '2026-10-30T09:00:00-05:00',
  'lastSavedAt': '2026-10-30T09:00:00-05:00',
  'measurement': null,
  'diagnosis': null,
  'targets': null,
  'publicationDraft': null,
  'patientCheckIn': null,
  'completedAt': null,
  'publishedPlanVersion': null,
  'isFirstConsultation': true,
  'scheduledFollowUpId': null,
};

/// The graph `main` registers, the real router and the real screens. Only the HTTP client, the session and the
/// connectivity are replaced: a route or cubit that needs something unregistered fails here as it does on a device.
void main() {
  late List<http.Request> requests;
  late Map<String, http.Response> responses;
  late SessionGate gate;
  GoRouter? router;

  setUpAll(loadAppFonts);

  setUp(() async {
    requests = [];
    responses = {};
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    await getIt.reset();
    await setupCore();
    registerFeatureModules();
    final session = FakeSessionRepository(practitionerUser());
    await getIt.unregister<ApiClient>();
    await getIt.unregister<ConnectivityObserver>();
    await getIt.unregister<SessionRepository>();
    getIt
      ..registerSingleton<ApiClient>(
        ApiClient(
          MockClient((request) async {
            requests.add(request);
            final key = '${request.method} ${request.url.path.replaceFirst('/api/v1/', '')}';
            return responses[key] ?? _json(404, {'code': 'NotStubbed'});
          }),
        ),
      )
      ..registerSingleton<ConnectivityObserver>(FakeConnectivity())
      ..registerSingleton<SessionRepository>(session);
    gate = SessionGate(ObserveIsLoggedInUseCase(session), ObserveSessionExpiredUseCase(session));
  });

  tearDown(() async {
    router?.dispose();
    router = null;
    gate.dispose();
    await getIt.reset();
  });

  Future<void> pumpPatientFile(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    tester.binding.platformDispatcher.defaultRouteNameTestValue = const PractitionerPatientRoute(
      patientId: _patientId,
      careLinkId: 107,
      patientName: 'Ana Flores',
    ).location;
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

  void stubPatient({Map<String, Object?>? nextFollowUp}) {
    responses
      ..['GET patients/$_patientId/summary'] = _json(200, _summaryJson(nextFollowUp: nextFollowUp))
      ..['GET patients/$_patientId/baseline'] = _json(200, {
        'patientId': _patientId,
        'birthDate': '1995-02-15',
        'ageYears': 31,
        'biologicalSex': 'Female',
        'heightCm': 168.0,
        'conditions': <String>[],
        'updatedAt': null,
        'birthDateEstimated': false,
      })
      ..['GET patients/$_patientId/consultations/in-progress'] = _json(404, {'code': 'ConsultationNotFound'})
      ..['POST patients/$_patientId/consultations'] = _json(201, _startedConsultationJson());
  }

  testWidgets('"New consultation" reaches the Measurement step', (tester) async {
    stubPatient();
    await pumpPatientFile(tester);

    // The backend has the consultation in progress from the moment it is created.
    responses['GET patients/$_patientId/consultations/in-progress'] = _json(200, _startedConsultationJson());
    await tester.tap(find.text('Nueva consulta'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('PASO 1 DE 4 · MEDICIÓN DE HOY'), findsOneWidget);
    expect(
      router!.routerDelegate.currentConfiguration.last.matchedLocation,
      '/patients/$_patientId/consultation/measurement',
    );
    final start = requests.singleWhere((r) => r.method == 'POST');
    expect(start.url.path, '/api/v1/patients/$_patientId/consultations');
    expect(start.body, '{}');
  });

  testWidgets('an appointment today in the summary is linked to the consultation, without the patient-only endpoints', (
    tester,
  ) async {
    final today = DateTime.now();
    stubPatient(
      nextFollowUp: {
        'followUpId': 4,
        'scheduledFor': DateTime(today.year, today.month, today.day, 12).toUtc().toIso8601String(),
      },
    );
    await pumpPatientFile(tester);

    await tester.tap(find.text('Historia'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Resumen'));
    await tester.pumpAndSettle();
    responses['GET patients/$_patientId/consultations/in-progress'] = _json(200, _startedConsultationJson());
    await tester.tap(find.text('Nueva consulta'));
    await tester.pumpAndSettle();

    expect(requests.singleWhere((r) => r.method == 'POST').body, '{"scheduledFollowUpId":4}');
    expect(find.text('PASO 1 DE 4 · MEDICIÓN DE HOY'), findsOneWidget);
    final paths = requests.map((r) => r.url.path);
    expect(paths.where((p) => p.endsWith('/consultations-overview') || p.endsWith('/plan-versions')), isEmpty);
  });

  test('every cubit of the app can be built from the graph', () async {
    final cubits = <Cubit<Object?> Function()>[
      () => getIt<PatientRosterCubit>(),
      () => getIt<InvitePatientCubit>(),
      () => getIt<DischargePatientCubit>(param1: (careLinkId: 1, patientName: 'Ana')),
      () => getIt<PatientSummaryCubit>(param1: _patientId),
      () => getIt<PatientFollowUpCubit>(param1: _patientId),
      () => getIt<PatientHistoryCubit>(param1: _patientId),
      () => getIt<PatientPlanCubit>(param1: (patientId: _patientId, careLinkId: 1)),
      () => getIt<BaselineCubit>(param1: (patientId: _patientId, editing: false)),
      () => getIt<MeasurementStepCubit>(param1: _patientId),
      () => getIt<DiagnosisStepCubit>(param1: _patientId),
      () => getIt<TargetsStepCubit>(param1: _patientId),
      () => getIt<PublicationStepCubit>(param1: _patientId),
      () => getIt<ReviewInboxCubit>(),
      () => getIt<ReviewItemCubit>(param1: 1),
      () => getIt<AdjustProposalCubit>(param1: 1),
      () => getIt<PractitionerAgendaCubit>(),
      () => getIt<ScheduleFollowUpCubit>(
        param1: (patientId: _patientId, patientName: 'Ana', followUpId: 0, scheduledFor: null, preparation: const <PreparationCode>{}),
      ),
      () => getIt<RecordReferralCubit>(param1: _patientId),
      () => getIt<PractitionerShellCubit>(),
      () => getIt<PractitionerSettingsCubit>(),
      () => getIt<FoodCatalogCubit>(),
      () => getIt<AddLocalFoodCubit>(),
      () => getIt<SignOutCubit>(),
    ];

    for (final build in cubits) {
      final cubit = build();
      await pumpEventQueue();
      await cubit.close();
    }
  });

  test('the idempotency keys of the publications outlive each visit to the step', () {
    expect(identical(getIt<IdempotencyKeyStore>(), getIt<IdempotencyKeyStore>()), isTrue);
  });
}

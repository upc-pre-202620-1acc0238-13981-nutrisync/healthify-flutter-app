import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/monitoring/application/usecase/monitoring_use_cases.dart';
import 'package:healthify/features/monitoring/domain/entity/patient_monitoring_panel.dart';
import 'package:healthify/features/monitoring/presentation/cubit/patient_follow_up_cubit.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakePractitionerMonitoringRepository repository;
  late FakeConnectivity connectivity;
  final now = DateTime(2026, 10, 7, 21, 30);

  setUp(() {
    repository = FakePractitionerMonitoringRepository();
    connectivity = FakeConnectivity();
  });

  PatientFollowUpCubit build() => PatientFollowUpCubit(
    GetMonitoringPanelUseCase(repository, () => now),
    GetMonitoringSummaryUseCase(repository),
    connectivity,
    patientId: 7,
  );

  test('asks for the last 7 days up to the phone day and shows the panel with the AI summary', () async {
    final cubit = build();
    await pumpEventQueue();

    expect(repository.panelRequests.single, (7, DateTime(2026, 10, 7), 7));
    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.panel!.week!.metDays, 4);
    expect(cubit.state.aiSummary, 'Cumple casi todos los días.');
    await cubit.close();
  });

  test('without the summary (no consent, feature off, quota) the panel still shows', () async {
    repository.summaryResult = const Result.failure(Forbidden());

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.panel, isNotNull);
    expect(cubit.state.aiSummary, isNull);
    expect(cubit.state.loadFailed, isFalse);
    await cubit.close();
  });

  test('a summary with no text hides the card', () async {
    repository.summaryResult = const Result.success(MonitoringSummary(null));

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.aiSummary, isNull);
    await cubit.close();
  });

  test('offline with nothing read asks for a connection', () async {
    repository.panelResult = const Result.failure(Network());

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.loadFailed, isTrue);
    expect(cubit.state.isOffline, isTrue);
    expect(cubit.state.panel, isNull);
    await cubit.close();
  });

  test('403 without an active link is an error state', () async {
    repository.panelResult = const Result.failure(Forbidden('AccessNotAllowed'));

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.loadFailed, isTrue);
    expect(cubit.state.isOffline, isFalse);
    await cubit.close();
  });

  test('coming back refreshes the panel and keeps the last one if the refresh fails', () async {
    final cubit = build();
    await pumpEventQueue();

    cubit.onResume();
    await pumpEventQueue();
    expect(repository.panelCalls, 2);

    repository.panelResult = const Result.failure(Unexpected('HTTP_500'));
    cubit.onResume();
    await pumpEventQueue();
    expect(cubit.state.panel, isNotNull);
    expect(cubit.state.loadFailed, isFalse);
    await cubit.close();
  });

  test('retry recovers, and reconnecting reloads', () async {
    repository.panelResult = const Result.failure(Unexpected('HTTP_500'));
    final cubit = build();
    await pumpEventQueue();

    repository.panelResult = Result.success(panel());
    cubit.onRetry();
    await pumpEventQueue();
    expect(cubit.state.loadFailed, isFalse);
    final calls = repository.panelCalls;

    connectivity.set(false);
    connectivity.set(true);
    await pumpEventQueue();
    expect(repository.panelCalls, calls + 1);
    await cubit.close();
  });
}

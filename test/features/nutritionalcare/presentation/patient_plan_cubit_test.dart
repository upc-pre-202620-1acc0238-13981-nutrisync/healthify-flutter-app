import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import 'package:healthify/features/carerelationship/domain/entity/targets_read_status.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/care_link_id.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/patient_plan_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/patient_tab_states.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

class _ReadStatusRepository extends FakePractitionerCareLinkRepository {
  Result<TargetsReadStatus> statusResult = Result.success(
    TargetsReadStatus(
      careLinkId: CareLinkId(101),
      lastAcknowledgedVersion: 3,
      lastAcknowledgedAt: DateTime.utc(2026, 9, 4, 20),
    ),
  );
  final requested = <int>[];

  @override
  Future<Result<TargetsReadStatus>> getTargetsReadStatus(CareLinkId careLinkId) async {
    requested.add(careLinkId.value);
    return statusResult;
  }
}

void main() {
  late FakeNutritionPlanRepository plans;
  late FakeConsultationRepository consultations;
  late _ReadStatusRepository careLinks;
  late FakeConnectivity connectivity;
  late List<PatientTabEvent> events;

  setUp(() {
    plans = FakeNutritionPlanRepository();
    consultations = FakeConsultationRepository();
    careLinks = _ReadStatusRepository();
    connectivity = FakeConnectivity();
  });

  PatientPlanCubit build() {
    final cubit = PatientPlanCubit(
      GetPlanHistoryUseCase(plans),
      GetLinkTargetsReadStatusUseCase(careLinks),
      StartOrResumeConsultationUseCase(consultations),
      connectivity,
      patientId: 7,
      careLinkId: 101,
    );
    events = [];
    cubit.events.listen(events.add);
    return cubit;
  }

  test('loads the history and whether the patient saw the targets, using the care link', () async {
    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.history!.active!.version, 3);
    expect(cubit.state.readStatus!.lastAcknowledgedVersion, 3);
    expect(careLinks.requested, [101]);
    await cubit.close();
  });

  test('without the read status the plan still shows', () async {
    careLinks.statusResult = const Result.failure(Forbidden());

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.history, isNotNull);
    expect(cubit.state.readStatus, isNull);
    expect(cubit.state.loadFailed, isFalse);
    await cubit.close();
  });

  test('a patient without a published plan has a history with no active version', () async {
    plans.result = Result.success(planHistory(withActive: false));

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.history!.active, isNull);
    await cubit.close();
  });

  test('offline with nothing read asks for a connection; a server error is an error state', () async {
    plans.result = const Result.failure(Network());
    final offline = build();
    await pumpEventQueue();
    expect(offline.state.loadFailed, isTrue);
    expect(offline.state.isOffline, isTrue);
    await offline.close();

    plans.result = const Result.failure(Unexpected('HTTP_500'));
    final broken = build();
    await pumpEventQueue();
    expect(broken.state.loadFailed, isTrue);
    expect(broken.state.isOffline, isFalse);
    await broken.close();
  });

  test('coming back refreshes it, keeping the last history if the refresh fails', () async {
    final cubit = build();
    await pumpEventQueue();

    cubit.onResume();
    await pumpEventQueue();
    expect(plans.calls, 2);

    plans.result = const Result.failure(Unexpected('HTTP_500'));
    cubit.onResume();
    await pumpEventQueue();
    expect(cubit.state.history, isNotNull);
    expect(cubit.state.loadFailed, isFalse);
    await cubit.close();
  });

  test('reloads when the connection comes back', () async {
    final cubit = build();
    await pumpEventQueue();

    connectivity.set(false);
    connectivity.set(true);
    await pumpEventQueue();

    expect(plans.calls, 2);
    await cubit.close();
  });

  group('Adjust plan', () {
    test('starts or resumes the consultation and opens its step', () async {
      consultations.startResult = Result.success(consultation(step: ConsultationStep.targets));

      final cubit = build();
      await pumpEventQueue();
      await cubit.onAdjustPlan();
      await pumpEventQueue();

      expect(consultations.startedWith, [null]);
      expect(events.single, isA<OpenConsultation>().having((e) => e.step, 'step', ConsultationStep.targets));
      expect(cubit.state.isStartingConsultation, isFalse);
      await cubit.close();
    });

    test('422 BaselineRequired opens the baseline', () async {
      consultations.startResult = const Result.failure(Validation('BaselineRequired'));

      final cubit = build();
      await pumpEventQueue();
      await cubit.onAdjustPlan();
      await pumpEventQueue();

      expect(events.single, isA<OpenBaseline>().having((e) => e.editing, 'editing', isFalse));
      await cubit.close();
    });

    test('another failure shows the notice until it is dismissed', () async {
      consultations.startResult = const Result.failure(Unexpected('HTTP_500'));

      final cubit = build();
      await pumpEventQueue();
      await cubit.onAdjustPlan();
      expect(cubit.state.showStartError, isTrue);
      expect(events, isEmpty);

      cubit.onStartErrorDismissed();
      expect(cubit.state.showStartError, isFalse);
      await cubit.close();
    });
  });
}

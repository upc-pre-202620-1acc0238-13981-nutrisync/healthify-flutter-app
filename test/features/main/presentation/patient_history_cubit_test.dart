import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/main/presentation/cubit/patient_history_cubit.dart';
import 'package:healthify/features/main/presentation/state/patient_history_state.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_record.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/patient_tab_states.dart';

import '../../carerelationship/fakes.dart';
import '../../nutritionalcare/fakes.dart';

void main() {
  late FakePatientBaselineRepository baselines;
  late FakeConsultationRepository consultations;
  late FakePractitionerRecordRepository records;
  late FakeConnectivity connectivity;
  late List<PatientTabEvent> events;

  setUp(() {
    baselines = FakePatientBaselineRepository()..getResult = Result.success(baseline());
    consultations = FakeConsultationRepository();
    records = FakePractitionerRecordRepository();
    connectivity = FakeConnectivity();
  });

  PatientHistoryCubit build() {
    final cubit = PatientHistoryCubit(
      GetPatientBaselineUseCase(baselines),
      GetConsultationInProgressUseCase(consultations),
      GetPractitionerRecordUseCase(records),
      GetEvaluationDetailUseCase(records),
      connectivity,
      patientId: 7,
    );
    events = [];
    cubit.events.listen(events.add);
    return cubit;
  }

  test('reads the baseline, the open consultation and the record together', () async {
    consultations.inProgressResult = Result.success(consultation(step: ConsultationStep.targets));

    final cubit = build();
    await pumpEventQueue();

    final data = cubit.state.data!;
    expect(cubit.state.isLoading, isFalse);
    expect(data.baseline!.heightCm, 168);
    expect(data.inProgress!.currentStep, ConsultationStep.targets);
    expect(data.record, isNotNull);
    await cubit.close();
  });

  test('"Edit" asks to open the baseline form editing', () async {
    final cubit = build();
    await pumpEventQueue();

    cubit.onEditBaseline();
    await pumpEventQueue();

    expect(events.single, isA<OpenBaseline>().having((e) => e.editing, 'editing', isTrue));
    await cubit.close();
  });

  group('failures', () {
    test('the baseline failing offline asks for a connection', () async {
      baselines.getResult = const Result.failure(Network());

      final cubit = build();
      await pumpEventQueue();

      expect(cubit.state.loadFailed, isTrue);
      expect(cubit.state.isOffline, isTrue);
      expect(cubit.state.data, isNull);
      await cubit.close();
    });

    test('the open consultation failing is an error, not "no consultation"', () async {
      consultations.inProgressResult = const Result.failure(Unexpected('HTTP_500'));

      final cubit = build();
      await pumpEventQueue();

      expect(cubit.state.loadFailed, isTrue);
      expect(cubit.state.isOffline, isFalse);
      await cubit.close();
    });

    test('a refresh that fails keeps what was read', () async {
      final cubit = build();
      await pumpEventQueue();

      baselines.getResult = const Result.failure(Unexpected('HTTP_500'));
      cubit.onResume();
      await pumpEventQueue();

      expect(cubit.state.data, isNotNull);
      expect(cubit.state.loadFailed, isFalse);
      await cubit.close();
    });
  });

  test('coming back refreshes only what was already read, and reconnecting reloads', () async {
    final cubit = build();
    await pumpEventQueue();
    final readsBefore = consultations.inProgressCalls;

    cubit.onResume();
    await pumpEventQueue();
    expect(consultations.inProgressCalls, readsBefore + 1);

    connectivity.set(false);
    connectivity.set(true);
    await pumpEventQueue();
    expect(consultations.inProgressCalls, readsBefore + 2);
    await cubit.close();
  });

  group('the clinical record', () {
    test('is read with the rest and shown as its own section', () async {
      records.recordResult = Result.success(practitionerRecord());

      final cubit = build();
      await pumpEventQueue();

      final data = cubit.state.data!;
      expect(data.record!.evaluations, hasLength(2));
      expect(data.recordFailed, isFalse);
      expect(records.recordCalls, 1);
      await cubit.close();
    });

    test('if it cannot be read the baseline still works', () async {
      records.recordResult = const Result.failure(Forbidden());

      final cubit = build();
      await pumpEventQueue();

      final data = cubit.state.data!;
      expect(cubit.state.loadFailed, isFalse);
      expect(data.record, isNull);
      expect(data.recordFailed, isTrue);
      expect(data.baseline, isNotNull);
      await cubit.close();
    });

    test('a refresh that fails keeps the record that was read', () async {
      final cubit = build();
      await pumpEventQueue();

      records.recordResult = const Result.failure(Unexpected('HTTP_500'));
      cubit.onResume();
      await pumpEventQueue();

      expect(cubit.state.data!.record, isNotNull);
      expect(cubit.state.data!.recordFailed, isTrue);
      await cubit.close();
    });
  });

  group('the assessment detail', () {
    test('tapping one reads it into the sheet', () async {
      final cubit = build();
      await pumpEventQueue();

      cubit.onEvaluationSelected(2);
      expect(cubit.state.evaluationSheet, isA<EvaluationLoading>());
      await pumpEventQueue();

      expect(records.evaluationsRequested, [2]);
      expect((cubit.state.evaluationSheet! as EvaluationLoaded).detail.assessmentId, 2);
      await cubit.close();
    });

    test('a failure shows the retry, and retrying asks for the same assessment', () async {
      records.evaluationResult = const Result.failure(Forbidden());
      final cubit = build();
      await pumpEventQueue();

      cubit.onEvaluationSelected(2);
      await pumpEventQueue();
      expect(cubit.state.evaluationSheet, isA<EvaluationFailed>());

      records.evaluationResult = Result.success(evaluationDetail());
      cubit.onEvaluationRetry();
      await pumpEventQueue();

      expect(records.evaluationsRequested, [2, 2]);
      expect(cubit.state.evaluationSheet, isA<EvaluationLoaded>());
      await cubit.close();
    });

    test('closing the sheet drops a reply that is still on its way', () async {
      final gate = records.evaluationGate = Completer<Result<EvaluationDetail>>();
      final cubit = build();
      await pumpEventQueue();

      cubit.onEvaluationSelected(2);
      cubit.onEvaluationDismissed();
      gate.complete(Result.success(evaluationDetail()));
      await pumpEventQueue();

      expect(cubit.state.evaluationSheet, isNull);
      await cubit.close();
    });

    test('retrying with nothing selected does nothing', () async {
      final cubit = build();
      await pumpEventQueue();

      cubit.onEvaluationRetry();
      await pumpEventQueue();

      expect(records.evaluationsRequested, isEmpty);
      await cubit.close();
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_baseline.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/baseline_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/baseline_state.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakePatientBaselineRepository baselines;
  late FakeConsultationRepository consultations;
  late FakeConnectivity connectivity;
  late List<BaselineEvent> events;
  final now = DateTime(2026, 10, 30, 9);

  setUp(() {
    baselines = FakePatientBaselineRepository();
    consultations = FakeConsultationRepository();
    connectivity = FakeConnectivity();
  });

  BaselineCubit build({bool editing = false}) {
    final cubit = BaselineCubit(
      GetPatientBaselineUseCase(baselines),
      SavePatientBaselineUseCase(baselines),
      StartOrResumeConsultationUseCase(consultations),
      connectivity,
      () => now,
      patientId: 7,
      editing: editing,
    );
    events = [];
    cubit.events.listen(events.add);
    return cubit;
  }

  void fillForm(BaselineCubit cubit) {
    cubit
      ..onBirthDateChange(DateTime(1995, 2, 15))
      ..onSexChange(BiologicalSex.female)
      ..onHeightChange('168,5');
  }

  group('the form', () {
    test('the age follows the birth date, and an implausible date has none', () async {
      final cubit = build();

      cubit.onBirthDateChange(DateTime(1995, 2, 15));
      expect(cubit.state.ageYears, 31);

      cubit.onBirthDateChange(DateTime(2026, 6, 1));
      expect(cubit.state.ageYears, isNull);
      await cubit.close();
    });

    test('conditions toggle on and off', () async {
      final cubit = build();

      cubit.onConditionToggle(MedicalCondition.gout);
      cubit.onConditionToggle(MedicalCondition.hypertension);
      cubit.onConditionToggle(MedicalCondition.gout);

      expect(cubit.state.conditions, {MedicalCondition.hypertension});
      await cubit.close();
    });

    test('saving an empty form flags what is missing and sends nothing', () async {
      final cubit = build();

      await cubit.onSaveAndExit();

      expect(cubit.state.problems, {
        BaselineProblem.birthDateRequired,
        BaselineProblem.sexRequired,
        BaselineProblem.heightRequired,
      });
      expect(baselines.calls, isEmpty);
      expect(cubit.state.isSaving, isFalse);
      await cubit.close();
    });

    test('fixing a field clears only its own problems', () async {
      final cubit = build();
      await cubit.onSaveAndExit();

      cubit.onSexChange(BiologicalSex.male);
      expect(cubit.state.problems, {BaselineProblem.birthDateRequired, BaselineProblem.heightRequired});

      cubit.onHeightChange('180');
      cubit.onBirthDateChange(DateTime(1990, 1, 1));
      expect(cubit.state.problems, isEmpty);
      await cubit.close();
    });

    test('a height out of 50-250 or a birth date under a year ago is refused on the phone', () async {
      final cubit = build();
      cubit
        ..onBirthDateChange(DateTime(2026, 6, 1))
        ..onSexChange(BiologicalSex.female)
        ..onHeightChange('30');

      await cubit.onSaveAndExit();

      expect(cubit.state.problems, {BaselineProblem.birthDateImplausible, BaselineProblem.heightOutOfRange});
      expect(baselines.calls, isEmpty);
      await cubit.close();
    });
  });

  group('recording (first time)', () {
    test('"Save and exit" records with POST and goes back', () async {
      final cubit = build();
      fillForm(cubit);

      await cubit.onSaveAndExit();
      await pumpEventQueue();

      expect(baselines.calls, ['record']);
      expect(baselines.sent.single.height.value, 168.5);
      expect(events.single, isA<BaselineSaved>());
      expect(consultations.startedWith, isEmpty);
      await cubit.close();
    });

    test('"Save and start" records and opens the step the consultation is on', () async {
      consultations.startResult = Result.success(consultation(step: ConsultationStep.diagnosis));
      final cubit = build();
      fillForm(cubit);

      await cubit.onSaveAndStart();
      await pumpEventQueue();

      expect(baselines.calls, ['record']);
      expect(consultations.startedWith, [null]);
      expect(events.single, isA<ConsultationStarted>().having((e) => e.step, 'step', ConsultationStep.diagnosis));
      await cubit.close();
    });

    test('a 409 BaselineAlreadyRecorded is saved as an edit', () async {
      baselines.recordResult = const Result.failure(Conflict('BaselineAlreadyRecorded'));
      final cubit = build();
      fillForm(cubit);

      await cubit.onSaveAndExit();
      await pumpEventQueue();

      expect(baselines.calls, ['record', 'update']);
      expect(events.single, isA<BaselineSaved>());
      await cubit.close();
    });

    test('a retry of "start consultation" does not send the baseline again, and the next save edits it', () async {
      consultations.startResult = const Result.failure(Unexpected('HTTP_500'));
      final cubit = build();
      fillForm(cubit);

      await cubit.onSaveAndStart();
      expect(cubit.state.saveFailed, isTrue);
      expect(baselines.calls, ['record']);

      consultations.startResult = Result.success(consultation());
      await cubit.onRetrySave();
      await pumpEventQueue();

      expect(baselines.calls, ['record']);
      expect(consultations.startedWith, hasLength(2));
      expect(events.single, isA<ConsultationStarted>());
      await cubit.close();
    });

    test('editing the form after a recorded save uses PUT', () async {
      final cubit = build();
      fillForm(cubit);
      await cubit.onSaveAndExit();

      cubit.onHeightChange('170');
      await cubit.onSaveAndExit();

      expect(baselines.calls, ['record', 'update']);
      await cubit.close();
    });
  });

  group('save failures', () {
    test('400 InvalidBirthDate and InvalidHeight flag their own field', () async {
      baselines.recordResult = const Result.failure(Validation('InvalidBirthDate'));
      final cubit = build();
      fillForm(cubit);
      await cubit.onSaveAndExit();
      expect(cubit.state.problems, {BaselineProblem.birthDateImplausible});
      expect(cubit.state.saveFailed, isFalse);

      baselines.recordResult = const Result.failure(Validation('InvalidHeight'));
      await cubit.onSaveAndExit();
      expect(cubit.state.problems, {BaselineProblem.heightOutOfRange});
      expect(events, isEmpty);
      await cubit.close();
    });

    test('a network or server failure shows the notice with retry, and keeps the form', () async {
      baselines.recordResult = const Result.failure(Network());
      final cubit = build();
      fillForm(cubit);

      await cubit.onSaveAndExit();

      expect(cubit.state.saveFailed, isTrue);
      expect(cubit.state.isSaving, isFalse);
      expect(cubit.state.heightText, '168,5');

      baselines.recordResult = Result.success(baseline());
      await cubit.onRetrySave();
      await pumpEventQueue();
      expect(cubit.state.saveFailed, isFalse);
      expect(events.single, isA<BaselineSaved>());
      await cubit.close();
    });

    test('dismissing the notice clears it', () async {
      baselines.recordResult = const Result.failure(Unexpected('HTTP_500'));
      final cubit = build();
      fillForm(cubit);
      await cubit.onSaveAndExit();

      cubit.onSaveFailureDismissed();

      expect(cubit.state.saveFailed, isFalse);
      await cubit.close();
    });

    test('a second save while one is running is ignored', () async {
      final cubit = build();
      fillForm(cubit);

      final first = cubit.onSaveAndExit();
      final second = cubit.onSaveAndExit();
      await Future.wait([first, second]);

      expect(baselines.calls, ['record']);
      await cubit.close();
    });
  });

  group('editing', () {
    test('preloads the saved baseline, with the height written the way the practitioner would', () async {
      baselines.getResult = Result.success(baseline(heightCm: 168.5, conditions: {MedicalCondition.gout}));

      final cubit = build(editing: true);
      expect(cubit.state.isLoading, isTrue);
      await pumpEventQueue();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.birthDate, DateTime(1995, 2, 15));
      expect(cubit.state.sex, BiologicalSex.female);
      expect(cubit.state.heightText, '168.5');
      expect(cubit.state.conditions, {MedicalCondition.gout});
      expect(cubit.state.ageYears, 31);
      await cubit.close();
    });

    test('a whole height shows without decimals', () async {
      baselines.getResult = Result.success(baseline());

      final cubit = build(editing: true);
      await pumpEventQueue();

      expect(cubit.state.heightText, '168');
      await cubit.close();
    });

    test('saving edits with PUT and goes back, without starting a consultation', () async {
      baselines.getResult = Result.success(baseline());
      final cubit = build(editing: true);
      await pumpEventQueue();

      cubit.onHeightChange('170');
      await cubit.onSaveAndExit();
      await pumpEventQueue();

      expect(baselines.calls, ['get', 'update']);
      expect(baselines.sent.single.height.value, 170);
      expect(events.single, isA<BaselineSaved>());
      expect(consultations.startedWith, isEmpty);
      await cubit.close();
    });

    test('with nothing saved (or unreadable) it is recorded as the first time', () async {
      baselines.getResult = const Result.failure(Network());
      final cubit = build(editing: true);
      await pumpEventQueue();
      fillForm(cubit);

      await cubit.onSaveAndExit();

      expect(baselines.calls, ['get', 'record']);
      await cubit.close();
    });
  });

  test('follows the connection so the buttons disable offline', () async {
    final cubit = build();
    await pumpEventQueue();
    expect(cubit.state.isOffline, isFalse);

    connectivity.set(false);
    expect(cubit.state.isOffline, isTrue);
    await cubit.close();
  });
}

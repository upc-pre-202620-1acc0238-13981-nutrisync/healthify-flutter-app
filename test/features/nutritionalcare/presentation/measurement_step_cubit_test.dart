import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation_commands.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/measurement_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/consultation_step_states.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakeConsultationRepository consultations;
  late FakePatientBaselineRepository baselines;
  late FakeConnectivity connectivity;
  late List<ConsultationStepEvent> events;

  setUp(() {
    consultations = FakeConsultationRepository()..inProgressResult = Result.success(freshConsultation());
    baselines = FakePatientBaselineRepository()..getResult = Result.success(baseline());
    connectivity = FakeConnectivity();
  });

  Future<MeasurementStepCubit> build() async {
    final cubit = MeasurementStepCubit(
      GetConsultationInProgressUseCase(consultations),
      GetPatientBaselineUseCase(baselines),
      RecordConsultationMeasurementUseCase(consultations),
      DiscardConsultationUseCase(consultations),
      connectivity,
      patientId: 7,
    );
    events = [];
    cubit.events.listen(events.add);
    await pumpEventQueue();
    return cubit;
  }

  void fillValid(MeasurementStepCubit cubit) {
    cubit
      ..onWeightChange('74,2')
      ..onProtocolToggle(ProtocolCheck.fasting)
      ..onActivityChange(ActivityLevel.moderate);
  }

  group('loading', () {
    test('shows the baseline and the live BMI from its height', () async {
      final cubit = await build();

      expect(cubit.state.load.isLoading, isFalse);
      expect(cubit.state.baseline?.heightCm, 168);
      expect(cubit.state.bmi, isNull);

      cubit.onWeightChange('74,2');
      expect(cubit.state.bmi, 26.3);

      cubit.onWeightChange('abc');
      expect(cubit.state.bmi, isNull);
      await cubit.close();
    });

    test('rehydrates what the consultation saved, written the way it would be typed', () async {
      consultations.inProgressResult = Result.success(
        consultation(
          measurement: ConsultationMeasurement(
            weightKg: 74.2,
            heightCm: 168,
            waistCm: 88,
            bmi: 26.3,
            protocolChecks: const {ProtocolCheck.fasting},
            activityLevel: ActivityLevel.light,
            habits: EatingHabits(mealsPerDay: 4, waterLitersPerDay: 1.5),
            biochemistry: BiochemistryPanel(glucoseMgDl: 92),
            ageYears: 31,
          ),
          checkIn: PatientCheckIn(
            feeling: 'Fair',
            difficulties: const ['Dinners'],
            questions: const ['¿Puedo comer fuera?'],
            submittedAt: DateTime.utc(2026, 9, 15),
          ),
        ),
      );

      final cubit = await build();

      final form = cubit.state.form;
      expect(form.weight, '74.2');
      expect(form.waist, '88');
      expect(form.bodyFat, '');
      expect(form.activityLevel, ActivityLevel.light);
      expect(form.mealsPerDay, '4');
      expect(form.waterLiters, '1.5');
      expect(form.glucose, '92');
      expect(cubit.state.habitsExpanded, isTrue);
      expect(cubit.state.biochemistryExpanded, isTrue);
      expect(cubit.state.checkIn?.questions, ['¿Puedo comer fuera?']);
      expect(cubit.state.bmi, 26.3);
      await cubit.close();
    });

    test('no consultation in progress anymore closes the step', () async {
      consultations.inProgressResult = const Result.success(null);

      final cubit = await build();

      await pumpEventQueue();
      expect(events.single, isA<StepConsultationClosed>());
      await cubit.close();
    });

    test('a failed load is an error with retry; offline says so, and coming back online retries by itself', () async {
      consultations.inProgressResult = const Result.failure(Unexpected('HTTP_500'));
      var cubit = await build();
      expect(cubit.state.load.loadFailed, isTrue);
      expect(cubit.state.load.isOffline, isFalse);

      consultations.inProgressResult = Result.success(freshConsultation());
      cubit.onRetry();
      await pumpEventQueue();
      expect(cubit.state.load.loadFailed, isFalse);
      await cubit.close();

      consultations.inProgressResult = const Result.failure(Network());
      cubit = await build();
      expect(cubit.state.load.loadFailed, isTrue);
      expect(cubit.state.load.isOffline, isTrue);

      consultations.inProgressResult = Result.success(freshConsultation());
      connectivity.set(true);
      await pumpEventQueue();
      expect(cubit.state.load.loadFailed, isFalse);
      expect(cubit.state.load.isOffline, isFalse);
      await cubit.close();
    });
  });

  group('continue', () {
    test('saves a valid measurement and moves on', () async {
      final cubit = await build();
      fillValid(cubit);
      cubit.onWaistChange('88');

      await cubit.onContinue();

      final sent = consultations.measurements.single;
      expect(sent.weightKg, 74.2);
      expect(sent.waistCm, 88);
      expect(sent.protocolChecks, {ProtocolCheck.fasting});
      await pumpEventQueue();
      expect(events.single, isA<StepContinue>());
      expect(cubit.state.isSaving, isFalse);
      await cubit.close();
    });

    test('an invalid form sends nothing and flags the fields, opening the optional sections that hold them', () async {
      final cubit = await build();
      cubit
        ..onMealsPerDayChange('11')
        ..onGlucoseChange('700');

      await cubit.onContinue();

      expect(consultations.measurements, isEmpty);
      expect(cubit.state.problems.keys, containsAll([
        MeasurementField.weight,
        MeasurementField.protocol,
        MeasurementField.activity,
        MeasurementField.mealsPerDay,
        MeasurementField.glucose,
      ]));
      expect(cubit.state.habitsExpanded, isTrue);
      expect(cubit.state.biochemistryExpanded, isTrue);
      await pumpEventQueue();
      expect(events, isEmpty);
      await cubit.close();
    });

    test('editing a field clears its own problem only', () async {
      final cubit = await build();
      await cubit.onContinue();
      expect(cubit.state.problems.keys, contains(MeasurementField.weight));

      cubit.onWeightChange('74');

      expect(cubit.state.problems.keys, isNot(contains(MeasurementField.weight)));
      expect(cubit.state.problems.keys, contains(MeasurementField.protocol));
      await cubit.close();
    });

    test('a measurement equal to the saved one is not sent again', () async {
      consultations.inProgressResult = Result.success(consultationAtDiagnosis());
      final cubit = await build();

      await cubit.onContinue();

      expect(consultations.measurements, isEmpty);
      await pumpEventQueue();
      expect(events.single, isA<StepContinue>());
      await cubit.close();
    });

    test('400 ImplausibleMeasurement flags the weight', () async {
      consultations.recordMeasurementResult = const Result.failure(Validation('ImplausibleMeasurement'));
      final cubit = await build();
      fillValid(cubit);

      await cubit.onContinue();

      expect(cubit.state.problems, {MeasurementField.weight: FieldProblem.outOfRange});
      expect(cubit.state.saveFailure, isNull);
      await pumpEventQueue();
      expect(events, isEmpty);
      await cubit.close();
    });

    test('a lost connection is a notice with retry that keeps everything typed, and retry saves', () async {
      consultations.recordMeasurementResult = const Result.failure(Network());
      final cubit = await build();
      fillValid(cubit);

      await cubit.onContinue();

      expect(cubit.state.saveFailure, const SaveFailure(isNetwork: true));
      expect(cubit.state.form.weight, '74,2');
      await pumpEventQueue();
      expect(events, isEmpty);

      consultations.recordMeasurementResult = null;
      cubit.onSaveFailureDismissed();
      await cubit.onContinue();
      expect(cubit.state.saveFailure, isNull);
      await pumpEventQueue();
      expect(events.single, isA<StepContinue>());
      await cubit.close();
    });

    test('a server error is a notice that is not about the network', () async {
      consultations.recordMeasurementResult = const Result.failure(Unexpected('HTTP_500'));
      final cubit = await build();
      fillValid(cubit);

      await cubit.onContinue();

      expect(cubit.state.saveFailure, const SaveFailure(isNetwork: false));
      await cubit.close();
    });

    test('409 ConsultationNotInProgress closes the consultation', () async {
      consultations.recordMeasurementResult = const Result.failure(Conflict('ConsultationNotInProgress'));
      final cubit = await build();
      fillValid(cubit);

      await cubit.onContinue();

      await pumpEventQueue();
      expect(events.single, isA<StepConsultationClosed>());
      expect(cubit.state.saveFailure, isNull);
      await cubit.close();
    });
  });

  group('leaving', () {
    test('"‹" asks first; staying keeps the step and leaving exits', () async {
      final cubit = await build();

      cubit.onBack();
      expect(cubit.state.showExitDialog, isTrue);
      cubit.onStay();
      expect(cubit.state.showExitDialog, isFalse);
      await pumpEventQueue();
      expect(events, isEmpty);

      cubit.onBack();
      cubit.onExit();
      await pumpEventQueue();
      expect(cubit.state.showExitDialog, isFalse);
      await pumpEventQueue();
      expect(events.single, isA<StepExit>());
      await cubit.close();
    });
  });

  group('delete consultation', () {
    test('asks first, and keeping it deletes nothing', () async {
      final cubit = await build();

      cubit.onDiscard();
      expect(cubit.state.showDiscardDialog, isTrue);
      cubit.onDiscardDismissed();

      expect(cubit.state.showDiscardDialog, isFalse);
      expect(consultations.discarded, isEmpty);
      await cubit.close();
    });

    test('confirming deletes it and exits', () async {
      final cubit = await build();

      cubit.onDiscard();
      await cubit.onDiscardConfirmed();

      expect(consultations.discarded, [ConsultationId(9)]);
      expect(cubit.state.isDiscarding, isFalse);
      expect(cubit.state.showDiscardDialog, isFalse);
      await pumpEventQueue();
      expect(events.single, isA<StepExit>());
      await cubit.close();
    });

    test('one that was already closed elsewhere just closes', () async {
      consultations.discardResult = const Result.failure(Conflict('ConsultationNotInProgress'));
      final cubit = await build();

      await cubit.onDiscardConfirmed();

      await pumpEventQueue();
      expect(events.single, isA<StepConsultationClosed>());
      await cubit.close();
    });

    test('a failure is a notice with retry', () async {
      consultations.discardResult = const Result.failure(Network());
      final cubit = await build();

      await cubit.onDiscardConfirmed();
      expect(cubit.state.discardFailure, const SaveFailure(isNetwork: true));
      await pumpEventQueue();
      expect(events, isEmpty);

      consultations.discardResult = const Result.success(null);
      cubit.onDiscardFailureDismissed();
      await cubit.onDiscardConfirmed();
      await pumpEventQueue();
      expect(events.single, isA<StepExit>());
      await cubit.close();
    });
  });

  test('coming back from editing the baseline rereads it, and the BMI follows the new height', () async {
    final cubit = await build();
    cubit.onWeightChange('74,2');
    expect(cubit.state.bmi, 26.3);

    baselines.getResult = Result.success(baseline(heightCm: 180));
    await cubit.onResume();

    expect(cubit.state.baseline?.heightCm, 180);
    expect(cubit.state.bmi, 22.9);
    await cubit.close();
  });
}

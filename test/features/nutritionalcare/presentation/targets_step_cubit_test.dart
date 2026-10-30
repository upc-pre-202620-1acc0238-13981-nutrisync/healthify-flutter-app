import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation_commands.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/targets_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/consultation_step_states.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakeConsultationRepository consultations;
  late FakeConnectivity connectivity;
  late List<ConsultationStepEvent> events;

  setUp(() {
    consultations = FakeConsultationRepository()..inProgressResult = Result.success(consultationAtTargets());
    connectivity = FakeConnectivity();
  });

  Future<TargetsStepCubit> build() async {
    final cubit = TargetsStepCubit(
      GetConsultationInProgressUseCase(consultations),
      ProposeConsultationTargetsUseCase(consultations),
      PrescribeConsultationTargetsUseCase(consultations),
      connectivity,
      patientId: 7,
    );
    events = [];
    cubit.events.listen(events.add);
    await pumpEventQueue();
    return cubit;
  }

  Future<List<ConsultationStepEvent>> delivered() async {
    await pumpEventQueue();
    return events;
  }

  group('the proposal', () {
    test('is calculated on its own with the default parameters', () async {
      final cubit = await build();

      expect(consultations.parametersSent, [null]);
      expect(cubit.state.proposal?.proposal.energyKcal, 1796);
      expect(cubit.state.isCalculating, isFalse);
      expect(cubit.state.proposalFailed, isFalse);
      await cubit.close();
    });

    test('on resume with targets already calculated nothing is recalculated', () async {
      consultations.inProgressResult = Result.success(consultationAtTargets(targets: savedTargets()));

      final cubit = await build();

      expect(consultations.parametersSent, isEmpty);
      expect(cubit.state.proposal?.proposal, proposedTargets());
      expect(cubit.state.proposal?.inputs.ageYears, 31);
      expect(cubit.state.proposal?.inputs.activityLevel, ActivityLevel.moderate);
      await cubit.close();
    });

    test('a failure with nothing on screen is an error with retry that recalculates', () async {
      consultations.proposeTargetsResult = const Result.failure(Unexpected('HTTP_500'));
      final cubit = await build();
      expect(cubit.state.proposalFailed, isTrue);
      expect(cubit.state.proposal, isNull);

      consultations.proposeTargetsResult = Result.success(targetProposal());
      cubit.onRetry();
      await pumpEventQueue();

      expect(cubit.state.proposalFailed, isFalse);
      expect(cubit.state.proposal, isNotNull);
      await cubit.close();
    });

    test('a failed recalculation keeps the proposal on screen and says so in a notice', () async {
      final cubit = await build();
      cubit.onChangeParameters();
      consultations.proposeTargetsResult = const Result.failure(Network());

      cubit.onApplyParameters();
      await pumpEventQueue();

      expect(cubit.state.proposal, isNotNull);
      expect(cubit.state.proposalFailed, isFalse);
      expect(cubit.state.saveFailure, const SaveFailure(isNetwork: true));
      await cubit.close();
    });

    test('422 ConsultationStepOutOfOrder sends the practitioner back a step', () async {
      consultations.proposeTargetsResult = const Result.failure(Validation('ConsultationStepOutOfOrder'));

      final cubit = await build();

      expect((await delivered()).single, isA<StepBack>());
      await cubit.close();
    });

    test('without the diagnosis the step goes back to it', () async {
      consultations.inProgressResult = Result.success(consultationAtDiagnosis());

      final cubit = await build();

      expect((await delivered()).single, isA<StepBack>());
      expect(consultations.parametersSent, isEmpty);
      await cubit.close();
    });

    test('a failed load is an error, offline is flagged, and the connection coming back retries', () async {
      consultations.inProgressResult = const Result.failure(Network());
      final cubit = await build();
      expect(cubit.state.load.loadFailed, isTrue);
      expect(cubit.state.load.isOffline, isTrue);

      consultations.inProgressResult = Result.success(consultationAtTargets());
      connectivity.set(true);
      await pumpEventQueue();

      expect(cubit.state.load.loadFailed, isFalse);
      expect(cubit.state.proposal, isNotNull);
      await cubit.close();
    });
  });

  group('change parameters', () {
    test('opens prefilled with what the proposal was calculated with and the backend defaults', () async {
      final cubit = await build();

      cubit.onChangeParameters();

      final form = cubit.state.parameters!;
      expect(cubit.state.showParameters, isTrue);
      expect(form.equation, EnergyEquation.mifflinStJeor);
      expect(form.deficitKind, DeficitKind.fixedKcal);
      expect(form.deficit, '500');
      expect(form.proteinPerKg, '1.6');
      expect(form.fatPercent, '30');
      await cubit.close();
    });

    test('recalculates with the typed parameters, accepting the decimal comma', () async {
      final cubit = await build();
      cubit.onChangeParameters();
      cubit.onParametersChange(
        cubit.state.parameters!.copyWith(
          equation: EnergyEquation.harrisBenedict,
          deficitKind: DeficitKind.percentOfTdee,
          deficit: '20',
          proteinPerKg: '1,8',
          fatPercent: '25',
        ),
      );

      cubit.onApplyParameters();
      await pumpEventQueue();

      final sent = consultations.parametersSent.last!;
      expect(sent.equation, EnergyEquation.harrisBenedict);
      expect(sent.deficitKind, DeficitKind.percentOfTdee);
      expect(sent.deficitValue, 20);
      expect(sent.proteinGramsPerKg, 1.8);
      expect(sent.fatPercentOfEnergy, 25);
      expect(cubit.state.showParameters, isFalse);
      await cubit.close();
    });

    test('values out of range are refused before calling the backend', () async {
      final cubit = await build();
      cubit.onChangeParameters();
      for (final bad in [
        cubit.state.parameters!.copyWith(deficit: '1501'),
        cubit.state.parameters!.copyWith(deficitKind: DeficitKind.percentOfTdee, deficit: '41'),
        cubit.state.parameters!.copyWith(proteinPerKg: '3,1'),
        cubit.state.parameters!.copyWith(fatPercent: '14'),
        cubit.state.parameters!.copyWith(deficit: 'x'),
      ]) {
        cubit.onParametersChange(bad);
        cubit.onApplyParameters();
        expect(cubit.state.parametersInvalid, isTrue, reason: '$bad');
      }

      expect(consultations.parametersSent, [null]);
      cubit.onParametersChange(cubit.state.parameters!.copyWith(deficit: '0', fatPercent: '45', proteinPerKg: '0,5'));
      expect(cubit.state.parametersInvalid, isFalse);
      await cubit.close();
    });
  });

  group('accept targets', () {
    test('prescribes them as proposed and moves on', () async {
      final cubit = await build();

      cubit.onAccept();
      await pumpEventQueue();

      expect(consultations.prescriptions.single, isA<AcceptedAsProposed>());
      expect((await delivered()).single, isA<StepContinue>());
      await cubit.close();
    });

    test('targets already prescribed as proposed are not sent again', () async {
      consultations.inProgressResult = Result.success(consultationAtTargets(targets: savedTargets()));
      final cubit = await build();

      cubit.onAccept();

      expect(consultations.prescriptions, isEmpty);
      expect((await delivered()).single, isA<StepContinue>());
      await cubit.close();
    });

    test('a lost connection is a notice and "Retry" repeats the same prescription', () async {
      consultations.prescribeTargetsResult = const Result.failure(Network());
      final cubit = await build();

      cubit.onAccept();
      await pumpEventQueue();
      expect(cubit.state.saveFailure, const SaveFailure(isNetwork: true));
      expect(cubit.state.isSaving, isFalse);

      consultations.prescribeTargetsResult = Result.success(consultationAtPublication());
      cubit.onRetrySave();
      await pumpEventQueue();

      expect(consultations.prescriptions, hasLength(2));
      expect(cubit.state.saveFailure, isNull);
      expect((await delivered()).single, isA<StepContinue>());
      await cubit.close();
    });

    test('409 ConsultationNotInProgress closes the consultation', () async {
      consultations.prescribeTargetsResult = const Result.failure(Conflict('ConsultationNotInProgress'));
      final cubit = await build();

      cubit.onAccept();

      expect((await delivered()).single, isA<StepConsultationClosed>());
      await cubit.close();
    });
  });

  group('own values', () {
    test('open prefilled with the proposal, rounded', () async {
      final cubit = await build();

      cubit.onWriteOwnValues();

      expect(cubit.state.showOverride, isTrue);
      expect(cubit.state.ownValues.energy, '1796');
      expect(cubit.state.ownValues.protein, '119');
      expect(cubit.state.ownValues.carb, '195');
      expect(cubit.state.ownValues.fat, '60');
      expect(cubit.state.ownValues.reason, '');
      await cubit.close();
    });

    test('without a reason nothing is sent and the reason is flagged', () async {
      final cubit = await build();
      cubit.onWriteOwnValues();

      cubit.onSaveOverride();

      expect(cubit.state.overrideProblems, {OverrideField.reason});
      expect(consultations.prescriptions, isEmpty);

      cubit.onOverrideChange(cubit.state.ownValues.copyWith(reason: 'Su ritmo'));
      expect(cubit.state.overrideProblems, isEmpty);
      await cubit.close();
    });

    test('each invalid field is flagged, and filling it in clears only its own flag', () async {
      final cubit = await build();
      cubit.onWriteOwnValues();
      cubit.onOverrideChange(cubit.state.ownValues.copyWith(energy: '', protein: '', reason: 'x'));

      cubit.onSaveOverride();
      expect(cubit.state.overrideProblems, {OverrideField.energy, OverrideField.protein});

      cubit.onOverrideChange(cubit.state.ownValues.copyWith(protein: '110'));
      expect(cubit.state.overrideProblems, {OverrideField.energy});
      await cubit.close();
    });

    test('a zero energy is flagged by the validation, not accepted', () async {
      final cubit = await build();
      cubit.onWriteOwnValues();
      cubit.onOverrideChange(cubit.state.ownValues.copyWith(energy: '0', reason: 'x'));

      cubit.onSaveOverride();

      expect(cubit.state.overrideProblems, {OverrideField.energy});
      expect(consultations.prescriptions, isEmpty);
      await cubit.close();
    });

    test('are prescribed with the trimmed reason and close the sheet', () async {
      final cubit = await build();
      cubit.onWriteOwnValues();
      cubit.onOverrideChange(cubit.state.ownValues.copyWith(energy: '1700', protein: '120', reason: ' Su ritmo '));

      cubit.onSaveOverride();
      await pumpEventQueue();

      final sent = consultations.prescriptions.single as OverriddenTargets;
      expect(sent.targets.energyKcal, 1700);
      expect(sent.targets.proteinG, 120);
      expect(sent.reason.value, 'Su ritmo');
      expect(cubit.state.showOverride, isFalse);
      expect((await delivered()).single, isA<StepContinue>());
      await cubit.close();
    });

    test('400 OverrideReasonRequired from the backend reopens the sheet on the reason', () async {
      consultations.prescribeTargetsResult = const Result.failure(Validation('OverrideReasonRequired'));
      final cubit = await build();
      cubit.onWriteOwnValues();
      cubit.onOverrideChange(cubit.state.ownValues.copyWith(reason: 'x'));

      cubit.onSaveOverride();
      await pumpEventQueue();

      expect(cubit.state.showOverride, isTrue);
      expect(cubit.state.overrideProblems, {OverrideField.reason});
      expect(cubit.state.saveFailure, isNull);
      expect(await delivered(), isEmpty);
      await cubit.close();
    });

    test('dismissing keeps what was typed for the next time', () async {
      final cubit = await build();
      cubit.onWriteOwnValues();
      cubit.onOverrideChange(cubit.state.ownValues.copyWith(reason: 'Su ritmo'));
      cubit.onOverrideDismissed();

      cubit.onWriteOwnValues();

      expect(cubit.state.ownValues.reason, 'Su ritmo');
      await cubit.close();
    });
  });
}

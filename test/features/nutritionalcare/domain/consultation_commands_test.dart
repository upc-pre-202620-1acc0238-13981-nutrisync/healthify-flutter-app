import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation_commands.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_history.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';

import '../fakes.dart';

NewMeasurement _measurement({
  double weightKg = 74.2,
  Set<ProtocolCheck> checks = const {ProtocolCheck.fasting, ProtocolCheck.noShoes},
}) => NewMeasurement(
  weightKg: weightKg,
  waistCm: 88,
  protocolChecks: checks,
  activityLevel: ActivityLevel.moderate,
  habits: EatingHabits(mealsPerDay: 4),
);

void main() {
  group('clinical ranges follow the backend plausibility', () {
    test('weight', () {
      expect(ClinicalRange.weightKg.parse(''), isA<EmptyNumber>());
      expect(ClinicalRange.weightKg.parse('351'), isA<OutOfRangeNumber>());
      expect(ClinicalRange.weightKg.parse('19,9'), isA<OutOfRangeNumber>());
      expect((ClinicalRange.weightKg.parse('20') as ValidNumber).value, 20);
      expect((ClinicalRange.weightKg.parse('74,256') as ValidNumber).value, 74.26);
    });

    test('whole numbers refuse decimals', () {
      expect(ClinicalRange.mealsPerDay.parse('2.5'), isA<OutOfRangeNumber>());
      expect((ClinicalRange.mealsPerDay.parse('4') as ValidNumber).value, 4);
      expect(ClinicalRange.mealsPerDay.parse('0'), isA<OutOfRangeNumber>());
      expect((ClinicalRange.mealsOutPerWeek.parse('0') as ValidNumber).value, 0);
    });

    test('every range matches the backend limits', () {
      expect([ClinicalRange.waistCm.minimum, ClinicalRange.waistCm.maximum], [40, 200]);
      expect([ClinicalRange.bodyFatPercent.minimum, ClinicalRange.bodyFatPercent.maximum], [3, 70]);
      expect([ClinicalRange.waterLitersPerDay.minimum, ClinicalRange.waterLitersPerDay.maximum], [0, 10]);
      expect([ClinicalRange.glucoseMgDl.minimum, ClinicalRange.glucoseMgDl.maximum], [20, 600]);
      expect([ClinicalRange.totalCholesterolMgDl.minimum, ClinicalRange.totalCholesterolMgDl.maximum], [50, 500]);
      expect([ClinicalRange.triglyceridesMgDl.minimum, ClinicalRange.triglyceridesMgDl.maximum], [20, 2000]);
    });
  });

  test('bmi is weight over height squared with one decimal and the WHO category', () {
    final bmi = BodyMassIndex.of(74.2, 168);
    expect(bmi.value, 26.3);
    expect(bmi.category, DiagnosisCode.overweightGradeI);
    expect(DiagnosisCode.forBmi(24.9), DiagnosisCode.normalWeight);
    expect(DiagnosisCode.forBmi(40), DiagnosisCode.obesityGradeIII);
    expect(DiagnosisCode.forBmi(18.4), DiagnosisCode.underweight);
    expect(DiagnosisCode.forBmi(30), DiagnosisCode.obesityGradeI);
    expect(DiagnosisCode.forBmi(35), DiagnosisCode.obesityGradeII);
  });

  group('measurement form', () {
    test('needs weight, a protocol check and the activity; the rest is optional', () {
      final empty = const MeasurementForm().validate() as InvalidMeasurement;
      expect(empty.problems, {
        MeasurementField.weight: FieldProblem.required,
        MeasurementField.protocol: FieldProblem.required,
        MeasurementField.activity: FieldProblem.required,
      });

      const form = MeasurementForm(
        weight: '74,2',
        waist: '88',
        protocolChecks: {ProtocolCheck.fasting},
        activityLevel: ActivityLevel.moderate,
        mealsPerDay: '4',
        glucose: '700',
      );
      final withBadLab = form.validate() as InvalidMeasurement;
      expect(withBadLab.problems, {MeasurementField.glucose: FieldProblem.outOfRange});

      final valid = form.copyWith(glucose: '').validate() as ValidMeasurement;
      expect(valid.measurement.weightKg, 74.2);
      expect(valid.measurement.waistCm, 88);
      expect(valid.measurement.habits?.mealsPerDay, 4);
      expect(valid.measurement.biochemistry, isNull);
    });

    test('flags every out-of-range field at once, with the decimal comma', () {
      const form = MeasurementForm(
        weight: '19',
        waist: '39,9',
        bodyFat: '71',
        protocolChecks: {ProtocolCheck.fasting},
        activityLevel: ActivityLevel.light,
        mealsPerDay: '11',
        waterLiters: '10,5',
        mealsOut: '22',
        glucose: '19',
        cholesterol: '501',
        triglycerides: '2001',
      );

      final invalid = form.validate() as InvalidMeasurement;

      expect(invalid.problems.keys.toSet(), {
        MeasurementField.weight,
        MeasurementField.waist,
        MeasurementField.bodyFat,
        MeasurementField.mealsPerDay,
        MeasurementField.water,
        MeasurementField.mealsOut,
        MeasurementField.glucose,
        MeasurementField.cholesterol,
        MeasurementField.triglycerides,
      });
      expect(invalid.problems.values.toSet(), {FieldProblem.outOfRange});
    });

    test('a measurement equal to the saved one is recognised so it is not sent again', () {
      final same = _measurement();
      final saved = savedMeasurement();

      expect(same.sameAs(saved), isTrue);
      expect(_measurement(weightKg: 74).sameAs(saved), isFalse);
      expect(_measurement(checks: const {ProtocolCheck.fasting}).sameAs(saved), isFalse);
      expect(() => _measurement(checks: const {}), throwsArgumentError);
    });

    test('habits and biochemistry need at least one value', () {
      expect(EatingHabits.new, throwsArgumentError);
      expect(BiochemistryPanel.new, throwsArgumentError);
    });
  });

  group('own values', () {
    test('require a reason', () {
      final noReason = validateOverride(energy: '1700', protein: '120', carb: '180', fat: '55', reason: '  ');
      expect((noReason as InvalidOverride).problems, {OverrideField.reason});

      final badEnergy = validateOverride(energy: '0', protein: '120', carb: 'x', fat: '55', reason: 'Ajuste');
      expect((badEnergy as InvalidOverride).problems, {OverrideField.energy, OverrideField.carb});

      final valid =
          validateOverride(energy: '1700', protein: '120', carb: '180', fat: '55', reason: ' Su ritmo de trabajo ')
              as ValidOverride;
      expect(valid.prescription.reason.value, 'Su ritmo de trabajo');
      expect(valid.prescription.targets.energyKcal, 1700);
      expect(() => OverrideReason(''), throwsArgumentError);
    });

    test('macros may be zero, energy may not, and nothing goes past 10 000', () {
      final zeroMacros = validateOverride(energy: '1500', protein: '0', carb: '0', fat: '0', reason: 'x');
      expect(zeroMacros, isA<ValidOverride>());

      final tooMuch = validateOverride(energy: '10001', protein: '10000.1', carb: '-1', fat: '1', reason: 'x');
      expect((tooMuch as InvalidOverride).problems, {OverrideField.energy, OverrideField.protein, OverrideField.carb});
    });

    test('the reason has at most 500 characters', () {
      final long = 'x' * 501;
      expect(
        (validateOverride(energy: '1', protein: '1', carb: '1', fat: '1', reason: long) as InvalidOverride).problems,
        {OverrideField.reason},
      );
      expect(
        validateOverride(energy: '1', protein: '1', carb: '1', fat: '1', reason: 'x' * 500),
        isA<ValidOverride>(),
      );
    });
  });

  test('macro shares follow 4-4-9 kcal per gram', () {
    final targets = Targets(energyKcal: 1796, proteinG: 119, carbG: 195, fatG: 60);

    expect(targets.proteinPercent, 27);
    expect(targets.carbPercent, 43);
    expect(targets.fatPercent, 30);
    expect(Targets(energyKcal: 1, proteinG: 0, carbG: 0, fatG: 0).proteinPercent, 0);
  });

  test('only a real AI generation is recorded as an accepted suggestion', () {
    final ai = diagnosisSuggestion();
    final accepted = DiagnosisChoice.accepting(ai) as AcceptAiSuggestion;
    expect(accepted.code, DiagnosisCode.overweightGradeI);
    expect(accepted.aiGenerationId, 77);
    expect(accepted.source, DiagnosisSource.aiSuggestionAccepted);

    final rule = DiagnosisChoice.accepting(diagnosisSuggestion(fromAi: false)) as SelectedDiagnosis;
    expect(rule.source, DiagnosisSource.practitionerSelected);
    expect(rule.rationale, 'IMC 26.3 kg/m2 (rango 25 a 29.9).');
    expect(SuggestionSource.fromCode('Something'), SuggestionSource.rule);
    expect(SuggestionSource.fromCode('ai'), SuggestionSource.ai);
  });

  group('target parameters', () {
    TargetParameters build({
      DeficitKind kind = DeficitKind.fixedKcal,
      double deficit = 500,
      double protein = 1.6,
      double fat = 30,
    }) => TargetParameters(
      equation: EnergyEquation.mifflinStJeor,
      deficitKind: kind,
      deficitValue: deficit,
      proteinGramsPerKg: protein,
      fatPercentOfEnergy: fat,
    );

    test('the deficit goes to 1500 kcal or 40 %', () {
      expect(build(deficit: 1500).deficitValue, 1500);
      expect(() => build(deficit: 1501), throwsArgumentError);
      expect(build(kind: DeficitKind.percentOfTdee, deficit: 40).deficitValue, 40);
      expect(() => build(kind: DeficitKind.percentOfTdee, deficit: 41), throwsArgumentError);
      expect(() => build(deficit: -1), throwsArgumentError);
    });

    test('protein goes 0.5 to 3 g/kg and fat 15 to 45 %', () {
      expect(build(protein: 0.5).proteinGramsPerKg, 0.5);
      expect(() => build(protein: 3.1), throwsArgumentError);
      expect(build(fat: 45).fatPercentOfEnergy, 45);
      expect(() => build(fat: 14.9), throwsArgumentError);
    });
  });

  group('publication', () {
    test('limits custom guidelines, their length and the message', () {
      expect(() => CustomGuidelineText('ab'), throwsArgumentError);
      expect(() => CustomGuidelineText('x' * 141), throwsArgumentError);
      expect(CustomGuidelineText('  abc  ').text, '  abc  ');
      expect(
        () => Publication(
          restrictions: const {},
          guidelines: const {},
          customGuidelines: [for (var i = 0; i < 6; i++) CustomGuidelineText('Indicación $i')],
        ),
        throwsArgumentError,
      );
      expect(PatientMessage.ofOptional('   '), isNull);
      expect(PatientMessage.ofOptional(' Hola ')?.text, 'Hola');
      expect(() => PatientMessage('x' * 501), throwsArgumentError);
    });

    test('two publications with the same choices are equal, whatever the order', () {
      Publication build(Set<PlanGuidelineCode> guidelines) => Publication(
        restrictions: const {PlanRestrictionCode.halal},
        guidelines: guidelines,
        customGuidelines: [CustomGuidelineText('Caminar')],
        patientMessage: PatientMessage('Hola'),
      );

      expect(
        build({PlanGuidelineCode.reduceSalt, PlanGuidelineCode.drink2lWater}),
        build({PlanGuidelineCode.drink2lWater, PlanGuidelineCode.reduceSalt}),
      );
      expect(build({PlanGuidelineCode.reduceSalt}) == build({PlanGuidelineCode.drink2lWater}), isFalse);
    });
  });

  test('idempotency keys are visible ascii and random ones are unique', () {
    final first = IdempotencyKey.random();

    expect(first.value.length, lessThanOrEqualTo(IdempotencyKey.maxLength));
    expect(first == IdempotencyKey.random(), isFalse);
    expect(first.value, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
    expect(() => IdempotencyKey('con espacio'), throwsArgumentError);
    expect(() => IdempotencyKey(''), throwsArgumentError);
    expect(() => IdempotencyKey('x' * 65), throwsArgumentError);
  });

  test('step numbers and codes round-trip', () {
    for (final step in ConsultationStep.values) {
      expect(ConsultationStep.fromNumber(step.number), step);
      expect(ConsultationStep.fromCode(step.code.toLowerCase()), step);
    }
    expect(ConsultationStep.fromNumber(5), isNull);
  });
}

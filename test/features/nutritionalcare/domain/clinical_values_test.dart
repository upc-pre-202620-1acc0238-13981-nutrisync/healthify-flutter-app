import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_baseline.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';

void main() {
  group('DecimalText', () {
    test('reads a decimal comma or point', () {
      expect(DecimalText.parse('74,2'), 74.2);
      expect(DecimalText.parse(' 74.2 '), 74.2);
      expect(DecimalText.parse('168'), 168);
    });

    test('rejects what is not a plain number', () {
      for (final text in ['', 'abc', '1.2.3', '-5', '1e3', '12 cm', '.']) {
        expect(DecimalText.parse(text), isNull, reason: text);
      }
    });

    test('rounds half up on the written number', () {
      expect(DecimalText.round(1.005, 2), 1.01);
      expect(DecimalText.round(168.25, 1), 168.3);
      expect(DecimalText.round(168, 1), 168);
    });
  });

  group('ClinicalRange.heightCm', () {
    test('empty text is empty', () => expect(ClinicalRange.heightCm.parse('  '), isA<EmptyNumber>()));

    test('accepts the edges of 50-250', () {
      expect((ClinicalRange.heightCm.parse('50') as ValidNumber).value, 50);
      expect((ClinicalRange.heightCm.parse('250') as ValidNumber).value, 250);
    });

    test('rounds to one decimal', () {
      expect((ClinicalRange.heightCm.parse('168,46') as ValidNumber).value, 168.5);
    });

    test('rejects out of range and non numbers', () {
      for (final text in ['49.9', '250.1', '0', 'alto']) {
        expect(ClinicalRange.heightCm.parse(text), isA<OutOfRangeNumber>(), reason: text);
      }
    });
  });

  group('BirthDate', () {
    final today = DateTime(2026, 10, 30);

    test('is plausible between 1 and 120 years ago, edges included', () {
      expect(BirthDate.isPlausible(DateTime(2025, 10, 30), today), isTrue);
      expect(BirthDate.isPlausible(DateTime(2025, 10, 31), today), isFalse);
      expect(BirthDate.isPlausible(DateTime(1906, 10, 30), today), isTrue);
      expect(BirthDate.isPlausible(DateTime(1906, 10, 29), today), isFalse);
      expect(BirthDate.isPlausible(DateTime(2027, 1, 1), today), isFalse);
    });

    test('a leap day counts back to Feb 28 in a common year', () {
      expect(BirthDate.isPlausible(DateTime(2023, 2, 28), DateTime(2024, 2, 29)), isTrue);
    });

    test('the age counts the birthday on its day', () {
      expect(BirthDate.ageOn(DateTime(1995, 10, 30), today), 31);
      expect(BirthDate.ageOn(DateTime(1995, 10, 31), today), 30);
      expect(BirthDate.ageOn(DateTime(1995, 11, 1), today), 30);
      expect(BirthDate(DateTime(1995, 2, 15), today).ageYears, 31);
    });

    test('refuses an implausible date', () {
      expect(() => BirthDate(DateTime(2026, 1, 1), today), throwsArgumentError);
    });
  });

  group('validateBaseline', () {
    final today = DateTime(2026, 10, 30);

    BaselineValidation validate({
      DateTime? birthDate,
      BiologicalSex? sex,
      String height = '',
      Set<MedicalCondition> conditions = const {},
    }) => validateBaseline(birthDate: birthDate, sex: sex, heightText: height, conditions: conditions, today: today);

    test('an empty form lacks the birth date, the sex and the height', () {
      final result = validate() as InvalidBaseline;

      expect(result.problems, {
        BaselineProblem.birthDateRequired,
        BaselineProblem.sexRequired,
        BaselineProblem.heightRequired,
      });
    });

    test('flags an implausible birth date and an out of range height', () {
      final result = validate(birthDate: DateTime(2026, 6, 1), sex: BiologicalSex.male, height: '300') as InvalidBaseline;

      expect(result.problems, {BaselineProblem.birthDateImplausible, BaselineProblem.heightOutOfRange});
    });

    test('a complete form is valid, with no condition meaning no history', () {
      final result = validate(birthDate: DateTime(1995, 2, 15), sex: BiologicalSex.female, height: '168,5') as ValidBaseline;

      expect(result.baseline.height.value, 168.5);
      expect(result.baseline.birthDate.ageYears, 31);
      expect(result.baseline.conditions, isEmpty);
    });

    test('two equal baselines compare equal whatever the order of the conditions', () {
      NewBaseline build(Set<MedicalCondition> conditions) =>
          (validate(birthDate: DateTime(1995, 2, 15), sex: BiologicalSex.female, height: '168', conditions: conditions)
                  as ValidBaseline)
              .baseline;

      final a = build({MedicalCondition.gout, MedicalCondition.hypertension});
      final b = build({MedicalCondition.hypertension, MedicalCondition.gout});

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == build({MedicalCondition.gout}), isFalse);
    });
  });

  test('codes are read ignoring case, and an unknown one is dropped', () {
    expect(BiologicalSex.fromCode('female'), BiologicalSex.female);
    expect(MedicalCondition.fromCode('Type2Diabetes'), MedicalCondition.type2Diabetes);
    expect(MedicalCondition.fromCode('Flu'), isNull);
    expect(ConsultationStep.fromCode('targets'), ConsultationStep.targets);
    expect(ConsultationStep.fromNumber(4), ConsultationStep.publication);
    expect(ConsultationStep.fromNumber(5), isNull);
  });
}

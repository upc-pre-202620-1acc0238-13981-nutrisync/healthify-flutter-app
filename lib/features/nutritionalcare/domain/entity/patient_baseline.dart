import '../valueobject/clinical_codes.dart';
import '../valueobject/clinical_values.dart';

/// `PatientBaselineResource`: the baseline, recorded only once. Only the practitioner sees it.
///
/// [ageYears]: age as of today according to the backend ("updates itself"). [birthDate] is a calendar date.
final class PatientBaseline {
  /// Throws [ArgumentError] if the age is negative or the height is not positive.
  PatientBaseline({
    required this.birthDate,
    required this.ageYears,
    required this.sex,
    required this.heightCm,
    required this.conditions,
  }) {
    if (ageYears < 0) throw ArgumentError.value(ageYears, 'ageYears', 'Age cannot be negative');
    if (heightCm <= 0) throw ArgumentError.value(heightCm, 'heightCm', 'Height must be positive');
  }

  final DateTime birthDate;
  final int ageYears;
  final BiologicalSex sex;
  final double heightCm;
  final Set<MedicalCondition> conditions;
}

/// What `POST`/`PUT /patients/{pid}/baseline` sends. No condition checked = no medical history.
final class NewBaseline {
  const NewBaseline({required this.birthDate, required this.sex, required this.height, required this.conditions});

  final BirthDate birthDate;
  final BiologicalSex sex;
  final HeightCm height;
  final Set<MedicalCondition> conditions;

  @override
  bool operator ==(Object other) =>
      other is NewBaseline &&
      other.birthDate == birthDate &&
      other.sex == sex &&
      other.height == height &&
      other.conditions.length == conditions.length &&
      other.conditions.containsAll(conditions);

  @override
  int get hashCode => Object.hash(birthDate, sex, height, Object.hashAllUnordered(conditions));
}

/// What the baseline form is missing before it can be saved.
enum BaselineProblem { birthDateRequired, birthDateImplausible, sexRequired, heightRequired, heightOutOfRange }

sealed class BaselineValidation {
  const BaselineValidation();
}

final class ValidBaseline extends BaselineValidation {
  const ValidBaseline(this.baseline);

  final NewBaseline baseline;
}

final class InvalidBaseline extends BaselineValidation {
  const InvalidBaseline(this.problems);

  final Set<BaselineProblem> problems;
}

/// Validates the baseline on the phone with the backend's rules (`InvalidBirthDate`, `InvalidHeight`).
BaselineValidation validateBaseline({
  required DateTime? birthDate,
  required BiologicalSex? sex,
  required String heightText,
  required Set<MedicalCondition> conditions,
  required DateTime today,
}) {
  final problems = <BaselineProblem>{};
  if (birthDate == null) {
    problems.add(BaselineProblem.birthDateRequired);
  } else if (!BirthDate.isPlausible(birthDate, today)) {
    problems.add(BaselineProblem.birthDateImplausible);
  }
  if (sex == null) problems.add(BaselineProblem.sexRequired);
  double? height;
  switch (ClinicalRange.heightCm.parse(heightText)) {
    case ValidNumber(:final value):
      height = value;
    case EmptyNumber():
      problems.add(BaselineProblem.heightRequired);
    case OutOfRangeNumber():
      problems.add(BaselineProblem.heightOutOfRange);
  }
  if (problems.isNotEmpty || birthDate == null || sex == null || height == null) return InvalidBaseline(problems);
  return ValidBaseline(
    NewBaseline(birthDate: BirthDate(birthDate, today), sex: sex, height: HeightCm(height), conditions: conditions),
  );
}

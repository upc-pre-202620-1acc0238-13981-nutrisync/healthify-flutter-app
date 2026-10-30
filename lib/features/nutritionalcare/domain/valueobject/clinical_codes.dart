// NutritionalCare closed lists. Each value carries the backend's exact code; the app translates codes through the ARB
// files, and an unknown code is dropped or shown as is, depending on the screen.

T? _byCode<T>(Iterable<T> values, String Function(T) codeOf, String? code) {
  if (code == null) return null;
  for (final value in values) {
    if (codeOf(value).toLowerCase() == code.toLowerCase()) return value;
  }
  return null;
}

/// Biological sex in the baseline: only Female and Male.
enum BiologicalSex {
  female('Female'),
  male('Male');

  const BiologicalSex(this.code);

  final String code;

  static BiologicalSex? fromCode(String? code) => _byCode(values, (v) => v.code, code);
}

/// Medical history: an empty set is valid (there is no "None" option).
enum MedicalCondition {
  type2Diabetes('Type2Diabetes'),
  hypertension('Hypertension'),
  celiacDisease('CeliacDisease'),
  hypothyroidism('Hypothyroidism'),
  chronicKidneyDisease('ChronicKidneyDisease'),
  gout('Gout');

  const MedicalCondition(this.code);

  final String code;

  static MedicalCondition? fromCode(String? code) => _byCode(values, (v) => v.code, code);
}

/// Step of the guided consultation.
enum ConsultationStep {
  measurement('Measurement', 1),
  diagnosis('Diagnosis', 2),
  targets('Targets', 3),
  publication('Publication', 4);

  const ConsultationStep(this.code, this.number);

  final String code;
  final int number;

  static const total = 4;

  static ConsultationStep? fromCode(String? code) => _byCode(values, (v) => v.code, code);

  static ConsultationStep? fromNumber(int number) {
    for (final step in values) {
      if (step.number == number) return step;
    }
    return null;
  }
}

/// Plan restrictions, a closed list with no "Other restriction".
enum PlanRestrictionCode {
  lactoseFree('LactoseFree'),
  glutenFree('GlutenFree'),
  vegan('Vegan'),
  vegetarian('Vegetarian'),
  treeNutFree('TreeNutFree'),
  shellfishFree('ShellfishFree'),
  kosher('Kosher'),
  halal('Halal');

  const PlanRestrictionCode(this.code);

  final String code;

  static PlanRestrictionCode? fromCode(String? code) => _byCode(values, (v) => v.code, code);
}

/// Catalog guidelines. Anything not listed here goes as "Other guideline" (the practitioner's text).
enum PlanGuidelineCode {
  prioritizeVegetables('PrioritizeVegetables'),
  drink2lWater('Drink2LWater'),
  avoidSugaryDrinks('AvoidSugaryDrinks'),
  proteinAtBreakfast('ProteinAtBreakfast'),
  reduceSalt('ReduceSalt'),
  eatEvery3To4Hours('EatEvery3To4Hours'),
  proteinAndVegetablesAtDinner('ProteinAndVegetablesAtDinner');

  const PlanGuidelineCode(this.code);

  final String code;

  static PlanGuidelineCode? fromCode(String? code) => _byCode(values, (v) => v.code, code);
}

/// Current physical activity with its default factor (`NutritionalCare:ActivityFactors`).
enum ActivityLevel {
  sedentary('Sedentary', 1.2),
  light('Light', 1.375),
  moderate('Moderate', 1.55),
  intense('Intense', 1.725);

  const ActivityLevel(this.code, this.defaultFactor);

  final String code;
  final double defaultFactor;

  static ActivityLevel? fromCode(String? code) => _byCode(values, (v) => v.code, code);
}

/// Measurement protocol checkboxes: at least one checked.
enum ProtocolCheck {
  fasting('Fasting'),
  noShoes('NoShoes'),
  lightClothing('LightClothing'),
  emptyBladder('EmptyBladder'),
  sameScale('SameScale');

  const ProtocolCheck(this.code);

  final String code;

  static ProtocolCheck? fromCode(String? code) => _byCode(values, (v) => v.code, code);
}

/// Nutritional diagnosis, a closed list with no "Other". It shares the WHO cut-offs with the BMI category:
/// < 18.5 · 18.5-24.9 · 25-29.9 · 30-34.9 · 35-39.9 · >= 40.
enum DiagnosisCode {
  underweight('Underweight'),
  normalWeight('NormalWeight'),
  overweightGradeI('OverweightGradeI'),
  obesityGradeI('ObesityGradeI'),
  obesityGradeII('ObesityGradeII'),
  obesityGradeIII('ObesityGradeIII');

  const DiagnosisCode(this.code);

  final String code;

  static DiagnosisCode? fromCode(String? code) => _byCode(values, (v) => v.code, code);

  /// The backend's `BodyMassIndex.CategoryFor`.
  static DiagnosisCode forBmi(double bmi) {
    if (bmi < 18.5) return underweight;
    if (bmi < 25.0) return normalWeight;
    if (bmi < 30.0) return overweightGradeI;
    if (bmi < 35.0) return obesityGradeI;
    if (bmi < 40.0) return obesityGradeII;
    return obesityGradeIII;
  }
}

/// Who chose the diagnosis. Accepting the deterministic ("rule-based") suggestion counts as [practitionerSelected]:
/// only a real AI generation is recorded as accepted.
enum DiagnosisSource {
  aiSuggestionAccepted('AiSuggestionAccepted'),
  practitionerSelected('PractitionerSelected');

  const DiagnosisSource(this.code);

  final String code;

  static DiagnosisSource? fromCode(String? code) => _byCode(values, (v) => v.code, code);
}

/// Where a diagnosis or guideline suggestion comes from: the AI, or the fixed rule when AI is unavailable.
enum SuggestionSource {
  ai('Ai'),
  rule('Rule');

  const SuggestionSource(this.code);

  final String code;

  /// Any other value reads as a rule: nothing that is not AI is ever labeled "AI".
  static SuggestionSource fromCode(String? code) => code?.toLowerCase() == ai.code.toLowerCase() ? ai : rule;
}

/// Basal expenditure equation. KatchMcArdle needs the body fat from the measurement.
enum EnergyEquation {
  mifflinStJeor('MifflinStJeor'),
  harrisBenedict('HarrisBenedict'),
  faoWhoUnu('FaoWhoUnu'),
  katchMcArdle('KatchMcArdle');

  const EnergyEquation(this.code);

  final String code;

  static EnergyEquation? fromCode(String? code) => _byCode(values, (v) => v.code, code);
}

/// Deficit type: fixed kcal (0-1500) or a percentage of total expenditure (0-40).
enum DeficitKind {
  fixedKcal('FixedKcal', 1500),
  percentOfTdee('PercentOfTdee', 40);

  const DeficitKind(this.code, this.maximum);

  final String code;
  final double maximum;

  static DeficitKind? fromCode(String? code) => _byCode(values, (v) => v.code, code);
}

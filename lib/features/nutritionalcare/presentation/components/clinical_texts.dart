import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/valueobject/clinical_codes.dart';

/// Clinical codes -> ARB texts in the reader's language. Texts written by a person (custom guideline, legacy
/// restriction, message) are shown as is: never translated.
extension ClinicalTexts on AppLocalizations {
  /// "Female" / "Male" in the baseline selector.
  String sexOption(BiologicalSex sex) => switch (sex) {
    BiologicalSex.female => sexFemale,
    BiologicalSex.male => sexMale,
  };

  /// "Woman" / "Man" in summaries ("Woman · 31 years · 168 cm").
  String sexSummary(BiologicalSex sex) => switch (sex) {
    BiologicalSex.female => sexSummaryFemale,
    BiologicalSex.male => sexSummaryMale,
  };

  String condition(MedicalCondition condition) => switch (condition) {
    MedicalCondition.type2Diabetes => conditionType2Diabetes,
    MedicalCondition.hypertension => conditionHypertension,
    MedicalCondition.celiacDisease => conditionCeliacDisease,
    MedicalCondition.hypothyroidism => conditionHypothyroidism,
    MedicalCondition.chronicKidneyDisease => conditionChronicKidneyDisease,
    MedicalCondition.gout => conditionGout,
  };

  /// "Today's measurement", "Diagnosis", "Targets", "Guidelines and publication".
  String stepTitle(ConsultationStep step) => switch (step) {
    ConsultationStep.measurement => consultationStepMeasurement,
    ConsultationStep.diagnosis => consultationStepDiagnosis,
    ConsultationStep.targets => consultationStepTargets,
    ConsultationStep.publication => consultationStepPublication,
  };

  String guideline(PlanGuidelineItem item) => switch (item) {
    CatalogGuideline(:final code) => switch (code) {
      PlanGuidelineCode.prioritizeVegetables => guidelinePrioritizeVegetables,
      PlanGuidelineCode.drink2lWater => guidelineDrink2lWater,
      PlanGuidelineCode.avoidSugaryDrinks => guidelineAvoidSugaryDrinks,
      PlanGuidelineCode.proteinAtBreakfast => guidelineProteinAtBreakfast,
      PlanGuidelineCode.reduceSalt => guidelineReduceSalt,
      PlanGuidelineCode.eatEvery3To4Hours => guidelineEatEvery3To4Hours,
      PlanGuidelineCode.proteinAndVegetablesAtDinner => guidelineProteinAndVegetablesAtDinner,
    },
    CustomGuideline(:final text) => text,
  };

  String restriction(PlanRestrictionItem item) => switch (item) {
    CatalogRestriction(:final code) => switch (code) {
      PlanRestrictionCode.lactoseFree => restrictionLactoseFree,
      PlanRestrictionCode.glutenFree => restrictionGlutenFree,
      PlanRestrictionCode.vegan => restrictionVegan,
      PlanRestrictionCode.vegetarian => restrictionVegetarian,
      PlanRestrictionCode.treeNutFree => restrictionTreeNutFree,
      PlanRestrictionCode.shellfishFree => restrictionShellfishFree,
      PlanRestrictionCode.kosher => restrictionKosher,
      PlanRestrictionCode.halal => restrictionHalal,
    },
    LegacyRestriction(:final text) => text,
  };

  /// "Woman · 31 years · 168 cm".
  String baselineHeadline(BaselineSummary baseline) => [
    if (baseline.sex != null) sexSummary(baseline.sex!),
    baselineAgeYears(baseline.ageYears),
    unitCmValue(compactText(baseline.heightCm, locale)),
  ].join(textSeparator);

  /// "hypothyroidism, gout" (lowercase, inside a sentence) or `null` without medical history.
  String? conditionsInline(Set<MedicalCondition> conditions) {
    if (conditions.isEmpty) return null;
    return [
      for (final item in MedicalCondition.values)
        if (conditions.contains(item)) condition(item).toLowerCase(),
    ].join(', ');
  }
}

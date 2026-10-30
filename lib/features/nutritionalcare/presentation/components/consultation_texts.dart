import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/valueobject/clinical_codes.dart';
import 'clinical_texts.dart';

/// Guided consultation codes -> ARB texts in the reader's language.
extension ConsultationTexts on AppLocalizations {
  String activity(ActivityLevel level) => switch (level) {
    ActivityLevel.sedentary => activitySedentary,
    ActivityLevel.light => activityLight,
    ActivityLevel.moderate => activityModerate,
    ActivityLevel.intense => activityIntense,
  };

  /// "moderate activity" inside a sentence.
  String activityInline(ActivityLevel level) => switch (level) {
    ActivityLevel.sedentary => activityInlineSedentary,
    ActivityLevel.light => activityInlineLight,
    ActivityLevel.moderate => activityInlineModerate,
    ActivityLevel.intense => activityInlineIntense,
  };

  String protocolCheck(ProtocolCheck check) => switch (check) {
    ProtocolCheck.fasting => protocolFasting,
    ProtocolCheck.noShoes => protocolNoShoes,
    ProtocolCheck.lightClothing => protocolLightClothing,
    ProtocolCheck.emptyBladder => protocolEmptyBladder,
    ProtocolCheck.sameScale => protocolSameScale,
  };

  String diagnosis(DiagnosisCode code) => switch (code) {
    DiagnosisCode.underweight => diagnosisUnderweight,
    DiagnosisCode.normalWeight => diagnosisNormalWeight,
    DiagnosisCode.overweightGradeI => diagnosisOverweightGradeI,
    DiagnosisCode.obesityGradeI => diagnosisObesityGradeI,
    DiagnosisCode.obesityGradeII => diagnosisObesityGradeIi,
    DiagnosisCode.obesityGradeIII => diagnosisObesityGradeIii,
  };

  String equation(EnergyEquation equation) => switch (equation) {
    EnergyEquation.mifflinStJeor => equationMifflinStJeor,
    EnergyEquation.harrisBenedict => equationHarrisBenedict,
    EnergyEquation.faoWhoUnu => equationFaoWhoUnu,
    EnergyEquation.katchMcArdle => equationKatchMcardle,
  };

  String deficitKindLabel(DeficitKind kind) => switch (kind) {
    DeficitKind.fixedKcal => targetsDeficitKindKcal,
    DeficitKind.percentOfTdee => targetsDeficitKindPercent,
  };

  String guidelineCodeLabel(PlanGuidelineCode code) => switch (code) {
    PlanGuidelineCode.prioritizeVegetables => guidelinePrioritizeVegetables,
    PlanGuidelineCode.drink2lWater => guidelineDrink2lWater,
    PlanGuidelineCode.avoidSugaryDrinks => guidelineAvoidSugaryDrinks,
    PlanGuidelineCode.proteinAtBreakfast => guidelineProteinAtBreakfast,
    PlanGuidelineCode.reduceSalt => guidelineReduceSalt,
    PlanGuidelineCode.eatEvery3To4Hours => guidelineEatEvery3To4Hours,
    PlanGuidelineCode.proteinAndVegetablesAtDinner => guidelineProteinAndVegetablesAtDinner,
  };

  String restrictionCodeLabel(PlanRestrictionCode code) => switch (code) {
    PlanRestrictionCode.lactoseFree => restrictionLactoseFree,
    PlanRestrictionCode.glutenFree => restrictionGlutenFree,
    PlanRestrictionCode.vegan => restrictionVegan,
    PlanRestrictionCode.vegetarian => restrictionVegetarian,
    PlanRestrictionCode.treeNutFree => restrictionTreeNutFree,
    PlanRestrictionCode.shellfishFree => restrictionShellfishFree,
    PlanRestrictionCode.kosher => restrictionKosher,
    PlanRestrictionCode.halal => restrictionHalal,
  };

  /// Deficit "of 500 kcal" or "of 20 %".
  String deficitText(DeficitKind? kind, double value) => kind == DeficitKind.percentOfTdee
      ? targetsDeficitPercent(compactText(value, locale))
      : targetsDeficitKcal(compactText(value, locale, maxDecimals: 0));

  /// "Mifflin-St Jeor · 500 kcal deficit · activity factor 1.55".
  String methodText(CalculationBasis basis) => [
    if (basis.equation != null) equation(basis.equation!),
    deficitText(basis.deficitKind, basis.deficitValue),
    targetsActivityFactor(compactText(basis.activityFactor, locale, maxDecimals: 3)),
  ].join(textSeparator);

  /// "Woman · 31 years · 168 cm · 74.2 kg · moderate activity".
  String inputsText(TargetInputs inputs) => [
    if (inputs.sex != null) sexSummary(inputs.sex!),
    baselineAgeYears(inputs.ageYears),
    unitCmValue(compactText(inputs.heightCm, locale)),
    unitKgValue(compactText(inputs.weightKg, locale, maxDecimals: 2)),
    if (inputs.activityLevel != null) activityInline(inputs.activityLevel!),
  ].join(textSeparator);

  /// The bullets of "Before the consultation, Ana shared": how they feel, what was hard and their questions (the
  /// patient's text, as is). An unknown code is left out.
  List<String> checkInLines(PatientCheckIn checkIn) {
    final feeling = switch (checkIn.feeling.toLowerCase()) {
      'good' => checkInReportFeelingGood,
      'fair' => checkInReportFeelingFair,
      'hard' => checkInReportFeelingHard,
      _ => null,
    };
    final difficulties = [
      for (final code in checkIn.difficulties)
        switch (code.toLowerCase()) {
          'dinners' => checkInDifficultyDinners.toLowerCase(),
          'weekends' => checkInDifficultyWeekends.toLowerCase(),
          'eatingout' => checkInDifficultyEatingOut.toLowerCase(),
          'schedules' => checkInDifficultySchedules.toLowerCase(),
          'cravings' => checkInDifficultyCravings.toLowerCase(),
          _ => null,
        },
    ].nonNulls.toList();
    return [
      ?feeling,
      if (difficulties.isNotEmpty) checkInReportDifficulties(difficulties.join(', ')),
      for (final question in checkIn.questions) checkInReportQuestion(question),
    ];
  }
}

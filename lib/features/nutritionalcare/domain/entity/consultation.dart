import '../valueobject/clinical_codes.dart';
import '../valueobject/clinical_values.dart';
import 'plan_history.dart';

/// `ConsultationResource`: the in-progress guided consultation with what each step already saved, used to
/// **rehydrate** the steps on resume ("Continue consultation"). Practitioner only.
final class Consultation {
  const Consultation({
    required this.id,
    required this.patientId,
    required this.isInProgress,
    required this.currentStep,
    required this.lastSavedAt,
    this.measurement,
    this.diagnosis,
    this.targets,
    this.publicationDraft,
    this.patientCheckIn,
    this.publishedPlanVersion,
  });

  final ConsultationId id;
  final PatientId patientId;
  final bool isInProgress;
  final ConsultationStep currentStep;
  final DateTime lastSavedAt;
  final ConsultationMeasurement? measurement;
  final ConsultationDiagnosis? diagnosis;
  final ConsultationTargets? targets;
  final PublicationDraft? publicationDraft;
  final PatientCheckIn? patientCheckIn;
  final int? publishedPlanVersion;
}

/// Saved step 1. Height, age and sex come from the baseline.
final class ConsultationMeasurement {
  const ConsultationMeasurement({
    required this.weightKg,
    required this.heightCm,
    required this.bmi,
    required this.protocolChecks,
    required this.ageYears,
    this.waistCm,
    this.bodyFatPercentage,
    this.activityLevel,
    this.habits,
    this.biochemistry,
    this.sex,
  });

  final double weightKg;
  final double heightCm;
  final double? waistCm;
  final double? bodyFatPercentage;
  final double bmi;
  final Set<ProtocolCheck> protocolChecks;
  final ActivityLevel? activityLevel;
  final EatingHabits? habits;
  final BiochemistryPanel? biochemistry;
  final int ageYears;
  final BiologicalSex? sex;
}

/// Optional eating habits: at least one value if sent.
final class EatingHabits {
  /// Throws [ArgumentError] if every value is `null`.
  EatingHabits({this.mealsPerDay, this.waterLitersPerDay, this.mealsOutPerWeek}) {
    if (mealsPerDay == null && waterLitersPerDay == null && mealsOutPerWeek == null) {
      throw ArgumentError('Eating habits need at least one value');
    }
  }

  final int? mealsPerDay;
  final double? waterLitersPerDay;
  final int? mealsOutPerWeek;

  @override
  bool operator ==(Object other) =>
      other is EatingHabits &&
      other.mealsPerDay == mealsPerDay &&
      other.waterLitersPerDay == waterLitersPerDay &&
      other.mealsOutPerWeek == mealsOutPerWeek;

  @override
  int get hashCode => Object.hash(mealsPerDay, waterLitersPerDay, mealsOutPerWeek);
}

/// Optional biochemistry data: at least one value if sent.
final class BiochemistryPanel {
  /// Throws [ArgumentError] if every value is `null`.
  BiochemistryPanel({this.glucoseMgDl, this.totalCholesterolMgDl, this.triglyceridesMgDl}) {
    if (glucoseMgDl == null && totalCholesterolMgDl == null && triglyceridesMgDl == null) {
      throw ArgumentError('A biochemistry panel needs at least one value');
    }
  }

  final double? glucoseMgDl;
  final double? totalCholesterolMgDl;
  final double? triglyceridesMgDl;

  @override
  bool operator ==(Object other) =>
      other is BiochemistryPanel &&
      other.glucoseMgDl == glucoseMgDl &&
      other.totalCholesterolMgDl == totalCholesterolMgDl &&
      other.triglyceridesMgDl == triglyceridesMgDl;

  @override
  int get hashCode => Object.hash(glucoseMgDl, totalCholesterolMgDl, triglyceridesMgDl);
}

/// Saved step 2. `isPending`: issued in this consultation, it becomes the active diagnosis on publish; while the
/// consultation is still in progress this is normal and the step counts as done. If the measurement changes, the
/// backend discards it and the consultation comes back without a diagnosis.
final class ConsultationDiagnosis {
  const ConsultationDiagnosis({required this.rationale, required this.isPending, this.code, this.source});

  final DiagnosisCode? code;
  final DiagnosisSource? source;
  final String rationale;
  final bool isPending;
}

/// How the targets were calculated. Practitioner-only information: it **never** reaches the patient (ethics rule 1).
final class CalculationBasis {
  const CalculationBasis({
    required this.referenceWeightKg,
    required this.activityFactor,
    required this.deficitValue,
    this.equation,
    this.deficitKind,
  });

  final EnergyEquation? equation;
  final double referenceWeightKg;
  final double activityFactor;
  final DeficitKind? deficitKind;
  final double deficitValue;
}

/// Saved step 3: the draft of version N+1.
final class ConsultationTargets {
  const ConsultationTargets({
    required this.basis,
    required this.proposal,
    required this.isOverridden,
    this.prescribed,
    this.overrideReason,
  });

  final CalculationBasis basis;
  final Targets proposal;
  final Targets? prescribed;
  final bool isOverridden;
  final String? overrideReason;
}

/// Step 4 draft (`publication-draft`): the choices on the publication step, so "what you wrote is not lost".
final class PublicationDraft {
  const PublicationDraft({
    required this.restrictions,
    required this.guidelines,
    required this.customGuidelines,
    this.patientMessage,
  });

  final Set<PlanRestrictionCode> restrictions;
  final Set<PlanGuidelineCode> guidelines;
  final List<String> customGuidelines;
  final String? patientMessage;
}

/// What the patient shared before the consultation (the "Before the consultation, Ana shared" card). Codes as they
/// arrive (`Good`/`Fair`/`Hard`, `Dinners`...); the questions are the patient's own text and are shown as is.
final class PatientCheckIn {
  const PatientCheckIn({
    required this.feeling,
    required this.difficulties,
    required this.questions,
    required this.submittedAt,
  });

  final String feeling;
  final List<String> difficulties;
  final List<String> questions;
  final DateTime submittedAt;
}

/// The "AI suggestion" on the diagnosis step, or the BMI category (`source = Rule`) when AI is unavailable.
final class DiagnosisSuggestion {
  const DiagnosisSuggestion({
    required this.code,
    required this.rationale,
    required this.isFromAi,
    required this.disclaimer,
    this.aiGenerationId,
  });

  final int? aiGenerationId;
  final DiagnosisCode code;
  final String rationale;
  final bool isFromAi;
  final String disclaimer;
}

/// `ConsultationTargetProposalResource`: the proposal and what it was calculated with ("Calculated with...").
final class TargetProposal {
  const TargetProposal({required this.basis, required this.proposal, required this.inputs});

  final CalculationBasis basis;
  final Targets proposal;
  final TargetInputs inputs;
}

/// "Woman · 31 years · 168 cm · 74.2 kg · moderate activity".
final class TargetInputs {
  const TargetInputs({
    required this.ageYears,
    required this.heightCm,
    required this.weightKg,
    this.sex,
    this.activityLevel,
  });

  final BiologicalSex? sex;
  final int ageYears;
  final double heightCm;
  final double weightKg;
  final ActivityLevel? activityLevel;
}

/// Guidelines suggested from the diagnosis (or the fixed table, `Rule`).
final class GuidelineSuggestions {
  const GuidelineSuggestions({required this.codes, required this.isFromAi});

  final List<PlanGuidelineCode> codes;
  final bool isFromAi;
}

/// Set equality for the commands below that compare against what a step already saved.
bool sameSet<T>(Set<T> a, Set<T> b) => a.length == b.length && a.containsAll(b);

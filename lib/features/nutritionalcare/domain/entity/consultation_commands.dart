import '../valueobject/clinical_codes.dart';
import '../valueobject/clinical_values.dart';
import 'consultation.dart';
import 'plan_history.dart';

/// Step 1 · `PUT /consultations/{id}/measurement`. At least one protocol checkbox and the activity.
final class NewMeasurement {
  /// Throws [ArgumentError] if a value is outside the backend range or no protocol check is ticked.
  NewMeasurement({
    required this.weightKg,
    required this.protocolChecks,
    required this.activityLevel,
    this.waistCm,
    this.bodyFatPercentage,
    this.habits,
    this.biochemistry,
  }) {
    if (!ClinicalRange.weightKg.contains(weightKg)) throw ArgumentError.value(weightKg, 'weightKg', 'Implausible weight');
    final waist = waistCm;
    if (waist != null && !ClinicalRange.waistCm.contains(waist)) throw ArgumentError.value(waist, 'waistCm', 'Implausible waist');
    final bodyFat = bodyFatPercentage;
    if (bodyFat != null && !ClinicalRange.bodyFatPercent.contains(bodyFat)) {
      throw ArgumentError.value(bodyFat, 'bodyFatPercentage', 'Implausible body fat');
    }
    if (protocolChecks.isEmpty) throw ArgumentError('At least one protocol check must be ticked');
  }

  final double weightKg;
  final double? waistCm;
  final double? bodyFatPercentage;
  final Set<ProtocolCheck> protocolChecks;
  final ActivityLevel activityLevel;
  final EatingHabits? habits;
  final BiochemistryPanel? biochemistry;

  /// `true` if it matches what step 1 already saved: not resent (repeating it forces redoing step 2).
  bool sameAs(ConsultationMeasurement saved) =>
      weightKg == saved.weightKg &&
      waistCm == saved.waistCm &&
      bodyFatPercentage == saved.bodyFatPercentage &&
      sameSet(protocolChecks, saved.protocolChecks) &&
      activityLevel == saved.activityLevel &&
      habits == saved.habits &&
      biochemistry == saved.biochemistry;
}

/// Measurement step fields the phone validates.
enum MeasurementField {
  weight,
  waist,
  bodyFat,
  protocol,
  activity,
  mealsPerDay,
  water,
  mealsOut,
  glucose,
  cholesterol,
  triglycerides,
}

/// Why a measurement field is invalid: empty while required, or outside the backend range.
enum FieldProblem { required, outOfRange }

/// The text of each measurement field exactly as the practitioner typed it.
final class MeasurementForm {
  const MeasurementForm({
    this.weight = '',
    this.waist = '',
    this.bodyFat = '',
    this.protocolChecks = const {},
    this.activityLevel,
    this.mealsPerDay = '',
    this.waterLiters = '',
    this.mealsOut = '',
    this.glucose = '',
    this.cholesterol = '',
    this.triglycerides = '',
  });

  final String weight;
  final String waist;
  final String bodyFat;
  final Set<ProtocolCheck> protocolChecks;
  final ActivityLevel? activityLevel;
  final String mealsPerDay;
  final String waterLiters;
  final String mealsOut;
  final String glucose;
  final String cholesterol;
  final String triglycerides;

  MeasurementForm copyWith({
    String? weight,
    String? waist,
    String? bodyFat,
    Set<ProtocolCheck>? protocolChecks,
    ActivityLevel? activityLevel,
    String? mealsPerDay,
    String? waterLiters,
    String? mealsOut,
    String? glucose,
    String? cholesterol,
    String? triglycerides,
  }) => MeasurementForm(
    weight: weight ?? this.weight,
    waist: waist ?? this.waist,
    bodyFat: bodyFat ?? this.bodyFat,
    protocolChecks: protocolChecks ?? this.protocolChecks,
    activityLevel: activityLevel ?? this.activityLevel,
    mealsPerDay: mealsPerDay ?? this.mealsPerDay,
    waterLiters: waterLiters ?? this.waterLiters,
    mealsOut: mealsOut ?? this.mealsOut,
    glucose: glucose ?? this.glucose,
    cholesterol: cholesterol ?? this.cholesterol,
    triglycerides: triglycerides ?? this.triglycerides,
  );

  /// Checks the backend ranges (`ImplausibleMeasurement`, `ProtocolChecklistEmpty`, `InvalidEatingHabits`...).
  MeasurementValidation validate() {
    final problems = <MeasurementField, FieldProblem>{};

    double? read(ClinicalRange range, String text, MeasurementField field, {bool required = false}) {
      switch (range.parse(text)) {
        case ValidNumber(:final value):
          return value;
        case EmptyNumber():
          if (required) problems[field] = FieldProblem.required;
          return null;
        case OutOfRangeNumber():
          problems[field] = FieldProblem.outOfRange;
          return null;
      }
    }

    final weightValue = read(ClinicalRange.weightKg, weight, MeasurementField.weight, required: true);
    final waistValue = read(ClinicalRange.waistCm, waist, MeasurementField.waist);
    final bodyFatValue = read(ClinicalRange.bodyFatPercent, bodyFat, MeasurementField.bodyFat);
    final meals = read(ClinicalRange.mealsPerDay, mealsPerDay, MeasurementField.mealsPerDay);
    final water = read(ClinicalRange.waterLitersPerDay, waterLiters, MeasurementField.water);
    final out = read(ClinicalRange.mealsOutPerWeek, mealsOut, MeasurementField.mealsOut);
    final glucoseValue = read(ClinicalRange.glucoseMgDl, glucose, MeasurementField.glucose);
    final cholesterolValue = read(ClinicalRange.totalCholesterolMgDl, cholesterol, MeasurementField.cholesterol);
    final triglyceridesValue = read(ClinicalRange.triglyceridesMgDl, triglycerides, MeasurementField.triglycerides);
    if (protocolChecks.isEmpty) problems[MeasurementField.protocol] = FieldProblem.required;
    final activity = activityLevel;
    if (activity == null) problems[MeasurementField.activity] = FieldProblem.required;

    if (problems.isNotEmpty || weightValue == null || activity == null) return InvalidMeasurement(problems);
    final habits = meals != null || water != null || out != null
        ? EatingHabits(mealsPerDay: meals?.toInt(), waterLitersPerDay: water, mealsOutPerWeek: out?.toInt())
        : null;
    final biochemistry = glucoseValue != null || cholesterolValue != null || triglyceridesValue != null
        ? BiochemistryPanel(
            glucoseMgDl: glucoseValue,
            totalCholesterolMgDl: cholesterolValue,
            triglyceridesMgDl: triglyceridesValue,
          )
        : null;
    return ValidMeasurement(
      NewMeasurement(
        weightKg: weightValue,
        waistCm: waistValue,
        bodyFatPercentage: bodyFatValue,
        protocolChecks: protocolChecks,
        activityLevel: activity,
        habits: habits,
        biochemistry: biochemistry,
      ),
    );
  }
}

sealed class MeasurementValidation {
  const MeasurementValidation();
}

final class ValidMeasurement extends MeasurementValidation {
  const ValidMeasurement(this.measurement);

  final NewMeasurement measurement;
}

final class InvalidMeasurement extends MeasurementValidation {
  const InvalidMeasurement(this.problems);

  final Map<MeasurementField, FieldProblem> problems;
}

/// Step 2 · `PUT /consultations/{id}/diagnosis`.
sealed class DiagnosisChoice {
  const DiagnosisChoice(this.code);

  final DiagnosisCode code;

  /// The source the backend stores it with.
  DiagnosisSource get source;

  /// Accepting the suggestion: only a real AI generation counts as "accepted"; a rule one is a choice.
  static DiagnosisChoice accepting(DiagnosisSuggestion suggestion) {
    final generation = suggestion.aiGenerationId;
    return suggestion.isFromAi && generation != null
        ? AcceptAiSuggestion(suggestion.code, generation, suggestion.rationale)
        : SelectedDiagnosis(suggestion.code, suggestion.rationale);
  }
}

/// "Use suggestion" from AI: the generation and its rationale are stored (AI traceability).
final class AcceptAiSuggestion extends DiagnosisChoice {
  const AcceptAiSuggestion(super.code, this.aiGenerationId, this.rationale);

  final int aiGenerationId;
  final String rationale;

  @override
  DiagnosisSource get source => DiagnosisSource.aiSuggestionAccepted;
}

/// "Choose another", or the rule suggestion: the backend builds the rationale from the measurement if missing.
final class SelectedDiagnosis extends DiagnosisChoice {
  const SelectedDiagnosis(super.code, [this.rationale]);

  final String? rationale;

  @override
  DiagnosisSource get source => DiagnosisSource.practitionerSelected;
}

/// "Change parameters" on the targets step. The backend sets the reference weight and activity factor.
final class TargetParameters {
  /// Ranges the phone accepts before requesting the calculation; the backend revalidates everything together.
  static const proteinMin = 0.5;
  static const proteinMax = 3.0;
  static const fatMin = 15.0;
  static const fatMax = 45.0;

  /// Throws [ArgumentError] if a value is outside its range.
  TargetParameters({
    required this.equation,
    required this.deficitKind,
    required this.deficitValue,
    required this.proteinGramsPerKg,
    required this.fatPercentOfEnergy,
  }) {
    if (deficitValue < 0 || deficitValue > deficitKind.maximum) {
      throw ArgumentError.value(deficitValue, 'deficitValue', 'Deficit out of range');
    }
    if (proteinGramsPerKg < proteinMin || proteinGramsPerKg > proteinMax) {
      throw ArgumentError.value(proteinGramsPerKg, 'proteinGramsPerKg', 'Protein per kg out of range');
    }
    if (fatPercentOfEnergy < fatMin || fatPercentOfEnergy > fatMax) {
      throw ArgumentError.value(fatPercentOfEnergy, 'fatPercentOfEnergy', 'Fat percent out of range');
    }
  }

  final EnergyEquation equation;
  final DeficitKind deficitKind;
  final double deficitValue;
  final double proteinGramsPerKg;
  final double fatPercentOfEnergy;
}

/// Step 3 · `PUT /consultations/{id}/targets`.
sealed class TargetPrescription {
  const TargetPrescription();
}

/// "Accept targets".
final class AcceptedAsProposed extends TargetPrescription {
  const AcceptedAsProposed();
}

/// "Enter my own values": the reason is required (`OverrideReasonRequired`).
final class OverriddenTargets extends TargetPrescription {
  const OverriddenTargets(this.targets, this.reason);

  final Targets targets;
  final OverrideReason reason;
}

/// Own values: what is missing before they can be saved.
enum OverrideField { energy, protein, carb, fat, reason }

sealed class OverrideValidation {
  const OverrideValidation();
}

final class ValidOverride extends OverrideValidation {
  const ValidOverride(this.prescription);

  final OverriddenTargets prescription;
}

final class InvalidOverride extends OverrideValidation {
  const InvalidOverride(this.problems);

  final Set<OverrideField> problems;
}

const _maxOverrideValue = 10000.0;

/// Validates "Enter my own values": energy > 0, macros >= 0 and a required reason (1-500 characters).
OverrideValidation validateOverride({
  required String energy,
  required String protein,
  required String carb,
  required String fat,
  required String reason,
}) {
  final problems = <OverrideField>{};

  double? read(String text, OverrideField field, {required bool positive}) {
    final value = DecimalText.parse(text);
    final ok = value != null && (positive ? value > 0 : value >= 0) && value <= _maxOverrideValue;
    if (!ok) problems.add(field);
    return ok ? value : null;
  }

  final energyValue = read(energy, OverrideField.energy, positive: true);
  final proteinValue = read(protein, OverrideField.protein, positive: false);
  final carbValue = read(carb, OverrideField.carb, positive: false);
  final fatValue = read(fat, OverrideField.fat, positive: false);
  if (reason.trim().isEmpty || reason.trim().length > OverrideReason.maxLength) problems.add(OverrideField.reason);
  if (problems.isNotEmpty || energyValue == null || proteinValue == null || carbValue == null || fatValue == null) {
    return InvalidOverride(problems);
  }
  return ValidOverride(
    OverriddenTargets(
      Targets(energyKcal: energyValue, proteinG: proteinValue, carbG: carbValue, fatG: fatValue),
      OverrideReason(reason.trim()),
    ),
  );
}

/// Step 4 · what gets published and the draft (`publication-draft`). Up to 5 custom guidelines of 3-140 characters
/// each; the message is optional (<= 500).
final class Publication {
  /// Throws [ArgumentError] with more than 5 custom guidelines.
  Publication({
    required this.restrictions,
    required this.guidelines,
    required this.customGuidelines,
    this.patientMessage,
  }) {
    if (customGuidelines.length > CustomGuidelineText.maxPerVersion) {
      throw ArgumentError.value(customGuidelines.length, 'customGuidelines', 'At most 5 custom guidelines');
    }
  }

  final Set<PlanRestrictionCode> restrictions;
  final Set<PlanGuidelineCode> guidelines;
  final List<CustomGuidelineText> customGuidelines;
  final PatientMessage? patientMessage;

  @override
  bool operator ==(Object other) =>
      other is Publication &&
      sameSet(restrictions, other.restrictions) &&
      sameSet(guidelines, other.guidelines) &&
      _sameList(customGuidelines, other.customGuidelines) &&
      patientMessage == other.patientMessage;

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(restrictions),
    Object.hashAllUnordered(guidelines),
    Object.hashAll(customGuidelines),
    patientMessage,
  );

  static bool _sameList<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

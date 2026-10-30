import 'package:json_annotation/json_annotation.dart';

import 'practitioner_patient_dtos.dart';

part 'consultation_dtos.g.dart';

// Guided consultation resources (`Healthify.Platform/NutritionalCare/Interfaces/REST/Resources`). Requests omit what
// is null (same as Android's `explicitNulls = false`), so an empty request is `{}`.

/// `StartConsultationResource`. No appointment = `{}`.
@JsonSerializable(createFactory: false, includeIfNull: false)
class StartConsultationRequestDto {
  const StartConsultationRequestDto({this.scheduledFollowUpId});

  final int? scheduledFollowUpId;

  Map<String, dynamic> toJson() => _$StartConsultationRequestDtoToJson(this);
}

@JsonSerializable(includeIfNull: false)
class EatingHabitsDto {
  const EatingHabitsDto({this.mealsPerDay, this.waterLitersPerDay, this.mealsOutPerWeek});

  factory EatingHabitsDto.fromJson(Map<String, dynamic> json) => _$EatingHabitsDtoFromJson(json);

  final int? mealsPerDay;
  final double? waterLitersPerDay;
  final int? mealsOutPerWeek;

  Map<String, dynamic> toJson() => _$EatingHabitsDtoToJson(this);
}

@JsonSerializable(includeIfNull: false)
class BiochemistryPanelDto {
  const BiochemistryPanelDto({this.fastingGlucoseMgDl, this.totalCholesterolMgDl, this.triglyceridesMgDl});

  factory BiochemistryPanelDto.fromJson(Map<String, dynamic> json) => _$BiochemistryPanelDtoFromJson(json);

  final double? fastingGlucoseMgDl;
  final double? totalCholesterolMgDl;
  final double? triglyceridesMgDl;

  Map<String, dynamic> toJson() => _$BiochemistryPanelDtoToJson(this);
}

/// `RecordConsultationMeasurementResource`.
@JsonSerializable(createFactory: false, includeIfNull: false, explicitToJson: true)
class MeasurementRequestDto {
  const MeasurementRequestDto({
    required this.weightKg,
    required this.protocolChecks,
    required this.activityLevel,
    this.waistCm,
    this.bodyFatPercentage,
    this.habits,
    this.biochemistry,
  });

  final double weightKg;
  final double? waistCm;
  final double? bodyFatPercentage;
  final List<String> protocolChecks;
  final String activityLevel;
  final EatingHabitsDto? habits;
  final BiochemistryPanelDto? biochemistry;

  Map<String, dynamic> toJson() => _$MeasurementRequestDtoToJson(this);
}

/// `IssueConsultationDiagnosisResource`.
@JsonSerializable(createFactory: false, includeIfNull: false)
class DiagnosisRequestDto {
  const DiagnosisRequestDto({required this.code, required this.source, this.aiGenerationId, this.rationale});

  final String code;
  final String source;
  final int? aiGenerationId;
  final String? rationale;

  Map<String, dynamic> toJson() => _$DiagnosisRequestDtoToJson(this);
}

/// `ConsultationTargetParametersResource`: whatever is not sent the backend fills with its defaults.
@JsonSerializable(createFactory: false)
class TargetParametersDto {
  const TargetParametersDto({
    required this.equation,
    required this.deficitKind,
    required this.deficitValue,
    required this.proteinGramsPerKg,
    required this.fatPercentOfEnergy,
  });

  final String equation;
  final String deficitKind;
  final double deficitValue;
  final double proteinGramsPerKg;
  final double fatPercentOfEnergy;

  Map<String, dynamic> toJson() => _$TargetParametersDtoToJson(this);
}

/// `ProposeConsultationTargetsResource`: `{}` uses the default parameters.
@JsonSerializable(createFactory: false, includeIfNull: false, explicitToJson: true)
class TargetProposalRequestDto {
  const TargetProposalRequestDto({this.parameters});

  final TargetParametersDto? parameters;

  Map<String, dynamic> toJson() => _$TargetProposalRequestDtoToJson(this);
}

/// `PrescribeConsultationTargetsResource`.
@JsonSerializable(createFactory: false, includeIfNull: false)
class PrescribeTargetsRequestDto {
  const PrescribeTargetsRequestDto({
    required this.outcome,
    this.energyKcal,
    this.proteinG,
    this.carbG,
    this.fatG,
    this.overrideReason,
  });

  final String outcome;
  final double? energyKcal;
  final double? proteinG;
  final double? carbG;
  final double? fatG;
  final String? overrideReason;

  Map<String, dynamic> toJson() => _$PrescribeTargetsRequestDtoToJson(this);
}

/// `ConsultationPublicationResource` (draft and publication).
@JsonSerializable(createFactory: false, includeIfNull: false)
class PublicationRequestDto {
  const PublicationRequestDto({
    required this.restrictions,
    required this.guidelines,
    required this.customGuidelines,
    this.patientMessage,
  });

  final List<String> restrictions;
  final List<String> guidelines;
  final List<String> customGuidelines;
  final String? patientMessage;

  Map<String, dynamic> toJson() => _$PublicationRequestDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class CalculationBasisDto {
  const CalculationBasisDto({
    this.equation,
    this.referenceWeightKind,
    this.referenceWeightKg = 0,
    this.activityFactor = 0,
    this.deficitKind,
    this.deficitValue = 0,
  });

  factory CalculationBasisDto.fromJson(Map<String, dynamic> json) => _$CalculationBasisDtoFromJson(json);

  final String? equation;
  final String? referenceWeightKind;
  final double referenceWeightKg;
  final double activityFactor;
  final String? deficitKind;
  final double deficitValue;
}

@JsonSerializable(createToJson: false)
class ConsultationMeasurementDto {
  const ConsultationMeasurementDto({
    required this.weightKg,
    required this.heightCm,
    required this.bmi,
    this.waistCm,
    this.bodyFatPercentage,
    this.protocolChecks = const [],
    this.activityLevel,
    this.habits,
    this.biochemistry,
    this.ageYears = 0,
    this.biologicalSex,
  });

  factory ConsultationMeasurementDto.fromJson(Map<String, dynamic> json) => _$ConsultationMeasurementDtoFromJson(json);

  final double weightKg;
  final double heightCm;
  final double? waistCm;
  final double? bodyFatPercentage;
  final double bmi;
  final List<String> protocolChecks;
  final String? activityLevel;
  final EatingHabitsDto? habits;
  final BiochemistryPanelDto? biochemistry;
  final int ageYears;
  final String? biologicalSex;
}

@JsonSerializable(createToJson: false)
class ConsultationDiagnosisDto {
  const ConsultationDiagnosisDto({this.code, this.source, this.rationale = '', this.isPending = false});

  factory ConsultationDiagnosisDto.fromJson(Map<String, dynamic> json) => _$ConsultationDiagnosisDtoFromJson(json);

  final String? code;
  final String? source;
  final String rationale;
  final bool isPending;
}

@JsonSerializable(createToJson: false)
class ConsultationTargetsDto {
  const ConsultationTargetsDto({
    required this.calculationBasis,
    required this.proposal,
    this.prescribed,
    this.prescriptionOutcome,
    this.overrideReason,
  });

  factory ConsultationTargetsDto.fromJson(Map<String, dynamic> json) => _$ConsultationTargetsDtoFromJson(json);

  final CalculationBasisDto calculationBasis;
  final TargetsDto proposal;
  final TargetsDto? prescribed;
  final String? prescriptionOutcome;
  final String? overrideReason;
}

@JsonSerializable(createToJson: false)
class PublicationDraftDto {
  const PublicationDraftDto({
    this.restrictions = const [],
    this.guidelines = const [],
    this.customGuidelines = const [],
    this.patientMessage,
  });

  factory PublicationDraftDto.fromJson(Map<String, dynamic> json) => _$PublicationDraftDtoFromJson(json);

  final List<String> restrictions;
  final List<String> guidelines;
  final List<String> customGuidelines;
  final String? patientMessage;
}

@JsonSerializable(createToJson: false)
class CheckInQuestionDto {
  const CheckInQuestionDto({required this.text, this.origin});

  factory CheckInQuestionDto.fromJson(Map<String, dynamic> json) => _$CheckInQuestionDtoFromJson(json);

  final String text;
  final String? origin;
}

/// `ConsultationPatientCheckInResource`: what the patient shared before the consultation.
@JsonSerializable(createToJson: false)
class ConsultationCheckInDto {
  const ConsultationCheckInDto({
    required this.feeling,
    required this.submittedAt,
    this.difficulties = const [],
    this.questions = const [],
  });

  factory ConsultationCheckInDto.fromJson(Map<String, dynamic> json) => _$ConsultationCheckInDtoFromJson(json);

  final String feeling;
  final List<String> difficulties;
  final List<CheckInQuestionDto> questions;
  final String submittedAt;
}

/// `ConsultationResource`.
@JsonSerializable(createToJson: false)
class ConsultationDto {
  const ConsultationDto({
    required this.consultationId,
    required this.patientId,
    required this.state,
    required this.currentStep,
    required this.lastSavedAt,
    this.stepNumber = 1,
    this.measurement,
    this.diagnosis,
    this.targets,
    this.publicationDraft,
    this.patientCheckIn,
    this.publishedPlanVersion,
  });

  factory ConsultationDto.fromJson(Map<String, dynamic> json) => _$ConsultationDtoFromJson(json);

  final int consultationId;
  final int patientId;
  final String state;
  final String currentStep;
  final int stepNumber;
  final String lastSavedAt;
  final ConsultationMeasurementDto? measurement;
  final ConsultationDiagnosisDto? diagnosis;
  final ConsultationTargetsDto? targets;
  final PublicationDraftDto? publicationDraft;
  final ConsultationCheckInDto? patientCheckIn;
  final int? publishedPlanVersion;
}

/// `DiagnosisSuggestionResource`.
@JsonSerializable(createToJson: false)
class DiagnosisSuggestionDto {
  const DiagnosisSuggestionDto({
    required this.code,
    this.aiGenerationId,
    this.rationale = '',
    this.source,
    this.disclaimer = '',
  });

  factory DiagnosisSuggestionDto.fromJson(Map<String, dynamic> json) => _$DiagnosisSuggestionDtoFromJson(json);

  final int? aiGenerationId;
  final String code;
  final String rationale;
  final String? source;
  final String disclaimer;
}

/// `GuidelineSuggestionsResource`.
@JsonSerializable(createToJson: false)
class GuidelineSuggestionsDto {
  const GuidelineSuggestionsDto({this.suggested = const [], this.source});

  factory GuidelineSuggestionsDto.fromJson(Map<String, dynamic> json) => _$GuidelineSuggestionsDtoFromJson(json);

  final List<String> suggested;
  final String? source;
}

@JsonSerializable(createToJson: false)
class TargetInputsDto {
  const TargetInputsDto({this.sex, this.ageYears = 0, this.heightCm = 0, this.weightKg = 0, this.activityLevel});

  factory TargetInputsDto.fromJson(Map<String, dynamic> json) => _$TargetInputsDtoFromJson(json);

  final String? sex;
  final int ageYears;
  final double heightCm;
  final double weightKg;
  final String? activityLevel;
}

/// `ConsultationTargetProposalResource`.
@JsonSerializable(createToJson: false)
class TargetProposalDto {
  const TargetProposalDto({required this.calculationBasis, required this.proposal, required this.inputsSummary});

  factory TargetProposalDto.fromJson(Map<String, dynamic> json) => _$TargetProposalDtoFromJson(json);

  final CalculationBasisDto calculationBasis;
  final TargetsDto proposal;
  final TargetInputsDto inputsSummary;
}

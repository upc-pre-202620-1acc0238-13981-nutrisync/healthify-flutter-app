import 'package:json_annotation/json_annotation.dart';

import 'consultation_dtos.dart' show BiochemistryPanelDto, EatingHabitsDto;

part 'practitioner_patient_dtos.g.dart';

/// `PatientBaselineSummaryResource`.
@JsonSerializable(createToJson: false)
class BaselineSummaryDto {
  const BaselineSummaryDto({this.biologicalSex, this.ageYears = 0, this.heightCm = 0, this.conditions = const []});

  factory BaselineSummaryDto.fromJson(Map<String, dynamic> json) => _$BaselineSummaryDtoFromJson(json);

  final String? biologicalSex;
  final int ageYears;
  final double heightCm;
  final List<String> conditions;
}

@JsonSerializable(createToJson: false)
class SummaryFollowUpDto {
  const SummaryFollowUpDto({required this.followUpId, required this.scheduledFor});

  factory SummaryFollowUpDto.fromJson(Map<String, dynamic> json) => _$SummaryFollowUpDtoFromJson(json);

  final int followUpId;
  final String scheduledFor;
}

@JsonSerializable(createToJson: false)
class SummaryConsultationInProgressDto {
  const SummaryConsultationInProgressDto({
    required this.consultationId,
    required this.lastSavedAt,
    this.stepNumber = 1,
    this.stepName,
  });

  factory SummaryConsultationInProgressDto.fromJson(Map<String, dynamic> json) =>
      _$SummaryConsultationInProgressDtoFromJson(json);

  final int consultationId;
  final int stepNumber;
  final String? stepName;
  final String lastSavedAt;
}

@JsonSerializable(createToJson: false)
class ComplianceRatioDto {
  const ComplianceRatioDto({required this.met, required this.total});

  factory ComplianceRatioDto.fromJson(Map<String, dynamic> json) => _$ComplianceRatioDtoFromJson(json);

  final int met;
  final int total;
}

@JsonSerializable(createToJson: false)
class SinceLastConsultationDto {
  const SinceLastConsultationDto({
    required this.fromDate,
    this.weightSlopeKgPerWeek,
    this.trendWeeks = 0,
    this.compliance,
  });

  factory SinceLastConsultationDto.fromJson(Map<String, dynamic> json) => _$SinceLastConsultationDtoFromJson(json);

  final String fromDate;
  final double? weightSlopeKgPerWeek;
  final int trendWeeks;
  final ComplianceRatioDto? compliance;
}

/// `PatientSummaryResource`.
@JsonSerializable(createToJson: false)
class PatientSummaryDto {
  const PatientSummaryDto({
    required this.patientId,
    required this.sinceLastConsultation,
    this.fullName,
    this.linkedSince,
    this.linkStatus,
    this.activePlanVersion,
    this.baseline,
    this.nextFollowUp,
    this.consultationInProgress,
  });

  factory PatientSummaryDto.fromJson(Map<String, dynamic> json) => _$PatientSummaryDtoFromJson(json);

  final int patientId;
  final String? fullName;
  final String? linkedSince;
  final String? linkStatus;
  final int? activePlanVersion;
  final BaselineSummaryDto? baseline;
  final SummaryFollowUpDto? nextFollowUp;
  final SummaryConsultationInProgressDto? consultationInProgress;
  final SinceLastConsultationDto sinceLastConsultation;
}

@JsonSerializable(createToJson: false)
class TargetsDto {
  const TargetsDto({required this.energyKcal, required this.proteinG, required this.carbG, required this.fatG});

  factory TargetsDto.fromJson(Map<String, dynamic> json) => _$TargetsDtoFromJson(json);

  final double energyKcal;
  final double proteinG;
  final double carbG;
  final double fatG;
}

/// `ActiveGuidelineResource(Code, Custom)`: one of the two.
@JsonSerializable(createToJson: false)
class GuidelineItemDto {
  const GuidelineItemDto({this.code, this.custom});

  factory GuidelineItemDto.fromJson(Map<String, dynamic> json) => _$GuidelineItemDtoFromJson(json);

  final String? code;
  final String? custom;
}

/// `NutritionPlanResource`.
@JsonSerializable(createToJson: false)
class NutritionPlanDto {
  const NutritionPlanDto({
    required this.planId,
    required this.version,
    required this.proposal,
    this.prescribed,
    this.guidelines = const [],
    this.restrictions = const [],
    this.isActive = false,
    this.publishedAt,
    this.guidelineItems,
    this.legacyRestrictions,
    this.patientMessage,
  });

  factory NutritionPlanDto.fromJson(Map<String, dynamic> json) => _$NutritionPlanDtoFromJson(json);

  final int planId;
  final int version;
  final TargetsDto proposal;
  final TargetsDto? prescribed;
  final List<String> guidelines;
  final List<String> restrictions;
  final bool isActive;
  final String? publishedAt;
  final List<GuidelineItemDto>? guidelineItems;
  final List<String>? legacyRestrictions;
  final String? patientMessage;
}

@JsonSerializable(createToJson: false)
class ActiveDiagnosisDto {
  const ActiveDiagnosisDto({required this.issuedAt, this.code, this.statement = ''});

  factory ActiveDiagnosisDto.fromJson(Map<String, dynamic> json) => _$ActiveDiagnosisDtoFromJson(json);

  final String? code;
  final String statement;
  final String issuedAt;
}

@JsonSerializable(createToJson: false)
class EvaluationDto {
  const EvaluationDto({
    required this.assessmentId,
    required this.takenAt,
    required this.weightKg,
    required this.bmi,
    this.waistCm,
    this.isFirst = false,
  });

  factory EvaluationDto.fromJson(Map<String, dynamic> json) => _$EvaluationDtoFromJson(json);

  final int assessmentId;
  final String takenAt;
  final double weightKg;
  final double bmi;
  final double? waistCm;
  final bool isFirst;
}

@JsonSerializable(createToJson: false)
class ClinicalWeightSummaryDto {
  const ClinicalWeightSummaryDto({
    required this.latestKg,
    required this.latestDate,
    required this.deltaKgSinceFirst,
    required this.firstDate,
  });

  factory ClinicalWeightSummaryDto.fromJson(Map<String, dynamic> json) => _$ClinicalWeightSummaryDtoFromJson(json);

  final double latestKg;
  final String latestDate;
  final double deltaKgSinceFirst;
  final String firstDate;
}

@JsonSerializable(createToJson: false)
class BmiDto {
  const BmiDto({required this.value, this.category});

  factory BmiDto.fromJson(Map<String, dynamic> json) => _$BmiDtoFromJson(json);

  final double value;
  final String? category;
}

@JsonSerializable(createToJson: false)
class PractitionerComplianceDto {
  const PractitionerComplianceDto({required this.from, required this.to, required this.met, required this.total});

  factory PractitionerComplianceDto.fromJson(Map<String, dynamic> json) => _$PractitionerComplianceDtoFromJson(json);

  final String from;
  final String to;
  final int met;
  final int total;
}

@JsonSerializable(createToJson: false)
class InterventionDto {
  const InterventionDto({required this.planVersion, required this.validFrom, required this.energyKcal});

  factory InterventionDto.fromJson(Map<String, dynamic> json) => _$InterventionDtoFromJson(json);

  final int planVersion;
  final String validFrom;
  final double energyKcal;
}

@JsonSerializable(createToJson: false)
class ReferralSummaryDto {
  const ReferralSummaryDto({
    required this.referralId,
    required this.specialty,
    required this.issuedAt,
    this.status = 'Open',
    this.reason = '',
    this.closedAt,
  });

  factory ReferralSummaryDto.fromJson(Map<String, dynamic> json) => _$ReferralSummaryDtoFromJson(json);

  final int referralId;
  final String specialty;
  final String issuedAt;
  final String status;
  final String reason;
  final String? closedAt;
}

@JsonSerializable(createToJson: false)
class PractitionerFollowUpSectionDto {
  const PractitionerFollowUpSectionDto({this.referrals = const []});

  factory PractitionerFollowUpSectionDto.fromJson(Map<String, dynamic> json) =>
      _$PractitionerFollowUpSectionDtoFromJson(json);

  final List<ReferralSummaryDto> referrals;
}

/// `PractitionerPatientRecordResource`: `PatientRecordResource` plus the practitioner-only data.
@JsonSerializable(createToJson: false)
class PractitionerRecordDto {
  const PractitionerRecordDto({
    required this.patientId,
    this.intervention,
    this.followUp,
    this.activeDiagnosis,
    this.evaluations = const [],
    this.clinicalWeight,
    this.bmi,
    this.compliance,
  });

  factory PractitionerRecordDto.fromJson(Map<String, dynamic> json) => _$PractitionerRecordDtoFromJson(json);

  final int patientId;
  final InterventionDto? intervention;
  final PractitionerFollowUpSectionDto? followUp;
  final ActiveDiagnosisDto? activeDiagnosis;
  final List<EvaluationDto> evaluations;
  final ClinicalWeightSummaryDto? clinicalWeight;
  final BmiDto? bmi;
  final PractitionerComplianceDto? compliance;
}

/// `ClinicalMeasurementResource`.
@JsonSerializable(createToJson: false)
class ClinicalMeasurementDto {
  const ClinicalMeasurementDto({
    required this.weightKg,
    required this.heightCm,
    required this.takenAt,
    required this.bmi,
    this.bodyFatPercentage,
    this.waistCircumferenceCm,
    this.bmiCategory,
    this.protocolChecks,
  });

  factory ClinicalMeasurementDto.fromJson(Map<String, dynamic> json) => _$ClinicalMeasurementDtoFromJson(json);

  final double weightKg;
  final double heightCm;
  final double? bodyFatPercentage;
  final double? waistCircumferenceCm;
  final String takenAt;
  final double bmi;
  final String? bmiCategory;
  final List<String>? protocolChecks;
}

/// `NutritionalAssessmentResource` (assessment detail). Only the fields that are shown.
@JsonSerializable(createToJson: false)
class NutritionalAssessmentDto {
  const NutritionalAssessmentDto({
    required this.assessmentId,
    this.ageYears = 0,
    this.biologicalSex,
    this.anthropometry = const [],
    this.activityLevel,
    this.eatingHabits,
    this.biochemistryPanel,
  });

  factory NutritionalAssessmentDto.fromJson(Map<String, dynamic> json) => _$NutritionalAssessmentDtoFromJson(json);

  final int assessmentId;
  final int ageYears;
  final String? biologicalSex;
  final List<ClinicalMeasurementDto> anthropometry;
  final String? activityLevel;
  final EatingHabitsDto? eatingHabits;
  final BiochemistryPanelDto? biochemistryPanel;
}

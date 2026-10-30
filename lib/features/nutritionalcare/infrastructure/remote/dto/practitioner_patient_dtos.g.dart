// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practitioner_patient_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaselineSummaryDto _$BaselineSummaryDtoFromJson(Map<String, dynamic> json) =>
    BaselineSummaryDto(
      biologicalSex: json['biologicalSex'] as String?,
      ageYears: (json['ageYears'] as num?)?.toInt() ?? 0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0,
      conditions:
          (json['conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

SummaryFollowUpDto _$SummaryFollowUpDtoFromJson(Map<String, dynamic> json) =>
    SummaryFollowUpDto(
      followUpId: (json['followUpId'] as num).toInt(),
      scheduledFor: json['scheduledFor'] as String,
    );

SummaryConsultationInProgressDto _$SummaryConsultationInProgressDtoFromJson(
  Map<String, dynamic> json,
) => SummaryConsultationInProgressDto(
  consultationId: (json['consultationId'] as num).toInt(),
  lastSavedAt: json['lastSavedAt'] as String,
  stepNumber: (json['stepNumber'] as num?)?.toInt() ?? 1,
  stepName: json['stepName'] as String?,
);

ComplianceRatioDto _$ComplianceRatioDtoFromJson(Map<String, dynamic> json) =>
    ComplianceRatioDto(
      met: (json['met'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

SinceLastConsultationDto _$SinceLastConsultationDtoFromJson(
  Map<String, dynamic> json,
) => SinceLastConsultationDto(
  fromDate: json['fromDate'] as String,
  weightSlopeKgPerWeek: (json['weightSlopeKgPerWeek'] as num?)?.toDouble(),
  trendWeeks: (json['trendWeeks'] as num?)?.toInt() ?? 0,
  compliance: json['compliance'] == null
      ? null
      : ComplianceRatioDto.fromJson(json['compliance'] as Map<String, dynamic>),
);

PatientSummaryDto _$PatientSummaryDtoFromJson(Map<String, dynamic> json) =>
    PatientSummaryDto(
      patientId: (json['patientId'] as num).toInt(),
      sinceLastConsultation: SinceLastConsultationDto.fromJson(
        json['sinceLastConsultation'] as Map<String, dynamic>,
      ),
      fullName: json['fullName'] as String?,
      linkedSince: json['linkedSince'] as String?,
      linkStatus: json['linkStatus'] as String?,
      activePlanVersion: (json['activePlanVersion'] as num?)?.toInt(),
      baseline: json['baseline'] == null
          ? null
          : BaselineSummaryDto.fromJson(
              json['baseline'] as Map<String, dynamic>,
            ),
      nextFollowUp: json['nextFollowUp'] == null
          ? null
          : SummaryFollowUpDto.fromJson(
              json['nextFollowUp'] as Map<String, dynamic>,
            ),
      consultationInProgress: json['consultationInProgress'] == null
          ? null
          : SummaryConsultationInProgressDto.fromJson(
              json['consultationInProgress'] as Map<String, dynamic>,
            ),
    );

TargetsDto _$TargetsDtoFromJson(Map<String, dynamic> json) => TargetsDto(
  energyKcal: (json['energyKcal'] as num).toDouble(),
  proteinG: (json['proteinG'] as num).toDouble(),
  carbG: (json['carbG'] as num).toDouble(),
  fatG: (json['fatG'] as num).toDouble(),
);

GuidelineItemDto _$GuidelineItemDtoFromJson(Map<String, dynamic> json) =>
    GuidelineItemDto(
      code: json['code'] as String?,
      custom: json['custom'] as String?,
    );

NutritionPlanDto _$NutritionPlanDtoFromJson(Map<String, dynamic> json) =>
    NutritionPlanDto(
      planId: (json['planId'] as num).toInt(),
      version: (json['version'] as num).toInt(),
      proposal: TargetsDto.fromJson(json['proposal'] as Map<String, dynamic>),
      prescribed: json['prescribed'] == null
          ? null
          : TargetsDto.fromJson(json['prescribed'] as Map<String, dynamic>),
      guidelines:
          (json['guidelines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      restrictions:
          (json['restrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? false,
      publishedAt: json['publishedAt'] as String?,
      guidelineItems: (json['guidelineItems'] as List<dynamic>?)
          ?.map((e) => GuidelineItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      legacyRestrictions: (json['legacyRestrictions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      patientMessage: json['patientMessage'] as String?,
    );

ActiveDiagnosisDto _$ActiveDiagnosisDtoFromJson(Map<String, dynamic> json) =>
    ActiveDiagnosisDto(
      issuedAt: json['issuedAt'] as String,
      code: json['code'] as String?,
      statement: json['statement'] as String? ?? '',
    );

EvaluationDto _$EvaluationDtoFromJson(Map<String, dynamic> json) =>
    EvaluationDto(
      assessmentId: (json['assessmentId'] as num).toInt(),
      takenAt: json['takenAt'] as String,
      weightKg: (json['weightKg'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      waistCm: (json['waistCm'] as num?)?.toDouble(),
      isFirst: json['isFirst'] as bool? ?? false,
    );

ClinicalWeightSummaryDto _$ClinicalWeightSummaryDtoFromJson(
  Map<String, dynamic> json,
) => ClinicalWeightSummaryDto(
  latestKg: (json['latestKg'] as num).toDouble(),
  latestDate: json['latestDate'] as String,
  deltaKgSinceFirst: (json['deltaKgSinceFirst'] as num).toDouble(),
  firstDate: json['firstDate'] as String,
);

BmiDto _$BmiDtoFromJson(Map<String, dynamic> json) => BmiDto(
  value: (json['value'] as num).toDouble(),
  category: json['category'] as String?,
);

PractitionerComplianceDto _$PractitionerComplianceDtoFromJson(
  Map<String, dynamic> json,
) => PractitionerComplianceDto(
  from: json['from'] as String,
  to: json['to'] as String,
  met: (json['met'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

InterventionDto _$InterventionDtoFromJson(Map<String, dynamic> json) =>
    InterventionDto(
      planVersion: (json['planVersion'] as num).toInt(),
      validFrom: json['validFrom'] as String,
      energyKcal: (json['energyKcal'] as num).toDouble(),
    );

ReferralSummaryDto _$ReferralSummaryDtoFromJson(Map<String, dynamic> json) =>
    ReferralSummaryDto(
      referralId: (json['referralId'] as num).toInt(),
      specialty: json['specialty'] as String,
      issuedAt: json['issuedAt'] as String,
      status: json['status'] as String? ?? 'Open',
      reason: json['reason'] as String? ?? '',
      closedAt: json['closedAt'] as String?,
    );

PractitionerFollowUpSectionDto _$PractitionerFollowUpSectionDtoFromJson(
  Map<String, dynamic> json,
) => PractitionerFollowUpSectionDto(
  referrals:
      (json['referrals'] as List<dynamic>?)
          ?.map((e) => ReferralSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

PractitionerRecordDto _$PractitionerRecordDtoFromJson(
  Map<String, dynamic> json,
) => PractitionerRecordDto(
  patientId: (json['patientId'] as num).toInt(),
  intervention: json['intervention'] == null
      ? null
      : InterventionDto.fromJson(json['intervention'] as Map<String, dynamic>),
  followUp: json['followUp'] == null
      ? null
      : PractitionerFollowUpSectionDto.fromJson(
          json['followUp'] as Map<String, dynamic>,
        ),
  activeDiagnosis: json['activeDiagnosis'] == null
      ? null
      : ActiveDiagnosisDto.fromJson(
          json['activeDiagnosis'] as Map<String, dynamic>,
        ),
  evaluations:
      (json['evaluations'] as List<dynamic>?)
          ?.map((e) => EvaluationDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  clinicalWeight: json['clinicalWeight'] == null
      ? null
      : ClinicalWeightSummaryDto.fromJson(
          json['clinicalWeight'] as Map<String, dynamic>,
        ),
  bmi: json['bmi'] == null
      ? null
      : BmiDto.fromJson(json['bmi'] as Map<String, dynamic>),
  compliance: json['compliance'] == null
      ? null
      : PractitionerComplianceDto.fromJson(
          json['compliance'] as Map<String, dynamic>,
        ),
);

ClinicalMeasurementDto _$ClinicalMeasurementDtoFromJson(
  Map<String, dynamic> json,
) => ClinicalMeasurementDto(
  weightKg: (json['weightKg'] as num).toDouble(),
  heightCm: (json['heightCm'] as num).toDouble(),
  takenAt: json['takenAt'] as String,
  bmi: (json['bmi'] as num).toDouble(),
  bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble(),
  waistCircumferenceCm: (json['waistCircumferenceCm'] as num?)?.toDouble(),
  bmiCategory: json['bmiCategory'] as String?,
  protocolChecks: (json['protocolChecks'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

NutritionalAssessmentDto _$NutritionalAssessmentDtoFromJson(
  Map<String, dynamic> json,
) => NutritionalAssessmentDto(
  assessmentId: (json['assessmentId'] as num).toInt(),
  ageYears: (json['ageYears'] as num?)?.toInt() ?? 0,
  biologicalSex: json['biologicalSex'] as String?,
  anthropometry:
      (json['anthropometry'] as List<dynamic>?)
          ?.map(
            (e) => ClinicalMeasurementDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  activityLevel: json['activityLevel'] as String?,
  eatingHabits: json['eatingHabits'] == null
      ? null
      : EatingHabitsDto.fromJson(json['eatingHabits'] as Map<String, dynamic>),
  biochemistryPanel: json['biochemistryPanel'] == null
      ? null
      : BiochemistryPanelDto.fromJson(
          json['biochemistryPanel'] as Map<String, dynamic>,
        ),
);

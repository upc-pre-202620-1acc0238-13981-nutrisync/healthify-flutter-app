// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$StartConsultationRequestDtoToJson(
  StartConsultationRequestDto instance,
) => <String, dynamic>{'scheduledFollowUpId': ?instance.scheduledFollowUpId};

EatingHabitsDto _$EatingHabitsDtoFromJson(Map<String, dynamic> json) =>
    EatingHabitsDto(
      mealsPerDay: (json['mealsPerDay'] as num?)?.toInt(),
      waterLitersPerDay: (json['waterLitersPerDay'] as num?)?.toDouble(),
      mealsOutPerWeek: (json['mealsOutPerWeek'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EatingHabitsDtoToJson(EatingHabitsDto instance) =>
    <String, dynamic>{
      'mealsPerDay': ?instance.mealsPerDay,
      'waterLitersPerDay': ?instance.waterLitersPerDay,
      'mealsOutPerWeek': ?instance.mealsOutPerWeek,
    };

BiochemistryPanelDto _$BiochemistryPanelDtoFromJson(
  Map<String, dynamic> json,
) => BiochemistryPanelDto(
  fastingGlucoseMgDl: (json['fastingGlucoseMgDl'] as num?)?.toDouble(),
  totalCholesterolMgDl: (json['totalCholesterolMgDl'] as num?)?.toDouble(),
  triglyceridesMgDl: (json['triglyceridesMgDl'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BiochemistryPanelDtoToJson(
  BiochemistryPanelDto instance,
) => <String, dynamic>{
  'fastingGlucoseMgDl': ?instance.fastingGlucoseMgDl,
  'totalCholesterolMgDl': ?instance.totalCholesterolMgDl,
  'triglyceridesMgDl': ?instance.triglyceridesMgDl,
};

Map<String, dynamic> _$MeasurementRequestDtoToJson(
  MeasurementRequestDto instance,
) => <String, dynamic>{
  'weightKg': instance.weightKg,
  'waistCm': ?instance.waistCm,
  'bodyFatPercentage': ?instance.bodyFatPercentage,
  'protocolChecks': instance.protocolChecks,
  'activityLevel': instance.activityLevel,
  'habits': ?instance.habits?.toJson(),
  'biochemistry': ?instance.biochemistry?.toJson(),
};

Map<String, dynamic> _$DiagnosisRequestDtoToJson(
  DiagnosisRequestDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'source': instance.source,
  'aiGenerationId': ?instance.aiGenerationId,
  'rationale': ?instance.rationale,
};

Map<String, dynamic> _$TargetParametersDtoToJson(
  TargetParametersDto instance,
) => <String, dynamic>{
  'equation': instance.equation,
  'deficitKind': instance.deficitKind,
  'deficitValue': instance.deficitValue,
  'proteinGramsPerKg': instance.proteinGramsPerKg,
  'fatPercentOfEnergy': instance.fatPercentOfEnergy,
};

Map<String, dynamic> _$TargetProposalRequestDtoToJson(
  TargetProposalRequestDto instance,
) => <String, dynamic>{'parameters': ?instance.parameters?.toJson()};

Map<String, dynamic> _$PrescribeTargetsRequestDtoToJson(
  PrescribeTargetsRequestDto instance,
) => <String, dynamic>{
  'outcome': instance.outcome,
  'energyKcal': ?instance.energyKcal,
  'proteinG': ?instance.proteinG,
  'carbG': ?instance.carbG,
  'fatG': ?instance.fatG,
  'overrideReason': ?instance.overrideReason,
};

Map<String, dynamic> _$PublicationRequestDtoToJson(
  PublicationRequestDto instance,
) => <String, dynamic>{
  'restrictions': instance.restrictions,
  'guidelines': instance.guidelines,
  'customGuidelines': instance.customGuidelines,
  'patientMessage': ?instance.patientMessage,
};

CalculationBasisDto _$CalculationBasisDtoFromJson(Map<String, dynamic> json) =>
    CalculationBasisDto(
      equation: json['equation'] as String?,
      referenceWeightKind: json['referenceWeightKind'] as String?,
      referenceWeightKg: (json['referenceWeightKg'] as num?)?.toDouble() ?? 0,
      activityFactor: (json['activityFactor'] as num?)?.toDouble() ?? 0,
      deficitKind: json['deficitKind'] as String?,
      deficitValue: (json['deficitValue'] as num?)?.toDouble() ?? 0,
    );

ConsultationMeasurementDto _$ConsultationMeasurementDtoFromJson(
  Map<String, dynamic> json,
) => ConsultationMeasurementDto(
  weightKg: (json['weightKg'] as num).toDouble(),
  heightCm: (json['heightCm'] as num).toDouble(),
  bmi: (json['bmi'] as num).toDouble(),
  waistCm: (json['waistCm'] as num?)?.toDouble(),
  bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble(),
  protocolChecks:
      (json['protocolChecks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  activityLevel: json['activityLevel'] as String?,
  habits: json['habits'] == null
      ? null
      : EatingHabitsDto.fromJson(json['habits'] as Map<String, dynamic>),
  biochemistry: json['biochemistry'] == null
      ? null
      : BiochemistryPanelDto.fromJson(
          json['biochemistry'] as Map<String, dynamic>,
        ),
  ageYears: (json['ageYears'] as num?)?.toInt() ?? 0,
  biologicalSex: json['biologicalSex'] as String?,
);

ConsultationDiagnosisDto _$ConsultationDiagnosisDtoFromJson(
  Map<String, dynamic> json,
) => ConsultationDiagnosisDto(
  code: json['code'] as String?,
  source: json['source'] as String?,
  rationale: json['rationale'] as String? ?? '',
  isPending: json['isPending'] as bool? ?? false,
);

ConsultationTargetsDto _$ConsultationTargetsDtoFromJson(
  Map<String, dynamic> json,
) => ConsultationTargetsDto(
  calculationBasis: CalculationBasisDto.fromJson(
    json['calculationBasis'] as Map<String, dynamic>,
  ),
  proposal: TargetsDto.fromJson(json['proposal'] as Map<String, dynamic>),
  prescribed: json['prescribed'] == null
      ? null
      : TargetsDto.fromJson(json['prescribed'] as Map<String, dynamic>),
  prescriptionOutcome: json['prescriptionOutcome'] as String?,
  overrideReason: json['overrideReason'] as String?,
);

PublicationDraftDto _$PublicationDraftDtoFromJson(Map<String, dynamic> json) =>
    PublicationDraftDto(
      restrictions:
          (json['restrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      guidelines:
          (json['guidelines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      customGuidelines:
          (json['customGuidelines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      patientMessage: json['patientMessage'] as String?,
    );

CheckInQuestionDto _$CheckInQuestionDtoFromJson(Map<String, dynamic> json) =>
    CheckInQuestionDto(
      text: json['text'] as String,
      origin: json['origin'] as String?,
    );

ConsultationCheckInDto _$ConsultationCheckInDtoFromJson(
  Map<String, dynamic> json,
) => ConsultationCheckInDto(
  feeling: json['feeling'] as String,
  submittedAt: json['submittedAt'] as String,
  difficulties:
      (json['difficulties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  questions:
      (json['questions'] as List<dynamic>?)
          ?.map((e) => CheckInQuestionDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

ConsultationDto _$ConsultationDtoFromJson(Map<String, dynamic> json) =>
    ConsultationDto(
      consultationId: (json['consultationId'] as num).toInt(),
      patientId: (json['patientId'] as num).toInt(),
      state: json['state'] as String,
      currentStep: json['currentStep'] as String,
      lastSavedAt: json['lastSavedAt'] as String,
      stepNumber: (json['stepNumber'] as num?)?.toInt() ?? 1,
      measurement: json['measurement'] == null
          ? null
          : ConsultationMeasurementDto.fromJson(
              json['measurement'] as Map<String, dynamic>,
            ),
      diagnosis: json['diagnosis'] == null
          ? null
          : ConsultationDiagnosisDto.fromJson(
              json['diagnosis'] as Map<String, dynamic>,
            ),
      targets: json['targets'] == null
          ? null
          : ConsultationTargetsDto.fromJson(
              json['targets'] as Map<String, dynamic>,
            ),
      publicationDraft: json['publicationDraft'] == null
          ? null
          : PublicationDraftDto.fromJson(
              json['publicationDraft'] as Map<String, dynamic>,
            ),
      patientCheckIn: json['patientCheckIn'] == null
          ? null
          : ConsultationCheckInDto.fromJson(
              json['patientCheckIn'] as Map<String, dynamic>,
            ),
      publishedPlanVersion: (json['publishedPlanVersion'] as num?)?.toInt(),
    );

DiagnosisSuggestionDto _$DiagnosisSuggestionDtoFromJson(
  Map<String, dynamic> json,
) => DiagnosisSuggestionDto(
  code: json['code'] as String,
  aiGenerationId: (json['aiGenerationId'] as num?)?.toInt(),
  rationale: json['rationale'] as String? ?? '',
  source: json['source'] as String?,
  disclaimer: json['disclaimer'] as String? ?? '',
);

GuidelineSuggestionsDto _$GuidelineSuggestionsDtoFromJson(
  Map<String, dynamic> json,
) => GuidelineSuggestionsDto(
  suggested:
      (json['suggested'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  source: json['source'] as String?,
);

TargetInputsDto _$TargetInputsDtoFromJson(Map<String, dynamic> json) =>
    TargetInputsDto(
      sex: json['sex'] as String?,
      ageYears: (json['ageYears'] as num?)?.toInt() ?? 0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      activityLevel: json['activityLevel'] as String?,
    );

TargetProposalDto _$TargetProposalDtoFromJson(Map<String, dynamic> json) =>
    TargetProposalDto(
      calculationBasis: CalculationBasisDto.fromJson(
        json['calculationBasis'] as Map<String, dynamic>,
      ),
      proposal: TargetsDto.fromJson(json['proposal'] as Map<String, dynamic>),
      inputsSummary: TargetInputsDto.fromJson(
        json['inputsSummary'] as Map<String, dynamic>,
      ),
    );

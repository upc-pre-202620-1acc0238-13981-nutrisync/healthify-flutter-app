// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_item_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewItemDto _$ReviewItemDtoFromJson(Map<String, dynamic> json) =>
    ReviewItemDto(
      reviewItemId: (json['reviewItemId'] as num).toInt(),
      patientId: (json['patientId'] as num).toInt(),
      signalType: json['signalType'] as String,
      state: json['state'] as String,
      evidence: json['evidence'] as String? ?? '',
      resolvedWithAdjustment: json['resolvedWithAdjustment'] as bool?,
      resolutionNote: json['resolutionNote'] as String?,
      resolvedAt: json['resolvedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      patientFullName: json['patientFullName'] as String?,
      hasPlanProposal: json['hasPlanProposal'] as bool? ?? false,
      evidenceData: json['evidenceData'] == null
          ? null
          : ReviewItemEvidenceDto.fromJson(
              json['evidenceData'] as Map<String, dynamic>,
            ),
      resolutionNoteCode: json['resolutionNoteCode'] as String?,
      resolutionNoteData: json['resolutionNoteData'] == null
          ? null
          : ResolutionNoteDataDto.fromJson(
              json['resolutionNoteData'] as Map<String, dynamic>,
            ),
    );

ReviewItemEvidenceDto _$ReviewItemEvidenceDtoFromJson(
  Map<String, dynamic> json,
) => ReviewItemEvidenceDto(
  averagePercentFromTarget: (json['averagePercentFromTarget'] as num?)
      ?.toDouble(),
  deviatedDays: (json['deviatedDays'] as num?)?.toInt(),
  loggedDaysConsidered: (json['loggedDaysConsidered'] as num?)?.toInt(),
  direction: json['direction'] as String?,
  adjustedOn: json['adjustedOn'] as String?,
  adjustedPlanVersion: (json['adjustedPlanVersion'] as num?)?.toInt(),
  averageEnergyKcalFromTarget: (json['averageEnergyKcalFromTarget'] as num?)
      ?.toDouble(),
  consistencyKgPerWeek: (json['consistencyKgPerWeek'] as num?)?.toDouble(),
  alertSinceOn: json['alertSinceOn'] as String?,
  weeksInAlert: (json['weeksInAlert'] as num?)?.toInt(),
  shownToPatientOn: json['shownToPatientOn'] as String?,
);

ResolutionNoteDataDto _$ResolutionNoteDataDtoFromJson(
  Map<String, dynamic> json,
) => ResolutionNoteDataDto(planVersion: (json['planVersion'] as num?)?.toInt());

Map<String, dynamic> _$ResolveReviewItemRequestDtoToJson(
  ResolveReviewItemRequestDto instance,
) => <String, dynamic>{
  'resolvedWithAdjustment': instance.resolvedWithAdjustment,
  'resolutionNote': ?instance.resolutionNote,
};

PlanAdjustmentProposalDto _$PlanAdjustmentProposalDtoFromJson(
  Map<String, dynamic> json,
) => PlanAdjustmentProposalDto(
  reviewItemId: (json['reviewItemId'] as num).toInt(),
  title: json['title'] as String,
  proposedEnergyKcal: (json['proposedEnergyKcal'] as num).toDouble(),
  proposedProteinG: (json['proposedProteinG'] as num).toDouble(),
  proposedCarbG: (json['proposedCarbG'] as num).toDouble(),
  proposedFatG: (json['proposedFatG'] as num).toDouble(),
  recheckAfterDays: (json['recheckAfterDays'] as num).toInt(),
  generatedAt: json['generatedAt'] as String,
  status: json['status'] as String,
  currentEnergyKcal: (json['currentEnergyKcal'] as num?)?.toDouble(),
  addedGuidelines:
      (json['addedGuidelines'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  removedGuidelines:
      (json['removedGuidelines'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  patientMessage: json['patientMessage'] as String? ?? '',
  rationale: json['rationale'] as String? ?? '',
);

Map<String, dynamic> _$AcceptPlanProposalRequestDtoToJson(
  AcceptPlanProposalRequestDto instance,
) => <String, dynamic>{
  'asIs': instance.asIs,
  'energyKcal': ?instance.energyKcal,
  'proteinG': ?instance.proteinG,
  'carbG': ?instance.carbG,
  'fatG': ?instance.fatG,
  'guidelines': ?instance.guidelines,
  'patientMessage': ?instance.patientMessage,
};

PlanProposalAcceptanceDto _$PlanProposalAcceptanceDtoFromJson(
  Map<String, dynamic> json,
) => PlanProposalAcceptanceDto(
  reviewItem: ReviewItemDto.fromJson(
    json['reviewItem'] as Map<String, dynamic>,
  ),
  planVersion: AcceptedPlanVersionDto.fromJson(
    json['planVersion'] as Map<String, dynamic>,
  ),
);

AcceptedPlanVersionDto _$AcceptedPlanVersionDtoFromJson(
  Map<String, dynamic> json,
) => AcceptedPlanVersionDto(version: (json['version'] as num).toInt());

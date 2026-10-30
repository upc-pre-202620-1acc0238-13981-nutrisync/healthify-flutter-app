import 'package:json_annotation/json_annotation.dart';

part 'review_item_dtos.g.dart';

/// `ReviewItemResource`.
@JsonSerializable(createToJson: false)
class ReviewItemDto {
  const ReviewItemDto({
    required this.reviewItemId,
    required this.patientId,
    required this.signalType,
    required this.state,
    this.evidence = '',
    this.resolvedWithAdjustment,
    this.resolutionNote,
    this.resolvedAt,
    this.createdAt,
    this.patientFullName,
    this.hasPlanProposal = false,
    this.evidenceData,
    this.resolutionNoteCode,
    this.resolutionNoteData,
  });

  factory ReviewItemDto.fromJson(Map<String, dynamic> json) => _$ReviewItemDtoFromJson(json);

  final int reviewItemId;
  final int patientId;
  final String signalType;
  final String evidence;
  final String state;
  final bool? resolvedWithAdjustment;
  final String? resolutionNote;
  final String? resolvedAt;
  final String? createdAt;
  final String? patientFullName;
  final bool hasPlanProposal;
  final ReviewItemEvidenceDto? evidenceData;
  final String? resolutionNoteCode;
  final ResolutionNoteDataDto? resolutionNoteData;
}

/// `ReviewItemEvidenceResource`: the fields of each `signalType` (the rest arrive as `null`).
@JsonSerializable(createToJson: false)
class ReviewItemEvidenceDto {
  const ReviewItemEvidenceDto({
    this.averagePercentFromTarget,
    this.deviatedDays,
    this.loggedDaysConsidered,
    this.direction,
    this.adjustedOn,
    this.adjustedPlanVersion,
    this.averageEnergyKcalFromTarget,
    this.consistencyKgPerWeek,
    this.alertSinceOn,
    this.weeksInAlert,
    this.shownToPatientOn,
  });

  factory ReviewItemEvidenceDto.fromJson(Map<String, dynamic> json) => _$ReviewItemEvidenceDtoFromJson(json);

  final double? averagePercentFromTarget;
  final int? deviatedDays;
  final int? loggedDaysConsidered;
  final String? direction;
  final String? adjustedOn;
  final int? adjustedPlanVersion;
  final double? averageEnergyKcalFromTarget;
  final double? consistencyKgPerWeek;
  final String? alertSinceOn;
  final int? weeksInAlert;
  final String? shownToPatientOn;
}

@JsonSerializable(createToJson: false)
class ResolutionNoteDataDto {
  const ResolutionNoteDataDto({this.planVersion});

  factory ResolutionNoteDataDto.fromJson(Map<String, dynamic> json) => _$ResolutionNoteDataDtoFromJson(json);

  final int? planVersion;
}

/// `ResolveReviewItemResource`. An empty note is omitted (`explicitNulls = false`).
@JsonSerializable(createFactory: false, includeIfNull: false)
class ResolveReviewItemRequestDto {
  const ResolveReviewItemRequestDto({required this.resolvedWithAdjustment, required this.resolutionNote});

  final bool resolvedWithAdjustment;
  final String? resolutionNote;

  Map<String, dynamic> toJson() => _$ResolveReviewItemRequestDtoToJson(this);
}

/// `PlanAdjustmentProposalResource`.
@JsonSerializable(createToJson: false)
class PlanAdjustmentProposalDto {
  const PlanAdjustmentProposalDto({
    required this.reviewItemId,
    required this.title,
    required this.proposedEnergyKcal,
    required this.proposedProteinG,
    required this.proposedCarbG,
    required this.proposedFatG,
    required this.recheckAfterDays,
    required this.generatedAt,
    required this.status,
    this.currentEnergyKcal,
    this.addedGuidelines = const [],
    this.removedGuidelines = const [],
    this.patientMessage = '',
    this.rationale = '',
  });

  factory PlanAdjustmentProposalDto.fromJson(Map<String, dynamic> json) => _$PlanAdjustmentProposalDtoFromJson(json);

  final int reviewItemId;
  final String title;
  final double? currentEnergyKcal;
  final double proposedEnergyKcal;
  final double proposedProteinG;
  final double proposedCarbG;
  final double proposedFatG;
  final List<String> addedGuidelines;
  final List<String> removedGuidelines;
  final String patientMessage;
  final int recheckAfterDays;
  final String rationale;
  final String generatedAt;
  final String status;
}

/// `AcceptPlanProposalResource`: `{ asIs: true }` or the complete edits. Nulls are omitted (`explicitNulls = false`).
@JsonSerializable(createFactory: false, includeIfNull: false)
class AcceptPlanProposalRequestDto {
  const AcceptPlanProposalRequestDto({
    required this.asIs,
    this.energyKcal,
    this.proteinG,
    this.carbG,
    this.fatG,
    this.guidelines,
    this.patientMessage,
  });

  final bool asIs;
  final double? energyKcal;
  final double? proteinG;
  final double? carbG;
  final double? fatG;
  final List<String>? guidelines;
  final String? patientMessage;

  Map<String, dynamic> toJson() => _$AcceptPlanProposalRequestDtoToJson(this);
}

/// `PlanProposalAcceptanceResource`: only the version number of the new plan is read.
@JsonSerializable(createToJson: false)
class PlanProposalAcceptanceDto {
  const PlanProposalAcceptanceDto({required this.reviewItem, required this.planVersion});

  factory PlanProposalAcceptanceDto.fromJson(Map<String, dynamic> json) => _$PlanProposalAcceptanceDtoFromJson(json);

  final ReviewItemDto reviewItem;
  final AcceptedPlanVersionDto planVersion;
}

@JsonSerializable(createToJson: false)
class AcceptedPlanVersionDto {
  const AcceptedPlanVersionDto({required this.version});

  factory AcceptedPlanVersionDto.fromJson(Map<String, dynamic> json) => _$AcceptedPlanVersionDtoFromJson(json);

  final int version;
}

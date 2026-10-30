import 'package:json_annotation/json_annotation.dart';

part 'practitioner_dtos.g.dart';

/// `PatientRosterItemResource`.
@JsonSerializable(createToJson: false)
class PatientRosterItemDto {
  const PatientRosterItemDto({
    required this.patientId,
    required this.careLinkId,
    required this.linkedSince,
    this.fullName = '',
    this.linkStatus,
    this.hasBaseline = false,
    this.activePlanVersion,
    this.isNew = false,
    this.hasConsultationInProgress = false,
    this.nextFollowUpAt,
    this.hasOpenReviewItem = false,
  });

  factory PatientRosterItemDto.fromJson(Map<String, dynamic> json) => _$PatientRosterItemDtoFromJson(json);

  final int patientId;
  final int careLinkId;
  final String fullName;
  final String linkedSince;
  final String? linkStatus;
  final bool hasBaseline;
  final int? activePlanVersion;
  final bool isNew;
  final bool hasConsultationInProgress;
  final String? nextFollowUpAt;
  final bool hasOpenReviewItem;
}

/// `IssueInvitationResource(ExpiresAt)`.
@JsonSerializable(createFactory: false)
class IssueInvitationRequestDto {
  const IssueInvitationRequestDto({required this.expiresAt});

  final String expiresAt;

  Map<String, dynamic> toJson() => _$IssueInvitationRequestDtoToJson(this);
}

/// `InvitationResource`: `token` only comes in the `POST` response.
@JsonSerializable(createToJson: false)
class InvitationDto {
  const InvitationDto({required this.invitationId, required this.expiresAt, this.token});

  factory InvitationDto.fromJson(Map<String, dynamic> json) => _$InvitationDtoFromJson(json);

  final int invitationId;
  final String? token;
  final String expiresAt;
}

/// `DischargePatientResource`.
@JsonSerializable(createFactory: false)
class DischargePatientRequestDto {
  const DischargePatientRequestDto({required this.clinicalReason});

  final String clinicalReason;

  Map<String, dynamic> toJson() => _$DischargePatientRequestDtoToJson(this);
}

/// `TargetsReadStatusResource`.
@JsonSerializable(createToJson: false)
class TargetsReadStatusDto {
  const TargetsReadStatusDto({
    required this.careLinkId,
    this.pendingTargetsVersion,
    this.lastAcknowledgedVersion,
    this.hasPendingAcknowledgement = false,
    this.lastAcknowledgedAt,
  });

  factory TargetsReadStatusDto.fromJson(Map<String, dynamic> json) => _$TargetsReadStatusDtoFromJson(json);

  final int careLinkId;
  final int? pendingTargetsVersion;
  final int? lastAcknowledgedVersion;
  final bool hasPendingAcknowledgement;
  final String? lastAcknowledgedAt;
}

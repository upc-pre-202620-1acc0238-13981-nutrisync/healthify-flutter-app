// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practitioner_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientRosterItemDto _$PatientRosterItemDtoFromJson(
  Map<String, dynamic> json,
) => PatientRosterItemDto(
  patientId: (json['patientId'] as num).toInt(),
  careLinkId: (json['careLinkId'] as num).toInt(),
  linkedSince: json['linkedSince'] as String,
  fullName: json['fullName'] as String? ?? '',
  linkStatus: json['linkStatus'] as String?,
  hasBaseline: json['hasBaseline'] as bool? ?? false,
  activePlanVersion: (json['activePlanVersion'] as num?)?.toInt(),
  isNew: json['isNew'] as bool? ?? false,
  hasConsultationInProgress:
      json['hasConsultationInProgress'] as bool? ?? false,
  nextFollowUpAt: json['nextFollowUpAt'] as String?,
  hasOpenReviewItem: json['hasOpenReviewItem'] as bool? ?? false,
);

Map<String, dynamic> _$IssueInvitationRequestDtoToJson(
  IssueInvitationRequestDto instance,
) => <String, dynamic>{'expiresAt': instance.expiresAt};

InvitationDto _$InvitationDtoFromJson(Map<String, dynamic> json) =>
    InvitationDto(
      invitationId: (json['invitationId'] as num).toInt(),
      expiresAt: json['expiresAt'] as String,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$DischargePatientRequestDtoToJson(
  DischargePatientRequestDto instance,
) => <String, dynamic>{'clinicalReason': instance.clinicalReason};

TargetsReadStatusDto _$TargetsReadStatusDtoFromJson(
  Map<String, dynamic> json,
) => TargetsReadStatusDto(
  careLinkId: (json['careLinkId'] as num).toInt(),
  pendingTargetsVersion: (json['pendingTargetsVersion'] as num?)?.toInt(),
  lastAcknowledgedVersion: (json['lastAcknowledgedVersion'] as num?)?.toInt(),
  hasPendingAcknowledgement:
      json['hasPendingAcknowledgement'] as bool? ?? false,
  lastAcknowledgedAt: json['lastAcknowledgedAt'] as String?,
);

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practitioner_agenda_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledFollowUpDto _$ScheduledFollowUpDtoFromJson(
  Map<String, dynamic> json,
) => ScheduledFollowUpDto(
  followUpId: (json['followUpId'] as num).toInt(),
  patientId: (json['patientId'] as num).toInt(),
  scheduledFor: json['scheduledFor'] as String,
  state: json['state'] as String,
  patientFullName: json['patientFullName'] as String?,
  preparation: (json['preparation'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  modality: json['modality'] as String?,
);

Map<String, dynamic> _$ScheduleFollowUpRequestDtoToJson(
  ScheduleFollowUpRequestDto instance,
) => <String, dynamic>{
  'patientId': instance.patientId,
  'scheduledFor': instance.scheduledFor,
  'preparation': instance.preparation,
  'modality': instance.modality,
};

Map<String, dynamic> _$RescheduleFollowUpRequestDtoToJson(
  RescheduleFollowUpRequestDto instance,
) => <String, dynamic>{
  'scheduledFor': instance.scheduledFor,
  'preparation': instance.preparation,
};

Map<String, dynamic> _$CancelFollowUpRequestDtoToJson(
  CancelFollowUpRequestDto instance,
) => <String, dynamic>{'reason': ?instance.reason};

Map<String, dynamic> _$RecordReferralRequestDtoToJson(
  RecordReferralRequestDto instance,
) => <String, dynamic>{
  'patientId': instance.patientId,
  'specialty': instance.specialty,
  'reason': instance.reason,
};

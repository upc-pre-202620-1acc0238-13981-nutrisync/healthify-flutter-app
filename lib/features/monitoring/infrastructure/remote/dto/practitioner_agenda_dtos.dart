import 'package:json_annotation/json_annotation.dart';

part 'practitioner_agenda_dtos.g.dart';

/// `ScheduledFollowUpResource` (read model *Practitioner Agenda*).
@JsonSerializable(createToJson: false)
class ScheduledFollowUpDto {
  const ScheduledFollowUpDto({
    required this.followUpId,
    required this.patientId,
    required this.scheduledFor,
    required this.state,
    this.patientFullName,
    this.preparation,
    this.modality,
  });

  factory ScheduledFollowUpDto.fromJson(Map<String, dynamic> json) => _$ScheduledFollowUpDtoFromJson(json);

  final int followUpId;
  final int patientId;
  final String scheduledFor;
  final String state;
  final String? patientFullName;
  final List<String>? preparation;
  final String? modality;
}

/// `ScheduleFollowUpResource`.
@JsonSerializable(createFactory: false)
class ScheduleFollowUpRequestDto {
  const ScheduleFollowUpRequestDto({
    required this.patientId,
    required this.scheduledFor,
    required this.preparation,
    required this.modality,
  });

  final int patientId;
  final String scheduledFor;
  final List<String> preparation;
  final String modality;

  Map<String, dynamic> toJson() => _$ScheduleFollowUpRequestDtoToJson(this);
}

/// `RescheduleFollowUpResource`: the sent preparation replaces the previous one.
@JsonSerializable(createFactory: false)
class RescheduleFollowUpRequestDto {
  const RescheduleFollowUpRequestDto({required this.scheduledFor, required this.preparation});

  final String scheduledFor;
  final List<String> preparation;

  Map<String, dynamic> toJson() => _$RescheduleFollowUpRequestDtoToJson(this);
}

/// `CancelFollowUpResource`. Without a reason it is `{}` (`explicitNulls = false`).
@JsonSerializable(createFactory: false, includeIfNull: false)
class CancelFollowUpRequestDto {
  const CancelFollowUpRequestDto({this.reason});

  final String? reason;

  Map<String, dynamic> toJson() => _$CancelFollowUpRequestDtoToJson(this);
}

/// `RecordReferralResource`.
@JsonSerializable(createFactory: false)
class RecordReferralRequestDto {
  const RecordReferralRequestDto({required this.patientId, required this.specialty, required this.reason});

  final int patientId;
  final String specialty;
  final String reason;

  Map<String, dynamic> toJson() => _$RecordReferralRequestDtoToJson(this);
}

import '../../../../core/network/iso_dates.dart';
import '../../domain/entity/practitioner_agenda.dart';
import '../../domain/entity/referral.dart';
import '../../domain/valueobject/monitoring_values.dart';
import '../remote/dto/practitioner_agenda_dtos.dart';

// ACL for the agenda. A visit with a state this version does not know, or without a readable date, is not listed.

extension ScheduledFollowUpMapper on ScheduledFollowUpDto {
  /// `null` for a visit this version cannot show.
  AgendaVisit? toDomainOrNull() {
    final moment = parseInstantOrNull(scheduledFor);
    final visitState = FollowUpState.fromCode(state);
    if (moment == null || visitState == null) return null;
    final name = patientFullName?.trim();
    return AgendaVisit(
      id: followUpId,
      patientId: PatientId(patientId),
      patientFullName: name == null || name.isEmpty ? null : name,
      scheduledFor: moment,
      state: visitState,
      preparation: (preparation ?? const <String>[]).map(PreparationInstruction.of).nonNulls.toList(),
      modality: ConsultationModality.fromCode(modality),
    );
  }

  /// A write answers with the visit: one this version cannot read is a malformed response.
  AgendaVisit toDomain() => toDomainOrNull() ?? (throw const FormatException('Unreadable follow up'));
}

extension NewFollowUpMapper on NewFollowUp {
  ScheduleFollowUpRequestDto toDto() => ScheduleFollowUpRequestDto(
    patientId: patientId.value,
    scheduledFor: toIsoSecondsUtc(scheduledFor),
    preparation: preparation.orderedCodes.map((code) => code.code).toList(),
    modality: modality.code,
  );
}

RescheduleFollowUpRequestDto rescheduleDto(DateTime scheduledFor, FollowUpPreparation preparation) =>
    RescheduleFollowUpRequestDto(
      scheduledFor: toIsoSecondsUtc(scheduledFor),
      preparation: preparation.orderedCodes.map((code) => code.code).toList(),
    );

extension NewReferralMapper on NewReferral {
  RecordReferralRequestDto toDto() => RecordReferralRequestDto(
    patientId: patientId.value,
    specialty: specialty.text.trim(),
    reason: reason.text.trim(),
  );
}

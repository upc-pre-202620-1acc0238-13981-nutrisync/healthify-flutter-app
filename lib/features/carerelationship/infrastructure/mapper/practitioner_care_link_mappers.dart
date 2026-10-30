import '../../../../core/network/iso_dates.dart';
import '../../domain/entity/issued_invitation.dart';
import '../../domain/entity/patient_roster.dart';
import '../../domain/entity/targets_read_status.dart';
import '../../domain/valueobject/care_link_id.dart';
import '../../domain/valueobject/invitation_token.dart';
import '../remote/dto/practitioner_dtos.dart';

extension PatientRosterMapper on List<PatientRosterItemDto> {
  /// A patient without a readable name or link date is skipped: the rest of the roster still shows.
  PatientRoster toRoster() {
    final patients = <RosterPatient>[];
    for (final dto in this) {
      final since = parseInstantOrNull(dto.linkedSince);
      if (since == null || dto.fullName.trim().isEmpty || dto.patientId <= 0 || dto.careLinkId <= 0) continue;
      patients.add(
        RosterPatient(
          patientId: dto.patientId,
          careLinkId: CareLinkId(dto.careLinkId),
          fullName: dto.fullName.trim(),
          linkedSince: since,
          isLinkActive: dto.linkStatus?.toLowerCase() == 'active',
          hasBaseline: dto.hasBaseline,
          activePlanVersion: dto.activePlanVersion,
          isNew: dto.isNew,
          hasConsultationInProgress: dto.hasConsultationInProgress,
          nextFollowUpAt: parseInstantOrNull(dto.nextFollowUpAt),
          hasOpenReviewItem: dto.hasOpenReviewItem,
        ),
      );
    }
    return PatientRoster(patients);
  }
}

extension InvitationMapper on InvitationDto {
  /// Without a token shaped like an invitation, the response is useless for the QR code.
  IssuedInvitation toDomain() => IssuedInvitation(
    invitationId: invitationId,
    token: (token == null ? null : InvitationToken.parse(token!)) ?? (throw const FormatException('Invitation without a usable token')),
    expiresAt: parseInstantOrNull(expiresAt) ?? (throw const FormatException('Unreadable expiresAt')),
  );
}

extension TargetsReadStatusMapper on TargetsReadStatusDto {
  /// A non-positive version is not a version: it reads as "nothing pending".
  TargetsReadStatus toDomain() => TargetsReadStatus(
    careLinkId: CareLinkId(careLinkId),
    pendingVersion: pendingTargetsVersion != null && pendingTargetsVersion! > 0 ? pendingTargetsVersion : null,
    lastAcknowledgedVersion: lastAcknowledgedVersion != null && lastAcknowledgedVersion! > 0
        ? lastAcknowledgedVersion
        : null,
    hasPendingAcknowledgement: hasPendingAcknowledgement,
    lastAcknowledgedAt: parseInstantOrNull(lastAcknowledgedAt),
  );
}

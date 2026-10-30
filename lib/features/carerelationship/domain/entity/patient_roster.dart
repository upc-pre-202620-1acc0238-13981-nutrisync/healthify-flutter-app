import '../valueobject/care_link_id.dart';
import '../valueobject/roster_attention.dart';

/// A patient in the nutritionist's roster (`PatientRosterItemResource`).
///
/// [isNew]: no baseline data or no published plan. [hasOpenReviewItem]: there is an open signal in the review inbox.
final class RosterPatient {
  /// Throws [ArgumentError] if the id is not positive or the name is blank.
  RosterPatient({
    required this.patientId,
    required this.careLinkId,
    required this.fullName,
    required this.linkedSince,
    required this.isLinkActive,
    required this.hasBaseline,
    required this.isNew,
    required this.hasConsultationInProgress,
    this.activePlanVersion,
    this.nextFollowUpAt,
    this.hasOpenReviewItem = false,
  }) {
    if (patientId <= 0) throw ArgumentError.value(patientId, 'patientId', 'PatientId must be positive');
    if (fullName.trim().isEmpty) throw ArgumentError.value(fullName, 'fullName', 'A roster patient needs a name');
  }

  final int patientId;
  final CareLinkId careLinkId;
  final String fullName;
  final DateTime linkedSince;
  final bool isLinkActive;
  final bool hasBaseline;
  final int? activePlanVersion;
  final bool isNew;
  final bool hasConsultationInProgress;
  final DateTime? nextFollowUpAt;
  final bool hasOpenReviewItem;

  /// The first reason, by priority ([RosterAttention]), why the patient needs action; `null` = up to date.
  RosterAttention? get attention {
    if (hasOpenReviewItem) return RosterAttention.openReview;
    if (hasConsultationInProgress) return RosterAttention.consultationInProgress;
    if (!hasBaseline) return RosterAttention.missingBaseline;
    if (isNew) return RosterAttention.planNotPublished;
    return null;
  }
}

/// The roster, in backend order. Empty = the first-time empty state.
final class PatientRoster {
  const PatientRoster(this.patients);

  final List<RosterPatient> patients;

  bool get isEmpty => patients.isEmpty;
}

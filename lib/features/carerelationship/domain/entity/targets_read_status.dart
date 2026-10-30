import '../valueobject/care_link_id.dart';

/// `TargetsReadStatusResource`: whether the patient **saw** the published targets. It says nothing about whether they
/// follow them. The mark lives on the care link, not on the plan.
///
/// [pendingVersion]: published version awaiting acknowledgement, or `null`.
final class TargetsReadStatus {
  /// Throws [ArgumentError] if a version is not positive.
  TargetsReadStatus({
    required this.careLinkId,
    this.pendingVersion,
    this.lastAcknowledgedVersion,
    this.hasPendingAcknowledgement = false,
    this.lastAcknowledgedAt,
  }) {
    for (final version in [pendingVersion, lastAcknowledgedVersion]) {
      if (version != null && version <= 0) throw ArgumentError.value(version, 'version', 'Plan versions are positive');
    }
  }

  final CareLinkId careLinkId;
  final int? pendingVersion;
  final int? lastAcknowledgedVersion;
  final bool hasPendingAcknowledgement;
  final DateTime? lastAcknowledgedAt;
}

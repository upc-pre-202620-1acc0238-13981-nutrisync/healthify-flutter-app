import '../valueobject/clinical_values.dart' show PatientId;
import '../valueobject/review_values.dart';

/// A review inbox item: a signal Monitoring raised that **awaits a human decision**. Nothing here has changed a plan
/// (*Signal Notifies Never Modifies The Plan*).
///
/// [legacyEvidence] is the English sentence from the backend (`evidence`): shown only without structured [evidence].
/// [hasPlanProposal]: the AI attached (or is generating) a proposed plan, so the item opens the AI proposal view.
final class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.patientId,
    required this.patientFullName,
    required this.signalType,
    required this.legacyEvidence,
    required this.evidence,
    required this.isOpen,
    required this.resolvedWithAdjustment,
    required this.resolutionNote,
    required this.createdAt,
    required this.resolvedAt,
    required this.hasPlanProposal,
  });

  final ReviewItemId id;
  final PatientId patientId;
  final String? patientFullName;
  final SignalType signalType;
  final String legacyEvidence;
  final ReviewEvidence? evidence;
  final bool isOpen;
  final bool? resolvedWithAdjustment;
  final ResolutionNote? resolutionNote;
  final DateTime? createdAt;
  final DateTime? resolvedAt;
  final bool hasPlanProposal;

  /// Only an open sustained deviation can carry an AI-proposed plan.
  bool get offersPlanProposal => isOpen && hasPlanProposal && signalType is SustainedDeviation;
}

/// Evidence of an item (`ReviewItemResource.evidenceData`). Days without logs **never count**: the denominator is the
/// logged days.
sealed class ReviewEvidence {
  const ReviewEvidence();
}

/// "Logged on average 40 % below their energy target (≈ 718 kcal/day) on 5 of their last 9 logged days".
final class SustainedDeviationEvidence extends ReviewEvidence {
  /// Throws [ArgumentError] if the numbers break an invariant (the mapper then falls back to the legacy sentence).
  SustainedDeviationEvidence({
    required this.averagePercentFromTarget,
    required this.deviatedDays,
    required this.loggedDaysConsidered,
    required this.direction,
    this.averageEnergyKcalFromTarget,
  }) {
    if (averagePercentFromTarget < 0) throw ArgumentError('The percent is unsigned');
    if (loggedDaysConsidered <= 0) throw ArgumentError('A deviation is measured over logged days');
    if (deviatedDays < 1 || deviatedDays > loggedDaysConsidered) {
      throw ArgumentError('Deviated days are a part of the logged days');
    }
    final kcal = averageEnergyKcalFromTarget;
    if (kcal != null && kcal < 0) throw ArgumentError('The kcal are unsigned');
  }

  /// Unsigned: how far it strayed on average (the sign goes in [direction]).
  final double averagePercentFromTarget;
  final int deviatedDays;
  final int loggedDaysConsidered;
  final DeviationDirection direction;

  /// Unsigned kcal/day; `null` on items that predate structured evidence.
  final double? averageEnergyKcalFromTarget;
}

/// "Scheduled review after the Sep 8 adjustment (v3): 2 of 6 logged days off target".
final class ScheduledRecheckEvidence extends ReviewEvidence {
  /// Throws [ArgumentError] if the counts break an invariant.
  ScheduledRecheckEvidence({
    required this.adjustedOn,
    required this.adjustedPlanVersion,
    this.deviatedDays,
    this.loggedDaysConsidered,
  }) {
    if (adjustedPlanVersion <= 0) throw ArgumentError('A plan version is positive');
    if ((deviatedDays == null) != (loggedDaysConsidered == null)) throw ArgumentError('Both counts or none');
    final deviated = deviatedDays;
    final logged = loggedDaysConsidered;
    if (deviated != null && logged != null && (logged < 0 || deviated < 0 || deviated > logged)) {
      throw ArgumentError('Deviated days are a part of the logged days');
    }
  }

  final DateTime adjustedOn;
  final int adjustedPlanVersion;

  /// `null` (both) if there was no summary since the adjustment.
  final int? deviatedDays;
  final int? loggedDaysConsidered;

  bool get hasCounts => deviatedDays != null && loggedDaysConsidered != null;
}

/// "Consistency index: 0.46 kg/week unexplained; on alert since Aug 20 (4 weeks); shown to the patient on Sep 9".
/// Missing parts are left out.
final class ConsistencyEscalationEvidence extends ReviewEvidence {
  /// Throws [ArgumentError] if the index or the weeks are negative.
  ConsistencyEscalationEvidence({required this.kgPerWeek, this.alertSinceOn, this.weeksInAlert, this.shownToPatientOn}) {
    if (kgPerWeek < 0) throw ArgumentError('The index is unsigned');
    final weeks = weeksInAlert;
    if (weeks != null && weeks < 0) throw ArgumentError('Weeks in alert cannot be negative');
  }

  final double kgPerWeek;
  final DateTime? alertSinceOn;
  final int? weeksInAlert;
  final DateTime? shownToPatientOn;
}

/// Note an item was resolved with (`resolutionNoteCode` + `resolutionNoteData`). A note written by the practitioner
/// ([CustomResolutionNote]) is shown as is and never translated.
sealed class ResolutionNote {
  const ResolutionNote();
}

final class PlanAssignedAsIs extends ResolutionNote {
  const PlanAssignedAsIs(this.planVersion);

  final int planVersion;
}

final class PlanAssignedWithEdits extends ResolutionNote {
  const PlanAssignedWithEdits(this.planVersion);

  final int planVersion;
}

final class ProposalDiscarded extends ResolutionNote {
  const ProposalDiscarded();
}

final class CustomResolutionNote extends ResolutionNote {
  /// Throws [ArgumentError] if [text] is blank.
  CustomResolutionNote(this.text) {
    if (text.trim().isEmpty) throw ArgumentError.value(text, 'text', 'A custom note needs text');
  }

  final String text;
}

/// Resolution of a review item (`POST /review-items/{id}/resolution`). **Saying whether the plan was adjusted is
/// required**: without it there is no record of what the signal led to (*Resolution States Whether The Plan Was Adjusted*).
final class ReviewResolution {
  const ReviewResolution._(this.resolvedWithAdjustment, this.note);

  /// `null` if Yes or No was not answered ("Answer Yes or No"). An empty note is not sent.
  static ReviewResolution? of(bool? resolvedWithAdjustment, String? note) {
    if (resolvedWithAdjustment == null) return null;
    final trimmed = note?.trim();
    return ReviewResolution._(resolvedWithAdjustment, trimmed == null || trimmed.isEmpty ? null : trimmed);
  }

  final bool resolvedWithAdjustment;
  final String? note;
}

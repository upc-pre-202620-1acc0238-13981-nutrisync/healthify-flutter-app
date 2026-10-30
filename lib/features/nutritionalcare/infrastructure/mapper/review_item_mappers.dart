import '../../../../core/network/iso_dates.dart';
import '../../domain/entity/plan_proposal.dart';
import '../../domain/entity/review_item.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../../domain/valueobject/review_values.dart';
import '../remote/dto/review_item_dtos.dart';

// ACL for the review inbox. An unreadable required field throws `FormatException` (`apiCall` turns it into
// `Unexpected('MALFORMED_RESPONSE')`); a malformed evidence only drops the structured evidence.

extension ReviewItemMapper on ReviewItemDto {
  ReviewItem toDomain() {
    final type = SignalType.of(signalType);
    final name = patientFullName?.trim();
    return ReviewItem(
      id: ReviewItemId(reviewItemId),
      patientId: PatientId(patientId),
      patientFullName: name == null || name.isEmpty ? null : name,
      signalType: type,
      legacyEvidence: evidence,
      evidence: evidenceData?.toEvidence(type),
      isOpen: ReviewItemStatus.fromCode(state) != ReviewItemStatus.resolved,
      resolvedWithAdjustment: resolvedWithAdjustment,
      resolutionNote: _resolutionNote(),
      createdAt: parseInstantOrNull(createdAt),
      resolvedAt: parseInstantOrNull(resolvedAt),
      hasPlanProposal: hasPlanProposal,
    );
  }

  ResolutionNote? _resolutionNote() {
    final version = resolutionNoteData?.planVersion;
    final trimmed = resolutionNote?.trim();
    final text = trimmed == null || trimmed.isEmpty ? null : trimmed;
    ResolutionNote? custom() => text == null ? null : CustomResolutionNote(text);
    return switch (resolutionNoteCode?.trim()) {
      'PlanAssignedAsIs' => version == null ? custom() : PlanAssignedAsIs(version),
      'PlanAssignedWithEdits' => version == null ? custom() : PlanAssignedWithEdits(version),
      'ProposalDiscarded' => const ProposalDiscarded(),
      // `Custom`, an unknown code or none: the text as is.
      _ => custom(),
    };
  }
}

extension ReviewItemEvidenceMapper on ReviewItemEvidenceDto {
  /// The evidence for [type]; `null` if its fields are missing (falls back to the legacy sentence, never a partial one).
  ReviewEvidence? toEvidence(SignalType type) {
    try {
      switch (type) {
        case SustainedDeviation():
          final percent = averagePercentFromTarget;
          final deviated = deviatedDays;
          final logged = loggedDaysConsidered;
          // The direction comes in `direction`; if missing, the sign of the percentage gives it.
          final sense =
              DeviationDirection.fromCode(direction) ??
              (percent == null ? null : (percent < 0 ? DeviationDirection.below : DeviationDirection.above));
          if (percent == null || deviated == null || logged == null || sense == null) return null;
          return SustainedDeviationEvidence(
            averagePercentFromTarget: percent.abs(),
            deviatedDays: deviated,
            loggedDaysConsidered: logged,
            direction: sense,
            averageEnergyKcalFromTarget: averageEnergyKcalFromTarget?.abs(),
          );
        case ScheduledRecheck():
          final date = parseLocalDateOrNull(adjustedOn);
          final version = adjustedPlanVersion;
          if (date == null || version == null) return null;
          final bothCounts = deviatedDays != null && loggedDaysConsidered != null;
          return ScheduledRecheckEvidence(
            adjustedOn: date,
            adjustedPlanVersion: version,
            deviatedDays: bothCounts ? deviatedDays : null,
            loggedDaysConsidered: bothCounts ? loggedDaysConsidered : null,
          );
        case ConsistencyEscalation():
          final index = consistencyKgPerWeek;
          if (index == null) return null;
          return ConsistencyEscalationEvidence(
            kgPerWeek: index.abs(),
            alertSinceOn: parseLocalDateOrNull(alertSinceOn),
            weeksInAlert: weeksInAlert,
            shownToPatientOn: parseLocalDateOrNull(shownToPatientOn),
          );
        case CustomSignal():
          return null;
      }
    } on ArgumentError {
      // Numbers that break an invariant (e.g. more deviated days than logged ones): the legacy sentence is better.
      return null;
    }
  }
}

extension ReviewResolutionMapper on ReviewResolution {
  ResolveReviewItemRequestDto toDto() =>
      ResolveReviewItemRequestDto(resolvedWithAdjustment: resolvedWithAdjustment, resolutionNote: note);
}

extension PlanAdjustmentProposalMapper on PlanAdjustmentProposalDto {
  /// A guideline this version does not know is left out (the AI can only return catalog codes).
  PlanAdjustmentProposal toDomain() => PlanAdjustmentProposal(
    reviewItemId: ReviewItemId(reviewItemId),
    title: title.trim(),
    currentEnergyKcal: currentEnergyKcal,
    proposed: Targets(
      energyKcal: proposedEnergyKcal,
      proteinG: proposedProteinG,
      carbG: proposedCarbG,
      fatG: proposedFatG,
    ),
    addedGuidelines: addedGuidelines.map(PlanGuidelineCode.fromCode).nonNulls.toList(),
    removedGuidelines: removedGuidelines.map(PlanGuidelineCode.fromCode).nonNulls.toList(),
    patientMessage: patientMessage.trim(),
    recheckAfterDays: recheckAfterDays,
    rationale: rationale.trim(),
    generatedAt: parseInstantOrNull(generatedAt) ?? (throw const FormatException('generatedAt is not a date')),
    status: PlanProposalStatus.fromCode(status),
  );
}

extension PlanAcceptanceMapper on PlanAcceptance {
  AcceptPlanProposalRequestDto toDto() => switch (this) {
    AcceptAsIs() => const AcceptPlanProposalRequestDto(asIs: true),
    AcceptWithEdits(:final edits) => AcceptPlanProposalRequestDto(
      asIs: false,
      energyKcal: edits.targets.energyKcal,
      proteinG: edits.targets.proteinG,
      carbG: edits.targets.carbG,
      fatG: edits.targets.fatG,
      // Catalog order, as the backend expects the list.
      guidelines: [for (final code in PlanGuidelineCode.values) if (edits.guidelines.contains(code)) code.code],
      patientMessage: edits.patientMessage?.text.trim(),
    ),
  };
}

extension PlanProposalAcceptanceMapper on PlanProposalAcceptanceDto {
  AcceptedProposal toDomain() => AcceptedProposal(reviewItem.toDomain(), planVersion.version);
}

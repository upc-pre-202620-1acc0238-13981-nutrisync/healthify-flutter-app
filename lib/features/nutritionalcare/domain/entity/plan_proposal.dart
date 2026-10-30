import '../valueobject/clinical_codes.dart';
import '../valueobject/clinical_values.dart';
import '../valueobject/review_values.dart';
import 'plan_history.dart';
import 'review_item.dart';

/// Where a proposal ended up (`PlanProposalStatus`). Only [proposed] can be accepted.
enum PlanProposalStatus {
  proposed('Proposed'),
  acceptedAsIs('AcceptedAsIs'),
  acceptedWithEdits('AcceptedWithEdits'),
  dismissed('Dismissed');

  const PlanProposalStatus(this.code);

  final String code;

  /// An unknown status reads as decided: the app never offers to accept something it does not understand.
  static PlanProposalStatus fromCode(String? code) {
    final normalized = code?.trim().toLowerCase();
    for (final status in values) {
      if (status.code.toLowerCase() == normalized) return status;
    }
    return dismissed;
  }
}

/// Plan the AI proposes after a sustained deviation (`PlanAdjustmentProposalResource`). Reading it never changes the
/// plan: the only way to a new version is for the practitioner to accept it.
///
/// [title] and [rationale] come in the practitioner's language; [patientMessage] in the patient's. [addedGuidelines] and
/// [removedGuidelines] are codes from the closed catalog (the AI cannot return others).
final class PlanAdjustmentProposal {
  /// Throws [ArgumentError] if the title is blank or the recheck is not in the future.
  PlanAdjustmentProposal({
    required this.reviewItemId,
    required this.title,
    required this.currentEnergyKcal,
    required this.proposed,
    required this.addedGuidelines,
    required this.removedGuidelines,
    required this.patientMessage,
    required this.recheckAfterDays,
    required this.rationale,
    required this.generatedAt,
    required this.status,
  }) {
    if (title.trim().isEmpty) throw ArgumentError.value(title, 'title', 'A proposal has a title');
    if (recheckAfterDays <= 0) throw ArgumentError.value(recheckAfterDays, 'recheckAfterDays', 'The recheck is in the future');
  }

  final ReviewItemId reviewItemId;
  final String title;
  final double? currentEnergyKcal;
  final Targets proposed;
  final List<PlanGuidelineCode> addedGuidelines;
  final List<PlanGuidelineCode> removedGuidelines;
  final String patientMessage;
  final int recheckAfterDays;
  final String rationale;
  final DateTime generatedAt;
  final PlanProposalStatus status;

  bool get canBeAccepted => status == PlanProposalStatus.proposed;

  /// Catalog guidelines the version ends up with if accepted as is: the current ones minus the removed plus the added
  /// (the practitioner's custom ones are always kept by the backend and are not edited here).
  Set<PlanGuidelineCode> resultingGuidelines(Iterable<PlanGuidelineCode> current) => {
    ...current.where((code) => !removedGuidelines.contains(code)),
    ...addedGuidelines,
  };
}

/// What `GET /review-items/{id}/plan-proposal` returns.
sealed class PlanProposalLookup {
  const PlanProposalLookup();
}

final class ProposalReady extends PlanProposalLookup {
  const ProposalReady(this.proposal);

  final PlanAdjustmentProposal proposal;
}

/// `202` + `Retry-After`: being generated.
final class ProposalGenerating extends PlanProposalLookup {
  /// Throws [ArgumentError] if [retryAfterSeconds] is not positive.
  ProposalGenerating(this.retryAfterSeconds) {
    if (retryAfterSeconds <= 0) throw ArgumentError.value(retryAfterSeconds, 'retryAfterSeconds', 'Retry-After is positive');
  }

  final int retryAfterSeconds;
}

/// `404`: no proposal (AI off, no consent, provider down or output rejected) -> the item opens without AI.
final class NoProposal extends PlanProposalLookup {
  const NoProposal();
}

/// "Resolve" on the AI proposal (as is) or "Assign adjusted plan" when adjusting it (with edits).
sealed class PlanAcceptance {
  const PlanAcceptance();
}

final class AcceptAsIs extends PlanAcceptance {
  const AcceptAsIs();
}

final class AcceptWithEdits extends PlanAcceptance {
  const AcceptWithEdits(this.edits);

  final ProposalEdits edits;
}

/// Edits made when adjusting the AI proposal. Only the backend checks them against the calorie floor
/// (`422 PlanProposalOutOfSafetyBounds`); here the targets must be positive, the minimum the backend accepts.
///
/// [guidelines] is the **complete** list of catalog guidelines the practitioner keeps.
final class ProposalEdits {
  /// Throws [ArgumentError] if a macro is not positive.
  ProposalEdits({required this.targets, required this.guidelines, required this.patientMessage}) {
    if (targets.proteinG <= 0 || targets.carbG <= 0 || targets.fatG <= 0) {
      throw ArgumentError('Edited macros must be positive');
    }
  }

  final Targets targets;
  final Set<PlanGuidelineCode> guidelines;
  final PatientMessage? patientMessage;
}

/// The item is resolved and version [planVersion] is the current one (`PlanProposalAcceptanceResource`).
final class AcceptedProposal {
  const AcceptedProposal(this.reviewItem, this.planVersion);

  final ReviewItem reviewItem;
  final int planVersion;
}

/// A field of the adjust form with an invalid value.
enum ProposalEditField { energy, protein, carb, fat, message }

/// Validation of the adjust form (fail fast before sending).
sealed class ProposalEditValidation {
  const ProposalEditValidation();

  static ProposalEditValidation of({
    required String energyText,
    required String proteinText,
    required String carbText,
    required String fatText,
    required Set<PlanGuidelineCode> guidelines,
    required String message,
  }) {
    final energy = parsePositive(energyText);
    final protein = parsePositive(proteinText);
    final carb = parsePositive(carbText);
    final fat = parsePositive(fatText);
    final trimmedMessage = message.trim();
    final invalid = <ProposalEditField>{
      if (energy == null) ProposalEditField.energy,
      if (protein == null) ProposalEditField.protein,
      if (carb == null) ProposalEditField.carb,
      if (fat == null) ProposalEditField.fat,
      if (trimmedMessage.length > PatientMessage.maxLength) ProposalEditField.message,
    };
    if (invalid.isNotEmpty || energy == null || protein == null || carb == null || fat == null) {
      return InvalidProposalEdits(invalid);
    }
    return ValidProposalEdits(
      ProposalEdits(
        targets: Targets(energyKcal: energy, proteinG: protein, carbG: carb, fatG: fat),
        guidelines: guidelines,
        patientMessage: PatientMessage.ofOptional(trimmedMessage),
      ),
    );
  }

  /// "1 650", "1650", "62,5" or "62.5"; `null` if it is not a positive number.
  static double? parsePositive(String text) {
    final normalized = text.replaceAll(RegExp(r'[\s  ]'), '').replaceAll(',', '.');
    final value = double.tryParse(normalized);
    return value != null && value > 0 && value.isFinite ? value : null;
  }
}

final class ValidProposalEdits extends ProposalEditValidation {
  const ValidProposalEdits(this.edits);

  final ProposalEdits edits;
}

final class InvalidProposalEdits extends ProposalEditValidation {
  const InvalidProposalEdits(this.fields);

  final Set<ProposalEditField> fields;
}

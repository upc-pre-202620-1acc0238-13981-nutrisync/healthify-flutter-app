import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/plan_proposal.dart';
import '../../domain/entity/review_item.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/review_values.dart';

part 'review_states.freezed.dart';

/// An inbox row: "Ana Flores · sustained deviation" and "Received on Sep 8, 2026".
@freezed
abstract class InboxRow with _$InboxRow {
  const factory InboxRow({
    required int id,
    required String? patientName,
    required SignalType signal,
    required DateTime? receivedAt,
  }) = _InboxRow;

  factory InboxRow.of(ReviewItem item) => InboxRow(
    id: item.id.value,
    patientName: item.patientFullName,
    signal: item.signalType,
    receivedAt: item.createdAt,
  );
}

/// Review inbox (plus the all-caught-up state; the "Signal resolved" snackbar is shown by the shell). `items == null` =
/// not read yet. The inbox is not stored on the phone: offline with no previous read -> offline state.
@freezed
abstract class ReviewInboxState with _$ReviewInboxState {
  const ReviewInboxState._();

  const factory ReviewInboxState({
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    List<InboxRow>? items,
  }) = _ReviewInboxState;

  bool get isEmpty => items?.isEmpty ?? false;
  bool get needsConnection => items == null && loadFailed && isOffline;
}

/// The AI proposal of a review item.
sealed class ProposalSection {
  const ProposalSection();
}

/// The item offers no proposal (another signal, or `404`): the plain review item.
final class ProposalNotOffered extends ProposalSection {
  const ProposalNotOffered();
}

/// `202`: the AI is preparing it (retried automatically).
final class ProposalPreparing extends ProposalSection {
  const ProposalPreparing();
}

final class ProposalLoaded extends ProposalSection {
  const ProposalLoaded(this.proposal);

  final PlanAdjustmentProposal proposal;
}

/// Why the item could not be opened.
enum ReviewLoadError { notAvailable, offline, generic }

/// Notices of the review item, AI proposal and adjust screens (copy from the design notes).
enum ReviewDialog {
  /// `404 ReviewItemNotFound`: "This item is no longer available."
  notAvailable,

  /// `409 PlanProposalAlreadyDecided`: "This item was already resolved."
  alreadyResolved,

  /// `403 ActiveCareLinkRequired` or no link in the caseload.
  noActiveLink,

  /// `409 PlanVersionAlreadySuperseded`: the current plan changed during the review.
  planChanged,

  /// Offline, 5xx or unexpected response: "Retry".
  serverError,
}

/// Resolve item (plus "Answer Yes or No") and the AI-proposed plan. "Resolve" without a proposal sends the resolution;
/// "Resolve" with a proposal assigns the plan as is. "Resolve without assigning this plan" shows the plain resolution
/// form (the proposal is discarded and the plan does not change).
@freezed
abstract class ReviewItemState with _$ReviewItemState {
  const ReviewItemState._();

  const factory ReviewItemState({
    @Default(true) bool isLoading,
    ReviewLoadError? loadError,
    ReviewItem? item,
    @Default(ProposalNotOffered()) ProposalSection proposal,
    @Default(false) bool showManualResolution,
    bool? adjusted,
    @Default('') String note,
    @Default(false) bool showOutcomeError,
    @Default(false) bool isResolving,
    @Default(false) bool isAccepting,
    @Default(false) bool isOpeningPatient,
    @Default(false) bool isOffline,
    ReviewDialog? dialog,
  }) = _ReviewItemState;

  /// The Yes/No + note form (no proposal, or when choosing to resolve without assigning it).
  bool get showsResolutionForm => item != null && (proposal is ProposalNotOffered || showManualResolution);

  bool get isBusy => isResolving || isAccepting || isOpeningPatient;
}

/// Adjust the proposed plan: everything comes prefilled from the proposal.
@freezed
abstract class AdjustProposalState with _$AdjustProposalState {
  const factory AdjustProposalState({
    @Default(true) bool isLoading,
    ReviewLoadError? loadError,
    String? patientFirstName,
    double? previousEnergyKcal,
    @Default('') String energy,
    @Default('') String protein,
    @Default('') String carb,
    @Default('') String fat,
    @Default(<PlanGuidelineCode>{}) Set<PlanGuidelineCode> guidelines,
    @Default('') String message,
    @Default(<ProposalEditField>{}) Set<ProposalEditField> invalidFields,

    /// `422 PlanProposalOutOfSafetyBounds`: the energy falls below the patient's calorie floor.
    @Default(false) bool belowSafetyFloor,
    @Default(false) bool isAssigning,
    @Default(false) bool isOffline,
    ReviewDialog? dialog,
  }) = _AdjustProposalState;
}

/// What the review item screen asks of its host.
sealed class ReviewItemEvent {
  const ReviewItemEvent();
}

/// Resolved (with or without an assigned plan): back to the inbox with "Signal resolved".
final class ReviewResolved extends ReviewItemEvent {
  const ReviewResolved(this.patientName);

  final String? patientName;
}

/// "Adjust" on the AI proposal -> the adjust screen.
final class OpenAdjust extends ReviewItemEvent {
  const OpenAdjust(this.reviewItemId);

  final int reviewItemId;
}

/// "Adjust the plan now": the patient file, as a separate action (never automatic).
final class OpenPatientFile extends ReviewItemEvent {
  const OpenPatientFile({required this.patientId, required this.careLinkId, required this.patientName});

  final int patientId;
  final int careLinkId;
  final String patientName;
}

/// The item is gone: back to the inbox, which is reread.
final class CloseReviewItem extends ReviewItemEvent {
  const CloseReviewItem();
}

/// What the adjust screen asks of its host.
sealed class AdjustProposalEvent {
  const AdjustProposalEvent();
}

/// Adjusted plan assigned: back to the inbox with "Signal resolved".
final class ProposalAssigned extends AdjustProposalEvent {
  const ProposalAssigned(this.patientName);

  final String? patientName;
}

/// The item or proposal is gone: back to the inbox.
final class CloseAdjustProposal extends AdjustProposalEvent {
  const CloseAdjustProposal();
}

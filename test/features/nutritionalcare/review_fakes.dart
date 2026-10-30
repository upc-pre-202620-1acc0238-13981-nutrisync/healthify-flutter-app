import 'dart:async';

import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_history.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_proposal.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/review_item.dart';
import 'package:healthify/features/nutritionalcare/domain/repository/review_inbox_repository.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/review_values.dart';

ReviewItem reviewItem({
  int id = 1,
  int patientId = 1,
  String? name = 'Ana Flores',
  SignalType signal = const SustainedDeviation(),
  bool hasPlanProposal = false,
  bool isOpen = true,
  ReviewEvidence? evidence,
  bool structured = true,
  String legacy = 'Logged 40% below target.',
}) => ReviewItem(
  id: ReviewItemId(id),
  patientId: PatientId(patientId),
  patientFullName: name,
  signalType: signal,
  legacyEvidence: legacy,
  evidence: !structured
      ? null
      : evidence ??
            SustainedDeviationEvidence(
              averagePercentFromTarget: 40,
              deviatedDays: 5,
              loggedDaysConsidered: 9,
              direction: DeviationDirection.below,
              averageEnergyKcalFromTarget: 718,
            ),
  isOpen: isOpen,
  resolvedWithAdjustment: null,
  resolutionNote: null,
  createdAt: DateTime.utc(2026, 9, 8, 15),
  resolvedAt: null,
  hasPlanProposal: hasPlanProposal,
);

PlanAdjustmentProposal proposal({
  int reviewItemId = 1,
  PlanProposalStatus status = PlanProposalStatus.proposed,
  List<PlanGuidelineCode> added = const [PlanGuidelineCode.proteinAndVegetablesAtDinner],
  List<PlanGuidelineCode> removed = const [PlanGuidelineCode.reduceSalt],
}) => PlanAdjustmentProposal(
  reviewItemId: ReviewItemId(reviewItemId),
  title: 'Ajustar la energía y reforzar las cenas',
  currentEnergyKcal: 1796,
  proposed: Targets(energyKcal: 1650, proteinG: 119, carbG: 170, fatG: 55),
  addedGuidelines: added,
  removedGuidelines: removed,
  patientMessage: 'Notamos que tus cenas son más ligeras.',
  recheckAfterDays: 7,
  rationale: 'Registra menos energía en la cena.',
  generatedAt: DateTime.utc(2026, 9, 8, 16),
  status: status,
);

class FakeReviewInboxRepository implements ReviewInboxRepository {
  Result<List<ReviewItem>> itemsResult = Result.success([reviewItem()]);
  Result<ReviewItem> resolveResult = Result.success(reviewItem(isOpen: false));
  Result<AcceptedProposal> acceptResult = Result.success(AcceptedProposal(reviewItem(isOpen: false), 4));

  /// Answers of `getPlanProposal`, in order; the last one repeats.
  final proposalAnswers = <Result<PlanProposalLookup>>[const Result.success(NoProposal())];

  /// Completes the next `getItems` call by hand, to test answers that arrive out of order.
  Completer<Result<List<ReviewItem>>>? itemsGate;

  int itemsCalls = 0;
  int proposalCalls = 0;
  final states = <ReviewItemStatus>[];
  final resolutions = <(int, ReviewResolution)>[];
  final acceptances = <(int, PlanAcceptance)>[];

  @override
  Future<Result<List<ReviewItem>>> getItems(ReviewItemStatus state) async {
    itemsCalls++;
    states.add(state);
    final gate = itemsGate;
    if (gate != null) {
      itemsGate = null;
      return gate.future;
    }
    return itemsResult;
  }

  @override
  Future<Result<ReviewItem>> resolve(ReviewItemId id, ReviewResolution resolution) async {
    resolutions.add((id.value, resolution));
    return resolveResult;
  }

  @override
  Future<Result<PlanProposalLookup>> getPlanProposal(ReviewItemId id) async {
    final index = proposalCalls < proposalAnswers.length ? proposalCalls : proposalAnswers.length - 1;
    proposalCalls++;
    return proposalAnswers[index];
  }

  @override
  Future<Result<AcceptedProposal>> acceptPlanProposal(ReviewItemId id, PlanAcceptance acceptance) async {
    acceptances.add((id.value, acceptance));
    return acceptResult;
  }
}

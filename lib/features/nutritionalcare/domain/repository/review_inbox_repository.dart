import '../../../../core/common/error/result.dart';
import '../entity/plan_proposal.dart';
import '../entity/review_item.dart';
import '../valueobject/review_values.dart';

/// Review inbox of the signed-in nutritionist. Not stored on the phone: offline it shows the offline state.
abstract interface class ReviewInboxRepository {
  /// `GET /review-items?state=` · the nutritionist's own inbox items, newest first.
  Future<Result<List<ReviewItem>>> getItems(ReviewItemStatus state);

  /// `POST /review-items/{id}/resolution`. `400 ResolutionOutcomeRequired` without Yes/No, `404 ReviewItemNotFound` if it
  /// does not exist or was already resolved. A pending AI proposal is discarded and the plan does not change.
  Future<Result<ReviewItem>> resolve(ReviewItemId id, ReviewResolution resolution);

  /// `GET /review-items/{id}/plan-proposal`: `200` ready, `202` + `Retry-After` generating, `404` no proposal.
  Future<Result<PlanProposalLookup>> getPlanProposal(ReviewItemId id);

  /// `POST /review-items/{id}/plan-proposal/acceptance`: creates the adjusted version and resolves the item at once.
  Future<Result<AcceptedProposal>> acceptPlanProposal(ReviewItemId id, PlanAcceptance acceptance);
}

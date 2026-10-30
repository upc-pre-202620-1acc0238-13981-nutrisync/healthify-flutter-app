import '../../../../core/common/error/result.dart';
import '../../domain/entity/plan_proposal.dart';
import '../../domain/entity/review_item.dart';
import '../../domain/repository/review_inbox_repository.dart';
import '../../domain/valueobject/review_values.dart';

/// The open inbox items (`?state=Open`).
class GetOpenReviewItemsUseCase {
  const GetOpenReviewItemsUseCase(this._repository);

  final ReviewInboxRepository _repository;

  Future<Result<List<ReviewItem>>> call() => _repository.getItems(ReviewItemStatus.open);
}

/// One open item. There is no `GET /review-items/{id}`: it is looked up in the open inbox; `null` if it is gone
/// (resolved or nonexistent -> "This item is no longer available.").
class GetOpenReviewItemUseCase {
  const GetOpenReviewItemUseCase(this._repository);

  final ReviewInboxRepository _repository;

  Future<Result<ReviewItem?>> call(int id) async {
    final result = await _repository.getItems(ReviewItemStatus.open);
    return result.map((items) {
      for (final item in items) {
        if (item.id.value == id) return item;
      }
      return null;
    });
  }
}

/// "Resolve": requires saying whether the plan was adjusted (the rule lives in [ReviewResolution]).
class ResolveReviewItemUseCase {
  const ResolveReviewItemUseCase(this._repository);

  final ReviewInboxRepository _repository;

  Future<Result<ReviewItem>> call(int id, ReviewResolution resolution) => _repository.resolve(ReviewItemId(id), resolution);
}

/// Waits for the AI proposal: emits [ProposalGenerating] while the backend answers `202` and retries after
/// `Retry-After`, up to [maxAttempts] reads. Ends with the proposal, with [NoProposal] (`404`, or when attempts run out:
/// the item opens without AI) or with the network/server failure.
class AwaitPlanProposalUseCase {
  const AwaitPlanProposalUseCase(this._repository, {this._wait = _defaultWait});

  static const defaultMaxAttempts = 6;

  final ReviewInboxRepository _repository;
  final Future<void> Function(Duration) _wait;

  static Future<void> _defaultWait(Duration duration) => Future<void>.delayed(duration);

  Stream<Result<PlanProposalLookup>> call(int id, {int maxAttempts = defaultMaxAttempts}) async* {
    if (maxAttempts <= 0) throw ArgumentError.value(maxAttempts, 'maxAttempts', 'At least one attempt');
    final itemId = ReviewItemId(id);
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final result = await _repository.getPlanProposal(itemId);
      yield result;
      final lookup = result.valueOrNull;
      if (lookup is! ProposalGenerating) return;
      if (attempt < maxAttempts - 1) await _wait(Duration(seconds: lookup.retryAfterSeconds));
    }
    // If it is still generating after ~30 s, the item opens without AI (it can be resolved all the same).
    yield const Result.success(NoProposal());
  }
}

/// "Resolve" (as is) and "Assign adjusted plan" (with edits).
class AcceptPlanProposalUseCase {
  const AcceptPlanProposalUseCase(this._repository);

  final ReviewInboxRepository _repository;

  Future<Result<AcceptedProposal>> call(int id, PlanAcceptance acceptance) =>
      _repository.acceptPlanProposal(ReviewItemId(id), acceptance);
}

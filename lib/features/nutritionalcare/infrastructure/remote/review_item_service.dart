import '../../../../core/network/api_client.dart';
import 'dto/review_item_dtos.dart';

/// The nutritionist's review inbox.
class ReviewItemService {
  const ReviewItemService(this._api);

  final ApiClient _api;

  Future<List<ReviewItemDto>> getItems(String state) async {
    final json = await _api.get('review-items', query: {'state': state}) as List<dynamic>;
    return [for (final item in json) ReviewItemDto.fromJson(item as Map<String, dynamic>)];
  }

  Future<ReviewItemDto> resolve(int reviewItemId, ResolveReviewItemRequestDto body) async => ReviewItemDto.fromJson(
    await _api.post('review-items/$reviewItemId/resolution', body: body.toJson()) as Map<String, dynamic>,
  );

  /// `200` with the proposal or `202` + `Retry-After` (a ProblemDetails body without a code) while generating: the raw
  /// response is returned and the repository decides by status.
  Future<ApiResponse> getPlanProposal(int reviewItemId) => _api.getResponse('review-items/$reviewItemId/plan-proposal');

  Future<PlanProposalAcceptanceDto> acceptPlanProposal(int reviewItemId, AcceptPlanProposalRequestDto body) async =>
      PlanProposalAcceptanceDto.fromJson(
        await _api.post('review-items/$reviewItemId/plan-proposal/acceptance', body: body.toJson())
            as Map<String, dynamic>,
      );
}

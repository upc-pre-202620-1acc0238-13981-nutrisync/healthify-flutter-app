import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/error/result.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entity/plan_proposal.dart';
import '../../domain/entity/review_item.dart';
import '../../domain/repository/review_inbox_repository.dart';
import '../../domain/valueobject/review_values.dart';
import '../mapper/review_item_mappers.dart';
import '../remote/dto/review_item_dtos.dart';
import '../remote/review_item_service.dart';

const _planProposalNotFound = 'PlanProposalNotFound';
const _defaultRetryAfterSeconds = 5;

/// Mappers run inside `apiCall`: an unreadable response becomes `Unexpected('MALFORMED_RESPONSE')`.
class ReviewInboxRepositoryImpl implements ReviewInboxRepository {
  const ReviewInboxRepositoryImpl(this._service);

  final ReviewItemService _service;

  @override
  Future<Result<List<ReviewItem>>> getItems(ReviewItemStatus state) =>
      apiCall(() async => [for (final dto in await _service.getItems(state.code)) dto.toDomain()]);

  @override
  Future<Result<ReviewItem>> resolve(ReviewItemId id, ReviewResolution resolution) =>
      apiCall(() async => (await _service.resolve(id.value, resolution.toDto())).toDomain());

  @override
  Future<Result<PlanProposalLookup>> getPlanProposal(ReviewItemId id) async {
    final result = await apiCall<PlanProposalLookup>(() async {
      final response = await _service.getPlanProposal(id.value);
      if (response.statusCode == 202) {
        final seconds = int.tryParse(response.header('Retry-After')?.trim() ?? '');
        return ProposalGenerating(seconds != null && seconds > 0 ? seconds : _defaultRetryAfterSeconds);
      }
      final body = response.body;
      if (body is! Map<String, dynamic>) throw const FormatException('Empty proposal');
      return ProposalReady(PlanAdjustmentProposalDto.fromJson(body).toDomain());
    });
    // 404 PlanProposalNotFound = no proposal: the item opens without AI. Another 404 (item gone) is an error.
    final error = result.errorOrNull;
    if (error is NotFound && error.code == _planProposalNotFound) return const Result.success(NoProposal());
    return result;
  }

  @override
  Future<Result<AcceptedProposal>> acceptPlanProposal(ReviewItemId id, PlanAcceptance acceptance) =>
      apiCall(() async => (await _service.acceptPlanProposal(id.value, acceptance.toDto())).toDomain());
}

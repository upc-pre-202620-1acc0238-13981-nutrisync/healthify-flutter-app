import '../../../../core/common/error/result.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entity/new_local_food.dart';
import '../../domain/entity/reference_food.dart';
import '../../domain/repository/reference_food_repository.dart';
import '../../domain/valueobject/food_search_term.dart';
import '../mapper/reference_food_mappers.dart';
import '../remote/reference_food_service.dart';

/// Mappers run inside `apiCall`: an unreadable response becomes `Unexpected('MALFORMED_RESPONSE')`.
class ReferenceFoodRepositoryImpl implements ReferenceFoodRepository {
  const ReferenceFoodRepositoryImpl(this._service);

  final ReferenceFoodService _service;

  @override
  Future<Result<List<ReferenceFood>>> browseCatalog(FoodSearchTerm? term) => apiCall(
    () async =>
        (await _service.search(term?.value ?? '', ReferenceFoodRepository.maxResults)).toDomainSkippingInvalid(),
  );

  @override
  Future<Result<ReferenceFood>> createLocalFood(NewLocalFood food) =>
      apiCall(() async => (await _service.createLocalOverride(food.toDto())).toDomain());
}

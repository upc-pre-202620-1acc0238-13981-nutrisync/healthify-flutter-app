import '../../../../core/common/error/result.dart';
import '../../domain/entity/new_local_food.dart';
import '../../domain/entity/reference_food.dart';
import '../../domain/repository/reference_food_repository.dart';
import '../../domain/valueobject/food_search_term.dart';

/// Searches the server catalog. Text shorter than 2 characters lists the catalog unfiltered.
class BrowseFoodCatalogUseCase {
  const BrowseFoodCatalogUseCase(this._repository);

  final ReferenceFoodRepository _repository;

  Future<Result<List<ReferenceFood>>> call(String query) => _repository.browseCatalog(FoodSearchTerm.of(query));
}

/// "Save food".
class CreateLocalFoodUseCase {
  const CreateLocalFoodUseCase(this._repository);

  final ReferenceFoodRepository _repository;

  Future<Result<ReferenceFood>> call(NewLocalFood food) => _repository.createLocalFood(food);
}

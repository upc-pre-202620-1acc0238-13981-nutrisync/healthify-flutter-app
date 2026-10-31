import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/foodcatalog/domain/entity/new_local_food.dart';
import 'package:healthify/features/foodcatalog/domain/entity/reference_food.dart';
import 'package:healthify/features/foodcatalog/domain/repository/reference_food_repository.dart';
import 'package:healthify/features/foodcatalog/domain/valueobject/food_search_term.dart';
import 'package:healthify/features/foodcatalog/domain/valueobject/reference_food_id.dart';

ReferenceFood referenceFood(int id, String name, {bool override = false, double kcal = 120}) => ReferenceFood(
  id: ReferenceFoodId(id),
  name: name,
  energyKcalPer100g: kcal,
  proteinGPer100g: 4,
  carbGPer100g: 20,
  fatGPer100g: 2,
  isLocalOverride: override,
);

class FakeReferenceFoodRepository implements ReferenceFoodRepository {
  /// What [browseCatalog] answers.
  Result<List<ReferenceFood>> remote = const Result.success([]);

  /// `null` = success: the created food echoes the request (marked as local).
  Result<ReferenceFood>? createResult;

  final browsedTerms = <String?>[];
  final created = <NewLocalFood>[];

  @override
  Future<Result<List<ReferenceFood>>> browseCatalog(FoodSearchTerm? term) async {
    browsedTerms.add(term?.value);
    return remote;
  }

  @override
  Future<Result<ReferenceFood>> createLocalFood(NewLocalFood food) async {
    created.add(food);
    return createResult ??
        Result.success(
          ReferenceFood(
            id: ReferenceFoodId(77),
            name: food.name,
            energyKcalPer100g: food.energyKcalPer100g,
            proteinGPer100g: food.proteinGPer100g,
            carbGPer100g: food.carbGPer100g,
            fatGPer100g: food.fatGPer100g,
            isLocalOverride: true,
          ),
        );
  }
}

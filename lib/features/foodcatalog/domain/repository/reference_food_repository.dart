import '../../../../core/common/error/result.dart';
import '../entity/new_local_food.dart';
import '../entity/reference_food.dart';
import '../valueobject/food_search_term.dart';

/// The nutritionist's food catalog management. Nothing is stored on the phone (the patient's offline copy is not part
/// of this app).
abstract interface class ReferenceFoodRepository {
  /// Maximum number of results shown (the same `max` requested from the server).
  static const maxResults = 25;

  /// `GET /reference-foods?query=&max=25`. [term] `null` = no text: the server lists its local catalog (local foods
  /// first).
  Future<Result<List<ReferenceFood>>> browseCatalog(FoodSearchTerm? term);

  /// `POST /reference-foods/local-overrides` (nutritionist only). `400 LocalNameAndNutrientsRequired`, and
  /// `409 DuplicatedLocalOverride` if a local food with that name already exists.
  Future<Result<ReferenceFood>> createLocalFood(NewLocalFood food);
}

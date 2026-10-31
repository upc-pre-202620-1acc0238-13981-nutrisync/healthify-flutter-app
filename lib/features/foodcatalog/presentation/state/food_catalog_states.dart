import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/new_local_food.dart';
import '../../domain/entity/reference_food.dart';

part 'food_catalog_states.freezed.dart';

/// A catalog row: "Cuy al horno (local)" · "176 kcal / 100 g".
@freezed
abstract class FoodRow with _$FoodRow {
  const factory FoodRow({
    required int id,
    required String name,
    required double energyKcalPer100g,
    required bool isLocal,
  }) = _FoodRow;

  factory FoodRow.of(ReferenceFood food) => FoodRow(
    id: food.id.value,
    name: food.name,
    energyKcalPer100g: food.energyKcalPer100g,
    isLocal: food.isLocalOverride,
  );
}

/// Food catalog. Catalog management does not work offline: offline and without a previous read the offline state
/// shows. `results == null` = not read yet.
@freezed
abstract class FoodCatalogState with _$FoodCatalogState {
  const FoodCatalogState._();

  const factory FoodCatalogState({
    @Default('') String query,
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    List<FoodRow>? results,
  }) = _FoodCatalogState;

  bool get isEmpty => results?.isEmpty ?? false;
  bool get needsConnection => results == null && loadFailed && isOffline;
}

/// Add local food.
///
/// [duplicatedName]: `409 DuplicatedLocalOverride` ("A local food with this name already exists").
@freezed
abstract class AddLocalFoodState with _$AddLocalFoodState {
  const factory AddLocalFoodState({
    @Default('') String name,
    @Default('') String energy,
    @Default('') String protein,
    @Default('') String carb,
    @Default('') String fat,
    @Default(<LocalFoodField>{}) Set<LocalFoodField> invalidFields,
    @Default(false) bool duplicatedName,
    @Default(false) bool isSaving,
    @Default(false) bool showServerError,
    @Default(false) bool isOffline,
  }) = _AddLocalFoodState;
}

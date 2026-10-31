import '../../domain/entity/new_local_food.dart';
import '../../domain/entity/reference_food.dart';
import '../../domain/valueobject/reference_food_id.dart';
import '../remote/dto/reference_food_dtos.dart';

extension ReferenceFoodMapper on ReferenceFoodDto {
  /// Throws [ArgumentError] if the resource breaks an invariant (id ≤ 0, blank name, nutrient < 0).
  ReferenceFood toDomain() => ReferenceFood(
    id: ReferenceFoodId(referenceFoodId),
    name: localName.trim(),
    energyKcalPer100g: energyKcalPer100g,
    proteinGPer100g: proteinGPer100g,
    carbGPer100g: carbGPer100g,
    fatGPer100g: fatGPer100g,
    isLocalOverride: isLocalOverride,
  );
}

extension ReferenceFoodListMapper on List<ReferenceFoodDto> {
  /// Invalid resources are dropped: one broken food does not stop the rest from showing.
  List<ReferenceFood> toDomainSkippingInvalid() {
    final foods = <ReferenceFood>[];
    for (final dto in this) {
      try {
        foods.add(dto.toDomain());
      } on ArgumentError {
        continue;
      }
    }
    return foods;
  }
}

extension NewLocalFoodMapper on NewLocalFood {
  CreateLocalOverrideRequestDto toDto() => CreateLocalOverrideRequestDto(
    localName: name.trim(),
    energyKcalPer100g: energyKcalPer100g,
    proteinGPer100g: proteinGPer100g,
    carbGPer100g: carbGPer100g,
    fatGPer100g: fatGPer100g,
  );
}

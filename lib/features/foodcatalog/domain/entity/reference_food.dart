import '../valueobject/reference_food_id.dart';

/// Reference catalog food (`ReferenceFoodResource`): local name and nutrients per 100 g. It is public reference data;
/// it says nothing about any patient.
///
/// [isLocalOverride]: a local food loaded by a nutritionist (it comes first in searches).
class ReferenceFood {
  /// Throws [ArgumentError] if the name is blank or a nutrient is negative.
  factory ReferenceFood({
    required ReferenceFoodId id,
    required String name,
    required double energyKcalPer100g,
    required double proteinGPer100g,
    required double carbGPer100g,
    required double fatGPer100g,
    bool isLocalOverride = false,
  }) {
    if (name.trim().isEmpty) throw ArgumentError.value(name, 'name', 'A reference food needs a name');
    if (energyKcalPer100g < 0 || proteinGPer100g < 0 || carbGPer100g < 0 || fatGPer100g < 0) {
      throw ArgumentError('Nutrients cannot be negative');
    }
    return ReferenceFood._(id, name, energyKcalPer100g, proteinGPer100g, carbGPer100g, fatGPer100g, isLocalOverride);
  }

  const ReferenceFood._(
    this.id,
    this.name,
    this.energyKcalPer100g,
    this.proteinGPer100g,
    this.carbGPer100g,
    this.fatGPer100g,
    this.isLocalOverride,
  );

  final ReferenceFoodId id;
  final String name;
  final double energyKcalPer100g;
  final double proteinGPer100g;
  final double carbGPer100g;
  final double fatGPer100g;
  final bool isLocalOverride;
}

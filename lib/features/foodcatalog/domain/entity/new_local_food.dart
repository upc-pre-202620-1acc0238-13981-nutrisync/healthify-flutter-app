/// Local food added by a nutritionist (`CreateLocalOverrideResource`): Peruvian dishes the external catalog lacks. It
/// stays marked as local **for good**: an import never overwrites it.
///
/// Same rules as the backend (`LocalName`, `NutrientsPer100g`): a name of 1–200 characters with at least one letter,
/// energy 0–950 kcal and each macro 0–100 g per 100 g. It is built through [LocalFoodValidation.of].
class NewLocalFood {
  const NewLocalFood._(this.name, this.energyKcalPer100g, this.proteinGPer100g, this.carbGPer100g, this.fatGPer100g);

  static const maxNameLength = 200;
  static const maxEnergyKcal = 950.0;
  static const maxMacroG = 100.0;

  final String name;
  final double energyKcalPer100g;
  final double proteinGPer100g;
  final double carbGPer100g;
  final double fatGPer100g;

  @override
  bool operator ==(Object other) =>
      other is NewLocalFood &&
      other.name == name &&
      other.energyKcalPer100g == energyKcalPer100g &&
      other.proteinGPer100g == proteinGPer100g &&
      other.carbGPer100g == carbGPer100g &&
      other.fatGPer100g == fatGPer100g;

  @override
  int get hashCode => Object.hash(name, energyKcalPer100g, proteinGPer100g, carbGPer100g, fatGPer100g);

  @override
  String toString() => 'NewLocalFood($name, $energyKcalPer100g, $proteinGPer100g, $carbGPer100g, $fatGPer100g)';
}

/// An add-local-food field that is empty or out of range.
enum LocalFoodField { name, energy, protein, carb, fat }

/// Add local food validation before sending (`400 LocalNameAndNutrientsRequired` on the backend).
sealed class LocalFoodValidation {
  const LocalFoodValidation();

  static LocalFoodValidation of({
    required String name,
    required String energy,
    required String protein,
    required String carb,
    required String fat,
  }) {
    final trimmedName = name.trim();
    final energyValue = _inRange(_parse(energy), NewLocalFood.maxEnergyKcal);
    final proteinValue = _inRange(_parse(protein), NewLocalFood.maxMacroG);
    final carbValue = _inRange(_parse(carb), NewLocalFood.maxMacroG);
    final fatValue = _inRange(_parse(fat), NewLocalFood.maxMacroG);
    final nameOk =
        trimmedName.isNotEmpty && trimmedName.length <= NewLocalFood.maxNameLength && _letter.hasMatch(trimmedName);
    final invalid = {
      if (!nameOk) LocalFoodField.name,
      if (energyValue == null) LocalFoodField.energy,
      if (proteinValue == null) LocalFoodField.protein,
      if (carbValue == null) LocalFoodField.carb,
      if (fatValue == null) LocalFoodField.fat,
    };
    if (invalid.isNotEmpty) return InvalidLocalFood(invalid);
    return ValidLocalFood(NewLocalFood._(trimmedName, energyValue!, proteinValue!, carbValue!, fatValue!));
  }

  /// "180", "12,5" or "12.5"; `null` if blank or not a number.
  static double? _parse(String text) {
    final normalized = text.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    final value = double.tryParse(normalized);
    return value != null && value.isFinite ? value : null;
  }

  static double? _inRange(double? value, double max) => value != null && value >= 0 && value <= max ? value : null;
}

final class ValidLocalFood extends LocalFoodValidation {
  const ValidLocalFood(this.food);

  final NewLocalFood food;
}

final class InvalidLocalFood extends LocalFoodValidation {
  const InvalidLocalFood(this.fields);

  final Set<LocalFoodField> fields;
}

final _letter = RegExp(r'\p{L}', unicode: true);

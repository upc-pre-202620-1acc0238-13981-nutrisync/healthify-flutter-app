import '../valueobject/clinical_codes.dart';

/// Targets (energy in kcal and macros in g).
final class Targets {
  /// Throws [ArgumentError] if the energy is not positive or a macro is negative.
  Targets({required this.energyKcal, required this.proteinG, required this.carbG, required this.fatG}) {
    if (energyKcal <= 0) throw ArgumentError.value(energyKcal, 'energyKcal', 'Target energy must be positive');
    if (proteinG < 0 || carbG < 0 || fatG < 0) throw ArgumentError('Macros cannot be negative');
  }

  final double energyKcal;
  final double proteinG;
  final double carbG;
  final double fatG;

  static const _kcalPerGramProtein = 4.0;
  static const _kcalPerGramCarb = 4.0;
  static const _kcalPerGramFat = 9.0;

  /// Each macro's share of the energy (4/4/9 kcal per gram), as a whole percentage.
  int get proteinPercent => _percentOf(proteinG * _kcalPerGramProtein);
  int get carbPercent => _percentOf(carbG * _kcalPerGramCarb);
  int get fatPercent => _percentOf(fatG * _kcalPerGramFat);

  int _percentOf(double kcal) {
    final total = proteinG * _kcalPerGramProtein + carbG * _kcalPerGramCarb + fatG * _kcalPerGramFat;
    return total <= 0 ? 0 : (kcal / total * 100).round();
  }

  @override
  bool operator ==(Object other) =>
      other is Targets &&
      other.energyKcal == energyKcal &&
      other.proteinG == proteinG &&
      other.carbG == carbG &&
      other.fatG == fatG;

  @override
  int get hashCode => Object.hash(energyKcal, proteinG, carbG, fatG);
}

/// A guideline: from the catalog (translated) or custom/legacy (as is, never translated: it is clinical text).
sealed class PlanGuidelineItem {
  const PlanGuidelineItem();

  /// Reads a guideline `{ code }` or `{ custom }`. An unknown code is shown as is. `null` if it carries nothing.
  static PlanGuidelineItem? of(String? code, String? custom) {
    final known = PlanGuidelineCode.fromCode(code);
    if (known != null) return CatalogGuideline(known);
    if (custom != null && custom.trim().isNotEmpty) return CustomGuideline(custom.trim());
    if (code != null && code.trim().isNotEmpty) return CustomGuideline(code.trim());
    return null;
  }
}

final class CatalogGuideline extends PlanGuidelineItem {
  const CatalogGuideline(this.code);

  final PlanGuidelineCode code;

  @override
  bool operator ==(Object other) => other is CatalogGuideline && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

final class CustomGuideline extends PlanGuidelineItem {
  const CustomGuideline(this.text);

  final String text;

  @override
  bool operator ==(Object other) => other is CustomGuideline && other.text == text;

  @override
  int get hashCode => text.hashCode;
}

/// A restriction: from the closed list (translated) or text that predates the list (as is).
sealed class PlanRestrictionItem {
  const PlanRestrictionItem();

  /// An unknown code is shown as is. `null` if it is empty.
  static PlanRestrictionItem? ofCode(String? code) {
    final known = PlanRestrictionCode.fromCode(code);
    if (known != null) return CatalogRestriction(known);
    return code != null && code.trim().isNotEmpty ? LegacyRestriction(code.trim()) : null;
  }

  static PlanRestrictionItem? legacy(String? text) =>
      text != null && text.trim().isNotEmpty ? LegacyRestriction(text.trim()) : null;
}

final class CatalogRestriction extends PlanRestrictionItem {
  const CatalogRestriction(this.code);

  final PlanRestrictionCode code;

  @override
  bool operator ==(Object other) => other is CatalogRestriction && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

final class LegacyRestriction extends PlanRestrictionItem {
  const LegacyRestriction(this.text);

  final String text;

  @override
  bool operator ==(Object other) => other is LegacyRestriction && other.text == text;

  @override
  int get hashCode => text.hashCode;
}

/// A published plan version ("PLAN HISTORY" on the Plan tab, `GET /patients/{pid}/nutrition-plans`).
final class NutritionPlanVersion {
  const NutritionPlanVersion({
    required this.version,
    required this.isActive,
    required this.publishedAt,
    required this.targets,
    this.guidelines = const [],
    this.restrictions = const [],
    this.patientMessage,
  });

  final int version;
  final bool isActive;
  final DateTime publishedAt;
  final Targets targets;
  final List<PlanGuidelineItem> guidelines;
  final List<PlanRestrictionItem> restrictions;
  final String? patientMessage;
}

/// Published versions, the current one first.
final class PlanHistory {
  const PlanHistory(this.versions);

  /// Sorts from newest to oldest.
  factory PlanHistory.of(List<NutritionPlanVersion> versions) =>
      PlanHistory([...versions]..sort((a, b) => b.version.compareTo(a.version)));

  final List<NutritionPlanVersion> versions;

  NutritionPlanVersion? get active {
    for (final version in versions) {
      if (version.isActive) return version;
    }
    return null;
  }
}

import '../../domain/entity/plan_history.dart';

/// A published version ready to render in its detail sheet (the Plan tab's history).
/// What the nutritionist wrote stays as typed; the codes are translated when drawn.
final class PlanVersionItem {
  const PlanVersionItem({
    required this.version,
    required this.publishedAt,
    required this.energyKcal,
    required this.isActive,
    this.proteinG = 0,
    this.carbG = 0,
    this.fatG = 0,
    this.guidelines = const [],
    this.restrictions = const [],
    this.patientMessage,
  });

  factory PlanVersionItem.fromHistory(NutritionPlanVersion version) => PlanVersionItem(
    version: version.version,
    publishedAt: version.publishedAt,
    energyKcal: version.targets.energyKcal,
    isActive: version.isActive,
    proteinG: version.targets.proteinG,
    carbG: version.targets.carbG,
    fatG: version.targets.fatG,
    guidelines: version.guidelines,
    restrictions: version.restrictions,
    patientMessage: version.patientMessage != null && version.patientMessage!.trim().isNotEmpty
        ? version.patientMessage!.trim()
        : null,
  );

  final int version;
  final DateTime publishedAt;
  final double energyKcal;
  final bool isActive;
  final double proteinG;
  final double carbG;
  final double fatG;
  final List<PlanGuidelineItem> guidelines;
  final List<PlanRestrictionItem> restrictions;
  final String? patientMessage;
}

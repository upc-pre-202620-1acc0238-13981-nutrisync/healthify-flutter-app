import '../../../../core/l10n/app_localizations.dart';
import '../../domain/valueobject/monitoring_values.dart';

extension AgendaTexts on AppLocalizations {
  /// The chips of "How should they prepare?" in the schedule form.
  String preparationChip(PreparationCode code) => switch (code) {
    PreparationCode.fasting => schedulePreparationFasting,
    PreparationCode.lightClothing => schedulePreparationLightClothing,
    PreparationCode.bringBloodTests => schedulePreparationBloodTests,
    PreparationCode.emptyBladder => schedulePreparationEmptyBladder,
  };
}

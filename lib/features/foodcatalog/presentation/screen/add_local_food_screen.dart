import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/dialog_overlay.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entity/new_local_food.dart';
import '../cubit/add_local_food_cubit.dart';
import '../state/food_catalog_states.dart';

/// Add local food.
class AddLocalFoodScreen extends StatelessWidget {
  const AddLocalFoodScreen({super.key, required this.onBack, required this.onAdded});

  final VoidCallback onBack;

  /// Food saved: returns to the catalog, which searches for it and shows the snackbar.
  final void Function(String name) onAdded;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<AddLocalFoodCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<AddLocalFoodCubit>();
        return ObserveEvents<String>(
          events: cubit.added,
          onEvent: (context, name) => onAdded(name),
          child: BlocBuilder<AddLocalFoodCubit, AddLocalFoodState>(
            builder: (context, state) => AddLocalFoodContent(
              state: state,
              onBack: onBack,
              onNameChange: cubit.onNameChange,
              onEnergyChange: cubit.onEnergyChange,
              onProteinChange: cubit.onProteinChange,
              onCarbChange: cubit.onCarbChange,
              onFatChange: cubit.onFatChange,
              onSave: cubit.onSave,
              onServerErrorDismissed: cubit.onServerErrorDismissed,
            ),
          ),
        );
      },
    ),
  );
}

class AddLocalFoodContent extends StatelessWidget {
  const AddLocalFoodContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onNameChange,
    required this.onEnergyChange,
    required this.onProteinChange,
    required this.onCarbChange,
    required this.onFatChange,
    required this.onSave,
    required this.onServerErrorDismissed,
  });

  final AddLocalFoodState state;
  final VoidCallback onBack;
  final ValueChanged<String> onNameChange;
  final ValueChanged<String> onEnergyChange;
  final ValueChanged<String> onProteinChange;
  final ValueChanged<String> onCarbChange;
  final ValueChanged<String> onFatChange;
  final VoidCallback onSave;
  final VoidCallback onServerErrorDismissed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final enabled = !state.isSaving;
    final invalid = state.invalidFields;
    Widget nutrient(String value, ValueChanged<String> onChanged, String label, String example, LocalFoodField field) =>
        Expanded(
          child: HealthifyTextField(
            value: value,
            onChanged: onChanged,
            label: label,
            placeholder: example,
            isError: invalid.contains(field),
            enabled: enabled,
            type: HealthifyTextFieldType.decimal,
            textInputAction: TextInputAction.next,
          ),
        );
    final screen = Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(title: l10n.localFoodTitle, onBack: onBack),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.all(dimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space24,
                children: [
                  if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                  Text(
                    l10n.localFoodIntro,
                    style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  HealthifyTextField(
                    value: state.name,
                    onChanged: onNameChange,
                    label: l10n.localFoodName,
                    placeholder: l10n.localFoodNamePlaceholder,
                    supportingText: l10n.localFoodNameSupport,
                    errorText: state.duplicatedName
                        ? l10n.localFoodDuplicated
                        : invalid.contains(LocalFoodField.name)
                        ? l10n.localFoodIncomplete
                        : null,
                    enabled: enabled,
                    type: HealthifyTextFieldType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: dimens.space12,
                    children: [
                      SectionOverline(l10n.localFoodValues),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: dimens.space16,
                        children: [
                          nutrient(
                            state.energy,
                            onEnergyChange,
                            l10n.localFoodEnergy,
                            l10n.localFoodEnergyExample,
                            LocalFoodField.energy,
                          ),
                          nutrient(
                            state.protein,
                            onProteinChange,
                            l10n.localFoodProtein,
                            l10n.localFoodProteinExample,
                            LocalFoodField.protein,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: dimens.space16,
                        children: [
                          nutrient(
                            state.carb,
                            onCarbChange,
                            l10n.localFoodCarb,
                            l10n.localFoodCarbExample,
                            LocalFoodField.carb,
                          ),
                          nutrient(
                            state.fat,
                            onFatChange,
                            l10n.localFoodFat,
                            l10n.localFoodFatExample,
                            LocalFoodField.fat,
                          ),
                        ],
                      ),
                      if (invalid.any((field) => field != LocalFoodField.name))
                        Text(
                          l10n.localFoodIncomplete,
                          style: context.textStyles.bodySmall!.copyWith(color: scheme.error),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(dimens.space16),
              child: HealthifyButton(
                text: state.isSaving ? l10n.commonSaving : l10n.localFoodSave,
                onPressed: onSave,
                loading: state.isSaving,
                enabled: !state.isOffline,
                fullWidth: true,
              ),
            ),
          ),
        ],
      ),
    );
    return StateDialogOverlay(
      dialog: state.showServerError ? ServerErrorDialog(onRetry: onSave, onDismiss: onServerErrorDismissed) : null,
      onDismiss: onServerErrorDismissed,
      child: screen,
    );
  }
}

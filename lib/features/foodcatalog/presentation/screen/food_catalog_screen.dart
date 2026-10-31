import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_snackbar.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/list_card.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../cubit/food_catalog_cubit.dart';
import '../state/food_catalog_states.dart';

const _skeletonRows = 4;

/// Food catalog (from the main menu). Technical support for patient logging: "Add local food" opens the add screen.
/// Management does not work offline.
///
/// [onAddLocalFood] opens the add screen and completes with the created food's name (`null` if nothing was saved): the
/// catalog then searches for it and shows the snackbar.
class FoodCatalogScreen extends StatelessWidget {
  const FoodCatalogScreen({super.key, required this.onBack, required this.onAddLocalFood});

  final VoidCallback onBack;
  final Future<String?> Function() onAddLocalFood;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<FoodCatalogCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<FoodCatalogCubit>();
        return BlocBuilder<FoodCatalogCubit, FoodCatalogState>(
          builder: (context, state) => FoodCatalogContent(
            state: state,
            onBack: onBack,
            onQueryChange: cubit.onQueryChange,
            onAddLocalFood: () => _addLocalFood(context, cubit),
            onRetry: cubit.onRetry,
          ),
        );
      },
    ),
  );

  Future<void> _addLocalFood(BuildContext context, FoodCatalogCubit cubit) async {
    final name = await onAddLocalFood();
    if (name == null || !context.mounted) return;
    cubit.onFoodAdded(name);
    showHealthifySnackbar(context, message: AppLocalizations.of(context).foodCatalogAdded(name));
  }
}

class FoodCatalogContent extends StatelessWidget {
  const FoodCatalogContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onQueryChange,
    required this.onAddLocalFood,
    required this.onRetry,
  });

  final FoodCatalogState state;
  final VoidCallback onBack;
  final ValueChanged<String> onQueryChange;
  final VoidCallback onAddLocalFood;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final results = state.results;
    final Widget body;
    if (state.needsConnection) {
      body = EmptyState(
        title: l10n.practitionerOfflineTitle,
        text: l10n.foodCatalogOfflineBody,
        actionLabel: l10n.dsRetry,
        onAction: onRetry,
      );
    } else if (state.isLoading && results == null) {
      body = Column(
        spacing: dimens.space12,
        children: [for (var i = 0; i < _skeletonRows; i++) const SkeletonListItem()],
      );
    } else if (state.loadFailed && results == null) {
      body = ErrorState(onRetry: onRetry);
    } else if (state.isEmpty) {
      body = EmptyState(
        title: l10n.foodCatalogEmptyTitle,
        text: l10n.foodCatalogEmptyBody,
        actionLabel: l10n.foodCatalogAddLocal,
        onAction: onAddLocalFood,
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.space12,
        children: [for (final food in results ?? const <FoodRow>[]) _FoodCard(key: ValueKey(food.id), food: food)],
      );
    }
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(title: l10n.foodCatalogTitle, onBack: onBack),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.all(dimens.space16),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: dimens.space12,
                  children: [
                    if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                    // "Add local food" sits above the search field; with no results the empty state offers it.
                    if (!state.isEmpty)
                      HealthifyButton(
                        text: l10n.foodCatalogAddLocal,
                        onPressed: onAddLocalFood,
                        style: HealthifyButtonStyle.tonal,
                        enabled: !state.isOffline,
                        fullWidth: true,
                      ),
                    HealthifyTextField(
                      value: state.query,
                      onChanged: onQueryChange,
                      label: l10n.foodCatalogSearch,
                      placeholder: l10n.foodCatalogSearchPlaceholder,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      trailingIcon: HealthifyIcon(HealthifyIcons.search, color: context.colors.onSurfaceVariant),
                    ),
                    body,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({super.key, required this.food});

  final FoodRow food;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return HealthifyCard(
      child: Padding(
        padding: EdgeInsets.all(dimens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: dimens.space4,
          children: [
            // The local name is seeded in Spanish (the backend does not localize it yet): shown as is.
            Text(
              food.isLocal ? l10n.foodCatalogLocalName(food.name) : food.name,
              style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
            ),
            Text(
              l10n.foodCatalogEnergy(compactText(food.energyKcalPer100g, l10n.locale)),
              style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

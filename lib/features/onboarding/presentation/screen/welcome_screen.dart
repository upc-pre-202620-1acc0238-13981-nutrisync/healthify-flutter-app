import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_logo.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../iam/presentation/components/language_switcher.dart';
import '../../../iam/presentation/cubit/app_language_cubit.dart';
import '../components/welcome_chip.dart';
import '../cubit/welcome_cubit.dart';
import '../state/welcome_state.dart';

// Measurements from the normal welcome frame.
const _heroHeight = 406.0;
const _logoSize = Size(48, 43);
const _decorAlpha = 0.82;

/// Welcome (normal / offline).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onCreateAccount, required this.onHaveAccount});

  final VoidCallback onCreateAccount;
  final VoidCallback onHaveAccount;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<WelcomeCubit>()),
      BlocProvider(create: (_) => getIt<AppLanguageCubit>()),
    ],
    child: Builder(
      builder: (context) => ObserveEvents<WelcomeEvent>(
        events: context.read<WelcomeCubit>().events,
        onEvent: (context, event) => switch (event) {
          WelcomeNavigateToSignUp() => onCreateAccount(),
          WelcomeNavigateToSignIn() => onHaveAccount(),
        },
        child: BlocBuilder<WelcomeCubit, WelcomeState>(
          builder: (context, state) => WelcomeContent(
            state: state,
            onCreateAccount: context.read<WelcomeCubit>().onCreateAccount,
            onHaveAccount: context.read<WelcomeCubit>().onHaveAccount,
          ),
        ),
      ),
    ),
  );
}

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key, required this.state, required this.onCreateAccount, required this.onHaveAccount});

  final WelcomeState state;
  final VoidCallback onCreateAccount;
  final VoidCallback onHaveAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Scaffold(
      backgroundColor: scheme.inverseSurface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: dimens.space8),
                        child: LanguageSwitcher(color: scheme.onInverseSurface, selectedColor: scheme.inversePrimary),
                      ),
                    ),
                    if (state.showOfflineBanner)
                      Padding(
                        padding: EdgeInsets.fromLTRB(dimens.space16, dimens.space8, dimens.space16, 0),
                        child: const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                      ),
                    const _WelcomeHero(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: dimens.screenHorizontal),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            container: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.welcomeHeadlineFirst,
                                  style: context.textStyles.displaySmall!.copyWith(color: scheme.onInverseSurface),
                                ),
                                Text(
                                  l10n.welcomeHeadlineSecond,
                                  style: context.textStyles.displaySmall!.copyWith(color: scheme.inversePrimary),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: dimens.space24),
                          Text(
                            l10n.welcomeBody,
                            style: context.textStyles.titleSmall!.copyWith(color: scheme.onInverseSurface),
                          ),
                          SizedBox(height: dimens.space24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(dimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HealthifyButton(text: l10n.welcomeCreateAccount, onPressed: onCreateAccount, fullWidth: true),
                  SizedBox(height: dimens.space12),
                  HealthifyButton(
                    text: l10n.welcomeHaveAccount,
                    onPressed: onHaveAccount,
                    style: HealthifyButtonStyle.text,
                    contentColor: scheme.inversePrimary,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Logo, decorative circles and the three illustrative cards (no real data).
class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colors;
    Widget circle(double x, double y, double size, Color color) => Positioned(
      left: x,
      top: y,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(color: color.withValues(alpha: _decorAlpha), shape: BoxShape.circle),
          child: SizedBox.square(dimension: size),
        ),
      ),
    );

    return SizedBox(
      height: _heroHeight,
      child: ClipRect(
        child: Stack(
          children: [
            circle(150, 26, 290, scheme.secondary),
            circle(-60, 206, 180, scheme.tertiary),
            circle(250, 276, 120, context.extendedColors.brandDecor),
            const Positioned(
              left: 20,
              top: 10,
              child: HealthifyLogo(variant: HealthifyLogoVariant.white, size: _logoSize),
            ),
            Positioned(
              left: 26,
              top: 96,
              child: WelcomeChip(
                label: l10n.welcomeChipGoalLabel,
                value: l10n.welcomeChipGoalValue,
                icon: const TargetChipIcon(),
                badgeColor: scheme.secondary,
                iconColor: scheme.surfaceContainerLowest,
                rotation: -6,
              ),
            ),
            Positioned(
              left: 124,
              top: 198,
              child: WelcomeChip(
                label: l10n.welcomeChipMealLabel,
                value: l10n.welcomeChipMealValue,
                icon: const VectorChipIcon(HealthifyIcons.camera),
                badgeColor: scheme.primary,
                iconColor: scheme.surfaceContainerLowest,
                rotation: 5,
              ),
            ),
            Positioned(
              left: 34,
              top: 294,
              child: WelcomeChip(
                label: l10n.welcomeChipPractitionerLabel,
                value: l10n.welcomeChipPractitionerValue,
                icon: const VectorChipIcon(HealthifyIcons.check),
                badgeColor: scheme.tertiary,
                iconColor: scheme.onSurface,
                rotation: -3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

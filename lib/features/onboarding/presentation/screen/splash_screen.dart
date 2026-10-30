import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/healthify_logo.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/splash_cubit.dart';
import '../state/splash_state.dart';

// Measurements from the splash frame.
const _topCircleSize = 320.0;
const _bottomCircleSize = 300.0;
const _haloSize = 180.0;
const _logoSize = Size(154, 126);
const _logoTop = 20.0;
const _nameTop = 148.0;
const _dotSize = 6.0;
const _dotGap = 9.0;
const _decorAlpha = 0.3;
const _haloAlpha = 0.14;
const _dotCount = 3;

/// Splash. Navigates on its own as soon as it knows whether a session is saved.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.onNavigate});

  final ValueChanged<SplashDestination> onNavigate;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SplashCubit>(),
    child: Builder(
      builder: (context) => ObserveEvents<SplashEvent>(
        events: context.read<SplashCubit>().events,
        onEvent: (context, event) => switch (event) {
          SplashNavigate(:final destination) => onNavigate(destination),
        },
        child: const SplashContent(),
      ),
    ),
  );
}

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Scaffold(
      backgroundColor: scheme.secondary,
      body: Semantics(
        label: l10n.dsCdLoading,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: -70,
              right: -120,
              child: _Circle(size: _topCircleSize, color: scheme.tertiary.withValues(alpha: _decorAlpha)),
            ),
            Positioned(
              bottom: -50,
              left: -140,
              child: _Circle(size: _bottomCircleSize, color: scheme.primary.withValues(alpha: _decorAlpha)),
            ),
            Center(
              child: SizedBox(
                width: _haloSize,
                height: _nameTop + 60,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    _Circle(size: _haloSize, color: scheme.surfaceContainerLowest.withValues(alpha: _haloAlpha)),
                    const Positioned(
                      top: _logoTop,
                      child: HealthifyLogo(variant: HealthifyLogoVariant.white, size: _logoSize, decorative: true),
                    ),
                    Positioned(
                      top: _nameTop,
                      child: Column(
                        children: [
                          Text(
                            l10n.appName,
                            textAlign: TextAlign.center,
                            style: context.textStyles.headlineMedium!.copyWith(color: scheme.onSecondary),
                          ),
                          SizedBox(height: dimens.space12),
                          ExcludeSemantics(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (var i = 0; i < _dotCount; i++) ...[
                                  if (i > 0) const SizedBox(width: _dotGap),
                                  _Circle(size: _dotSize, color: scheme.onSecondary),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      DecoratedBox(decoration: BoxDecoration(color: color, shape: BoxShape.circle), child: SizedBox.square(dimension: size));
}

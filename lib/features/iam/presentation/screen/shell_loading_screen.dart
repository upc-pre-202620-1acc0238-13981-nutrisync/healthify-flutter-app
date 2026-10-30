import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_logo.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/shell_loading_cubit.dart';
import '../state/shell_loading_state.dart';

// Measurements of the "Loading - Normal" frame.
const _logoSize = Size(72, 63);
const _loaderSize = 80.0;

// "Fixed group": three arcs (Figma `arcData`, inner radius 0.62), in degrees from 3 o'clock.
const _innerRadiusRatio = 0.62;
const _loaderArcs = [(-90.0, 34.4), (51.6, 149.0), (166.2, 263.6)];
const _loaderTurn = Duration(milliseconds: 1400);

/// Loading (Normal / Error). Both roles share the visual; the destination depends on the shell.
class ShellLoadingScreen extends StatelessWidget {
  const ShellLoadingScreen({super.key, required this.onNavigate, required this.onNoSession});

  final ValueChanged<ShellDestination> onNavigate;
  final VoidCallback onNoSession;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<ShellLoadingCubit>(),
    child: Builder(
      builder: (context) => ObserveEvents<ShellLoadingEvent>(
        events: context.read<ShellLoadingCubit>().events,
        onEvent: (context, event) => switch (event) {
          ShellLoadingNavigate(:final destination) => onNavigate(destination),
          ShellLoadingNavigateToWelcome() => onNoSession(),
        },
        child: BlocBuilder<ShellLoadingCubit, ShellLoadingState>(
          builder: (context, state) => ShellLoadingContent(
            state: state,
            onRetry: context.read<ShellLoadingCubit>().onRetry,
            onClose: SystemNavigator.pop,
          ),
        ),
      ),
    ),
  );
}

/// [onClose]: "Close" in the error state closes the app (the session is kept for the next attempt); it does not sign
/// out.
class ShellLoadingContent extends StatelessWidget {
  const ShellLoadingContent({super.key, required this.state, required this.onRetry, required this.onClose});

  final ShellLoadingState state;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: dimens.space16, vertical: dimens.space40),
            child: state.isError
                ? ErrorState(
                    onRetry: onRetry,
                    retrying: state.isRetrying,
                    secondaryLabel: l10n.commonClose,
                    onSecondary: onClose,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HealthifyLogo(variant: HealthifyLogoVariant.color, size: _logoSize, decorative: true),
                      SizedBox(height: dimens.space24),
                      const _BrandLoader(),
                      SizedBox(height: dimens.space24),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          l10n.shellLoadingText,
                          textAlign: TextAlign.center,
                          style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Brand loading indicator (three arcs: `secondary`, `tertiary`, `primary`). In the app it spins to show that loading
/// is still in progress.
class _BrandLoader extends StatefulWidget {
  const _BrandLoader();

  @override
  State<_BrandLoader> createState() => _BrandLoaderState();
}

class _BrandLoaderState extends State<_BrandLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: _loaderTurn)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return ExcludeSemantics(
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          size: const Size.square(_loaderSize),
          painter: _LoaderPainter([scheme.secondary, scheme.tertiary, scheme.primary]),
        ),
      ),
    );
  }
}

class _LoaderPainter extends CustomPainter {
  const _LoaderPainter(this.colors);

  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final outer = size.shortestSide / 2;
    final thickness = outer * (1 - _innerRadiusRatio);
    final radius = outer - thickness / 2;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: radius);
    for (final (index, (start, end)) in _loaderArcs.indexed) {
      final paint = Paint()
        ..color = colors[index]
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness;
      canvas.drawArc(rect, start * math.pi / 180, (end - start) * math.pi / 180, false, paint);
    }
  }

  @override
  bool shouldRepaint(_LoaderPainter oldDelegate) => oldDelegate.colors != colors;
}

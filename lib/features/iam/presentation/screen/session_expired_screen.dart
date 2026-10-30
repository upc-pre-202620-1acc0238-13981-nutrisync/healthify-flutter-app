import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_logo.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/session_expired_cubit.dart';
import '../state/session_expired_state.dart';

// Measurements of the "Session expired" frames (Normal / Offline).
const _logoSize = Size(64, 57);
const _badgeSizeNormal = 80.0;
const _badgeSizeOffline = 88.0;
const _lockBodySize = Size(34, 26);
const _lockBodyRadius = 6.0;
const _shackleRadius = 14.0;
const _shackleStroke = 5.0;
const _shackleBottomOverlap = 2.0;

/// Session expired (Normal / Offline). Neutral tone: never says why it expired.
class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key, required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SessionExpiredCubit>(),
    child: BlocBuilder<SessionExpiredCubit, SessionExpiredState>(
      builder: (context, state) => SessionExpiredContent(state: state, onSignIn: onSignIn),
    ),
  );
}

class SessionExpiredContent extends StatelessWidget {
  const SessionExpiredContent({super.key, required this.state, required this.onSignIn});

  final SessionExpiredState state;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final offline = state.isOffline;
    return Scaffold(
      backgroundColor: offline ? scheme.surface : scheme.inverseSurface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: dimens.space16, vertical: dimens.space40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (offline) ...[const OfflineBanner(type: OfflineBannerType.requiresNetwork), SizedBox(height: dimens.space24)],
                Center(
                  child: HealthifyLogo(
                    variant: offline ? HealthifyLogoVariant.color : HealthifyLogoVariant.white,
                    size: _logoSize,
                    decorative: true,
                  ),
                ),
                SizedBox(height: dimens.space24),
                Center(
                  child: offline
                      ? _LockBadge(
                          size: _badgeSizeOffline,
                          container: scheme.surfaceContainerLowest,
                          lock: scheme.primary,
                          elevated: true,
                        )
                      : _LockBadge(
                          size: _badgeSizeNormal,
                          container: scheme.onSurface,
                          lock: scheme.secondary,
                          elevated: false,
                        ),
                ),
                SizedBox(height: dimens.space24),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.sessionExpiredTitle,
                    textAlign: TextAlign.center,
                    style: offline
                        ? context.extendedTypography.metricMedium.copyWith(color: scheme.onSurface)
                        : context.textStyles.headlineSmall!.copyWith(color: scheme.onInverseSurface),
                  ),
                ),
                SizedBox(height: dimens.space4),
                Text(
                  l10n.sessionExpiredBody,
                  textAlign: TextAlign.center,
                  style: context.textStyles.bodyMedium!.copyWith(
                    color: offline ? scheme.onSurfaceVariant : scheme.onInverseSurface,
                  ),
                ),
                if (offline) ...[
                  SizedBox(height: dimens.space24),
                  Text(
                    l10n.sessionExpiredOffline,
                    textAlign: TextAlign.center,
                    style: context.textStyles.titleSmall!.copyWith(color: scheme.primary),
                  ),
                ],
                SizedBox(height: dimens.space24),
                HealthifyButton(text: l10n.signInSubmit, onPressed: onSignIn, fullWidth: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Session expired padlock drawn as in the Figma (circle, arc and rounded body).
class _LockBadge extends StatelessWidget {
  const _LockBadge({required this.size, required this.container, required this.lock, required this.elevated});

  final double size;
  final Color container;
  final Color lock;
  final bool elevated;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: container,
        shape: BoxShape.circle,
        boxShadow: elevated ? context.dimens.elevation1.shadows : null,
      ),
      child: CustomPaint(size: Size.square(size), painter: _LockPainter(lock)),
    ),
  );
}

class _LockPainter extends CustomPainter {
  const _LockPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final bodyTop = center.dy - _lockBodySize.height / 2 + _shackleRadius / 2;
    final shackleCenterY = bodyTop + _shackleBottomOverlap;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx, shackleCenterY), radius: _shackleRadius),
      3.141592653589793,
      3.141592653589793,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _shackleStroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - _lockBodySize.width / 2, bodyTop, _lockBodySize.width, _lockBodySize.height),
        const Radius.circular(_lockBodyRadius),
      ),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_LockPainter oldDelegate) => oldDelegate.color != color;
}

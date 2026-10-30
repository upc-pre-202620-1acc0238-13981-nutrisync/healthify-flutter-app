import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/component_support.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';

// Measurements of the goal, logging and nutritionist chips in the welcome frame.
const _badgeSize = 36.0;
const _badgeIconSize = 18.0;

/// Icon of each illustrative welcome chip.
sealed class WelcomeChipIcon {
  const WelcomeChipIcon();
}

/// "Today's goal": a target (ring with a dot), drawn as in Figma.
final class TargetChipIcon extends WelcomeChipIcon {
  const TargetChipIcon();
}

final class VectorChipIcon extends WelcomeChipIcon {
  const VectorChipIcon(this.icon);

  final HealthifyIconData icon;
}

/// Tilted illustrative card on the welcome screen (not interactive, shows no real data).
///
/// [rotation] is in degrees clockwise (Figma gives them counterclockwise).
class WelcomeChip extends StatelessWidget {
  const WelcomeChip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.badgeColor,
    required this.iconColor,
    required this.rotation,
  });

  final String label;
  final String value;
  final WelcomeChipIcon icon;
  final Color badgeColor;
  final Color iconColor;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return ExcludeSemantics(
      child: Transform.rotate(
        angle: rotation * math.pi / 180,
        child: HealthifySurface(
          shape: dimens.shapeLarge,
          color: scheme.surfaceContainerLowest,
          elevation: dimens.elevation1.shadows,
          padding: EdgeInsets.fromLTRB(dimens.space12, dimens.space8, dimens.space16, dimens.space8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: badgeColor, borderRadius: dimens.shapeLarge),
                child: SizedBox.square(
                  dimension: _badgeSize,
                  child: Center(
                    child: switch (icon) {
                      TargetChipIcon() => CustomPaint(
                        size: const Size.square(_badgeIconSize),
                        painter: _TargetPainter(iconColor),
                      ),
                      VectorChipIcon(:final icon) => HealthifyIcon(icon, color: iconColor, size: _badgeIconSize),
                    },
                  ),
                ),
              ),
              SizedBox(width: dimens.space8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.textStyles.labelSmall!.copyWith(color: scheme.onSurfaceVariant)),
                  Text(value, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TargetPainter extends CustomPainter {
  const _TargetPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas
      ..drawCircle(
        center,
        size.shortestSide / 2 - 2,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      )
      ..drawCircle(center, 2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TargetPainter oldDelegate) => oldDelegate.color != color;
}

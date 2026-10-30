import 'package:flutter/material.dart';

import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

/// "Style" variants of the Figma IconButton.
enum HealthifyIconButtonStyle { standard, tonal, filled }

/// Figma IconButton: 48×48 dp touch target, 24 dp icon.
///
/// [contentDescription] is required unless the icon is decorative and another element describes it.
/// [forcePressed] is only for the design system catalog.
class HealthifyIconButton extends StatelessWidget {
  const HealthifyIconButton({
    super.key,
    required this.icon,
    required this.contentDescription,
    required this.onPressed,
    this.style = HealthifyIconButtonStyle.standard,
    this.enabled = true,
    this.tint,
    this.forcePressed = false,
  });

  final HealthifyIconData icon;
  final String? contentDescription;
  final VoidCallback? onPressed;
  final HealthifyIconButtonStyle style;
  final bool enabled;
  final Color? tint;
  final bool forcePressed;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final ext = context.extendedColors;
    final active = enabled && onPressed != null;
    return HealthifyPressable(
      onTap: onPressed,
      enabled: active,
      forcePressed: forcePressed && enabled,
      semanticsLabel: contentDescription,
      builder: (context, pressed) {
        final container = switch (style) {
          HealthifyIconButtonStyle.standard => pressed ? ext.primaryOverlayPressed : Colors.transparent,
          HealthifyIconButtonStyle.tonal =>
            !enabled
                ? ext.disabledContainer
                : pressed
                ? ext.primaryContainerPressed
                : scheme.primaryContainer,
          HealthifyIconButtonStyle.filled =>
            !enabled
                ? ext.disabledContainer
                : pressed
                ? ext.cardPressed
                : scheme.surfaceContainerLowest,
        };
        final iconTint = !enabled
            ? ext.onDisabled
            : tint ??
                  (style == HealthifyIconButtonStyle.tonal ? scheme.onPrimaryContainer : scheme.onSurface);
        return SizedBox.square(
          dimension: dimens.touchMin,
          child: HealthifySurface(
            shape: BorderRadius.circular(dimens.radiusFull),
            color: container,
            elevation: style == HealthifyIconButtonStyle.filled && enabled ? dimens.elevation1.shadows : null,
            child: Center(child: HealthifyIcon(icon, color: iconTint, size: dimens.icon)),
          ),
        );
      },
    );
  }
}

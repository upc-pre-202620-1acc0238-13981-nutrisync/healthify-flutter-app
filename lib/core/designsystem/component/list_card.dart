import 'package:flutter/material.dart';

import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

/// "Style" variants of the Figma Card component.
enum ListCardStyle { elevated, filled, outlined }

// Figma Card component measurements.
const _listCardMinHeight = 72.0;
const _leadingContainerSize = 40.0;

/// Figma "Card (container)": same tokens as [ListCard], for free-form content (targets,
/// forms). It adds no padding: the content sets its own (usually 16).
///
/// [onTap] if not null, the whole card is the touch target and shows the "Pressed" color. [shape] is the card
/// radius: 16 by default; the diary list cards and the ideas use 24. [borderColor] is a 1 dp outline (e.g.
/// `tertiary` on AI cards); `null` = no outline of its own. [forcePressed] is only for the design system catalog.
class HealthifyCard extends StatelessWidget {
  const HealthifyCard({
    super.key,
    required this.child,
    this.style = ListCardStyle.elevated,
    this.onTap,
    this.shape,
    this.borderColor,
    this.forcePressed = false,
  });

  final Widget child;
  final ListCardStyle style;
  final VoidCallback? onTap;
  final BorderRadius? shape;
  final Color? borderColor;
  final bool forcePressed;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;

    Widget card(bool pressed) {
      final container = pressed
          ? context.extendedColors.cardPressed
          : style == ListCardStyle.filled
          ? scheme.surfaceContainer
          : scheme.surfaceContainerLowest;
      return HealthifySurface(
        shape: shape ?? dimens.shapeLarge,
        color: container,
        borderColor:
            borderColor ?? (style == ListCardStyle.outlined ? scheme.outlineVariant : null),
        elevation: style == ListCardStyle.elevated ? dimens.elevation1.shadows : null,
        child: child,
      );
    }

    if (onTap == null && !forcePressed) return card(false);
    return HealthifyPressable(
      onTap: onTap,
      enabled: onTap != null,
      forcePressed: forcePressed,
      builder: (context, pressed) => card(pressed),
    );
  }
}

/// Figma list Card (Elevated / Filled / Outlined): leading icon in a `primaryContainer` circle,
/// optional title, supporting text and chevron. Min. 72 dp; the whole card is the touch target.
class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.title,
    this.supportingText,
    this.leadingIcon,
    this.style = ListCardStyle.elevated,
    this.onTap,
    bool? showChevron,
    this.forcePressed = false,
  }) : showChevron = showChevron ?? onTap != null;

  final String title;
  final String? supportingText;
  final HealthifyIconData? leadingIcon;
  final ListCardStyle style;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool forcePressed;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return HealthifyCard(
      style: style,
      onTap: onTap,
      forcePressed: forcePressed,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _listCardMinHeight, minWidth: double.infinity),
        child: Padding(
          padding: EdgeInsets.all(dimens.space16),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                HealthifyCircle(
                  size: _leadingContainerSize,
                  color: scheme.primaryContainer,
                  child: HealthifyIcon(leadingIcon!, color: scheme.onPrimaryContainer, size: dimens.icon),
                ),
                SizedBox(width: dimens.space16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
                    if (supportingText != null) ...[
                      SizedBox(height: dimens.space4),
                      Text(
                        supportingText!,
                        style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
              if (showChevron) ...[
                SizedBox(width: dimens.space16),
                HealthifyIcon(HealthifyIcons.chevronRight, color: scheme.onSurfaceVariant, size: dimens.icon),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

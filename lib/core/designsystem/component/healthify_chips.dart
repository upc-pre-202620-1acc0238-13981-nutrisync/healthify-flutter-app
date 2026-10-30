import 'package:flutter/material.dart';

import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

/// Figma "Filter": multi-select chip. Selected = `primaryContainer`, `primary` border and check;
/// unselected = `outline` border. 38 dp visual with a 48 dp touch target.
class HealthifyFilterChip extends StatelessWidget {
  const HealthifyFilterChip({
    super.key,
    required this.text,
    required this.selected,
    required this.onSelectedChange,
    this.enabled = true,
  });

  final String text;
  final bool selected;
  final ValueChanged<bool> onSelectedChange;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Semantics(
      checked: selected,
      enabled: enabled,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: dimens.touchMin),
        child: Center(
          widthFactor: 1,
          child: HealthifyPressable(
            enabled: enabled,
            onTap: () => onSelectedChange(!selected),
            builder: (context, _) => HealthifySurface(
              shape: dimens.shapeSmall,
              color: selected ? scheme.primaryContainer : scheme.surfaceContainerLowest,
              borderColor: selected ? scheme.primary : scheme.outline,
              padding: EdgeInsets.symmetric(horizontal: dimens.space12, vertical: dimens.space8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected) ...[
                    HealthifyIcon(HealthifyIcons.check, color: scheme.onPrimaryContainer, size: dimens.iconSmall),
                    SizedBox(width: dimens.space8),
                  ],
                  // Flexible: a long label wraps instead of overflowing on a narrow screen.
                  Flexible(
                    child: Text(
                      text,
                      style: context.textStyles.labelLarge!.copyWith(
                        color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma "Tag" (My plan): text with an `outline` border, read-only.
class HealthifyTag extends StatelessWidget {
  const HealthifyTag({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return HealthifySurface(
      shape: dimens.shapeSmall,
      borderColor: context.colors.outline,
      padding: EdgeInsets.symmetric(horizontal: dimens.space12, vertical: dimens.space4),
      child: Text(text, style: context.textStyles.labelMedium!.copyWith(color: context.colors.onSurfaceVariant)),
    );
  }
}

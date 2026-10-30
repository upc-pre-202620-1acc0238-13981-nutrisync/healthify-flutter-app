import 'package:flutter/material.dart';

import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';
import 'list_card.dart';

// Patient file avatar (48 in the Figma).
const _avatarSize = 48.0;

/// Figma section header (e.g. "SINCE THE LAST CONSULTATION", "MANAGEMENT"): Overline/Section in `primary`.
class SectionOverline extends StatelessWidget {
  const SectionOverline(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(text, style: context.extendedTypography.overlineSection.copyWith(color: context.colors.primary)),
  );
}

/// Figma indicator card (160 × 100 in two-card rows): Body/Small label, Metric/Medium value and a supporting
/// line. [captionColor] `null` = `onSurfaceVariant` (the Figma uses `primary` on cards that open another view).
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    this.captionColor,
    this.onTap,
  });

  final String label;
  final String value;
  final String caption;
  final Color? captionColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return HealthifyCard(
      shape: dimens.shapeExtraLarge,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(dimens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant)),
            SizedBox(height: dimens.space4),
            Text(value, style: context.extendedTypography.metricMedium.copyWith(color: scheme.onSurface)),
            SizedBox(height: dimens.space4),
            Text(
              caption,
              style: context.textStyles.bodySmall!.copyWith(color: captionColor ?? scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// 24 radius "Card" container with 16 padding (the patient file and consultation cards).
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.children, this.borderColor, this.verticalSpacing, this.onTap});

  final List<Widget> children;
  final Color? borderColor;

  /// `null` = 12.
  final double? verticalSpacing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final spacing = verticalSpacing ?? dimens.space12;
    return SizedBox(
      width: double.infinity,
      child: HealthifyCard(
        shape: dimens.shapeExtraLarge,
        borderColor: borderColor,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(dimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: spacing),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Figma icon row: 24 icon, Title/Small title and Body/Small text, with [trailing] on the right (chevron,
/// "Edit" button, a value…).
class IconInfoRow extends StatelessWidget {
  const IconInfoRow({super.key, required this.title, this.icon, this.supportingText, this.trailing});

  final HealthifyIconData? icon;
  final String title;
  final String? supportingText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Row(
      children: [
        if (icon != null) ...[
          HealthifyIcon(icon!, color: scheme.onSurfaceVariant, size: dimens.icon),
          SizedBox(width: dimens.space8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
              if (supportingText != null) ...[
                SizedBox(height: dimens.space4),
                Text(
                  supportingText!,
                  style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[SizedBox(width: dimens.space8), trailing!],
      ],
    );
  }
}

/// List action row (e.g. "Schedule consultation ›"): icon, Body/Large text and chevron; 48 touch target.
class ActionRow extends StatelessWidget {
  const ActionRow({super.key, required this.icon, required this.text, required this.onTap});

  final HealthifyIconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return HealthifyPressable(
      onTap: onTap,
      builder: (context, _) => ConstrainedBox(
        constraints: BoxConstraints(minHeight: dimens.touchMin),
        child: Row(
          children: [
            HealthifyIcon(icon, color: scheme.onSurfaceVariant, size: dimens.icon),
            SizedBox(width: dimens.space8),
            Expanded(
              child: Text(text, style: context.textStyles.bodyLarge!.copyWith(color: scheme.onSurface)),
            ),
            SizedBox(width: dimens.space8),
            HealthifyIcon(HealthifyIcons.chevronRight, color: scheme.onSurfaceVariant, size: dimens.icon),
          ],
        ),
      ),
    );
  }
}

/// Divider for lists inside a card (`outlineVariant`, 1 dp).
class CardDivider extends StatelessWidget {
  const CardDivider({super.key});

  @override
  Widget build(BuildContext context) => Divider(
    height: context.dimens.borderThin,
    thickness: context.dimens.borderThin,
    color: context.colors.outlineVariant,
  );
}

/// Avatar with the initial (`primaryContainer` circle, Title/Large).
class InitialAvatar extends StatelessWidget {
  const InitialAvatar(this.initial, {super.key});

  final String initial;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return HealthifyCircle(
      size: _avatarSize,
      color: scheme.primaryContainer,
      child: Text(initial, style: context.textStyles.titleLarge!.copyWith(color: scheme.onPrimaryContainer)),
    );
  }
}

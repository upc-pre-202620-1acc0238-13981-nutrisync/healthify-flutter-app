import 'package:flutter/material.dart';

import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

/// Figma AI badge, as on the AI summaries and suggestions. Everything AI-generated carries this mark.
class AiBadge extends StatelessWidget {
  const AiBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return HealthifySurface(
      shape: BorderRadius.circular(dimens.radiusFull),
      color: scheme.primaryContainer,
      padding: EdgeInsets.symmetric(horizontal: dimens.space8, vertical: dimens.space4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HealthifyIcon(HealthifyIcons.ai, color: scheme.onPrimaryContainer, size: dimens.iconSmall),
          SizedBox(width: dimens.space4),
          // A long label (Suggested by AI based on the diagnosis) wraps on a small phone instead of overflowing.
          Flexible(
            child: Text(label, style: context.textStyles.labelMedium!.copyWith(color: scheme.onPrimaryContainer)),
          ),
        ],
      ),
    );
  }
}

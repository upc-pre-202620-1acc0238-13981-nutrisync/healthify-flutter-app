import 'package:flutter/material.dart';

import '../theme/healthify_theme.dart';
import 'healthify_button.dart';

/// Figma empty state: centered block with title (Title/Medium), supporting text and optional action
/// (Tonal, full width). Wrap it in `Expanded` / a sized box to center it in the available area.
/// Inviting tone, never reproachful.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.text,
    this.actionLabel,
    this.onAction,
    this.actionStyle = HealthifyButtonStyle.tonal,
  });

  final String title;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;
  final HealthifyButtonStyle actionStyle;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
          ),
        ),
        SizedBox(height: dimens.space4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
        ),
        if (actionLabel != null) ...[
          SizedBox(height: dimens.space16),
          HealthifyButton(text: actionLabel!, onPressed: onAction, style: actionStyle, fullWidth: true),
        ],
      ],
    );
  }
}

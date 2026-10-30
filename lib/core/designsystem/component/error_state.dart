import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';
import 'healthify_button.dart';

// Figma error state measurements (the loading screen's error state).
const _badgeSize = 88.0;
const _badgeAlpha = 0.15;

/// Glyph inside the error badges; not translatable.
const errorStateGlyph = '!';

/// Generic error state (same pattern as the loading screen's error): "!" badge, title, text and "Retry"
/// (Filled, full width) with an optional Outlined secondary action. The default texts are the
/// generic ones; each screen passes the ones from its "Notes" frame when it has them.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.onRetry,
    this.title,
    this.text,
    this.retryLabel,
    this.retrying = false,
    this.secondaryLabel,
    this.onSecondary,
  });

  final VoidCallback onRetry;
  final String? title;
  final String? text;
  final String? retryLabel;
  final bool retrying;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ExcludeSemantics(
          child: HealthifyCircle(
            size: _badgeSize,
            color: scheme.secondary.withValues(alpha: _badgeAlpha),
            child: Text(
              errorStateGlyph,
              style: context.textStyles.displaySmall!.copyWith(color: scheme.onSecondaryContainer),
            ),
          ),
        ),
        SizedBox(height: dimens.space24),
        Semantics(
          header: true,
          child: Text(
            title ?? l10n.dsErrorStateTitle,
            textAlign: TextAlign.center,
            style: context.extendedTypography.metricMedium.copyWith(color: scheme.onSurface),
          ),
        ),
        SizedBox(height: dimens.space4),
        Text(
          text ?? l10n.dsErrorStateBody,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
        ),
        SizedBox(height: dimens.space24),
        HealthifyButton(
          text: retryLabel ?? l10n.dsRetry,
          onPressed: onRetry,
          loading: retrying,
          fullWidth: true,
        ),
        if (secondaryLabel != null) ...[
          SizedBox(height: dimens.space12),
          HealthifyButton(
            text: secondaryLabel!,
            onPressed: onSecondary,
            style: HealthifyButtonStyle.outlined,
            fullWidth: true,
          ),
        ],
      ],
    );
  }
}

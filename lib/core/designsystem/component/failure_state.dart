import 'package:flutter/material.dart';

import '../theme/healthify_theme.dart';
import 'component_support.dart';
import 'error_state.dart';
import 'healthify_button.dart';

// Figma "fixed group" of the failure screens: a 120 circle (error at 15 %) holding an 84 one (error) and "!".
const _outerCircle = 120.0;
const _innerCircle = 84.0;
const _outerAlpha = 0.15;

/// Full-screen "could not" state (a consultation that could not be saved, an AI error): error badge, title
/// (Headline/Medium), text that makes clear nothing was lost and the main action (Filled). The tone never
/// blames the user.
class FailureState extends StatelessWidget {
  const FailureState({
    super.key,
    required this.title,
    required this.text,
    required this.actionLabel,
    required this.onAction,
    this.actionLoading = false,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String text;
  final String actionLabel;
  final VoidCallback onAction;
  final bool actionLoading;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Center(
            child: HealthifyCircle(
              size: _outerCircle,
              color: scheme.error.withValues(alpha: _outerAlpha),
              child: HealthifyCircle(
                size: _innerCircle,
                color: scheme.error,
                child: Text(
                  errorStateGlyph,
                  style: context.textStyles.displaySmall!.copyWith(color: scheme.onPrimary),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: dimens.space24),
        Semantics(
          header: true,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: context.textStyles.headlineMedium!.copyWith(color: scheme.onSurface),
          ),
        ),
        SizedBox(height: dimens.space4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
        ),
        SizedBox(height: dimens.space24),
        HealthifyButton(text: actionLabel, onPressed: onAction, loading: actionLoading, fullWidth: true),
        if (secondaryLabel != null) ...[
          SizedBox(height: dimens.space24),
          HealthifyButton(
            text: secondaryLabel!,
            onPressed: onSecondary,
            style: HealthifyButtonStyle.text,
            fullWidth: true,
          ),
        ],
      ],
    );
  }
}

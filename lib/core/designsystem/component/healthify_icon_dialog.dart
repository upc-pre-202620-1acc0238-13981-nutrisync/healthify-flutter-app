import 'package:flutter/material.dart';

import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';
import 'healthify_button.dart';

// Figma icon dialog: 312 dp wide, 56 dp circle with the 28 dp icon.
const _iconDialogMaxWidth = 312.0;
const _iconCircleSize = 56.0;
const _iconGlyphSize = 28.0;

/// Figma icon dialog (e.g. leaving a consultation): `secondaryContainer` circle with the icon, title in
/// Metric/Medium, supporting text and two stacked actions (Filled + Text). Place it in `showHealthifyDialog`.
class HealthifyIconDialog extends StatelessWidget {
  const HealthifyIconDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    required this.confirmLabel,
    required this.onConfirm,
    required this.dismissLabel,
    required this.onDismiss,
  });

  final HealthifyIconData icon;
  final String title;
  final String text;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final String dismissLabel;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _iconDialogMaxWidth),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: title,
          explicitChildNodes: true,
          child: HealthifySurface(
            shape: dimens.shapeExtraLarge,
            color: scheme.surfaceContainerLowest,
            elevation: dimens.elevation3.shadows,
            padding: EdgeInsets.symmetric(horizontal: dimens.space16, vertical: dimens.space24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: HealthifyCircle(
                      size: _iconCircleSize,
                      color: scheme.secondaryContainer,
                      child: HealthifyIcon(icon, color: scheme.secondary, size: _iconGlyphSize),
                    ),
                  ),
                  SizedBox(height: dimens.space12),
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.extendedTypography.metricMedium.copyWith(color: scheme.onSurface),
                    ),
                  ),
                  SizedBox(height: dimens.space12),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  SizedBox(height: dimens.space12),
                  HealthifyButton(text: confirmLabel, onPressed: onConfirm, fullWidth: true),
                  SizedBox(height: dimens.space12),
                  HealthifyButton(
                    text: dismissLabel,
                    onPressed: onDismiss,
                    style: HealthifyButtonStyle.text,
                    fullWidth: true,
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

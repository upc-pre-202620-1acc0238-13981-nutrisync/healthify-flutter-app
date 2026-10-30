import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';
import 'healthify_button.dart';

// Figma Dialog: 312 dp wide in the 360 frame (24 dp per side); scrim at 32 %.
const _dialogMaxWidth = 312.0;
const dialogScrimAlpha = 0.32;

/// Shows [builder]'s content as a Healthify dialog window (Figma 32 % scrim, no platform default width).
/// The back gesture and tapping outside close it with `null`.
Future<T?> showHealthifyDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) => showDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  barrierColor: context.colors.scrim.withValues(alpha: dialogScrimAlpha),
  builder: (context) => Dialog(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    insetPadding: EdgeInsets.zero,
    child: builder(context),
  ),
);

/// Confirmation dialog on top of [showHealthifyDialog]: `true` if confirmed, `false` for cancel, back or
/// tapping outside.
Future<bool> showHealthifyConfirmDialog({
  required BuildContext context,
  required String title,
  required String text,
  required String confirmLabel,
  String? dismissLabel,
  bool destructive = false,
}) async {
  final confirmed = await showHealthifyDialog<bool>(
    context: context,
    builder: (dialogContext) => HealthifyDialog(
      title: title,
      text: text,
      confirmLabel: confirmLabel,
      onConfirm: () => Navigator.of(dialogContext).pop(true),
      onDismiss: () => Navigator.of(dialogContext).pop(false),
      dismissLabel: dismissLabel,
      destructive: destructive,
    ),
  );
  return confirmed ?? false;
}

/// Figma AlertDialog ("Basic" / "Destructive") surface. Place it in [showHealthifyDialog].
///
/// [informational] = a single button ([confirmLabel]). [dismissLabel] defaults to "Cancel". [destructive]: the
/// confirm button uses the Danger style (irreversible actions).
class HealthifyDialog extends StatelessWidget {
  const HealthifyDialog({
    super.key,
    required this.title,
    required this.text,
    required this.confirmLabel,
    required this.onConfirm,
    required this.onDismiss,
    this.dismissLabel,
    this.informational = false,
    this.destructive = false,
    this.confirmLoading = false,
  });

  final String title;
  final String text;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;
  final String? dismissLabel;
  final bool informational;
  final bool destructive;
  final bool confirmLoading;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _dialogMaxWidth),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: title,
          explicitChildNodes: true,
          child: HealthifySurface(
            shape: BorderRadius.circular(dimens.radiusDialog),
            color: scheme.surfaceContainerLowest,
            elevation: dimens.elevation3.shadows,
            padding: EdgeInsets.only(
              left: dimens.space24,
              top: dimens.space24,
              right: dimens.space24,
              bottom: dimens.space16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(title, style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface)),
                  ),
                  SizedBox(height: dimens.space16),
                  Text(text, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant)),
                  SizedBox(height: dimens.space16),
                  // Wraps to a second line when a long label does not fit beside the other button.
                  Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: dimens.space8,
                    children: [
                      if (!informational)
                        HealthifyButton(
                          text: dismissLabel ?? AppLocalizations.of(context).dsCancel,
                          onPressed: onDismiss,
                          style: HealthifyButtonStyle.text,
                        ),
                      HealthifyButton(
                        text: confirmLabel,
                        onPressed: onConfirm,
                        style: destructive ? HealthifyButtonStyle.danger : HealthifyButtonStyle.text,
                        loading: confirmLoading,
                      ),
                    ],
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

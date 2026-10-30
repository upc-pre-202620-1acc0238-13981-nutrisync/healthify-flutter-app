import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'healthify_dialog.dart';

/// "Generic server error" dialog ("Retry" / "Close") for the sign-up, sign-in, consent and consent withdrawal
/// validations. Uses the texts of the design system's generic error state. Place it in `showHealthifyDialog`
/// or use [showServerErrorDialog].
class ServerErrorDialog extends StatelessWidget {
  const ServerErrorDialog({super.key, required this.onRetry, required this.onDismiss});

  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return HealthifyDialog(
      title: l10n.dsErrorStateTitle,
      text: l10n.dsErrorStateBody,
      confirmLabel: l10n.dsRetry,
      onConfirm: onRetry,
      onDismiss: onDismiss,
      dismissLabel: l10n.commonClose,
    );
  }
}

/// Shows [ServerErrorDialog]; `true` if the user chose "Retry".
Future<bool> showServerErrorDialog(BuildContext context) async {
  final retry = await showHealthifyDialog<bool>(
    context: context,
    builder: (dialogContext) => ServerErrorDialog(
      onRetry: () => Navigator.of(dialogContext).pop(true),
      onDismiss: () => Navigator.of(dialogContext).pop(false),
    ),
  );
  return retry ?? false;
}

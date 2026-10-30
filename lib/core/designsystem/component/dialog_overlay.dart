import 'package:flutter/material.dart';

import '../theme/healthify_theme.dart';
import 'healthify_dialog.dart';

/// Shows [dialog] over [child] when it is not `null`, for dialogs that are part of a screen's state (as in Compose): the
/// cubit closes them when the answer arrives. Tapping the scrim or going back calls [onDismiss].
class StateDialogOverlay extends StatelessWidget {
  const StateDialogOverlay({super.key, required this.child, required this.dialog, required this.onDismiss});

  final Widget child;
  final Widget? dialog;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final dialog = this.dialog;
    if (dialog == null) return child;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onDismiss();
      },
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDismiss,
              child: ColoredBox(color: context.colors.scrim.withValues(alpha: dialogScrimAlpha)),
            ),
          ),
          Center(child: Material(type: MaterialType.transparency, child: dialog)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/healthify_theme.dart';
import 'component_support.dart';

/// Shows the Figma Snackbar through the nearest `ScaffoldMessenger` (it appears above the NavigationBar).
/// The 4 s duration matches the Figma. A new one replaces the one on screen.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showHealthifySnackbar(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  return messenger.showSnackBar(
    SnackBar(
      content: HealthifySnackbarContent(
        message: message,
        actionLabel: actionLabel,
        onAction: () {
          messenger.hideCurrentSnackBar();
          onAction?.call();
        },
      ),
      duration: const Duration(seconds: 4),
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.zero,
    ),
  );
}

/// Figma Snackbar (`inverseSurface`, 4 dp radius, Elevation/3): "Simple" or "WithAction" (48 dp action
/// in `inversePrimary`).
class HealthifySnackbarContent extends StatelessWidget {
  const HealthifySnackbarContent({super.key, required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.screenHorizontal, vertical: dimens.space8),
      child: Semantics(
        liveRegion: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: dimens.touchMin),
          child: HealthifySurface(
            shape: dimens.shapeExtraSmall,
            color: scheme.inverseSurface,
            elevation: dimens.elevation3.shadows,
            padding: EdgeInsetsDirectional.only(
              start: dimens.space16,
              end: dimens.space8,
              top: dimens.space4,
              bottom: dimens.space4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: dimens.space8),
                    child: Text(
                      message,
                      style: context.textStyles.bodyMedium!.copyWith(color: scheme.onInverseSurface),
                    ),
                  ),
                ),
                if (actionLabel != null) ...[
                  SizedBox(width: dimens.space8),
                  HealthifyPressable(
                    onTap: onAction,
                    enabled: onAction != null,
                    builder: (context, _) => ConstrainedBox(
                      constraints: BoxConstraints(minHeight: dimens.touchMin),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: dimens.space12),
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            actionLabel!,
                            style: context.textStyles.labelLarge!.copyWith(color: scheme.inversePrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

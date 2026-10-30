import 'package:flutter/material.dart';

import '../theme/healthify_theme.dart';
import 'component_support.dart';
import 'healthify_button.dart';

// Figma BottomSheet measurements.
const _handleWidth = 32.0;
const _handleHeight = 4.0;
const _handleRadius = 2.0;
const _sheetScrimAlpha = 0.32;

/// Figma modal BottomSheet: `surfaceContainerLowest`, 28 dp top radius, 32×4 dp handle.
/// The standard content is [BottomSheetContent]. It closes by swiping, tapping the scrim or back.
Future<T?> showHealthifyBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
}) {
  final dimens = context.dimens;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: context.colors.surfaceContainerLowest,
    barrierColor: context.colors.scrim.withValues(alpha: _sheetScrimAlpha),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(dimens.radiusDialog)),
    ),
    builder: (context) => SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: dimens.space12),
              child: const BottomSheetHandle(),
            ),
            builder(context),
          ],
        ),
      ),
    ),
  );
}

/// Figma BottomSheet handle.
class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: _handleWidth,
    height: _handleHeight,
    decoration: BoxDecoration(
      color: context.colors.outline,
      borderRadius: BorderRadius.circular(_handleRadius),
    ),
  );
}

/// Standard Figma BottomSheet content: title (Headline/Small), supporting text, full-width Filled main
/// action and optional Text secondary action.
class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({
    super.key,
    required this.title,
    required this.text,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.primaryLoading = false,
  });

  final String title;
  final String text;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool primaryLoading;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Padding(
      padding: EdgeInsets.only(
        left: dimens.space24,
        right: dimens.space24,
        top: dimens.space16,
        bottom: dimens.space24,
      ),
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
          HealthifyButton(text: primaryLabel, onPressed: onPrimary, loading: primaryLoading, fullWidth: true),
          if (secondaryLabel != null) ...[
            SizedBox(height: dimens.space16),
            Center(
              child: HealthifyButton(
                text: secondaryLabel!,
                onPressed: onSecondary,
                style: HealthifyButtonStyle.text,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Static copy of the sheet (no route) for the catalog.
class BottomSheetStaticFrame extends StatelessWidget {
  const BottomSheetStaticFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return HealthifySurface(
      shape: BorderRadius.vertical(top: Radius.circular(dimens.radiusDialog)),
      color: context.colors.surfaceContainerLowest,
      elevation: dimens.elevation3.shadows,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: dimens.space12),
              child: const BottomSheetHandle(),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

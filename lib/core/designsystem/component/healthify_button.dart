import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

/// "Style" variants of the Figma Button component.
/// - [filled]: main CTA (orange `secondary`).
/// - [tonal], [outlined], [text]: secondary actions.
/// - [danger]: irreversible actions.
enum HealthifyButtonStyle { filled, tonal, outlined, text, danger }

// Figma Button component measurements.
const _loadingIndicatorSize = 20.0;
const _loadingIndicatorStroke = 2.0;

/// Figma Button (adapted M3). 56 dp tall (Text: 48 dp), pill shape.
///
/// [loading] shows the circular progress and blocks taps; pass the mockup's loading text in [text]
/// (e.g. "Saving…"). [contentColor] is the text color when enabled, for the Figma variants that change it
/// on dark backgrounds; `null` = the style's. [fullWidth] stretches it to the parent's width.
/// [forcePressed] is only for the design system catalog.
class HealthifyButton extends StatelessWidget {
  const HealthifyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = HealthifyButtonStyle.filled,
    this.enabled = true,
    this.loading = false,
    this.icon,
    this.contentColor,
    this.fullWidth = false,
    this.forcePressed = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final HealthifyButtonStyle style;
  final bool enabled;
  final bool loading;
  final HealthifyIconData? icon;
  final Color? contentColor;
  final bool fullWidth;
  final bool forcePressed;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final isText = style == HealthifyButtonStyle.text;
    final active = enabled && !loading && onPressed != null;
    final shape = BorderRadius.circular(dimens.radiusFull);

    return HealthifyPressable(
      onTap: onPressed,
      enabled: active,
      forcePressed: forcePressed && enabled && !loading,
      builder: (context, pressed) {
        var colors = _buttonColors(context, style, enabled, pressed);
        if (contentColor != null && enabled) colors = colors.copyWith(content: contentColor);
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: fullWidth ? double.infinity : 0,
            minHeight: isText ? dimens.touchMin : dimens.button,
          ),
          child: HealthifySurface(
            shape: shape,
            color: colors.container,
            borderColor: colors.border,
            elevation: style == HealthifyButtonStyle.filled && enabled ? dimens.elevation1.shadows : null,
            padding: EdgeInsets.symmetric(horizontal: isText ? dimens.space12 : dimens.space24),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loading)
                    SizedBox.square(
                      dimension: _loadingIndicatorSize,
                      child: CircularProgressIndicator(
                        color: colors.content,
                        strokeWidth: _loadingIndicatorStroke,
                        semanticsLabel: AppLocalizations.of(context).dsCdLoading,
                      ),
                    )
                  else if (icon != null)
                    HealthifyIcon(icon!, color: colors.content, size: dimens.icon),
                  if (loading || icon != null) SizedBox(width: dimens.space8),
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: (isText ? context.textStyles.labelLarge : context.extendedTypography.buttonLarge)!
                          .copyWith(color: colors.content),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

@immutable
class _ButtonColors {
  const _ButtonColors({required this.container, required this.content, this.border});

  final Color container;
  final Color content;
  final Color? border;

  _ButtonColors copyWith({Color? content}) =>
      _ButtonColors(container: container, content: content ?? this.content, border: border);
}

_ButtonColors _buttonColors(BuildContext context, HealthifyButtonStyle style, bool enabled, bool pressed) {
  final scheme = context.colors;
  final ext = context.extendedColors;
  return switch (style) {
    HealthifyButtonStyle.filled => _ButtonColors(
      container: !enabled
          ? ext.disabledContainer
          : pressed
          ? ext.secondaryPressed
          : scheme.secondary,
      content: enabled ? scheme.onSecondary : ext.onDisabled,
    ),
    HealthifyButtonStyle.tonal => _ButtonColors(
      container: !enabled
          ? ext.disabledContainer
          : pressed
          ? ext.primaryContainerPressed
          : scheme.primaryContainer,
      content: enabled ? scheme.onPrimaryContainer : ext.onDisabled,
    ),
    HealthifyButtonStyle.outlined => _ButtonColors(
      container: pressed ? ext.primaryOverlayPressed : Colors.transparent,
      content: enabled ? scheme.primary : ext.onDisabled,
      border: enabled ? scheme.outline : ext.disabledContainer,
    ),
    HealthifyButtonStyle.text => _ButtonColors(
      container: pressed ? ext.primaryOverlayPressed : Colors.transparent,
      content: enabled ? scheme.primary : ext.onDisabled,
    ),
    HealthifyButtonStyle.danger => _ButtonColors(
      container: pressed ? ext.errorOverlayPressed : Colors.transparent,
      content: enabled ? scheme.error : ext.onDisabled,
      border: enabled ? scheme.error : ext.disabledContainer,
    ),
  };
}

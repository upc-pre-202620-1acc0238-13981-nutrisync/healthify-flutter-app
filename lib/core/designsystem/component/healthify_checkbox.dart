import 'package:flutter/material.dart';

import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';

const _boxSize = 20.0;

/// Visual checkbox, drawn like `HealthifySwitch`: checked = `primary` fill with an `onPrimary` check; unchecked =
/// `outline` border (`error` when [isError]); disabled = disabled colors.
///
/// Used inside [HealthifyCheckboxRow], which makes the whole row tappable (≥ 48 dp) and announces the state
/// to screen readers.
class HealthifyCheckbox extends StatelessWidget {
  const HealthifyCheckbox({super.key, required this.checked, this.enabled = true, this.isError = false});

  final bool checked;
  final bool enabled;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final ext = context.extendedColors;
    final fill = !enabled && checked
        ? ext.disabledContainer
        : checked
        ? scheme.primary
        : scheme.surfaceContainerLowest;
    final border = !enabled
        ? ext.disabledContainer
        : checked
        ? scheme.primary
        : isError
        ? scheme.error
        : scheme.outline;
    return ExcludeSemantics(
      child: Container(
        width: _boxSize,
        height: _boxSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: dimens.shapeExtraSmall,
          border: Border.all(color: border, width: dimens.borderThick),
        ),
        child: checked
            ? HealthifyIcon(
                HealthifyIcons.check,
                color: enabled ? scheme.onPrimary : ext.onDisabled,
                size: dimens.iconSmall,
              )
            : null,
      ),
    );
  }
}

/// "Checkbox + label" row (12 gap); the whole row is the touch target. [label] is an [InlineSpan] so it can carry
/// links (a `TextSpan` with a recognizer): tapping a link opens it instead of toggling the box.
class HealthifyCheckboxRow extends StatelessWidget {
  const HealthifyCheckboxRow({
    super.key,
    required this.label,
    required this.checked,
    required this.onChanged,
    this.enabled = true,
    this.isError = false,
  });

  final InlineSpan label;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return Semantics(
      checked: checked,
      enabled: enabled,
      onTap: enabled ? () => onChanged(!checked) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged(!checked) : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: dimens.touchMin),
          child: Row(
            children: [
              HealthifyCheckbox(checked: checked, enabled: enabled, isError: isError),
              SizedBox(width: dimens.space12),
              Expanded(
                child: Text.rich(
                  label,
                  style: context.textStyles.bodyMedium!.copyWith(color: context.colors.onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

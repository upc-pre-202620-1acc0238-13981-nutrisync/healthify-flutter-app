import 'package:flutter/material.dart';

import '../theme/healthify_theme.dart';

// Figma switch: 40 × 24 track, 4 padding, 16 thumb.
const _trackWidth = 40.0;
const _trackHeight = 24.0;
const _thumbSize = 16.0;

/// Visual switch. The Figma only draws the on state (`primary` track, `surfaceContainerLowest` thumb on
/// the right). Design system choice: off = `surfaceContainerHigh` track and `outline` thumb on the
/// left; disabled = disabled colors.
///
/// Used inside [HealthifySwitchRow], which makes the whole row tappable (≥ 48 dp) and announces the state
/// to screen readers.
class HealthifySwitch extends StatelessWidget {
  const HealthifySwitch({super.key, required this.checked, this.enabled = true});

  final bool checked;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final ext = context.extendedColors;
    final track = !enabled
        ? ext.disabledContainer
        : checked
        ? scheme.primary
        : scheme.surfaceContainerHigh;
    final thumb = !enabled
        ? ext.onDisabled
        : checked
        ? scheme.surfaceContainerLowest
        : scheme.outline;
    return ExcludeSemantics(
      child: Container(
        width: _trackWidth,
        height: _trackHeight,
        padding: EdgeInsets.all(context.dimens.space4),
        decoration: BoxDecoration(color: track, borderRadius: BorderRadius.circular(context.dimens.radiusFull)),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: checked ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
          child: Container(
            width: _thumbSize,
            height: _thumbSize,
            decoration: BoxDecoration(color: thumb, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

/// Figma "label + switch" row (24 gap); the whole row is the touch target.
///
/// [supportingText] is the secondary text under the label (e.g. a reminder's time), Body/Small in
/// `onSurfaceVariant`. Label and text sit together in a column, centered against the switch.
class HealthifySwitchRow extends StatelessWidget {
  const HealthifySwitchRow({
    super.key,
    required this.label,
    required this.checked,
    required this.onChanged,
    this.enabled = true,
    this.supportingText,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final String? supportingText;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Semantics(
      toggled: checked,
      enabled: enabled,
      label: label,
      hint: supportingText,
      excludeSemantics: true,
      onTap: enabled ? () => onChanged(!checked) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged(!checked) : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: dimens.touchMin),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: supportingText != null ? dimens.space4 : dimens.space0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
                      if (supportingText != null) ...[
                        SizedBox(height: dimens.space4),
                        Text(
                          supportingText!,
                          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(width: dimens.space24),
              HealthifySwitch(checked: checked, enabled: enabled),
            ],
          ),
        ),
      ),
    );
  }
}

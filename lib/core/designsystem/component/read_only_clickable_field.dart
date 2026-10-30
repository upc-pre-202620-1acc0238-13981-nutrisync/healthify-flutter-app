import 'package:flutter/material.dart';

import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'healthify_text_field.dart';

/// A read-only TextField that acts as a button (a date or time picker, a selection list).
class ReadOnlyClickableField extends StatelessWidget {
  const ReadOnlyClickableField({
    super.key,
    required this.value,
    required this.label,
    required this.onTap,
    this.supportingText,
    this.errorText,
    this.enabled = true,
    this.trailingIcon,
  });

  final String value;
  final String label;
  final VoidCallback onTap;
  final String? supportingText;
  final String? errorText;
  final bool enabled;
  final HealthifyIconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HealthifyTextField(
          value: value,
          onChanged: (_) {},
          label: label,
          supportingText: supportingText,
          errorText: errorText,
          enabled: enabled,
          trailingIcon: trailingIcon == null
              ? null
              : Padding(
                  padding: EdgeInsets.only(right: context.dimens.space12),
                  child: HealthifyIcon(trailingIcon!, color: context.colors.onSurfaceVariant),
                ),
        ),
        // Layer that receives the tap: the field does not open the keyboard.
        Positioned.fill(
          child: Semantics(
            button: true,
            label: label,
            enabled: enabled,
            excludeSemantics: true,
            onTap: enabled ? onTap : null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: enabled ? onTap : null,
            ),
          ),
        ),
      ],
    );
  }
}

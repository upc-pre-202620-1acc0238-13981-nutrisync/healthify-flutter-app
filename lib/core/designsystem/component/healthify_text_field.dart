import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';
import 'healthify_icon_button.dart';

/// Field data type: picks the keyboard (and for [password], the masking with a show button).
enum HealthifyTextFieldType { text, name, email, password, number, decimal, phone }

// Height of the Figma "Lines=Multi" field.
const _multiLineFieldMinHeight = 112.0;
const _multiLineMinLines = 3;

/// Figma TextField: visible label on top (never placeholder only), 56 dp outlined field and
/// helper or error text below (the error has an icon).
///
/// States: Enabled (empty, with [placeholder]), Focused (2 dp `primary` border), Filled, Error ([errorText]
/// not null: border and message in `error`) and Disabled.
///
/// [isError] is the Error state without a message (e.g. the sign-in password, whose message goes under the
/// email). [singleLine] `false` = "Lines=Multi" variant (min. 112 dp, text keyboard with line breaks).
/// [labelColor] is the label color on dark backgrounds; `null` = `onSurface`. [trailingIcon] is an optional
/// trailing widget (48 dp touch target); it is ignored for [HealthifyTextFieldType.password], which shows the
/// show/hide button. [suffix] is the unit at the end of the field («kg», «cm», «%»), Label/Large in
/// `onSurfaceVariant`: it goes as text with a 16 dp end margin so it does not get cut off in narrow fields.
/// [forceFocused] is only for the design system catalog.
class HealthifyTextField extends StatefulWidget {
  const HealthifyTextField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.placeholder,
    this.supportingText,
    this.errorText,
    bool? isError,
    this.enabled = true,
    this.singleLine = true,
    this.type = HealthifyTextFieldType.text,
    this.textInputAction,
    this.onSubmitted,
    this.trailingIcon,
    this.focusNode,
    this.labelColor,
    this.suffix,
    this.forceFocused = false,
  }) : isError = isError ?? errorText != null;

  final String value;
  final ValueChanged<String> onChanged;
  final String label;
  final String? placeholder;
  final String? supportingText;
  final String? errorText;
  final bool isError;
  final bool enabled;
  final bool singleLine;
  final HealthifyTextFieldType type;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? trailingIcon;
  final FocusNode? focusNode;
  final Color? labelColor;
  final String? suffix;
  final bool forceFocused;

  @override
  State<HealthifyTextField> createState() => _HealthifyTextFieldState();
}

class _HealthifyTextFieldState extends State<HealthifyTextField> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);
  FocusNode? _ownFocusNode;
  bool _focused = false;
  bool _passwordVisible = false;

  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(HealthifyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
    }
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _ownFocusNode?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focused != _focusNode.hasFocus) setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final ext = context.extendedColors;
    final enabled = widget.enabled;
    final focused = (_focused || widget.forceFocused) && enabled;
    final showError = widget.isError && enabled;
    final isPassword = widget.type == HealthifyTextFieldType.password;
    final singleLine = widget.singleLine;

    final borderColor = !enabled
        ? ext.disabledContainer
        : showError
        ? scheme.error
        : focused
        ? scheme.primary
        : scheme.outline;
    final borderWidth = showError || focused ? dimens.borderThick : dimens.borderThin;
    final textColor = enabled ? scheme.onSurface : ext.onDisabled;

    final Widget? trailing = isPassword
        ? HealthifyIconButton(
            // Open eye = "show"; crossed eye = "hide" (the password is already visible).
            icon: _passwordVisible ? HealthifyIcons.visibilityOff : HealthifyIcons.visibility,
            contentDescription: _passwordVisible
                ? AppLocalizations.of(context).dsHidePassword
                : AppLocalizations.of(context).dsShowPassword,
            onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
            enabled: enabled,
          )
        : widget.trailingIcon;

    final bodyLarge = context.textStyles.bodyLarge!;
    final field = ConstrainedBox(
      constraints: BoxConstraints(minHeight: singleLine ? dimens.textField : _multiLineFieldMinHeight),
      child: HealthifySurface(
        shape: dimens.shapeMedium,
        color: scheme.surfaceContainer,
        borderColor: borderColor,
        borderWidth: borderWidth,
        padding: EdgeInsetsDirectional.only(
          start: dimens.space16,
          end: trailing != null
              ? dimens.space0
              : widget.suffix != null
              ? dimens.space16
              : dimens.space12,
        ),
        child: Row(
          crossAxisAlignment: singleLine ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: dimens.space16),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: enabled,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  style: bodyLarge.copyWith(color: textColor),
                  cursorColor: showError ? scheme.error : scheme.primary,
                  obscureText: isPassword && !_passwordVisible,
                  minLines: singleLine ? 1 : _multiLineMinLines,
                  maxLines: singleLine ? 1 : null,
                  keyboardType: _keyboardType(widget.type, singleLine),
                  textCapitalization: _capitalization(widget.type, singleLine),
                  textInputAction: widget.textInputAction,
                  autocorrect: !(widget.type == HealthifyTextFieldType.email || isPassword),
                  enableSuggestions: !(widget.type == HealthifyTextFieldType.email || isPassword),
                  decoration: InputDecoration.collapsed(
                    hintText: widget.placeholder,
                    hintStyle: bodyLarge.copyWith(color: enabled ? scheme.onSurfaceVariant : ext.onDisabled),
                  ),
                ),
              ),
            ),
            if (widget.suffix != null) ...[
              SizedBox(width: dimens.space8),
              Padding(
                padding: EdgeInsets.only(top: singleLine ? 0 : dimens.space16),
                child: Text(
                  widget.suffix!,
                  maxLines: 1,
                  softWrap: false,
                  style: context.textStyles.labelLarge!.copyWith(
                    color: enabled ? scheme.onSurfaceVariant : ext.onDisabled,
                  ),
                ),
              ),
            ],
            if (trailing != null) ...[
              SizedBox(width: dimens.space8),
              Padding(padding: EdgeInsets.only(top: singleLine ? 0 : dimens.space4), child: trailing),
            ],
          ],
        ),
      ),
    );

    return Semantics(
      label: widget.label,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: context.textStyles.titleSmall!.copyWith(
              color: enabled ? widget.labelColor ?? scheme.onSurface : ext.onDisabled,
            ),
          ),
          SizedBox(height: dimens.space8),
          field,
          if (widget.errorText != null || widget.supportingText != null) ...[
            SizedBox(height: dimens.space8),
            _SupportingRow(supportingText: widget.supportingText, errorText: widget.errorText, enabled: enabled),
          ],
        ],
      ),
    );
  }
}

class _SupportingRow extends StatelessWidget {
  const _SupportingRow({required this.supportingText, required this.errorText, required this.enabled});

  final String? supportingText;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final text = errorText ?? supportingText!;
    final isError = errorText != null && enabled;
    final color = !enabled
        ? context.extendedColors.onDisabled
        : isError
        ? scheme.error
        : scheme.onSurfaceVariant;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: dimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isError) ...[
            HealthifyIcon(HealthifyIcons.error, color: scheme.error, size: dimens.iconSmall),
            SizedBox(width: dimens.space4),
          ],
          Expanded(
            child: Text(text, style: context.textStyles.bodySmall!.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}

TextInputType _keyboardType(HealthifyTextFieldType type, bool singleLine) {
  if (!singleLine) return TextInputType.multiline;
  return switch (type) {
    HealthifyTextFieldType.text || HealthifyTextFieldType.name => TextInputType.text,
    HealthifyTextFieldType.email => TextInputType.emailAddress,
    HealthifyTextFieldType.password => TextInputType.visiblePassword,
    HealthifyTextFieldType.number => TextInputType.number,
    HealthifyTextFieldType.decimal => const TextInputType.numberWithOptions(decimal: true),
    HealthifyTextFieldType.phone => TextInputType.phone,
  };
}

TextCapitalization _capitalization(HealthifyTextFieldType type, bool singleLine) {
  if (!singleLine) return TextCapitalization.sentences;
  return switch (type) {
    HealthifyTextFieldType.text => TextCapitalization.sentences,
    HealthifyTextFieldType.name => TextCapitalization.words,
    _ => TextCapitalization.none,
  };
}

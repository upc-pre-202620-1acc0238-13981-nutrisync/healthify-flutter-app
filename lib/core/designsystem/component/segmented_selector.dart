import 'package:flutter/material.dart';

import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'component_support.dart';

// Check icon of the Figma "Segmento" component.
const _segmentCheckSize = 18.0;

/// Figma single-choice SegmentedButton ("Segmento"): role, activity factor, reference weight,
/// deficit type… Each option takes the same width, 48 dp tall, 8 dp gap.
///
/// If an option's text does not fit in its share of the row (narrow dialogs, large font, another language), the
/// options stack at full width instead of breaking words.
///
/// [selected] `null` = no option chosen yet. [isError] paints the `error` border on the unchosen options
/// (e.g. a required question left unanswered).
class SegmentedSelector<T> extends StatelessWidget {
  const SegmentedSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.optionLabel,
    this.enabled = true,
    this.isError = false,
  });

  final List<T> options;
  final T? selected;
  final ValueChanged<T> onSelect;
  final String Function(T option) optionLabel;
  final bool enabled;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final gap = context.dimens.space8;
    final labelStyle = context.textStyles.labelLarge!;
    final textScaler = MediaQuery.textScalerOf(context);
    final labels = [for (final option in options) optionLabel(option)];

    Widget option(int index) => SegmentedOption(
      text: labels[index],
      selected: options[index] == selected,
      onTap: () => onSelect(options[index]),
      enabled: enabled,
      isError: isError,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (options.isEmpty) return const SizedBox.shrink();
        final count = options.length;
        final slot = (constraints.maxWidth - gap * (count - 1)) / count;
        // The option's own horizontal padding (16 + 16) plus the border.
        final chrome = context.dimens.space16 * 2 + context.dimens.borderThick * 2;
        final fitsInRow = labels.every(
          (label) => _textWidth(label, labelStyle, textScaler) + chrome <= slot,
        );
        return Semantics(
          container: true,
          child: fitsInRow
              // Every label fits on one line here, so all options have the same 48 dp height.
              ? Row(
                  children: [
                    for (var i = 0; i < count; i++) ...[
                      if (i > 0) SizedBox(width: gap),
                      Expanded(child: option(i)),
                    ],
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < count; i++) ...[
                      if (i > 0) SizedBox(height: gap),
                      option(i),
                    ],
                  ],
                ),
        );
      },
    );
  }
}

double _textWidth(String text, TextStyle style, TextScaler textScaler) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaler: textScaler,
    maxLines: 1,
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width;
}

/// A single option ("Segmento"), for rows that do not fit [SegmentedSelector].
class SegmentedOption extends StatelessWidget {
  const SegmentedOption({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
    this.enabled = true,
    this.isError = false,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final ext = context.extendedColors;
    final container = selected && !enabled
        ? ext.disabledContainer
        : selected
        ? scheme.primaryContainer
        : scheme.surfaceContainerLowest;
    final border = !enabled
        ? ext.disabledContainer
        : selected
        ? scheme.primary
        : isError
        ? scheme.error
        : scheme.outline;
    final content = !enabled
        ? ext.onDisabled
        : selected
        ? scheme.onPrimaryContainer
        : scheme.onSurface;
    final labelStyle = context.textStyles.labelLarge!.copyWith(color: content);

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: HealthifyPressable(
        enabled: enabled,
        onTap: onTap,
        builder: (context, _) => ConstrainedBox(
          constraints: BoxConstraints(minHeight: dimens.touchMin),
          child: HealthifySurface(
            shape: BorderRadius.circular(dimens.radiusFull),
            color: container,
            borderColor: border,
            borderWidth: selected ? dimens.borderThick : dimens.borderThin,
            padding: EdgeInsets.symmetric(horizontal: dimens.space16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // The check is only drawn if it fits next to the text, so choosing an option never shrinks the
                // text's space or breaks it letter by letter.
                final withCheck = _segmentCheckSize + dimens.space8;
                final textWidth = _textWidth(text, labelStyle, MediaQuery.textScalerOf(context));
                final drawCheck = selected && textWidth + withCheck <= constraints.maxWidth;
                return Center(
                  widthFactor: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (drawCheck) ...[
                        HealthifyIcon(HealthifyIcons.check, color: content, size: _segmentCheckSize),
                        SizedBox(width: dimens.space8),
                      ],
                      Flexible(child: Text(text, textAlign: TextAlign.center, style: labelStyle)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

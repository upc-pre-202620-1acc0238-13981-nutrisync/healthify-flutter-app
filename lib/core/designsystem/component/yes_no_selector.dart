import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';
import 'segmented_selector.dart';

/// Figma yes/no selector ("SelectorSiNo"): binary question **with no default value**. Replaces switches,
/// which cannot represent "unanswered" (e.g. the weigh-in protocol, "did you adjust the plan?").
///
/// [answer] `null` = unanswered; `true` = Yes; `false` = No. [isError] shows "Answer Yes or No" (the Figma
/// "Error" state, e.g. on submit without an answer). [errorText] is the error text if the screen has its own.
class YesNoSelector extends StatelessWidget {
  const YesNoSelector({
    super.key,
    required this.question,
    required this.answer,
    required this.onAnswer,
    this.enabled = true,
    this.isError = false,
    this.errorText,
  });

  final String question;
  final bool? answer;
  final ValueChanged<bool> onAnswer;
  final bool enabled;
  final bool isError;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final l10n = AppLocalizations.of(context);
    final showError = isError && answer == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(question, style: context.textStyles.bodyLarge!.copyWith(color: scheme.onSurface)),
        SizedBox(height: dimens.space8),
        SegmentedSelector<bool>(
          options: const [true, false],
          selected: answer,
          onSelect: onAnswer,
          optionLabel: (value) => value ? l10n.dsYes : l10n.dsNo,
          enabled: enabled,
          isError: showError,
        ),
        if (showError) ...[
          SizedBox(height: dimens.space8),
          Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HealthifyIcon(HealthifyIcons.error, color: scheme.error, size: dimens.iconSmall),
                SizedBox(width: dimens.space4),
                Expanded(
                  child: Text(
                    errorText ?? l10n.dsYesNoRequired,
                    style: context.textStyles.bodySmall!.copyWith(color: scheme.error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

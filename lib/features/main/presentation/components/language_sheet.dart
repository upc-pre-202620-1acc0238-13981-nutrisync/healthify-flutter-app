import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/component_support.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../iam/domain/valueobject/preferred_language.dart';

/// "LANGUAGE" sheet: Español and English; the current option has the check mark.
class LanguageSheetContent extends StatelessWidget {
  const LanguageSheetContent({super.key, required this.selected, required this.onSelect, required this.onClose});

  final PreferredLanguage selected;
  final ValueChanged<PreferredLanguage> onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space24, dimens.space16, dimens.space24, dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.settingsLanguageSheetTitle,
              style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface),
            ),
          ),
          SizedBox(height: dimens.space16),
          for (final (index, language) in PreferredLanguage.values.indexed) ...[
            if (index > 0) Divider(height: dimens.borderThin, thickness: dimens.borderThin, color: scheme.outlineVariant),
            Semantics(
              inMutuallyExclusiveGroup: true,
              selected: language == selected,
              child: HealthifyPressable(
                onTap: () => onSelect(language),
                builder: (context, pressed) => ConstrainedBox(
                  constraints: BoxConstraints(minHeight: dimens.button),
                  child: Row(
                    children: [
                      Expanded(
                        // Each language is named in its own language (not translated).
                        child: Text(
                          language.label(l10n),
                          style: context.textStyles.bodyLarge!.copyWith(color: scheme.onSurface),
                        ),
                      ),
                      if (language == selected) HealthifyIcon(HealthifyIcons.check, color: scheme.primary),
                    ],
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: dimens.space16),
          HealthifyButton(text: l10n.commonClose, onPressed: onClose, style: HealthifyButtonStyle.text),
        ],
      ),
    );
  }
}

extension PreferredLanguageLabel on PreferredLanguage {
  String label(AppLocalizations l10n) => switch (this) {
    PreferredLanguage.spanish => l10n.languageSpanish,
    PreferredLanguage.english => l10n.languageEnglish,
  };
}

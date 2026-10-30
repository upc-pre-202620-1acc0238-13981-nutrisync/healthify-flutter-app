import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/valueobject/preferred_language.dart';
import '../cubit/app_language_cubit.dart';

/// Español / English switch. Needs an [AppLanguageCubit] above it. [color] is the text color (it sits on a dark
/// background in the welcome screen).
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, required this.color, required this.selectedColor});

  final Color color;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    return BlocBuilder<AppLanguageCubit, PreferredLanguage>(
      builder: (context, language) => Semantics(
        container: true,
        label: l10n.languageSelectorLabel,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Option(
              text: l10n.languageSpanish,
              selected: language == PreferredLanguage.spanish,
              color: color,
              selectedColor: selectedColor,
              onTap: () => context.read<AppLanguageCubit>().onSelect(PreferredLanguage.spanish),
            ),
            SizedBox(width: dimens.space4),
            _Option(
              text: l10n.languageEnglish,
              selected: language == PreferredLanguage.english,
              color: color,
              selectedColor: selectedColor,
              onTap: () => context.read<AppLanguageCubit>().onSelect(PreferredLanguage.english),
            ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.text,
    required this.selected,
    required this.color,
    required this.selectedColor,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final Color color;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: dimens.touchMin, minWidth: dimens.touchMin),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: dimens.space8),
              child: Text(
                text,
                style: context.textStyles.labelLarge!.copyWith(
                  color: selected ? selectedColor : color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  decoration: selected ? TextDecoration.underline : TextDecoration.none,
                  decorationColor: selectedColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

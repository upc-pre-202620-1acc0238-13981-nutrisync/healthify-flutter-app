import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/route_resume_effect.dart';
import '../../../../core/designsystem/component/healthify_bottom_sheet.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/list_card.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../components/language_sheet.dart';
import '../cubit/practitioner_settings_cubit.dart';
import '../navigation/shell_routes.dart';
import '../state/practitioner_settings_state.dart';

/// Practitioner settings (+ language), an inner screen opened from the main menu. [onBack] returns to the tab the
/// practitioner was on.
class PractitionerSettingsScreen extends StatelessWidget {
  const PractitionerSettingsScreen({super.key, required this.onBack, required this.onSignOut});

  final VoidCallback onBack;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<PractitionerSettingsCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<PractitionerSettingsCubit>();
        return RouteResumeEffect(
          path: practitionerSettingsPath,
          onResume: cubit.onResume,
          child: BlocBuilder<PractitionerSettingsCubit, PractitionerSettingsState>(
            builder: (context, state) => PractitionerSettingsContent(
              state: state,
              onBack: onBack,
              onSignOut: onSignOut,
              onOpenLanguage: () => _openLanguageSheet(context, cubit),
            ),
          ),
        );
      },
    ),
  );

  Future<void> _openLanguageSheet(BuildContext context, PractitionerSettingsCubit cubit) async {
    final language = await showHealthifyBottomSheet(
      context: context,
      builder: (sheetContext) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<PractitionerSettingsCubit, PractitionerSettingsState>(
          builder: (context, state) => LanguageSheetContent(
            selected: state.language,
            onSelect: (language) => Navigator.of(sheetContext).pop(language),
            onClose: () => Navigator.of(sheetContext).pop(),
          ),
        ),
      ),
    );
    if (language != null) cubit.onLanguageSelected(language);
  }
}

class PractitionerSettingsContent extends StatelessWidget {
  const PractitionerSettingsContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onSignOut,
    required this.onOpenLanguage,
  });

  final PractitionerSettingsState state;
  final VoidCallback onBack;
  final VoidCallback onSignOut;
  final VoidCallback onOpenLanguage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final account = [state.fullName, state.email].where((part) => part.isNotEmpty).join(' · ');
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(title: l10n.settingsTitle, onBack: onBack),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(dimens.space16, dimens.space16, dimens.space16, dimens.space24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.isOffline) ...[
                      const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                      SizedBox(height: dimens.space12),
                    ],
                    // "My account" has no screen in the Figma: it shows without a chevron or destination.
                    ListCard(
                      title: l10n.settingsAccount,
                      supportingText: account,
                      leadingIcon: HealthifyIcons.person,
                    ),
                    SizedBox(height: dimens.space12),
                    ListCard(
                      title: l10n.settingsLanguage,
                      supportingText: state.language.label(l10n),
                      leadingIcon: HealthifyIcons.language,
                      onTap: onOpenLanguage,
                    ),
                    SizedBox(height: dimens.space12),
                    // Sign out works the same offline (it is local).
                    ListCard(title: l10n.signOutConfirm, leadingIcon: HealthifyIcons.logout, onTap: onSignOut),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

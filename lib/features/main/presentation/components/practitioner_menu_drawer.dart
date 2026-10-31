import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/healthify_end_drawer.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Content of the practitioner's main menu: header, Food catalog · Settings and, after the divider, Sign out.
///
/// The menu only opens from the tabs, which are not menu items, so no item is selected.
List<Widget> practitionerMenuChildren(
  BuildContext context, {
  required String fullName,
  required String avatarInitial,
  required VoidCallback onFoodCatalog,
  required VoidCallback onSettings,
  required VoidCallback onSignOut,
}) {
  final l10n = AppLocalizations.of(context);
  return [
    HealthifyDrawerHeader(name: fullName, role: l10n.menuRolePractitioner, avatarInitial: avatarInitial),
    HealthifyDrawerItem(icon: HealthifyIcons.cutlery, label: l10n.menuFoodCatalog, selected: false, onTap: onFoodCatalog),
    HealthifyDrawerItem(icon: HealthifyIcons.settings, label: l10n.menuSettings, selected: false, onTap: onSettings),
    const HealthifyDrawerDivider(),
    HealthifyDrawerItem(icon: HealthifyIcons.logout, label: l10n.menuSignOut, selected: false, onTap: onSignOut),
  ];
}

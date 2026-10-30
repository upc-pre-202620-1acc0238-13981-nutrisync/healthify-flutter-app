import 'package:flutter/material.dart';

import '../../../../core/designsystem/component/healthify_end_drawer.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Content of the practitioner's main menu: header, Settings and, after the divider, Sign out. (Food catalog is a
/// patient-and-catalog feature that this app does not carry.)
///
/// The menu only opens from the tabs, which are not menu items, so no item is selected.
List<Widget> practitionerMenuChildren(
  BuildContext context, {
  required String fullName,
  required String avatarInitial,
  required VoidCallback onSettings,
  required VoidCallback onSignOut,
}) {
  final l10n = AppLocalizations.of(context);
  return [
    HealthifyDrawerHeader(name: fullName, role: l10n.menuRolePractitioner, avatarInitial: avatarInitial),
    HealthifyDrawerItem(icon: HealthifyIcons.settings, label: l10n.menuSettings, selected: false, onTap: onSettings),
    const HealthifyDrawerDivider(),
    HealthifyDrawerItem(icon: HealthifyIcons.logout, label: l10n.menuSignOut, selected: false, onTap: onSignOut),
  ];
}

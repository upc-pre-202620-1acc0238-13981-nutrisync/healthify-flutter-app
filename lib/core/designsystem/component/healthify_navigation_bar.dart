import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../icon/healthify_icons.dart';
import '../theme/healthify_theme.dart';

/// Practitioner NavigationBar destinations (Figma "NavigationBar/Nutricionista").
enum PractitionerTab {
  patients,
  inbox,
  agenda;

  HealthifyIconData get icon => switch (this) {
    PractitionerTab.patients => HealthifyIcons.patients,
    PractitionerTab.inbox => HealthifyIcons.inbox,
    PractitionerTab.agenda => HealthifyIcons.agenda,
  };

  String label(AppLocalizations l10n) => switch (this) {
    PractitionerTab.patients => l10n.navPatients,
    PractitionerTab.inbox => l10n.navInbox,
    PractitionerTab.agenda => l10n.navAgenda,
  };
}

/// A generic [HealthifyNavigationBar] destination.
@immutable
class NavigationBarEntry {
  const NavigationBarEntry({required this.label, required this.icon});

  final String label;
  final HealthifyIconData icon;
}

// Figma "NavigationBar/Item" measurements.
const _navigationBarHeight = 80.0;
const _indicatorWidth = 64.0;
const _indicatorHeight = 32.0;

/// Figma NavigationBar (80 dp plus the system gesture inset). The active destination gets the
/// `primaryContainer` indicator and a bold label.
class HealthifyNavigationBar extends StatelessWidget {
  const HealthifyNavigationBar({super.key, required this.items, required this.selectedIndex, required this.onSelect});

  final List<NavigationBarEntry> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return ColoredBox(
      color: context.colors.surfaceContainerLowest,
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _navigationBarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dimens.space8),
            child: Row(
              children: [
                for (var index = 0; index < items.length; index++)
                  Expanded(
                    child: _NavigationBarDestination(
                      item: items[index],
                      selected: index == selectedIndex,
                      onTap: () => onSelect(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationBarDestination extends StatelessWidget {
  const _NavigationBarDestination({required this.item, required this.selected, required this.onTap});

  final NavigationBarEntry item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final labelStyle = context.textStyles.labelMedium!;
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(top: dimens.space12, bottom: dimens.space16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: _indicatorWidth,
                height: _indicatorHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? scheme.primaryContainer : null,
                  borderRadius: BorderRadius.circular(dimens.radiusFull),
                ),
                child: HealthifyIcon(
                  item.icon,
                  color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                  size: dimens.icon,
                ),
              ),
              SizedBox(height: dimens.space4),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle.copyWith(
                  fontWeight: selected ? FontWeight.w700 : labelStyle.fontWeight,
                  color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Width from which the navigation moves from the bottom bar to a side rail (Material "medium" window class).
const navigationRailBreakpoint = 600.0;

/// Whether a layout [width] gets the side [HealthifyNavigationRail] instead of the bottom bar.
bool usesNavigationRail(double width) => width > navigationRailBreakpoint;

/// The tablet version of [HealthifyNavigationBar]: same destinations, indicator colors and labels, on the side.
class HealthifyNavigationRail extends StatelessWidget {
  const HealthifyNavigationRail({super.key, required this.items, required this.selectedIndex, required this.onSelect});

  final List<NavigationBarEntry> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final labelStyle = context.textStyles.labelMedium!;
    return NavigationRail(
      backgroundColor: scheme.surfaceContainerLowest,
      indicatorColor: scheme.primaryContainer,
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      labelType: NavigationRailLabelType.all,
      selectedLabelTextStyle: labelStyle.copyWith(fontWeight: FontWeight.w700, color: scheme.onSurface),
      unselectedLabelTextStyle: labelStyle.copyWith(color: scheme.onSurfaceVariant),
      destinations: [
        for (final item in items)
          NavigationRailDestination(
            label: Text(item.label),
            icon: HealthifyIcon(item.icon, color: scheme.onSurfaceVariant),
            selectedIcon: HealthifyIcon(item.icon, color: scheme.onPrimaryContainer),
          ),
      ],
    );
  }
}

/// Practitioner NavigationRail: the same three destinations as [PractitionerNavigationBar], for wide screens.
class PractitionerNavigationRail extends StatelessWidget {
  const PractitionerNavigationRail({super.key, required this.selected, required this.onSelect});

  final PractitionerTab selected;
  final ValueChanged<PractitionerTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const tabs = PractitionerTab.values;
    return HealthifyNavigationRail(
      items: [for (final tab in tabs) NavigationBarEntry(label: tab.label(l10n), icon: tab.icon)],
      selectedIndex: tabs.indexOf(selected),
      onSelect: (index) => onSelect(tabs[index]),
    );
  }
}

/// Practitioner NavigationBar: Patients · Inbox · Agenda (Settings opens from the main menu).
class PractitionerNavigationBar extends StatelessWidget {
  const PractitionerNavigationBar({super.key, required this.selected, required this.onSelect});

  final PractitionerTab selected;
  final ValueChanged<PractitionerTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const tabs = PractitionerTab.values;
    return HealthifyNavigationBar(
      items: [for (final tab in tabs) NavigationBarEntry(label: tab.label(l10n), icon: tab.icon)],
      selectedIndex: tabs.indexOf(selected),
      onSelect: (index) => onSelect(tabs[index]),
    );
  }
}

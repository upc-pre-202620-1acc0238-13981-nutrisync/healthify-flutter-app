import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/healthify_end_drawer.dart';
import '../../../../core/designsystem/component/healthify_navigation_bar.dart';
import '../../../../core/designsystem/component/healthify_snackbar.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../components/practitioner_menu_drawer.dart';
import '../cubit/practitioner_shell_cubit.dart';
import '../state/practitioner_shell_state.dart';

/// Practitioner shell: NavigationBar Patients · Inbox · Agenda over a `StatefulShellRoute` (each tab keeps its own
/// stack and state) and the main menu (menu button on the tabs) that opens from the right. The return snackbars
/// (discharge, signal resolved, visit scheduled) show above the NavigationBar.
///
/// Food catalog, settings and sign out are root-graph screens: the menu closes before opening them.
class PractitionerShellScreen extends StatelessWidget {
  const PractitionerShellScreen({
    super.key,
    required this.navigationShell,
    required this.onOpenFoodCatalog,
    required this.onOpenSettings,
    required this.onSignOut,
  });

  final StatefulNavigationShell navigationShell;
  final VoidCallback onOpenFoodCatalog;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<PractitionerShellCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<PractitionerShellCubit>();
        return ObserveEvents<PractitionerShellMessage>(
          events: cubit.messages,
          onEvent: (context, message) => _show(context, message),
          child: BlocBuilder<PractitionerShellCubit, PractitionerShellState>(
            builder: (context, state) => PractitionerShellContent(
              state: state,
              selected: PractitionerTab.values[navigationShell.currentIndex],
              onSelect: (tab) => navigationShell.goBranch(
                tab.index,
                // Tapping the current tab goes back to its first screen.
                initialLocation: tab.index == navigationShell.currentIndex,
              ),
              onCloseMenu: cubit.onCloseMenu,
              onFoodCatalog: () {
                cubit.onCloseMenu();
                onOpenFoodCatalog();
              },
              onSettings: () {
                cubit.onCloseMenu();
                onOpenSettings();
              },
              onSignOut: () {
                cubit.onCloseMenu();
                onSignOut();
              },
              child: navigationShell,
            ),
          ),
        );
      },
    ),
  );

  void _show(BuildContext context, PractitionerShellMessage message) {
    final l10n = AppLocalizations.of(context);
    switch (message) {
      case PatientDischarged(:final patientName):
        navigationShell.goBranch(PractitionerTab.patients.index);
        showHealthifySnackbar(context, message: l10n.shellPatientDischarged(patientName));
      case SignalResolved(:final patientName):
        navigationShell.goBranch(PractitionerTab.inbox.index);
        showHealthifySnackbar(
          context,
          message: patientName == null ? l10n.shellSignalResolvedGeneric : l10n.shellSignalResolved(patientName),
        );
      case AgendaVisitScheduled(:final scheduledFor, :final rescheduled):
        navigationShell.goBranch(PractitionerTab.agenda.index);
        // «jue 18 sept.» in lowercase inside the sentence.
        final day = weekdayDayMonthText(scheduledFor, l10n.locale);
        final lowerDay = day.isEmpty ? day : day[0].toLowerCase() + day.substring(1);
        final time = shortTimeText(scheduledFor, l10n.locale);
        showHealthifySnackbar(
          context,
          message: rescheduled ? l10n.shellFollowUpRescheduled(lowerDay, time) : l10n.shellFollowUpScheduled(lowerDay, time),
        );
    }
  }
}

class PractitionerShellContent extends StatelessWidget {
  const PractitionerShellContent({
    super.key,
    required this.state,
    required this.selected,
    required this.onSelect,
    required this.onCloseMenu,
    required this.onFoodCatalog,
    required this.onSettings,
    required this.onSignOut,
    required this.child,
  });

  final PractitionerShellState state;
  final PractitionerTab selected;
  final ValueChanged<PractitionerTab> onSelect;
  final VoidCallback onCloseMenu;
  final VoidCallback onFoodCatalog;
  final VoidCallback onSettings;
  final VoidCallback onSignOut;
  final Widget child;

  @override
  Widget build(BuildContext context) => HealthifyEndDrawer(
    open: state.isMenuOpen,
    onDismissRequest: onCloseMenu,
    drawerChildren: practitionerMenuChildren(
      context,
      fullName: state.fullName,
      avatarInitial: state.avatarInitial,
      onFoodCatalog: onFoodCatalog,
      onSettings: onSettings,
      onSignOut: onSignOut,
    ),
    // The snackbars float above the bar because it is the Scaffold's own bottom bar.
    child: LayoutBuilder(
      builder: (context, constraints) {
        // Tablets and landscape: the tabs go to a side rail instead of the bottom bar.
        final useRail = usesNavigationRail(constraints.maxWidth);
        return Scaffold(
          backgroundColor: context.colors.surface,
          body: useRail
              ? Row(
                  children: [
                    PractitionerNavigationRail(selected: selected, onSelect: onSelect),
                    VerticalDivider(width: 1, thickness: 1, color: context.colors.outlineVariant),
                    Expanded(child: child),
                  ],
                )
              : child,
          bottomNavigationBar: useRail ? null : PractitionerNavigationBar(selected: selected, onSelect: onSelect),
        );
      },
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/common/route_resume_effect.dart';
import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/dialog_overlay.dart';
import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_bottom_sheet.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_dialog.dart';
import '../../../../core/designsystem/component/healthify_icon_button.dart';
import '../../../../core/designsystem/component/healthify_snackbar.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/list_card.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../../main/presentation/navigation/shell_routes.dart';
import '../cubit/practitioner_agenda_cubit.dart';
import '../state/practitioner_agenda_states.dart';

// Date badge of each visit (Agenda frame).
const _dateBadgeSize = 44.0;
const _skeletonRows = 3;

/// What the visit sheet asks for.
enum _VisitAction { reschedule, viewPatient, cancel }

/// Agenda (the "Agenda" tab of the nutritionist's shell). "Schedule visit" opens the schedule form; the shell shows the
/// confirmation snackbar on return.
///
/// [onOpenMenu] is the shell's main menu button.
class PractitionerAgendaScreen extends StatelessWidget {
  const PractitionerAgendaScreen({
    super.key,
    required this.onSchedule,
    required this.onReschedule,
    required this.onOpenPatient,
    required this.onOpenMenu,
  });

  final VoidCallback onSchedule;
  final void Function(AgendaRow row) onReschedule;
  final void Function(int patientId, int careLinkId, String patientName) onOpenPatient;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<PractitionerAgendaCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<PractitionerAgendaCubit>();
        return RouteResumeEffect(
          path: agendaPath,
          onResume: cubit.onResume,
          child: ObserveEvents<AgendaEvent>(
            events: cubit.events,
            onEvent: (context, event) => switch (event) {
              OpenReschedule(:final row) => onReschedule(row),
              VisitCancelled() => showHealthifySnackbar(context, message: AppLocalizations.of(context).agendaCancelled),
              OpenAgendaPatient(:final patientId, :final careLinkId, :final patientName) => onOpenPatient(
                patientId,
                careLinkId,
                patientName,
              ),
            },
            // The confirmation was dismissed: the visit stays selected, so its sheet comes back (as in Android).
            child: BlocListener<PractitionerAgendaCubit, AgendaState>(
              listenWhen: (previous, current) =>
                  previous.dialog == AgendaDialog.confirmCancel && current.dialog == null && current.selected != null,
              listener: (context, state) => _openSheet(context, cubit, state.selected!),
              child: BlocBuilder<PractitionerAgendaCubit, AgendaState>(
                builder: (context, state) => PractitionerAgendaContent(
                  state: state,
                  onSchedule: onSchedule,
                  onRetry: cubit.onRetry,
                  onVisitSelected: (row) {
                    cubit.onVisitSelected(row);
                    _openSheet(context, cubit, row);
                  },
                  onCancelConfirmed: cubit.onCancelConfirmed,
                  onDialogDismissed: cubit.onDialogDismissed,
                  onOpenMenu: onOpenMenu,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );

  Future<void> _openSheet(BuildContext context, PractitionerAgendaCubit cubit, AgendaRow row) async {
    final action = await showHealthifyBottomSheet<_VisitAction>(
      context: context,
      builder: (_) => _VisitSheetContent(row: row),
    );
    switch (action) {
      case _VisitAction.reschedule:
        cubit.onReschedule();
      case _VisitAction.viewPatient:
        cubit.onViewPatient();
      case _VisitAction.cancel:
        cubit.onCancelRequested();
      case null:
        // Dismissed by swiping or tapping outside; a confirmation or another action already took the visit.
        if (cubit.state.dialog == null) cubit.onSheetDismissed();
    }
  }
}

class PractitionerAgendaContent extends StatelessWidget {
  const PractitionerAgendaContent({
    super.key,
    required this.state,
    required this.onSchedule,
    required this.onRetry,
    required this.onVisitSelected,
    required this.onCancelConfirmed,
    required this.onDialogDismissed,
    this.onOpenMenu = _noop,
  });

  final AgendaState state;
  final VoidCallback onSchedule;
  final VoidCallback onRetry;
  final void Function(AgendaRow row) onVisitSelected;
  final VoidCallback onCancelConfirmed;
  final VoidCallback onDialogDismissed;
  final VoidCallback onOpenMenu;

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final visits = state.visits;
    const banner = OfflineBanner(type: OfflineBannerType.requiresNetwork);
    final Widget body;
    if (visits != null && visits.isNotEmpty) {
      body = ListView(
        padding: EdgeInsets.all(dimens.space16),
        children: [
          if (state.isOffline) ...[banner, SizedBox(height: dimens.space12)],
          Semantics(
            header: true,
            child: Text(l10n.agendaUpcoming, style: context.textStyles.titleSmall!.copyWith(color: scheme.primary)),
          ),
          for (final row in visits) ...[
            SizedBox(height: dimens.space12),
            _AgendaCard(row: row, onTap: state.isOffline ? null : () => onVisitSelected(row)),
          ],
        ],
      );
    } else {
      body = SingleChildScrollView(
        padding: EdgeInsets.all(dimens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: dimens.space12,
          children: [
            if (state.needsConnection) ...[
              banner,
              EmptyState(
                title: l10n.practitionerOfflineTitle,
                text: l10n.agendaOfflineBody,
                actionLabel: l10n.dsRetry,
                onAction: onRetry,
              ),
            ] else if (state.isLoading)
              for (var i = 0; i < _skeletonRows; i++) const SkeletonListItem()
            else if (state.isEmpty) ...[
              if (state.isOffline) banner,
              // The empty state's call to action is the same fixed "Schedule visit" below.
              EmptyState(title: l10n.agendaEmptyTitle, text: l10n.agendaEmptyBody),
            ] else if (state.loadFailed)
              ErrorState(onRetry: onRetry),
          ],
        ),
      );
    }
    final screen = ColoredBox(
      color: scheme.surface,
      child: Column(
        children: [
          HealthifyTopAppBar(
            title: l10n.agendaTitle,
            actions: [
              HealthifyIconButton(icon: HealthifyIcons.menu, contentDescription: l10n.menuCdOpen, onPressed: onOpenMenu),
            ],
          ),
          Expanded(child: body),
          // "Schedule visit" fixed at the bottom (above the NavigationBar); offline it cannot schedule.
          Padding(
            padding: EdgeInsets.all(dimens.space16),
            child: HealthifyButton(
              text: l10n.agendaSchedule,
              onPressed: onSchedule,
              enabled: !state.isOffline,
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
    final dialog = state.dialog;
    return StateDialogOverlay(
      dialog: dialog == null ? null : _dialogFor(context, dialog),
      onDismiss: onDialogDismissed,
      child: screen,
    );
  }

  Widget _dialogFor(BuildContext context, AgendaDialog dialog) {
    final l10n = AppLocalizations.of(context);
    return switch (dialog) {
      AgendaDialog.confirmCancel => HealthifyDialog(
        title: l10n.agendaCancelDialogTitle,
        text: l10n.agendaCancelDialogBody,
        confirmLabel: l10n.agendaCancelConfirm,
        onConfirm: onCancelConfirmed,
        onDismiss: onDialogDismissed,
        destructive: true,
        confirmLoading: state.isCancelling,
      ),
      AgendaDialog.notCancellable => HealthifyDialog(
        title: l10n.agendaNotCancellableTitle,
        text: l10n.agendaNotCancellableBody,
        confirmLabel: l10n.commonUnderstood,
        onConfirm: onDialogDismissed,
        onDismiss: onDialogDismissed,
        informational: true,
      ),
      AgendaDialog.noActiveLink => HealthifyDialog(
        title: l10n.practitionerNoActiveLinkTitle,
        text: l10n.practitionerNoActiveLinkBody,
        confirmLabel: l10n.commonUnderstood,
        onConfirm: onDialogDismissed,
        onDismiss: onDialogDismissed,
        informational: true,
      ),
      AgendaDialog.serverError => ServerErrorDialog(onRetry: onCancelConfirmed, onDismiss: onDialogDismissed),
    };
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({required this.row, required this.onTap});

  final AgendaRow row;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return HealthifyCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(dimens.space16),
        child: Row(
          spacing: dimens.space16,
          children: [
            _DateBadge(moment: row.scheduledFor),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: dimens.space4,
                children: [
                  Text(
                    row.patientName ?? l10n.inboxUnknownPatient,
                    style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
                  ),
                  Text(
                    l10n.agendaRowTime(weekdayText(row.scheduledFor, l10n.locale), shortTimeText(row.scheduledFor, l10n.locale)),
                    style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            HealthifyIcon(HealthifyIcons.chevronRight, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// «18 / SEPT»: day and abbreviated month (no period) in uppercase.
class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.moment});

  final DateTime moment;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final tag = AppLocalizations.of(context).locale.toLanguageTag();
    final date = moment.toLocal();
    final month = DateFormat.MMM(tag).format(date).replaceAll('.', '').toUpperCase();
    return SizedBox.square(
      dimension: _dateBadgeSize,
      child: DecoratedBox(
        decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: context.dimens.shapeSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat.d(tag).format(date).padLeft(2, '0'),
              style: context.textStyles.titleMedium!.copyWith(color: scheme.onPrimaryContainer),
              textAlign: TextAlign.center,
            ),
            Text(
              month,
              style: context.textStyles.labelSmall!.copyWith(color: scheme.onPrimaryContainer),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitSheetContent extends StatelessWidget {
  const _VisitSheetContent({required this.row});

  final AgendaRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space24, dimens.space16, dimens.space24, dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.space12,
        children: [
          Semantics(
            header: true,
            child: Text(
              row.patientName ?? l10n.inboxUnknownPatient,
              style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface),
            ),
          ),
          Text(
            l10n.agendaRowTime(weekdayText(row.scheduledFor, l10n.locale), shortTimeText(row.scheduledFor, l10n.locale)),
            style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
          ),
          HealthifyButton(
            text: l10n.agendaReschedule,
            onPressed: () => Navigator.of(context).pop(_VisitAction.reschedule),
            style: HealthifyButtonStyle.tonal,
            fullWidth: true,
          ),
          HealthifyButton(
            text: l10n.agendaViewPatient,
            onPressed: () => Navigator.of(context).pop(_VisitAction.viewPatient),
            style: HealthifyButtonStyle.tonal,
            fullWidth: true,
          ),
          HealthifyButton(
            text: l10n.agendaCancel,
            onPressed: () => Navigator.of(context).pop(_VisitAction.cancel),
            style: HealthifyButtonStyle.outlined,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

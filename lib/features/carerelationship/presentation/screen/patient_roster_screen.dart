import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/route_resume_effect.dart';
import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_icon_button.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/list_card.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../main/presentation/navigation/shell_routes.dart';
import '../../domain/valueobject/roster_attention.dart';
import '../cubit/patient_roster_cubit.dart';
import '../state/patient_roster_state.dart';

// Measurements from the home frame grouped by action.
const _avatarSize = 40.0;
const _stackedAvatarSize = 32.0;
const _stackedAvatarOverlap = 10.0;
const _stackedAvatars = 3;
const _skeletonRows = 4;

/// My patients ("Patients" tab of the nutritionist shell), grouped by action: those who need something (with the
/// reason) and those up to date, collapsed into one row. Tapping a patient opens their file.
///
/// The screen does not scroll; if a list does not fit, it scrolls inside its card.
///
/// [onOpenMenu] is the shell's main menu button.
class PatientRosterScreen extends StatelessWidget {
  const PatientRosterScreen({
    super.key,
    required this.onInvitePatient,
    required this.onOpenPatient,
    required this.onOpenMenu,
  });

  final VoidCallback onInvitePatient;
  final void Function(RosterItem patient) onOpenPatient;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<PatientRosterCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<PatientRosterCubit>();
        return RouteResumeEffect(
          path: patientsPath,
          onResume: cubit.onResume,
          child: BlocBuilder<PatientRosterCubit, PatientRosterState>(
            builder: (context, state) => PatientRosterContent(
              state: state,
              onInvitePatient: onInvitePatient,
              onOpenPatient: onOpenPatient,
              onRetry: cubit.onRetry,
              onOpenMenu: onOpenMenu,
              onQueryChange: cubit.onQueryChange,
              onToggleUpToDate: cubit.onToggleUpToDate,
            ),
          ),
        );
      },
    ),
  );
}

class PatientRosterContent extends StatelessWidget {
  const PatientRosterContent({
    super.key,
    required this.state,
    required this.onInvitePatient,
    required this.onOpenPatient,
    required this.onRetry,
    required this.onOpenMenu,
    required this.onQueryChange,
    required this.onToggleUpToDate,
  });

  final PatientRosterState state;
  final VoidCallback onInvitePatient;
  final void Function(RosterItem patient) onOpenPatient;
  final VoidCallback onRetry;
  final VoidCallback onOpenMenu;
  final ValueChanged<String> onQueryChange;
  final VoidCallback onToggleUpToDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final patients = state.patients;
    return ColoredBox(
      color: scheme.surface,
      child: Column(
        children: [
          HealthifyTopAppBar(
            title: l10n.rosterTitle,
            actions: [
              HealthifyIconButton(
                icon: HealthifyIcons.menu,
                contentDescription: l10n.menuCdOpen,
                onPressed: onOpenMenu,
              ),
            ],
          ),
          Expanded(
            child: patients != null && patients.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.fromLTRB(dimens.space16, dimens.space16, dimens.space16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.isOffline) ...[
                          const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                          SizedBox(height: dimens.space12),
                        ],
                        _SearchField(query: state.query, onChanged: onQueryChange),
                        SizedBox(height: dimens.space12),
                        Expanded(
                          child: _RosterGroups(
                            state: state,
                            onOpenPatient: onOpenPatient,
                            onToggleUpToDate: onToggleUpToDate,
                          ),
                        ),
                      ],
                    ),
                  )
                : _NoRosterBody(state: state, onRetry: onRetry),
          ),
          // "Invite patient" pinned at the bottom (above the NavigationBar); offline the code cannot be generated.
          ColoredBox(
            color: scheme.surface,
            child: Padding(
              padding: EdgeInsets.all(dimens.space16),
              child: HealthifyButton(
                text: l10n.rosterInvite,
                onPressed: onInvitePatient,
                enabled: !state.isOffline,
                fullWidth: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading, offline, empty and error bodies: everything that is not a list of patients.
class _NoRosterBody extends StatelessWidget {
  const _NoRosterBody({required this.state, required this.onRetry});

  final PatientRosterState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    const banner = OfflineBanner(type: OfflineBannerType.requiresNetwork);
    final Widget body;
    if (state.needsConnection) {
      body = Column(
        children: [
          banner,
          SizedBox(height: dimens.space12),
          EmptyState(
            title: l10n.rosterOfflineTitle,
            text: l10n.rosterOfflineBody,
            actionLabel: l10n.dsRetry,
            onAction: onRetry,
          ),
        ],
      );
    } else if (state.isLoading) {
      body = Column(
        children: [
          for (var i = 0; i < _skeletonRows; i++) ...[
            if (i > 0) SizedBox(height: dimens.space12),
            const SkeletonListItem(),
          ],
        ],
      );
    } else if (state.isEmpty) {
      body = Column(
        children: [
          if (state.isOffline) ...[banner, SizedBox(height: dimens.space12)],
          EmptyState(title: l10n.rosterEmptyTitle, text: l10n.rosterEmptyBody),
        ],
      );
    } else if (state.loadFailed) {
      body = ErrorState(onRetry: onRetry);
    } else {
      body = const SizedBox.shrink();
    }
    return SingleChildScrollView(padding: EdgeInsets.all(dimens.space16), child: body);
  }
}

/// Filters the roster by name on the phone.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.query, required this.onChanged});

  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return HealthifyTextField(
      value: query,
      onChanged: onChanged,
      label: l10n.rosterSearch,
      placeholder: l10n.rosterSearchPlaceholder,
      textInputAction: TextInputAction.search,
      trailingIcon: HealthifyIcon(HealthifyIcons.search, color: context.colors.onSurfaceVariant),
    );
  }
}

/// "Need action · N" (hidden if nobody) and "Up to date · N". Each group takes what it needs; if they do not fit, the
/// height is shared and each list scrolls inside its card.
class _RosterGroups extends StatelessWidget {
  const _RosterGroups({required this.state, required this.onOpenPatient, required this.onToggleUpToDate});

  final PatientRosterState state;
  final void Function(RosterItem patient) onOpenPatient;
  final VoidCallback onToggleUpToDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    if (state.noSearchResults) {
      return SingleChildScrollView(
        child: EmptyState(
          title: l10n.rosterNoResultsTitle,
          text: l10n.rosterNoResultsBody(state.query.trim()),
        ),
      );
    }
    final needsAction = state.needsAction;
    final upToDate = state.upToDate;
    final expanded = state.isUpToDateExpanded;
    return Column(
      children: [
        if (needsAction.isNotEmpty)
          Flexible(
            child: HealthifyCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _GroupTitle(l10n.rosterNeedsAction(needsAction.length)),
                  Flexible(child: _PatientList(patients: needsAction, onOpenPatient: onOpenPatient)),
                ],
              ),
            ),
          ),
        if (needsAction.isNotEmpty && upToDate.isNotEmpty) SizedBox(height: dimens.space12),
        if (upToDate.isNotEmpty)
          // Collapsed it takes its own height; expanded it shares the room with the first card.
          Flexible(
            child: HealthifyCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _UpToDateRow(patients: upToDate, expanded: expanded, onTap: onToggleUpToDate),
                  if (expanded) Flexible(child: _PatientList(patients: upToDate, onOpenPatient: onOpenPatient)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space16, dimens.space16, dimens.space16, dimens.space4),
      child: Semantics(
        header: true,
        child: Text(text, style: context.textStyles.titleSmall!.copyWith(color: context.colors.onSurface)),
      ),
    );
  }
}

class _PatientList extends StatelessWidget {
  const _PatientList({required this.patients, required this.onOpenPatient});

  final List<RosterItem> patients;
  final void Function(RosterItem patient) onOpenPatient;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: dimens.space16),
      itemCount: patients.length,
      separatorBuilder: (_, _) =>
          Divider(height: dimens.borderThin, thickness: dimens.borderThin, color: context.colors.outlineVariant),
      itemBuilder: (context, index) {
        final patient = patients[index];
        return _PatientRow(key: ValueKey(patient.patientId), patient: patient, onTap: () => onOpenPatient(patient));
      },
    );
  }
}

/// "Ana Flores · Signal to review" (or, when up to date, just the name).
class _PatientRow extends StatelessWidget {
  const _PatientRow({super.key, required this.patient, required this.onTap});

  final RosterItem patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final attention = patient.attention;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: dimens.touchMin),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: dimens.space12),
            child: Row(
              children: [
                _Avatar(name: patient.fullName, color: _avatarColor(scheme, attention), size: _avatarSize),
                SizedBox(width: dimens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.fullName,
                        style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
                      ),
                      if (attention != null) ...[
                        SizedBox(height: dimens.space4),
                        Text(
                          _attentionLabel(l10n, attention),
                          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: dimens.space12),
                HealthifyIcon(HealthifyIcons.chevronRight, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Up to date · 9 · Nothing pending" with up to three overlapping avatars; tapping it expands it in place.
class _UpToDateRow extends StatelessWidget {
  const _UpToDateRow({required this.patients, required this.expanded, required this.onTap});

  final List<RosterItem> patients;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final stacked = patients.take(_stackedAvatars).toList();
    const step = _stackedAvatarSize - _stackedAvatarOverlap;
    return Semantics(
      button: true,
      expanded: expanded,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: dimens.touchMin),
          child: Padding(
            padding: EdgeInsets.all(dimens.space16),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: SizedBox(
                    width: _stackedAvatarSize + step * (stacked.length - 1),
                    height: _stackedAvatarSize,
                    child: Stack(
                      children: [
                        for (var i = 0; i < stacked.length; i++)
                          Positioned(
                            left: step * i,
                            child: _Avatar(
                              name: stacked[i].fullName,
                              color: scheme.surfaceContainer,
                              size: _stackedAvatarSize,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: dimens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.rosterUpToDate(patients.length),
                        style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
                      ),
                      SizedBox(height: dimens.space4),
                      Text(
                        l10n.rosterUpToDateBody,
                        style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: dimens.space12),
                // Expanded, the chevron points up (tap to collapse).
                Transform.rotate(
                  angle: expanded ? -math.pi / 2 : 0,
                  child: HealthifyIcon(HealthifyIcons.chevronRight, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.color, required this.size});

  final String name;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final initial = name.trim().isEmpty ? '' : String.fromCharCode(name.trim().runes.first).toUpperCase();
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: scheme.surfaceContainerLowest, width: context.dimens.borderThin),
        ),
        child: Text(initial, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
      ),
    );
  }
}

/// The avatar background follows the reason: signal (light orange), consultation (light green), the rest neutral.
Color _avatarColor(ColorScheme scheme, RosterAttention? attention) => switch (attention) {
  RosterAttention.openReview => scheme.secondaryContainer,
  RosterAttention.consultationInProgress => scheme.primaryContainer,
  _ => scheme.surfaceContainer,
};

String _attentionLabel(AppLocalizations l10n, RosterAttention attention) => switch (attention) {
  RosterAttention.openReview => l10n.rosterReasonOpenReview,
  RosterAttention.consultationInProgress => l10n.rosterReasonConsultation,
  RosterAttention.missingBaseline => l10n.rosterReasonBaseline,
  RosterAttention.planNotPublished => l10n.rosterReasonPlan,
};

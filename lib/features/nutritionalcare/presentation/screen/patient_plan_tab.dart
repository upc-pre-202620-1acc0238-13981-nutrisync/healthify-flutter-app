import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/component_support.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/component/status_chip.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../../carerelationship/domain/entity/targets_read_status.dart';
import '../../domain/entity/plan_history.dart';
import '../components/clinical_texts.dart';
import '../components/patient_tab_layout.dart';
import '../components/plan_version_sheet.dart';
import '../cubit/patient_plan_cubit.dart';
import '../state/patient_tab_states.dart';
import '../state/plan_version_item.dart';

const _skeletonRows = 3;

/// Plan tab: current targets, whether the patient saw them ("Ana saw them the same day"), guidelines, restrictions and
/// the plan history. "Adjust plan" starts or resumes the guided consultation (the screen reacts to the cubit's event).
///
/// There is no frame for a version's detail; tapping a history row opens [showPlanVersionSheet].
class PatientPlanTab extends StatelessWidget {
  const PatientPlanTab({super.key, required this.patientName});

  final String patientName;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PatientPlanCubit>();
    return BlocBuilder<PatientPlanCubit, PatientPlanState>(
      builder: (context, state) => PatientPlanContent(
        state: state,
        patientName: patientName,
        onAdjustPlan: cubit.onAdjustPlan,
        onRetry: cubit.onRetry,
        onSelectVersion: (version) {
          final selected = state.history?.versions.where((v) => v.version == version).firstOrNull;
          if (selected != null) showPlanVersionSheet(context, PlanVersionItem.fromHistory(selected));
        },
      ),
    );
  }
}

class PatientPlanContent extends StatelessWidget {
  const PatientPlanContent({
    super.key,
    required this.state,
    required this.patientName,
    required this.onAdjustPlan,
    required this.onRetry,
    required this.onSelectVersion,
  });

  final PatientPlanState state;
  final String patientName;
  final VoidCallback onAdjustPlan;
  final VoidCallback onRetry;
  final ValueChanged<int> onSelectVersion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final history = state.history;
    return PatientTabLayout(
      bottomBar: history?.active == null
          ? null
          : HealthifyButton(
              text: l10n.planAdjust,
              onPressed: onAdjustPlan,
              style: HealthifyButtonStyle.tonal,
              loading: state.isStartingConsultation,
              enabled: !state.isOffline,
              fullWidth: true,
            ),
      children: [
        if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
        if (history != null && history.active == null)
          EmptyState(title: l10n.planEmptyTitle, text: l10n.planEmptyBody)
        else if (history != null)
          ..._planBody(context, history)
        else if (state.isLoading)
          for (var i = 0; i < _skeletonRows; i++) const SkeletonListItem()
        else if (state.loadFailed && state.isOffline)
          NeedsConnection(onRetry: onRetry)
        else if (state.loadFailed)
          ErrorState(onRetry: onRetry),
      ],
    );
  }

  List<Widget> _planBody(BuildContext context, PlanHistory history) {
    final active = history.active!;
    return [
      _ActiveTargetsCard(active: active, readStatus: state.readStatus, patientName: patientName),
      _GuidelinesCard(active: active),
      _HistorySection(versions: history.versions, onSelect: onSelectVersion),
    ];
  }
}

class _ActiveTargetsCard extends StatelessWidget {
  const _ActiveTargetsCard({required this.active, required this.readStatus, required this.patientName});

  final NutritionPlanVersion active;
  final TargetsReadStatus? readStatus;
  final String patientName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final locale = l10n.locale;
    return SectionCard(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.planActiveTargets,
                style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
              ),
            ),
            StatusChip(type: StatusChipType.confirmed, label: l10n.planVersionChip(active.version)),
          ],
        ),
        Row(
          spacing: dimens.space8,
          children: [
            Expanded(child: PlanMacro(compactText(active.targets.energyKcal, locale, maxDecimals: 0), l10n.planKcalPerDay)),
            Expanded(child: PlanMacro(l10n.unitGValue(compactText(active.targets.proteinG, locale, maxDecimals: 0)), l10n.macroProtein)),
            Expanded(child: PlanMacro(l10n.unitGValue(compactText(active.targets.carbG, locale, maxDecimals: 0)), l10n.macroCarbsShort)),
            Expanded(child: PlanMacro(l10n.unitGValue(compactText(active.targets.fatG, locale, maxDecimals: 0)), l10n.macroFat)),
          ],
        ),
        Text(
          publishedLine(l10n, active, readStatus, patientName),
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// "Published on Sep 4 · Ana saw them the same day." With the current version acknowledged it says when; if not seen
/// yet, "has not reviewed them yet" (an inviting tone). Without the link's read status only the date shows.
String publishedLine(
  AppLocalizations l10n,
  NutritionPlanVersion active,
  TargetsReadStatus? readStatus,
  String patientName,
) {
  final format = DateFormat('d MMM', l10n.locale.toLanguageTag());
  final published = _day(active.publishedAt);
  final publishedText = l10n.planPublishedOn(format.format(published));
  final trimmed = patientName.trim();
  final firstName = trimmed.contains(' ') ? trimmed.substring(0, trimmed.indexOf(' ')) : trimmed;
  final String? seen;
  if (readStatus == null) {
    seen = null;
  } else if (readStatus.lastAcknowledgedVersion == active.version && readStatus.lastAcknowledgedAt != null) {
    final seenOn = _day(readStatus.lastAcknowledgedAt!);
    seen = seenOn == published
        ? l10n.planSeenSameDay(firstName)
        : l10n.planSeenOn(firstName, format.format(seenOn));
  } else if (readStatus.lastAcknowledgedVersion == active.version) {
    seen = l10n.planSeen(firstName);
  } else {
    seen = l10n.planNotSeenYet(firstName);
  }
  return [publishedText, ?seen].join(textSeparator);
}

DateTime _day(DateTime instant) {
  final local = instant.toLocal();
  return DateTime(local.year, local.month, local.day);
}

class _GuidelinesCard extends StatelessWidget {
  const _GuidelinesCard({required this.active});

  final NutritionPlanVersion active;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      verticalSpacing: context.dimens.space16,
      children: [
        PlanTagGroup(title: l10n.planGuidelines, tags: [for (final g in active.guidelines) l10n.guideline(g)]),
        PlanTagGroup(title: l10n.planRestrictions, tags: [for (final r in active.restrictions) l10n.restriction(r)]),
      ],
    );
  }
}

/// "PLAN HISTORY": "Version 3 · Sep 4, 2026 · 1 796 kcal · Current".
class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.versions, required this.onSelect});

  final List<NutritionPlanVersion> versions;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.dimens.space8,
      children: [
        SectionOverline(l10n.planHistory),
        SectionCard(
          children: [
            for (var i = 0; i < versions.length; i++) ...[
              if (i > 0) const CardDivider(),
              HealthifyPressable(
                onTap: () => onSelect(versions[i].version),
                builder: (context, _) => IconInfoRow(
                  icon: HealthifyIcons.history,
                  title: l10n.planVersionTitle(versions[i].version),
                  supportingText: l10n.planVersionLine(
                    mediumDateText(versions[i].publishedAt, l10n.locale),
                    compactText(versions[i].targets.energyKcal, l10n.locale, maxDecimals: 0),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: context.dimens.space8,
                    children: [
                      if (versions[i].isActive)
                        StatusChip(type: StatusChipType.confirmed, label: l10n.patientPlanActiveChip),
                      HealthifyIcon(HealthifyIcons.chevronRight, color: scheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

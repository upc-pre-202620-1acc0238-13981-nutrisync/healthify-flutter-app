import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/designsystem/component/ai_badge.dart';
import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/component/status_chip.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/patient_monitoring_panel.dart';
import '../../domain/valueobject/monitoring_values.dart';
import '../cubit/patient_follow_up_cubit.dart';
import '../state/patient_follow_up_state.dart';

// Figma "This week" chart: bars with 4 dp radius; height by the day's outcome (not a quantity).
const _barMaxHeight = 72.0;
const _barMetHeight = 64.0;
const _barShortHeight = 40.0;
const _barUnloggedHeight = 8.0;
const _legendDotSize = 8.0;
const _skeletonRows = 4;

/// Follow-up tab: Mon-Sun week, self-weighing trend, days with logs, AI-generated summary ("Review it before using it
/// in a visit"), today's **read-only** diary and the last clinical measurement (a series separate from self-weighing).
///
/// The frame only draws "Within goals" and "Below". "Above" uses `tertiary` and "No log" is a low outlined mark with no
/// fill: a day without logs is not non-compliance and is never drawn as "Below" or in red. The legend shows only the
/// week's outcomes.
class PatientFollowUpTab extends StatelessWidget {
  const PatientFollowUpTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PatientFollowUpCubit>();
    return BlocBuilder<PatientFollowUpCubit, PatientFollowUpState>(
      builder: (context, state) => PatientFollowUpContent(state: state, onRetry: cubit.onRetry),
    );
  }
}

class PatientFollowUpContent extends StatelessWidget {
  const PatientFollowUpContent({super.key, required this.state, required this.onRetry});

  final PatientFollowUpState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final panel = state.panel;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(dimens.space16, dimens.space24, dimens.space16, dimens.space40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.space24,
        children: [
          if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
          if (panel != null)
            ..._followUpBody(context, panel, state.aiSummary)
          else if (state.isLoading)
            for (var i = 0; i < _skeletonRows; i++) const SkeletonListItem()
          else if (state.loadFailed && state.isOffline)
            EmptyState(
              title: l10n.rosterOfflineTitle,
              text: l10n.patientOfflineBody,
              actionLabel: l10n.dsRetry,
              onAction: onRetry,
            )
          else if (state.loadFailed)
            ErrorState(onRetry: onRetry),
        ],
      ),
    );
  }
}

List<Widget> _followUpBody(BuildContext context, PatientMonitoringPanel panel, String? aiSummary) {
  final l10n = AppLocalizations.of(context);
  final dimens = context.dimens;
  final trend = panel.weightTrend;
  final slope = trend?.slopeKgPerWeek;
  final loggedDays = panel.loggedDays;
  return [
    if (panel.week != null) _WeekCard(week: panel.week!),
    IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.space8,
        children: [
          Expanded(
            child: MetricCard(
              label: l10n.followUpWeightTrend,
              value: slope == null ? valueMissing : l10n.unitKgPerWeek(signedDecimalText(slope, l10n.locale)),
              caption: l10n.followUpWeightTrendCaption(trend?.weeks ?? 0),
            ),
          ),
          Expanded(
            child: MetricCard(
              label: l10n.followUpLogging,
              value: loggedDays == null ? valueMissing : l10n.daysOfTotal(loggedDays.count, loggedDays.total),
              caption: l10n.followUpLoggingCaption,
            ),
          ),
        ],
      ),
    ),
    if (aiSummary != null && aiSummary.trim().isNotEmpty) _AiSummaryCard(text: aiSummary),
    _DiaryCard(entries: panel.diary),
    if (panel.lastClinicalMeasurement != null) _ClinicalMeasurementCard(measurement: panel.lastClinicalMeasurement!),
    Text(
      l10n.followUpReadOnly,
      style: context.textStyles.bodySmall!.copyWith(color: context.colors.onSurfaceVariant),
    ),
  ];
}

class _WeekCard extends StatelessWidget {
  const _WeekCard({required this.week});

  final PanelWeek week;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return SectionCard(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.followUpThisWeek,
                style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
              ),
            ),
            Text(
              l10n.daysOfTotal(week.metDays, week.totalDays),
              style: context.textStyles.labelLarge!.copyWith(color: scheme.primary),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: dimens.space8,
          children: [for (final day in week.days) Expanded(child: _DayBar(day: day))],
        ),
        Wrap(
          spacing: dimens.space16,
          runSpacing: dimens.space8,
          children: [
            for (final outcome in ComplianceOutcome.values)
              if (week.days.any((day) => day.outcome == outcome)) _LegendItem(outcome: outcome),
          ],
        ),
      ],
    );
  }
}

class _DayBar extends StatelessWidget {
  const _DayBar({required this.day});

  final PanelDay day;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final tag = l10n.locale.toLanguageTag();
    final letter = DateFormat('EEEEE', tag).format(day.date).toUpperCase();
    final description = l10n.followUpDayCd(DateFormat('EEEE', tag).format(day.date), outcomeLabel(l10n, day.outcome));
    final shape = BorderRadius.circular(dimens.radiusXs);
    return Semantics(
      container: true,
      label: description,
      excludeSemantics: true,
      child: Column(
        spacing: dimens.space4,
        children: [
          SizedBox(
            height: _barMaxHeight,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: _barHeight(day.outcome),
                decoration: day.outcome == ComplianceOutcome.unlogged
                    ? BoxDecoration(
                        borderRadius: shape,
                        border: Border.all(color: scheme.outline, width: dimens.borderThin),
                      )
                    : BoxDecoration(borderRadius: shape, color: outcomeColor(scheme, day.outcome)),
              ),
            ),
          ),
          Text(letter, style: context.textStyles.labelMedium!.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  static double _barHeight(ComplianceOutcome outcome) => switch (outcome) {
    ComplianceOutcome.met => _barMetHeight,
    ComplianceOutcome.exceeded => _barMaxHeight,
    ComplianceOutcome.short => _barShortHeight,
    ComplianceOutcome.unlogged => _barUnloggedHeight,
  };
}

/// "Within targets" / "Above" / "Below" / "Not logged".
String outcomeLabel(AppLocalizations l10n, ComplianceOutcome outcome) => switch (outcome) {
  ComplianceOutcome.met => l10n.followUpLegendMet,
  ComplianceOutcome.exceeded => l10n.followUpLegendExceeded,
  ComplianceOutcome.short => l10n.followUpLegendShort,
  ComplianceOutcome.unlogged => l10n.followUpLegendUnlogged,
};

Color outcomeColor(ColorScheme scheme, ComplianceOutcome outcome) => switch (outcome) {
  ComplianceOutcome.met => scheme.primary,
  ComplianceOutcome.exceeded => scheme.tertiary,
  ComplianceOutcome.short => scheme.secondary,
  ComplianceOutcome.unlogged => scheme.outline,
};

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.outcome});

  final ComplianceOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: dimens.space8,
      children: [
        Container(
          width: _legendDotSize,
          height: _legendDotSize,
          decoration: outcome == ComplianceOutcome.unlogged
              ? BoxDecoration(shape: BoxShape.circle, border: Border.all(color: scheme.outline, width: dimens.borderThin))
              : BoxDecoration(shape: BoxShape.circle, color: outcomeColor(scheme, outcome)),
        ),
        Text(
          outcomeLabel(AppLocalizations.of(context), outcome),
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// AI summary: `tertiary` border; the AI text already arrives in the reader's language.
class _AiSummaryCard extends StatelessWidget {
  const _AiSummaryCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colors;
    return SectionCard(
      borderColor: scheme.tertiary,
      children: [
        Align(alignment: Alignment.centerLeft, child: AiBadge(label: l10n.followUpAiBadge)),
        Text(text, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface)),
        Text(
          l10n.followUpAiReview,
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// "Today's diary" (read-only: the practitioner never writes or corrects entries).
class _DiaryCard extends StatelessWidget {
  const _DiaryCard({required this.entries});

  final List<PanelDiaryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return SectionCard(
      children: [
        Text(l10n.followUpDiaryToday, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
        if (entries.isEmpty)
          Text(
            l10n.followUpDiaryEmpty,
            style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
          ),
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0) const CardDivider(),
          Row(
            spacing: dimens.space8,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: dimens.space4,
                  children: [
                    Text(_title(l10n, entries[i]), style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface)),
                    Text(
                      l10n.followUpEntryMeta(
                        shortTimeText(entries[i].localTimestamp, l10n.locale),
                        _provenanceLabel(l10n, entries[i].provenance),
                      ),
                      style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (entries[i].isAwaitingConfirmation)
                const StatusChip(type: StatusChipType.pendingConfirmation)
              else
                StatusChip(type: StatusChipType.confirmed, label: l10n.followUpEntryConfirmed),
            ],
          ),
        ],
      ],
    );
  }

  String _title(AppLocalizations l10n, PanelDiaryEntry entry) {
    final name = entry.foodName ?? l10n.followUpFoodUnnamed;
    final grams = entry.grams;
    return grams == null ? name : l10n.followUpFoodPortion(name, compactText(grams.roundToDouble(), l10n.locale, maxDecimals: 0));
  }

  String _provenanceLabel(AppLocalizations l10n, PanelEntryProvenance provenance) => switch (provenance) {
    PanelEntryProvenance.photo => l10n.followUpProvenancePhoto,
    PanelEntryProvenance.manual => l10n.followUpProvenanceManual,
    PanelEntryProvenance.offPlan => l10n.followUpProvenanceOffPlan,
  };
}

/// "Last clinical measurement · Sep 3 · fasting, no shoes · 74.2 kg".
class _ClinicalMeasurementCard extends StatelessWidget {
  const _ClinicalMeasurementCard({required this.measurement});

  final PanelClinicalMeasurement measurement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final date = DateFormat('d MMM', l10n.locale.toLanguageTag()).format(measurement.takenAt.toLocal());
    final protocol = measurement.protocolChecks.map((check) => _protocolLabel(l10n, check).toLowerCase()).join(', ');
    return SectionCard(
      children: [
        Row(
          spacing: dimens.space8,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: dimens.space4,
                children: [
                  Text(
                    l10n.followUpLastMeasurement,
                    style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface),
                  ),
                  Text(
                    [date, protocol].where((part) => part.isNotEmpty).join(' · '),
                    style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Text(
              l10n.unitKgValue(decimalText(measurement.weightKg, l10n.locale)),
              style: context.textStyles.labelLarge!.copyWith(color: scheme.onSurface),
            ),
          ],
        ),
      ],
    );
  }

  String _protocolLabel(AppLocalizations l10n, PanelProtocolCheck check) => switch (check) {
    PanelProtocolCheck.fasting => l10n.protocolFasting,
    PanelProtocolCheck.noShoes => l10n.protocolNoShoes,
    PanelProtocolCheck.lightClothing => l10n.protocolLightClothing,
    PanelProtocolCheck.emptyBladder => l10n.protocolEmptyBladder,
    PanelProtocolCheck.sameScale => l10n.protocolSameScale,
  };
}

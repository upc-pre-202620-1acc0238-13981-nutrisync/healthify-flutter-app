import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/designsystem/component/ai_badge.dart';
import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/list_card.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/component/status_chip.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/patient_monitoring_panel.dart';
import '../../domain/valueobject/monitoring_values.dart';
import '../cubit/patient_follow_up_cubit.dart';
import '../state/patient_follow_up_state.dart';

// "This week" chart (compact dashboard): bars with 4 dp radius; height by the day's outcome (not a quantity).
const _barMaxHeight = 52.0;
const _barMetHeight = 42.0;
const _barShortHeight = 24.0;
const _barUnloggedHeight = 8.0;
const _legendDotSize = 8.0;
const _skeletonRows = 4;

/// Follow-up tab (compact dashboard, so a small phone needs little scrolling): the Mon-Sun week with its full legend,
/// three indicators in one row (self-weighing trend, days with logs, last clinical measurement), and two accordions for
/// the AI-generated summary ("Review it before using it in a visit") and today's **read-only** diary. Both accordions
/// start open; nothing is hidden, only collapsible.
///
/// "Above" uses `tertiary` and "No log" is a low outlined mark with no fill: a day without logs is not non-compliance
/// and is never drawn as "Below" or in red. The legend always lists the four outcomes, even those the week does not
/// have, so the colors can be read without remembering them.
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
      padding: EdgeInsets.fromLTRB(dimens.space16, dimens.space16, dimens.space16, dimens.space40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.space12,
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
  return [
    if (panel.week != null) _WeekCard(week: panel.week!),
    _IndicatorsRow(panel: panel),
    if (aiSummary != null && aiSummary.trim().isNotEmpty) _AiSummaryAccordion(text: aiSummary),
    _DiaryAccordion(entries: panel.diary),
    Text(l10n.followUpReadOnly, style: context.textStyles.bodySmall!.copyWith(color: context.colors.onSurfaceVariant)),
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
      verticalSpacing: dimens.space8,
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
          runSpacing: dimens.space4,
          children: [for (final outcome in ComplianceOutcome.values) _LegendItem(outcome: outcome)],
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
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.outline, width: dimens.borderThin),
                )
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

/// Three compact indicators in one row: self-weighing trend, days with logs and the last clinical measurement (a series
/// separate from self-weighing). The measurement's protocol («fasting, no shoes») goes on a caption under the row so it
/// is not lost.
class _IndicatorsRow extends StatelessWidget {
  const _IndicatorsRow({required this.panel});

  final PatientMonitoringPanel panel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final locale = l10n.locale;
    final trend = panel.weightTrend;
    final slope = trend?.slopeKgPerWeek;
    final ratio = panel.loggedDays;
    final measurement = panel.lastClinicalMeasurement;
    final date = measurement == null
        ? null
        : DateFormat('d MMM', locale.toLanguageTag()).format(measurement.takenAt.toLocal());
    final protocol = measurement == null
        ? ''
        : measurement.protocolChecks.map((check) => _protocolLabel(l10n, check).toLowerCase()).join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: dimens.space8,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: dimens.space8,
            children: [
              Expanded(
                child: _IndicatorTile(
                  label: l10n.followUpKpiWeight,
                  description: trend == null
                      ? l10n.followUpWeightTrend
                      : '${l10n.followUpWeightTrend}. ${l10n.followUpWeightTrendCaption(trend.weeks)}',
                  value: slope == null ? valueMissing : signedDecimalText(slope, locale),
                  caption: slope == null ? '' : l10n.followUpKpiWeightCaption(trend!.weeks),
                ),
              ),
              Expanded(
                child: _IndicatorTile(
                  label: l10n.followUpLogging,
                  description: '${l10n.followUpLogging} · ${l10n.followUpLoggingCaption}',
                  value: ratio == null ? valueMissing : l10n.followUpKpiRatio(ratio.count, ratio.total),
                  caption: ratio == null ? '' : l10n.followUpKpiDays,
                ),
              ),
              Expanded(
                child: _IndicatorTile(
                  label: l10n.followUpKpiMeasurement,
                  description: l10n.followUpLastMeasurement,
                  value: measurement == null ? valueMissing : decimalText(measurement.weightKg, locale),
                  caption: date == null ? '' : l10n.followUpKpiMeasurementCaption(date),
                ),
              ),
            ],
          ),
        ),
        if (protocol.isNotEmpty)
          Text(
            l10n.followUpKpiMeasurementProtocol(protocol),
            style: context.textStyles.bodySmall!.copyWith(color: context.colors.onSurfaceVariant),
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

/// A small card: label, value in the metric style and a short caption. Reads as one phrase to a screen reader.
class _IndicatorTile extends StatelessWidget {
  const _IndicatorTile({required this.label, required this.description, required this.value, required this.caption});

  final String label;
  final String description;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    final spoken = [description, value, caption].where((part) => part.isNotEmpty).join('. ');
    return Semantics(
      container: true,
      label: spoken,
      excludeSemantics: true,
      child: HealthifyCard(
        shape: dimens.shapeExtraLarge,
        child: Padding(
          padding: EdgeInsets.all(dimens.space12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: dimens.space4,
            children: [
              Text(label, style: context.textStyles.labelMedium!.copyWith(color: scheme.onSurfaceVariant)),
              Text(value, style: context.extendedTypography.metricMedium.copyWith(color: scheme.onSurface)),
              if (caption.isNotEmpty)
                Text(caption, style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card whose header toggles its content. [header] sits left of the chevron; the whole header row is the 48 dp touch
/// target and announces «Show» or «Hide».
class _Accordion extends StatelessWidget {
  const _Accordion({
    required this.expanded,
    required this.onToggle,
    required this.header,
    required this.children,
    this.borderColor,
  });

  final bool expanded;
  final VoidCallback onToggle;
  final List<Widget> header;
  final List<Widget> children;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return SectionCard(
      borderColor: borderColor,
      verticalSpacing: dimens.space8,
      children: [
        Semantics(
          button: true,
          expanded: expanded,
          onTapHint: expanded ? l10n.followUpCollapse : l10n.followUpExpand,
          child: InkWell(
            onTap: onToggle,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: dimens.touchMin),
              child: Row(
                spacing: dimens.space8,
                children: [
                  ...header,
                  RotatedBox(
                    quarterTurns: expanded ? 3 : 1,
                    child: HealthifyIcon(HealthifyIcons.chevronRight, color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (expanded) ...children,
      ],
    );
  }
}

/// AI summary: `tertiary` border; the AI text already arrives in the reader's language.
class _AiSummaryAccordion extends StatefulWidget {
  const _AiSummaryAccordion({required this.text});

  final String text;

  @override
  State<_AiSummaryAccordion> createState() => _AiSummaryAccordionState();
}

class _AiSummaryAccordionState extends State<_AiSummaryAccordion> {
  var _expanded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colors;
    return _Accordion(
      expanded: _expanded,
      onToggle: () => setState(() => _expanded = !_expanded),
      borderColor: scheme.tertiary,
      header: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: AiBadge(label: l10n.followUpAiBadge),
          ),
        ),
      ],
      children: [
        Text(widget.text, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface)),
        Text(l10n.followUpAiReview, style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

/// "Today's diary" (read-only: the practitioner never writes or corrects entries).
class _DiaryAccordion extends StatefulWidget {
  const _DiaryAccordion({required this.entries});

  final List<PanelDiaryEntry> entries;

  @override
  State<_DiaryAccordion> createState() => _DiaryAccordionState();
}

class _DiaryAccordionState extends State<_DiaryAccordion> {
  var _expanded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final entries = widget.entries;
    final pending = entries.where((entry) => entry.isAwaitingConfirmation).length;
    return _Accordion(
      expanded: _expanded,
      onToggle: () => setState(() => _expanded = !_expanded),
      header: [
        Expanded(
          child: Text(
            l10n.followUpDiaryToday,
            style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
          ),
        ),
        // Even collapsed, the header says there is something to review.
        if (pending > 0)
          StatusChip(type: StatusChipType.pendingConfirmation, label: l10n.followUpPendingCount(pending)),
      ],
      children: [
        if (entries.isEmpty)
          Text(l10n.followUpDiaryEmpty, style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant)),
        // "Pending confirmation" alone did not say whether to count the meal (validation interviews).
        if (pending > 0)
          Text(
            l10n.followUpPendingConfirmationHint,
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
                    Text(
                      _title(l10n, entries[i]),
                      style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface),
                    ),
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
    return grams == null
        ? name
        : l10n.followUpFoodPortion(name, compactText(grams.roundToDouble(), l10n.locale, maxDecimals: 0));
  }

  String _provenanceLabel(AppLocalizations l10n, PanelEntryProvenance provenance) => switch (provenance) {
    PanelEntryProvenance.photo => l10n.followUpProvenancePhoto,
    PanelEntryProvenance.manual => l10n.followUpProvenanceManual,
    PanelEntryProvenance.offPlan => l10n.followUpProvenanceOffPlan,
  };
}

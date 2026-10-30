import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../components/clinical_texts.dart';
import '../components/patient_header_card.dart';
import '../components/patient_tab_layout.dart';
import '../cubit/patient_summary_cubit.dart';
import '../state/patient_tab_states.dart';

const _skeletonRows = 4;
const _lastWeekDays = 7;
const _disabledOpacity = 0.38;

/// Summary tab of the patient file: the patient card, the baseline (with "Edit"), the consultation in progress, the
/// next visit, "since the last consultation", the management actions and the pinned button: "Record baseline data",
/// "New consultation" or "Continue consultation".
///
/// [onOpenFollowUp] switches to the Follow-up tab ("Trend"); [onDischarge] opens the discharge screen; [onSchedule] and
/// [onReferral] open the schedule form and the referral form.
class PatientSummaryTab extends StatelessWidget {
  const PatientSummaryTab({
    super.key,
    required this.onOpenFollowUp,
    required this.onSchedule,
    required this.onReferral,
    required this.onDischarge,
  });

  final VoidCallback onOpenFollowUp;
  final VoidCallback onSchedule;
  final VoidCallback onReferral;
  final VoidCallback onDischarge;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PatientSummaryCubit>();
    return BlocBuilder<PatientSummaryCubit, PatientSummaryState>(
      builder: (context, state) => PatientSummaryContent(
        state: state,
        onPrimaryAction: cubit.onPrimaryAction,
        onEditBaseline: cubit.onEditBaseline,
        onOpenFollowUp: onOpenFollowUp,
        onSchedule: onSchedule,
        onReferral: onReferral,
        onDischarge: onDischarge,
        onRetry: cubit.onRetry,
      ),
    );
  }
}

class PatientSummaryContent extends StatelessWidget {
  const PatientSummaryContent({
    super.key,
    required this.state,
    required this.onPrimaryAction,
    required this.onEditBaseline,
    required this.onOpenFollowUp,
    required this.onSchedule,
    required this.onReferral,
    required this.onDischarge,
    required this.onRetry,
  });

  final PatientSummaryState state;
  final VoidCallback onPrimaryAction;
  final VoidCallback onEditBaseline;
  final VoidCallback onOpenFollowUp;
  final VoidCallback onSchedule;
  final VoidCallback onReferral;
  final VoidCallback onDischarge;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summary = state.summary;
    return PatientTabLayout(
      bottomBar: summary == null
          ? null
          : HealthifyButton(
              text: !summary.hasBaseline
                  ? l10n.summaryRegisterBaseline
                  : summary.consultationInProgress != null
                  ? l10n.summaryContinueConsultation
                  : l10n.summaryStartConsultation,
              onPressed: onPrimaryAction,
              loading: state.isStartingConsultation,
              enabled: !state.isOffline,
              fullWidth: true,
            ),
      children: [
        if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
        if (summary != null)
          ..._summaryBody(context, summary)
        else if (state.isLoading)
          for (var i = 0; i < _skeletonRows; i++) const SkeletonListItem()
        else if (state.loadFailed && state.isOffline)
          NeedsConnection(onRetry: onRetry)
        else if (state.loadFailed)
          ErrorState(onRetry: onRetry),
      ],
    );
  }

  List<Widget> _summaryBody(BuildContext context, PatientSummary summary) {
    final baseline = summary.baseline;
    return [
      PatientHeaderCard(
        fullName: summary.fullName,
        linkedSince: summary.linkedSince,
        activePlanVersion: summary.activePlanVersion,
        isNew: summary.isNew,
      ),
      if (baseline == null)
        const _NoBaselineState()
      else ...[
        if (summary.consultationInProgress != null) _InProgressCard(inProgress: summary.consultationInProgress!),
        if (summary.nextFollowUp != null) _NextFollowUpCard(next: summary.nextFollowUp!),
        _BaselineCard(baseline: baseline, onEdit: onEditBaseline, enabled: !state.isOffline),
        _SinceLastConsultation(since: summary.sinceLastConsultation, onOpenFollowUp: onOpenFollowUp),
        _ManagementSection(
          onSchedule: onSchedule,
          onReferral: onReferral,
          onDischarge: onDischarge,
          enabled: !state.isOffline,
        ),
      ],
    ];
  }
}

/// "No baseline yet".
class _NoBaselineState extends StatelessWidget {
  const _NoBaselineState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colors;
    return Padding(
      padding: EdgeInsets.only(top: context.dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.dimens.space8,
        children: [
          Text(l10n.summaryNoBaselineTitle, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
          Text(
            l10n.summaryNoBaselineBody,
            style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// "Consultation in progress · Step 1 of 4 · Today's measurement · saved today".
class _InProgressCard extends StatelessWidget {
  const _InProgressCard({required this.inProgress});

  final ConsultationInProgress inProgress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      children: [
        IconInfoRow(
          icon: HealthifyIcons.history,
          title: l10n.summaryInProgressTitle,
          supportingText: l10n.summaryInProgressBody(
            inProgress.step.number,
            ConsultationStep.total,
            l10n.stepTitle(inProgress.step),
            savedWhenText(l10n, inProgress.lastSavedAt),
          ),
        ),
      ],
    );
  }
}

/// "saved today" / "saved yesterday" / "saved on Sep 3".
String savedWhenText(AppLocalizations l10n, DateTime at, {DateTime? now}) {
  final date = at.toLocal();
  final today = (now ?? DateTime.now()).toLocal();
  final day = DateTime(date.year, date.month, date.day);
  final todayDay = DateTime(today.year, today.month, today.day);
  if (day == todayDay) return l10n.savedToday;
  if (day == DateTime(todayDay.year, todayDay.month, todayDay.day - 1)) return l10n.savedYesterday;
  return l10n.savedOn(DateFormat('d MMM', l10n.locale.toLanguageTag()).format(day));
}

class _NextFollowUpCard extends StatelessWidget {
  const _NextFollowUpCard({required this.next});

  final SummaryFollowUp next;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      children: [
        IconInfoRow(
          icon: HealthifyIcons.calendar,
          title: l10n.summaryNextFollowUp,
          supportingText: l10n.summaryFollowUpWhen(
            weekdayDayMonthText(next.scheduledFor, l10n.locale),
            shortTimeText(next.scheduledFor, l10n.locale),
          ),
        ),
      ],
    );
  }
}

class _BaselineCard extends StatelessWidget {
  const _BaselineCard({required this.baseline, required this.onEdit, required this.enabled});

  final BaselineSummary baseline;
  final VoidCallback onEdit;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final conditions = l10n.conditionsInline(baseline.conditions);
    return SectionCard(
      children: [
        IconInfoRow(
          icon: HealthifyIcons.person,
          title: l10n.summaryBaselineTitle,
          supportingText: [l10n.baselineHeadline(baseline), ?conditions].join(textSeparator),
          trailing: HealthifyButton(
            text: l10n.commonEdit,
            onPressed: onEdit,
            style: HealthifyButtonStyle.text,
            enabled: enabled,
          ),
        ),
      ],
    );
  }
}

/// "SINCE THE LAST CONSULTATION": self-weigh-in trend (never a single day's weight) and adherence.
class _SinceLastConsultation extends StatelessWidget {
  const _SinceLastConsultation({required this.since, required this.onOpenFollowUp});

  final SinceLastConsultation since;
  final VoidCallback onOpenFollowUp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final slope = since.weightSlopeKgPerWeek;
    final compliance = since.compliance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: dimens.space8,
      children: [
        SectionOverline(l10n.summarySinceLastConsultation),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: dimens.space8,
            children: [
              Expanded(
                child: MetricCard(
                  label: l10n.summaryWeightLabel,
                  value: slope == null ? valueMissing : l10n.unitKgPerWeek(signedDecimalText(slope, l10n.locale)),
                  caption: l10n.summaryWeightCaption(since.trendWeeks),
                  captionColor: context.colors.primary,
                  onTap: onOpenFollowUp,
                ),
              ),
              Expanded(
                child: MetricCard(
                  label: l10n.summaryComplianceLabel,
                  value: compliance == null ? valueMissing : l10n.daysOfTotal(compliance.met, compliance.total),
                  caption: compliance?.total == _lastWeekDays
                      ? l10n.summaryComplianceLastWeek
                      : l10n.summaryComplianceSince(
                          DateFormat('d MMM', l10n.locale.toLanguageTag()).format(since.fromDate),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "MANAGEMENT": schedule a consultation, record a referral and discharge.
class _ManagementSection extends StatelessWidget {
  const _ManagementSection({
    required this.onSchedule,
    required this.onReferral,
    required this.onDischarge,
    required this.enabled,
  });

  final VoidCallback onSchedule;
  final VoidCallback onReferral;
  final VoidCallback onDischarge;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Offline none of these can be sent: they show disabled.
    return Opacity(
      opacity: enabled ? 1 : _disabledOpacity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.dimens.space8,
        children: [
          SectionOverline(l10n.summaryManagement),
          SectionCard(
            verticalSpacing: context.dimens.space4,
            children: [
              ActionRow(
                icon: HealthifyIcons.agenda,
                text: l10n.summarySchedule,
                onTap: () {
                  if (enabled) onSchedule();
                },
              ),
              ActionRow(
                icon: HealthifyIcons.forward,
                text: l10n.summaryReferral,
                onTap: () {
                  if (enabled) onReferral();
                },
              ),
              ActionRow(
                icon: HealthifyIcons.info,
                text: l10n.dischargeAction,
                onTap: () {
                  if (enabled) onDischarge();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

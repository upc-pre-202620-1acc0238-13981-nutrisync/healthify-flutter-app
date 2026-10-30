import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_bottom_sheet.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../../nutritionalcare/domain/entity/consultation.dart';
import '../../../nutritionalcare/domain/entity/patient_baseline.dart';
import '../../../nutritionalcare/domain/entity/patient_record.dart';
import '../../../nutritionalcare/domain/entity/patient_summary.dart';
import '../../../nutritionalcare/domain/valueobject/clinical_codes.dart';
import '../../../nutritionalcare/presentation/components/clinical_texts.dart';
import '../../../nutritionalcare/presentation/components/patient_record_sections.dart';
import '../../../nutritionalcare/presentation/components/patient_tab_layout.dart';
import '../../../nutritionalcare/presentation/components/record_detail_sheets.dart';
import '../../../nutritionalcare/presentation/screen/patient_summary_tab.dart' show savedWhenText;
import '../cubit/patient_history_cubit.dart';
import '../state/patient_history_state.dart';

const _skeletonRows = 4;

/// Record tab ("Historia"): the baseline (edit it), the consultation in progress and the clinical record. The guided
/// consultation starts from the Summary tab.
class PatientHistoryTab extends StatelessWidget {
  const PatientHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PatientHistoryCubit>();
    return BlocBuilder<PatientHistoryCubit, PatientHistoryState>(
      builder: (context, state) => PatientHistoryContent(
        state: state,
        onEditBaseline: cubit.onEditBaseline,
        onRetry: cubit.onRetry,
        onSelectReferral: (referral) => showReferralSheet(context, referral),
        onSelectEvaluation: (assessmentId) => _openEvaluationSheet(context, cubit, assessmentId),
      ),
    );
  }

  /// The detail is read when tapped; the sheet follows the cubit (loading, failed, loaded) and tells it when it closes.
  Future<void> _openEvaluationSheet(BuildContext context, PatientHistoryCubit cubit, int assessmentId) async {
    cubit.onEvaluationSelected(assessmentId);
    await showHealthifyBottomSheet<void>(
      context: context,
      builder: (_) => BlocBuilder<PatientHistoryCubit, PatientHistoryState>(
        bloc: cubit,
        buildWhen: (previous, current) => previous.evaluationSheet != current.evaluationSheet,
        builder: (context, state) {
          final sheet = state.evaluationSheet;
          return EvaluationSheetContent(
            detail: sheet is EvaluationLoaded ? sheet.detail : null,
            failed: sheet is EvaluationFailed,
            onRetry: cubit.onEvaluationRetry,
          );
        },
      ),
    );
    cubit.onEvaluationDismissed();
  }
}

class PatientHistoryContent extends StatelessWidget {
  const PatientHistoryContent({
    super.key,
    required this.state,
    required this.onEditBaseline,
    required this.onRetry,
    this.onSelectReferral = _ignoreReferral,
    this.onSelectEvaluation = _ignoreEvaluation,
  });

  final PatientHistoryState state;
  final VoidCallback onEditBaseline;
  final VoidCallback onRetry;
  final ValueChanged<ReferralSummary> onSelectReferral;
  final ValueChanged<int> onSelectEvaluation;

  static void _ignoreReferral(ReferralSummary _) {}

  static void _ignoreEvaluation(int _) {}

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    return PatientTabLayout(
      children: [
        if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
        if (data != null)
          ..._historyBody(context, data)
        else if (state.isLoading)
          for (var i = 0; i < _skeletonRows; i++) const SkeletonListItem()
        else if (state.loadFailed && state.isOffline)
          NeedsConnection(onRetry: onRetry)
        else if (state.loadFailed)
          ErrorState(onRetry: onRetry),
      ],
    );
  }

  List<Widget> _historyBody(BuildContext context, HistoryData data) {
    final baseline = data.baseline;
    return [
      if (baseline == null) const _NoBaselineState() else _BaselineCard(baseline: baseline, onEdit: onEditBaseline, enabled: !state.isOffline),
      if (data.inProgress != null) _InProgressCard(consultation: data.inProgress!),
      if (data.record != null)
        PatientRecordSections(
          record: data.record!,
          onSelectReferral: onSelectReferral,
          onSelectEvaluation: onSelectEvaluation,
        )
      else if (data.recordFailed)
        PatientRecordUnavailable(onRetry: onRetry),
    ];
  }
}

class _NoBaselineState extends StatelessWidget {
  const _NoBaselineState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.dimens.space8,
      children: [
        Text(l10n.summaryNoBaselineTitle, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
        Text(
          l10n.summaryNoBaselineBody,
          style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _BaselineCard extends StatelessWidget {
  const _BaselineCard({required this.baseline, required this.onEdit, required this.enabled});

  final PatientBaseline baseline;
  final VoidCallback onEdit;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headline = l10n.baselineHeadline(
      BaselineSummary(
        sex: baseline.sex,
        ageYears: baseline.ageYears,
        heightCm: baseline.heightCm,
        conditions: baseline.conditions,
      ),
    );
    final conditions = l10n.conditionsInline(baseline.conditions);
    return SectionCard(
      children: [
        IconInfoRow(
          icon: HealthifyIcons.person,
          title: l10n.summaryBaselineTitle,
          supportingText: [headline, ?conditions].join(textSeparator),
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

/// "Consultation in progress · Step 1 of 4 · Today's measurement · saved today".
class _InProgressCard extends StatelessWidget {
  const _InProgressCard({required this.consultation});

  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      children: [
        IconInfoRow(
          icon: HealthifyIcons.history,
          title: l10n.summaryInProgressTitle,
          supportingText: l10n.summaryInProgressBody(
            consultation.currentStep.number,
            ConsultationStep.total,
            l10n.stepTitle(consultation.currentStep),
            savedWhenText(l10n, consultation.lastSavedAt),
          ),
        ),
      ],
    );
  }
}

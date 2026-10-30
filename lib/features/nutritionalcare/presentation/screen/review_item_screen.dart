import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/ai_badge.dart';
import '../../../../core/designsystem/component/dialog_overlay.dart';
import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/component/yes_no_selector.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/entity/plan_proposal.dart';
import '../../domain/entity/review_item.dart';
import '../components/clinical_texts.dart';
import '../components/review_parts.dart';
import '../cubit/review_item_cubit.dart';
import '../state/review_states.dart';

const _generatingIndicatorSize = 20.0;
const _generatingIndicatorStroke = 2.0;

/// Resolve item (plus the Yes/No prompt) and review a signal with an AI-proposed plan.
class ReviewItemScreen extends StatelessWidget {
  const ReviewItemScreen({
    super.key,
    required this.reviewItemId,
    required this.onBack,
    required this.onResolved,
    required this.onClose,
    required this.onOpenAdjust,
    required this.onOpenPatient,
  });

  final int reviewItemId;
  final VoidCallback onBack;

  /// Resolved (with or without a plan): back to the inbox, which shows the "Signal resolved" snackbar.
  final void Function(String? patientName) onResolved;

  /// The item is gone: back to the inbox (which is reloaded).
  final VoidCallback onClose;
  final void Function(int reviewItemId) onOpenAdjust;

  /// "Adjust the plan now" -> patient file.
  final void Function(int patientId, int careLinkId, String patientName) onOpenPatient;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<ReviewItemCubit>(param1: reviewItemId),
    child: Builder(
      builder: (context) {
        final cubit = context.read<ReviewItemCubit>();
        return ObserveEvents<ReviewItemEvent>(
          events: cubit.events,
          onEvent: (context, event) => switch (event) {
            ReviewResolved(:final patientName) => onResolved(patientName),
            OpenAdjust(:final reviewItemId) => onOpenAdjust(reviewItemId),
            OpenPatientFile(:final patientId, :final careLinkId, :final patientName) => onOpenPatient(
              patientId,
              careLinkId,
              patientName,
            ),
            CloseReviewItem() => onClose(),
          },
          child: BlocBuilder<ReviewItemCubit, ReviewItemState>(
            builder: (context, state) => ReviewItemContent(
              state: state,
              onBack: onBack,
              onRetryLoad: cubit.onRetryLoad,
              onClose: onClose,
              onAdjustedChange: cubit.onAdjustedChange,
              onNoteChange: cubit.onNoteChange,
              onResolve: cubit.onResolve,
              onAdjustPlanNow: cubit.onAdjustPlanNow,
              onAcceptAsIs: cubit.onAcceptAsIs,
              onAdjust: cubit.onAdjust,
              onResolveWithoutProposal: cubit.onResolveWithoutProposal,
              onDialogConfirmed: cubit.onDialogConfirmed,
              onDialogDismissed: cubit.onDialogDismissed,
            ),
          ),
        );
      },
    ),
  );
}

class ReviewItemContent extends StatelessWidget {
  const ReviewItemContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onRetryLoad,
    required this.onClose,
    required this.onAdjustedChange,
    required this.onNoteChange,
    required this.onResolve,
    required this.onAdjustPlanNow,
    required this.onAcceptAsIs,
    required this.onAdjust,
    required this.onResolveWithoutProposal,
    required this.onDialogConfirmed,
    required this.onDialogDismissed,
  });

  final ReviewItemState state;
  final VoidCallback onBack;
  final VoidCallback onRetryLoad;
  final VoidCallback onClose;
  final ValueChanged<bool> onAdjustedChange;
  final ValueChanged<String> onNoteChange;
  final VoidCallback onResolve;
  final VoidCallback onAdjustPlanNow;
  final VoidCallback onAcceptAsIs;
  final VoidCallback onAdjust;
  final VoidCallback onResolveWithoutProposal;
  final VoidCallback onDialogConfirmed;
  final VoidCallback onDialogDismissed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final item = state.item;
    final loadError = state.loadError;
    final dialog = state.dialog;
    final screen = Scaffold(
      backgroundColor: context.colors.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(title: l10n.reviewTitle, onBack: onBack),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.all(dimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space16,
                children: [
                  if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                  if (state.isLoading)
                    ...[const SkeletonCard(), const SkeletonCard()]
                  else if (loadError != null)
                    _LoadErrorBody(error: loadError, onClose: onClose, onRetry: onRetryLoad)
                  else if (item != null)
                    ..._body(context, item),
                ],
              ),
            ),
          ),
          if (item != null && !state.isLoading && loadError == null) _BottomActions(
            state: state,
            onResolve: onResolve,
            onAdjustPlanNow: onAdjustPlanNow,
            onAcceptAsIs: onAcceptAsIs,
            onAdjust: onAdjust,
          ),
        ],
      ),
    );
    return StateDialogOverlay(
      dialog: dialog == null
          ? null
          : reviewDialogFor(context, dialog, onConfirm: onDialogConfirmed, onDismiss: onDialogDismissed),
      onDismiss: onDialogDismissed,
      child: screen,
    );
  }

  List<Widget> _body(BuildContext context, ReviewItem item) {
    final l10n = AppLocalizations.of(context);
    return [
      ReviewEvidenceCard(item: item),
      switch (state.proposal) {
        ProposalLoaded(:final proposal) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.dimens.space16,
          children: [
            _ProposalCard(proposal: proposal, patientName: item.patientFullName),
            if (!state.showManualResolution)
              Center(
                child: HealthifyButton(
                  text: l10n.reviewResolveWithoutProposal,
                  onPressed: onResolveWithoutProposal,
                  style: HealthifyButtonStyle.text,
                  enabled: !state.isBusy,
                ),
              ),
          ],
        ),
        ProposalPreparing() => _GeneratingCard(
          showResolveNow: !state.showManualResolution,
          onResolveNow: onResolveWithoutProposal,
        ),
        ProposalNotOffered() => const SizedBox.shrink(),
      },
      if (state.showsResolutionForm) ..._resolutionForm(context),
    ];
  }

  List<Widget> _resolutionForm(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    return [
      SectionCard(
        verticalSpacing: dimens.space16,
        children: [
          YesNoSelector(
            question: l10n.reviewAdjustedQuestion,
            answer: state.adjusted,
            onAnswer: onAdjustedChange,
            enabled: !state.isBusy,
            isError: state.showOutcomeError,
            errorText: state.showOutcomeError ? l10n.reviewAnswerYesNo : null,
          ),
          HealthifyTextField(
            value: state.note,
            onChanged: onNoteChange,
            label: l10n.reviewNoteLabel,
            placeholder: l10n.reviewNotePlaceholder,
            enabled: !state.isBusy,
            singleLine: false,
          ),
        ],
      ),
      Text(
        l10n.reviewResolutionInfo,
        style: context.textStyles.bodySmall!.copyWith(color: context.colors.onSurfaceVariant),
      ),
    ];
  }
}

class _LoadErrorBody extends StatelessWidget {
  const _LoadErrorBody({required this.error, required this.onClose, required this.onRetry});

  final ReviewLoadError error;
  final VoidCallback onClose;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (error) {
      ReviewLoadError.notAvailable => EmptyState(
        title: l10n.reviewNotAvailableTitle,
        text: l10n.reviewNotAvailableBody,
        actionLabel: l10n.reviewBackToInbox,
        onAction: onClose,
      ),
      ReviewLoadError.offline => EmptyState(
        title: l10n.practitionerOfflineTitle,
        text: l10n.inboxOfflineBody,
        actionLabel: l10n.dsRetry,
        onAction: onRetry,
      ),
      ReviewLoadError.generic => ErrorState(onRetry: onRetry),
    };
  }
}

/// "AI-proposed plan" card (`tertiary` outline). Reading it never changes the plan.
class _ProposalCard extends StatelessWidget {
  const _ProposalCard({required this.proposal, required this.patientName});

  final PlanAdjustmentProposal proposal;
  final String? patientName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final locale = l10n.locale;
    final current = proposal.currentEnergyKcal;
    final energy = current == null
        ? l10n.proposalEnergyValue(compactText(proposal.proposed.energyKcal, locale, maxDecimals: 0))
        : l10n.proposalEnergyChange(
            compactText(current, locale, maxDecimals: 0),
            compactText(proposal.proposed.energyKcal, locale, maxDecimals: 0),
          );
    final firstName = patientName?.split(' ').first;
    return SectionCard(
      borderColor: scheme.tertiary,
      verticalSpacing: dimens.space16,
      children: [
        Align(alignment: Alignment.centerLeft, child: AiBadge(label: l10n.reviewAiProposalBadge)),
        Text(proposal.title, style: context.textStyles.titleLarge!.copyWith(color: scheme.onSurface)),
        ProposalRow(icon: HealthifyIcons.edit, title: l10n.proposalDailyEnergy, supportingText: energy),
        for (final code in proposal.addedGuidelines)
          ProposalRow(
            icon: HealthifyIcons.add,
            title: l10n.proposalAddedGuideline,
            supportingText: l10n.guideline(CatalogGuideline(code)),
          ),
        for (final code in proposal.removedGuidelines)
          ProposalRow(
            icon: HealthifyIcons.close,
            title: l10n.proposalRemovedGuideline,
            supportingText: l10n.guideline(CatalogGuideline(code)),
          ),
        if (proposal.patientMessage.trim().isNotEmpty)
          ProposalRow(
            icon: HealthifyIcons.info,
            title: firstName == null || firstName.isEmpty ? l10n.proposalMessageForPatient : l10n.proposalMessageFor(firstName),
            // AI text in the patient's language: shown as is.
            supportingText: l10n.proposalQuoted(proposal.patientMessage),
          ),
        ProposalRow(
          icon: HealthifyIcons.calendar,
          title: l10n.proposalFollowUp,
          supportingText: l10n.proposalRecheckInDays(proposal.recheckAfterDays),
        ),
        if (proposal.rationale.trim().isNotEmpty)
          DecoratedBox(
            decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: dimens.shapeMedium),
            child: Padding(
              padding: EdgeInsets.all(dimens.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space4,
                children: [
                  Text(l10n.proposalWhy, style: context.textStyles.labelLarge!.copyWith(color: scheme.onSurfaceVariant)),
                  Text(proposal.rationale, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// `202`: the AI is preparing the proposal; the item can be resolved without waiting.
class _GeneratingCard extends StatelessWidget {
  const _GeneratingCard({required this.showResolveNow, required this.onResolveNow});

  final bool showResolveNow;
  final VoidCallback onResolveNow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return SectionCard(
      borderColor: scheme.tertiary,
      children: [
        Align(alignment: Alignment.centerLeft, child: AiBadge(label: l10n.reviewAiProposalBadge)),
        Row(
          spacing: dimens.space12,
          children: [
            SizedBox.square(
              dimension: _generatingIndicatorSize,
              child: CircularProgressIndicator(color: scheme.primary, strokeWidth: _generatingIndicatorStroke),
            ),
            Expanded(
              child: Text(l10n.reviewAiGenerating, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface)),
            ),
          ],
        ),
        if (showResolveNow)
          Align(
            alignment: Alignment.centerLeft,
            child: HealthifyButton(text: l10n.reviewResolveNow, onPressed: onResolveNow, style: HealthifyButtonStyle.text),
          ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.state,
    required this.onResolve,
    required this.onAdjustPlanNow,
    required this.onAcceptAsIs,
    required this.onAdjust,
  });

  final ReviewItemState state;
  final VoidCallback onResolve;
  final VoidCallback onAdjustPlanNow;
  final VoidCallback onAcceptAsIs;
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final Widget actions;
    if (state.proposal is ProposalLoaded && !state.showManualResolution) {
      // "Adjust" (Outlined) and "Resolve" (assigns as is) side by side.
      actions = Row(
        spacing: dimens.space12,
        children: [
          Expanded(
            child: HealthifyButton(
              text: l10n.reviewAdjust,
              onPressed: onAdjust,
              style: HealthifyButtonStyle.outlined,
              enabled: !state.isBusy,
            ),
          ),
          Expanded(
            child: HealthifyButton(
              text: state.isAccepting ? l10n.reviewAssigning : l10n.reviewResolve,
              onPressed: onAcceptAsIs,
              loading: state.isAccepting,
              enabled: !state.isBusy,
            ),
          ),
        ],
      );
    } else if (state.showsResolutionForm) {
      actions = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.space12,
        children: [
          HealthifyButton(
            text: state.isResolving ? l10n.commonSaving : l10n.reviewResolve,
            onPressed: onResolve,
            loading: state.isResolving,
            enabled: !state.isBusy,
            fullWidth: true,
          ),
          HealthifyButton(
            text: l10n.reviewAdjustPlanNow,
            onPressed: onAdjustPlanNow,
            style: HealthifyButtonStyle.outlined,
            loading: state.isOpeningPatient,
            enabled: !state.isBusy && !state.isOffline,
            fullWidth: true,
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      child: Padding(padding: EdgeInsets.all(dimens.space16), child: actions),
    );
  }
}

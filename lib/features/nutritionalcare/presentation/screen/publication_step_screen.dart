import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/ai_badge.dart';
import '../../../../core/designsystem/component/failure_state.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_chips.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../components/consultation_step_scaffold.dart';
import '../components/consultation_texts.dart';
import '../cubit/publication_step_cubit.dart';
import '../state/consultation_step_states.dart';

/// Step 4, guidelines and publication (plus the publish error). "Publish and close consultation" publishes the new
/// version (it replaces the current one) and closes the consultation.
class PublicationStepScreen extends StatelessWidget {
  const PublicationStepScreen({super.key, required this.patientId, required this.onEvent});

  final int patientId;
  final void Function(BuildContext context, ConsultationStepEvent event) onEvent;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<PublicationStepCubit>(param1: patientId),
    child: Builder(
      builder: (context) {
        final cubit = context.read<PublicationStepCubit>();
        return BlocBuilder<PublicationStepCubit, PublicationState>(
          builder: (context, state) => PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              if (state.publishFailed) {
                cubit.onPublishFailureDismissed();
              } else {
                cubit.onBack();
              }
            },
            child: ObserveEvents<ConsultationStepEvent>(
              events: cubit.events,
              onEvent: onEvent,
              child: PublicationStepContent(state: state, cubit: cubit),
            ),
          ),
        );
      },
    ),
  );
}

class PublicationStepContent extends StatelessWidget {
  const PublicationStepContent({super.key, required this.state, required this.cubit});

  final PublicationState state;
  final PublicationStepCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (state.publishFailed) {
      return _PublishFailedContent(isRetrying: state.isPublishing, onRetry: cubit.onRetryPublish);
    }
    return ConsultationStepScaffold(
      step: ConsultationStep.publication,
      load: state.load.copyWith(isOffline: state.isOffline || state.load.isOffline),
      onBack: cubit.onBack,
      onRetry: cubit.onRetry,
      actions: [
        HealthifyButton(
          text: l10n.publicationPublish,
          onPressed: cubit.onPublish,
          loading: state.isPublishing,
          enabled: !state.isOffline && !state.messageTooLong,
        ),
      ],
      children: [
        _RestrictionsCard(state: state, cubit: cubit),
        _GuidelinesCard(state: state, cubit: cubit),
        _MessageCard(state: state, cubit: cubit),
        Text(
          l10n.publicationPatientSees,
          style: context.textStyles.bodySmall!.copyWith(color: context.colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _RestrictionsCard extends StatelessWidget {
  const _RestrictionsCard({required this.state, required this.cubit});

  final PublicationState state;
  final PublicationStepCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return SectionCard(
      verticalSpacing: dimens.space8,
      children: [
        Text(l10n.publicationRestrictions, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
        Text(
          l10n.publicationChooseSeveral,
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
        Wrap(
          spacing: dimens.space8,
          runSpacing: dimens.space8,
          children: [
            for (final code in PlanRestrictionCode.values)
              HealthifyFilterChip(
                text: l10n.restrictionCodeLabel(code),
                selected: state.restrictions.contains(code),
                onSelectedChange: (_) => cubit.onRestrictionToggle(code),
              ),
          ],
        ),
      ],
    );
  }
}

class _GuidelinesCard extends StatelessWidget {
  const _GuidelinesCard({required this.state, required this.cubit});

  final PublicationState state;
  final PublicationStepCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    // Suggested ones go first; then the rest of the catalog.
    final ordered = [...state.suggested, ...PlanGuidelineCode.values.where((code) => !state.suggested.contains(code))];
    return SectionCard(
      verticalSpacing: dimens.space8,
      children: [
        Text(l10n.publicationGuidelines, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
        if (state.suggestionStatus == AiRequestStatus.loading) ...[
          const SkeletonLine(lines: 1),
          Text(
            l10n.aiGeneratingNote,
            style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
          ),
        ] else if (state.suggestionStatus == AiRequestStatus.failed) ...[
          Text(
            l10n.publicationSuggestionsFailed,
            style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: HealthifyButton(
              text: l10n.dsRetry,
              onPressed: cubit.onRetrySuggestions,
              style: HealthifyButtonStyle.tonal,
              enabled: !state.isOffline,
            ),
          ),
        ] else if (state.suggested.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: state.suggestedByAi
                ? AiBadge(label: l10n.publicationSuggestedAi)
                : HealthifyTag(text: l10n.publicationSuggestedRule),
          ),
        Wrap(
          spacing: dimens.space8,
          runSpacing: dimens.space8,
          children: [
            for (final code in ordered)
              HealthifyFilterChip(
                text: l10n.guidelineCodeLabel(code),
                selected: state.guidelines.contains(code),
                onSelectedChange: (_) => cubit.onGuidelineToggle(code),
              ),
            // "Other guideline" written by the practitioner: shown as is; tapping it removes it.
            for (final text in state.customGuidelines)
              HealthifyFilterChip(text: text, selected: true, onSelectedChange: (_) => cubit.onRemoveCustom(text)),
          ],
        ),
        if (state.showCustomField) ...[
          HealthifyTextField(
            value: state.customDraft,
            onChanged: cubit.onCustomDraftChange,
            label: l10n.publicationOtherGuideline,
            supportingText: l10n.textCounter(state.customDraft.trim().length, CustomGuidelineText.maxLength),
            errorText: state.customError
                ? (state.customGuidelines.length >= CustomGuidelineText.maxPerVersion
                      ? l10n.publicationOtherGuidelineMax
                      : l10n.publicationOtherGuidelineLength)
                : null,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: HealthifyButton(
              text: l10n.publicationAddGuideline,
              onPressed: cubit.onConfirmCustom,
              style: HealthifyButtonStyle.tonal,
            ),
          ),
        ] else if (state.customGuidelines.length < CustomGuidelineText.maxPerVersion)
          Align(
            alignment: Alignment.centerLeft,
            child: HealthifyButton(
              text: l10n.publicationOtherGuideline,
              onPressed: cubit.onAddCustomClick,
              style: HealthifyButtonStyle.text,
              icon: HealthifyIcons.add,
            ),
          ),
      ],
    );
  }
}

/// Optional message to the patient, shown with their targets; practitioner text, never translated.
class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.state, required this.cubit});

  final PublicationState state;
  final PublicationStepCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      children: [
        Text(l10n.publicationMessage, style: context.textStyles.titleMedium!.copyWith(color: context.colors.onSurface)),
        HealthifyTextField(
          value: state.patientMessage,
          onChanged: cubit.onPatientMessageChange,
          label: l10n.publicationMessageLabel,
          placeholder: l10n.publicationMessagePlaceholder,
          supportingText: l10n.textCounter(state.patientMessage.trim().length, PatientMessage.maxLength),
          errorText: state.messageTooLong ? l10n.publicationMessageTooLong : null,
          singleLine: false,
        ),
      ],
    );
  }
}

/// "SOMETHING WENT WRONG · We could not publish the plan. What you wrote was not lost." (blames no one).
class _PublishFailedContent extends StatelessWidget {
  const _PublishFailedContent({required this.isRetrying, required this.onRetry});

  final bool isRetrying;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: dimens.space16, vertical: dimens.space40),
          child: Center(
            child: FailureState(
              title: l10n.publicationErrorTitle,
              text: l10n.publicationErrorBody,
              actionLabel: l10n.publicationErrorRetry,
              onAction: onRetry,
              actionLoading: isRetrying,
            ),
          ),
        ),
      ),
    );
  }
}

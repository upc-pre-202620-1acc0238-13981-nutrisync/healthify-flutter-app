import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/ai_badge.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_chips.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../components/consultation_step_scaffold.dart';
import '../components/consultation_texts.dart';
import '../cubit/diagnosis_step_cubit.dart';
import '../state/consultation_step_states.dart';

/// Step 2, diagnosis (only for the professional record: the patient will not see it). "‹" goes to the previous step
/// through [onBack]; the other outcomes arrive as [onEvent].
class DiagnosisStepScreen extends StatelessWidget {
  const DiagnosisStepScreen({
    super.key,
    required this.patientId,
    required this.onBack,
    required this.onEvent,
  });

  final int patientId;
  final VoidCallback onBack;
  final void Function(BuildContext context, ConsultationStepEvent event) onEvent;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<DiagnosisStepCubit>(param1: patientId),
    child: Builder(
      builder: (context) {
        final cubit = context.read<DiagnosisStepCubit>();
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) onBack();
          },
          child: ObserveEvents<ConsultationStepEvent>(
            events: cubit.events,
            onEvent: onEvent,
            child: BlocListener<DiagnosisStepCubit, DiagnosisState>(
              listenWhen: (previous, current) => previous.saveFailure == null && current.saveFailure != null,
              listener: (context, state) async {
                final retry = await showServerErrorDialog(context);
                if (!context.mounted) return;
                cubit.onSaveFailureDismissed();
                if (retry) await cubit.onContinue();
              },
              child: BlocBuilder<DiagnosisStepCubit, DiagnosisState>(
                builder: (context, state) => DiagnosisStepContent(state: state, cubit: cubit, onBack: onBack),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class DiagnosisStepContent extends StatelessWidget {
  const DiagnosisStepContent({super.key, required this.state, required this.cubit, required this.onBack});

  final DiagnosisState state;
  final DiagnosisStepCubit cubit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final suggestion = state.suggestion;
    return ConsultationStepScaffold(
      step: ConsultationStep.diagnosis,
      load: state.load,
      onBack: onBack,
      onRetry: cubit.onRetry,
      subtitle: l10n.diagnosisSubtitle,
      actions: [
        HealthifyButton(
          text: l10n.diagnosisContinue,
          onPressed: cubit.onContinue,
          loading: state.isSaving,
          enabled: !state.load.isOffline,
        ),
      ],
      children: [
        if (suggestion != null)
          _SuggestionCard(
            suggestion: suggestion,
            used: state.usesSuggestion,
            onUse: cubit.onUseSuggestion,
            onChooseOther: cubit.onChooseOther,
          )
        else if (state.suggestionStatus == AiRequestStatus.loading)
          const _SuggestionLoading()
        else if (state.suggestionStatus == AiRequestStatus.failed)
          _SuggestionFailed(onRetry: cubit.onRetrySuggestion, enabled: !state.load.isOffline),
        SectionCard(
          verticalSpacing: dimens.space8,
          children: [
            Text(l10n.diagnosisTitle, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
            Wrap(
              spacing: dimens.space8,
              runSpacing: dimens.space8,
              children: [
                for (final code in DiagnosisCode.values)
                  HealthifyFilterChip(
                    text: l10n.diagnosis(code),
                    selected: state.selected == code,
                    onSelectedChange: (_) => cubit.onSelect(code),
                  ),
              ],
            ),
            if (state.showRequired) ErrorLine(l10n.diagnosisRequired),
          ],
        ),
      ],
    );
  }
}

/// The AI is working: a long wait (up to a minute) says so, and the list below is usable meanwhile.
class _SuggestionLoading extends StatelessWidget {
  const _SuggestionLoading();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.dimens.space8,
      children: [
        const SkeletonCard(),
        Text(
          l10n.aiGeneratingNote,
          style: context.textStyles.bodySmall!.copyWith(color: context.colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// The AI did not answer (timeout, network, error): what was chosen stays and "Retry" asks again.
class _SuggestionFailed extends StatelessWidget {
  const _SuggestionFailed({required this.onRetry, required this.enabled});

  final VoidCallback onRetry;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colors;
    return SectionCard(
      borderColor: scheme.tertiary,
      children: [
        Text(
          l10n.diagnosisSuggestionFailedTitle,
          style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
        ),
        Text(
          l10n.diagnosisSuggestionFailedBody,
          style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: HealthifyButton(
            text: l10n.dsRetry,
            onPressed: onRetry,
            style: HealthifyButtonStyle.tonal,
            enabled: enabled,
          ),
        ),
      ],
    );
  }
}

/// "AI suggestion · Overweight class I · Clinical rationale..." (`tertiary` border). The rule-based one (no AI) says
/// "Suggestion based on BMI": nothing that is not AI is ever labeled AI.
class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.used,
    required this.onUse,
    required this.onChooseOther,
  });

  final DiagnosisSuggestion suggestion;
  final bool used;
  final VoidCallback onUse;
  final VoidCallback onChooseOther;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return SectionCard(
      borderColor: scheme.tertiary,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: suggestion.isFromAi
              ? AiBadge(label: l10n.diagnosisAiBadge)
              : HealthifyTag(text: l10n.diagnosisRuleBadge),
        ),
        Text(
          l10n.diagnosis(suggestion.code),
          style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
        ),
        if (suggestion.rationale.trim().isNotEmpty) ...[
          Text(l10n.diagnosisRationale, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
          // The AI rationale already arrives in the reader's language; it is not translated.
          Text(suggestion.rationale, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface)),
        ],
        Text(
          suggestion.disclaimer.trim().isEmpty ? l10n.diagnosisDisclaimer : suggestion.disclaimer,
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
        Wrap(
          spacing: dimens.space12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            HealthifyButton(
              text: used ? l10n.diagnosisSuggestionUsed : l10n.diagnosisUseSuggestion,
              onPressed: onUse,
              style: HealthifyButtonStyle.tonal,
            ),
            HealthifyButton(text: l10n.diagnosisChooseOther, onPressed: onChooseOther, style: HealthifyButtonStyle.text),
          ],
        ),
      ],
    );
  }
}

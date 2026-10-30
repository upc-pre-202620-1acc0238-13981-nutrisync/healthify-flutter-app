import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/ai_badge.dart';
import '../../../../core/designsystem/component/dialog_overlay.dart';
import '../../../../core/designsystem/component/empty_state.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_chips.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/entity/plan_proposal.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../components/clinical_texts.dart';
import '../components/consultation_step_scaffold.dart' show ErrorLine;
import '../components/review_parts.dart';
import '../cubit/adjust_proposal_cubit.dart';
import '../state/review_states.dart';

/// Adjust the AI-proposed plan (all prefilled; "Assign adjusted plan").
class AdjustProposalScreen extends StatelessWidget {
  const AdjustProposalScreen({
    super.key,
    required this.reviewItemId,
    required this.onBack,
    required this.onAssigned,
    required this.onClose,
  });

  final int reviewItemId;
  final VoidCallback onBack;
  final void Function(String? patientName) onAssigned;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<AdjustProposalCubit>(param1: reviewItemId),
    child: Builder(
      builder: (context) {
        final cubit = context.read<AdjustProposalCubit>();
        return ObserveEvents<AdjustProposalEvent>(
          events: cubit.events,
          onEvent: (context, event) => switch (event) {
            ProposalAssigned(:final patientName) => onAssigned(patientName),
            CloseAdjustProposal() => onClose(),
          },
          child: BlocBuilder<AdjustProposalCubit, AdjustProposalState>(
            builder: (context, state) => AdjustProposalContent(
              state: state,
              cubit: cubit,
              onBack: onBack,
              onClose: onClose,
            ),
          ),
        );
      },
    ),
  );
}

class AdjustProposalContent extends StatelessWidget {
  const AdjustProposalContent({
    super.key,
    required this.state,
    required this.cubit,
    required this.onBack,
    required this.onClose,
  });

  final AdjustProposalState state;
  final AdjustProposalCubit cubit;
  final VoidCallback onBack;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final loadError = state.loadError;
    final ready = !state.isLoading && loadError == null;
    final dialog = state.dialog;
    final screen = Scaffold(
      backgroundColor: context.colors.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(title: l10n.adjustProposalTitle, onBack: onBack),
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
                  else if (loadError == ReviewLoadError.notAvailable)
                    EmptyState(
                      title: l10n.reviewNotAvailableTitle,
                      text: l10n.reviewNotAvailableBody,
                      actionLabel: l10n.reviewBackToInbox,
                      onAction: onClose,
                    )
                  else if (loadError == ReviewLoadError.offline)
                    EmptyState(
                      title: l10n.practitionerOfflineTitle,
                      text: l10n.inboxOfflineBody,
                      actionLabel: l10n.dsRetry,
                      onAction: cubit.onRetryLoad,
                    )
                  else if (loadError != null)
                    ErrorState(onRetry: cubit.onRetryLoad)
                  else
                    ..._form(context),
                ],
              ),
            ),
          ),
          if (ready)
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.all(dimens.space16),
                child: HealthifyButton(
                  text: state.isAssigning ? l10n.reviewAssigning : l10n.adjustProposalAssign,
                  onPressed: cubit.onAssign,
                  loading: state.isAssigning,
                  fullWidth: true,
                ),
              ),
            ),
        ],
      ),
    );
    return StateDialogOverlay(
      dialog: dialog == null
          ? null
          : reviewDialogFor(context, dialog, onConfirm: cubit.onDialogConfirmed, onDismiss: cubit.onDialogDismissed),
      onDismiss: cubit.onDialogDismissed,
      child: screen,
    );
  }

  List<Widget> _form(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final enabled = !state.isAssigning;
    final positiveError = l10n.adjustProposalPositiveValue;
    final previous = state.previousEnergyKcal;
    final energyError = state.belowSafetyFloor
        ? l10n.adjustProposalBelowFloor
        : (state.invalidFields.contains(ProposalEditField.energy) ? positiveError : null);
    final macroInvalid = state.invalidFields.any(
      (field) => field == ProposalEditField.protein || field == ProposalEditField.carb || field == ProposalEditField.fat,
    );
    final firstName = state.patientFirstName;
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: dimens.space8,
        children: [
          AiBadge(label: l10n.adjustProposalBadge),
          Text(
            l10n.adjustProposalIntro,
            style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
      SectionCard(
        verticalSpacing: dimens.space16,
        children: [
          Text(l10n.adjustProposalTargets, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
          HealthifyTextField(
            value: state.energy,
            onChanged: cubit.onEnergyChange,
            label: l10n.adjustProposalEnergy,
            supportingText: previous == null
                ? null
                : l10n.adjustProposalBefore(compactText(previous, l10n.locale, maxDecimals: 0)),
            errorText: energyError,
            enabled: enabled,
            type: HealthifyTextFieldType.decimal,
            suffix: l10n.unitKcal,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: dimens.space8,
            children: [
              Expanded(
                child: _MacroField(
                  value: state.protein,
                  onChanged: cubit.onProteinChange,
                  label: l10n.adjustProposalProtein,
                  isError: state.invalidFields.contains(ProposalEditField.protein),
                  enabled: enabled,
                ),
              ),
              Expanded(
                child: _MacroField(
                  value: state.carb,
                  onChanged: cubit.onCarbChange,
                  label: l10n.adjustProposalCarb,
                  isError: state.invalidFields.contains(ProposalEditField.carb),
                  enabled: enabled,
                ),
              ),
              Expanded(
                child: _MacroField(
                  value: state.fat,
                  onChanged: cubit.onFatChange,
                  label: l10n.adjustProposalFat,
                  isError: state.invalidFields.contains(ProposalEditField.fat),
                  enabled: enabled,
                ),
              ),
            ],
          ),
          if (macroInvalid) ErrorLine(positiveError),
        ],
      ),
      SectionCard(
        children: [
          Text(l10n.adjustProposalGuidelines, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
          Wrap(
            spacing: dimens.space8,
            runSpacing: dimens.space8,
            children: [
              for (final code in PlanGuidelineCode.values)
                HealthifyFilterChip(
                  text: l10n.guideline(CatalogGuideline(code)),
                  selected: state.guidelines.contains(code),
                  onSelectedChange: (selected) => cubit.onGuidelineToggle(code, selected),
                  enabled: enabled,
                ),
            ],
          ),
        ],
      ),
      HealthifyTextField(
        value: state.message,
        onChanged: cubit.onMessageChange,
        label: firstName == null ? l10n.proposalMessageForPatient : l10n.proposalMessageFor(firstName),
        supportingText: l10n.adjustProposalMessageHelp(PatientMessage.maxLength),
        errorText: state.invalidFields.contains(ProposalEditField.message)
            ? l10n.adjustProposalMessageInvalid(PatientMessage.maxLength)
            : null,
        enabled: enabled,
        singleLine: false,
      ),
    ];
  }
}

class _MacroField extends StatelessWidget {
  const _MacroField({
    required this.value,
    required this.onChanged,
    required this.label,
    required this.isError,
    required this.enabled,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String label;
  final bool isError;
  final bool enabled;

  @override
  Widget build(BuildContext context) => HealthifyTextField(
    value: value,
    onChanged: onChanged,
    label: label,
    isError: isError,
    enabled: enabled,
    type: HealthifyTextFieldType.decimal,
    suffix: AppLocalizations.of(context).unitG,
  );
}

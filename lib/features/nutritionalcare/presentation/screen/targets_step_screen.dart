import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_bottom_sheet.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_chips.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/segmented_selector.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../components/consultation_step_scaffold.dart';
import '../components/consultation_texts.dart';
import '../cubit/targets_step_cubit.dart';
import '../state/consultation_step_states.dart';

/// Step 3, calculated targets: "Calculated with...", the proposal (energy and macros with their share of energy) and the
/// method; "Change parameters", "Accept targets" and "Enter my own values" (reason required).
class TargetsStepScreen extends StatelessWidget {
  const TargetsStepScreen({super.key, required this.patientId, required this.onBack, required this.onEvent});

  final int patientId;
  final VoidCallback onBack;
  final void Function(BuildContext context, ConsultationStepEvent event) onEvent;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<TargetsStepCubit>(param1: patientId),
    child: Builder(
      builder: (context) {
        final cubit = context.read<TargetsStepCubit>();
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) onBack();
          },
          child: ObserveEvents<ConsultationStepEvent>(
            events: cubit.events,
            onEvent: onEvent,
            child: MultiBlocListener(
              listeners: [
                BlocListener<TargetsStepCubit, TargetsState>(
                  listenWhen: (previous, current) => !previous.showParameters && current.showParameters,
                  listener: (context, state) => showHealthifyBottomSheet<void>(
                    context: context,
                    builder: (_) => BlocProvider.value(value: cubit, child: const _ParametersSheet()),
                  ).then((_) => cubit.onParametersDismissed()),
                ),
                BlocListener<TargetsStepCubit, TargetsState>(
                  listenWhen: (previous, current) => !previous.showOverride && current.showOverride,
                  listener: (context, state) => showHealthifyBottomSheet<void>(
                    context: context,
                    builder: (_) => BlocProvider.value(value: cubit, child: const _OverrideSheet()),
                  ).then((_) => cubit.onOverrideDismissed()),
                ),
                BlocListener<TargetsStepCubit, TargetsState>(
                  listenWhen: (previous, current) => previous.saveFailure == null && current.saveFailure != null,
                  listener: (context, state) async {
                    final retry = await showServerErrorDialog(context);
                    if (!context.mounted) return;
                    if (retry) {
                      cubit.onRetrySave();
                    } else {
                      cubit.onSaveFailureDismissed();
                    }
                  },
                ),
              ],
              child: BlocBuilder<TargetsStepCubit, TargetsState>(
                builder: (context, state) => TargetsStepContent(state: state, cubit: cubit, onBack: onBack),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class TargetsStepContent extends StatelessWidget {
  const TargetsStepContent({super.key, required this.state, required this.cubit, required this.onBack});

  final TargetsState state;
  final TargetsStepCubit cubit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final proposal = state.proposal;
    return ConsultationStepScaffold(
      step: ConsultationStep.targets,
      load: state.load,
      onBack: onBack,
      onRetry: cubit.onRetry,
      subtitle: l10n.targetsSubtitle,
      actions: [
        if (proposal != null) ...[
          HealthifyButton(
            text: l10n.targetsAccept,
            onPressed: cubit.onAccept,
            loading: state.isSaving && !state.showOverride,
            enabled: !state.load.isOffline && !state.isCalculating,
          ),
          HealthifyButton(
            text: l10n.targetsWriteOwn,
            onPressed: cubit.onWriteOwnValues,
            style: HealthifyButtonStyle.text,
            enabled: !state.load.isOffline && !state.isSaving,
          ),
        ],
      ],
      children: [
        if (proposal != null) ...[
          _InputsCard(inputs: proposal.inputs),
          _ProposalCard(
            proposal: proposal,
            isCalculating: state.isCalculating,
            onChangeParameters: cubit.onChangeParameters,
            enabled: !state.load.isOffline,
          ),
        ] else if (state.isCalculating) ...[
          const SkeletonCard(),
          Text(
            l10n.targetsCalculating,
            style: context.textStyles.bodySmall!.copyWith(color: context.colors.onSurfaceVariant),
          ),
        ] else if (state.proposalFailed)
          ErrorState(onRetry: cubit.onRetry),
      ],
    );
  }
}

/// "Calculated with · Woman · 31 years · 168 cm · 74.2 kg · moderate activity".
class _InputsCard extends StatelessWidget {
  const _InputsCard({required this.inputs});

  final TargetInputs inputs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      children: [
        IconInfoRow(icon: HealthifyIcons.info, title: l10n.targetsCalculatedWith, supportingText: l10n.inputsText(inputs)),
      ],
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.proposal,
    required this.isCalculating,
    required this.onChangeParameters,
    required this.enabled,
  });

  final TargetProposal proposal;
  final bool isCalculating;
  final VoidCallback onChangeParameters;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final targets = proposal.proposal;
    return SectionCard(
      verticalSpacing: dimens.space16,
      children: [
        Text(l10n.targetsProposed, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
        Column(
          spacing: dimens.space4,
          children: [
            Text(
              compactText(targets.energyKcal, l10n.locale, maxDecimals: 0),
              style: context.extendedTypography.metricLarge.copyWith(color: scheme.onSurface),
            ),
            Text(
              l10n.targetsKcalPerDay,
              style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: dimens.space8,
          children: [
            Expanded(child: _MacroBox(grams: targets.proteinG, label: l10n.macroProtein, percent: targets.proteinPercent)),
            Expanded(child: _MacroBox(grams: targets.carbG, label: l10n.macroCarbsShort, percent: targets.carbPercent)),
            Expanded(child: _MacroBox(grams: targets.fatG, label: l10n.macroFat, percent: targets.fatPercent)),
          ],
        ),
        Text(
          l10n.methodText(proposal.basis),
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: HealthifyButton(
            text: l10n.targetsChangeParameters,
            onPressed: onChangeParameters,
            style: HealthifyButtonStyle.text,
            icon: HealthifyIcons.edit,
            loading: isCalculating,
            enabled: enabled,
          ),
        ),
      ],
    );
  }
}

class _MacroBox extends StatelessWidget {
  const _MacroBox({required this.grams, required this.label, required this.percent});

  final double grams;
  final String label;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dimens.space8, vertical: dimens.space12),
      decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(dimens.radiusMd)),
      child: Column(
        spacing: dimens.space4,
        children: [
          Text(
            l10n.unitGValue(compactText(grams, l10n.locale, maxDecimals: 0)),
            textAlign: TextAlign.center,
            style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
          ),
          Text(
            l10n.targetsMacroShare(label, percent),
            textAlign: TextAlign.center,
            style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// A sheet closes itself when the cubit says its flag went down (applied, saved, cancelled).
class _SheetCloser extends StatelessWidget {
  const _SheetCloser({required this.closeWhen, required this.child});

  final bool Function(TargetsState previous, TargetsState current) closeWhen;
  final Widget child;

  @override
  Widget build(BuildContext context) => BlocListener<TargetsStepCubit, TargetsState>(
    listenWhen: closeWhen,
    listener: (context, state) {
      if (ModalRoute.of(context)?.isCurrent ?? false) Navigator.of(context).pop();
    },
    child: child,
  );
}

/// "Change parameters": equation, deficit, protein per kg and fat (the backend recalculates the same draft).
class _ParametersSheet extends StatelessWidget {
  const _ParametersSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final cubit = context.read<TargetsStepCubit>();
    return _SheetCloser(
      closeWhen: (previous, current) => previous.showParameters && !current.showParameters,
      child: BlocBuilder<TargetsStepCubit, TargetsState>(
        buildWhen: (previous, current) =>
            previous.parameters != current.parameters || previous.parametersInvalid != current.parametersInvalid,
        builder: (context, state) {
          final form = state.parameters;
          if (form == null) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(dimens.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space16,
                children: [
                  Text(
                    l10n.targetsParametersTitle,
                    style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface),
                  ),
                  _FieldTitle(l10n.targetsEquation),
                  Wrap(
                    spacing: dimens.space8,
                    runSpacing: dimens.space8,
                    children: [
                      for (final equation in EnergyEquation.values)
                        HealthifyFilterChip(
                          text: l10n.equation(equation),
                          selected: form.equation == equation,
                          onSelectedChange: (_) => cubit.onParametersChange(form.copyWith(equation: equation)),
                        ),
                    ],
                  ),
                  _FieldTitle(l10n.targetsDeficit),
                  SegmentedSelector<DeficitKind>(
                    options: DeficitKind.values,
                    selected: form.deficitKind,
                    onSelect: (kind) => cubit.onParametersChange(form.copyWith(deficitKind: kind)),
                    optionLabel: l10n.deficitKindLabel,
                  ),
                  HealthifyTextField(
                    value: form.deficit,
                    onChanged: (text) => cubit.onParametersChange(form.copyWith(deficit: text)),
                    label: l10n.targetsDeficitValue,
                    type: HealthifyTextFieldType.decimal,
                    suffix: form.deficitKind == DeficitKind.fixedKcal ? l10n.unitKcal : l10n.unitPercent,
                  ),
                  HealthifyTextField(
                    value: form.proteinPerKg,
                    onChanged: (text) => cubit.onParametersChange(form.copyWith(proteinPerKg: text)),
                    label: l10n.targetsProteinPerKg,
                    type: HealthifyTextFieldType.decimal,
                    suffix: l10n.unitGPerKg,
                  ),
                  HealthifyTextField(
                    value: form.fatPercent,
                    onChanged: (text) => cubit.onParametersChange(form.copyWith(fatPercent: text)),
                    label: l10n.targetsFatPercent,
                    type: HealthifyTextFieldType.decimal,
                    suffix: l10n.unitPercent,
                  ),
                  if (state.parametersInvalid) ErrorLine(l10n.targetsParametersInvalid),
                  HealthifyButton(text: l10n.targetsRecalculate, onPressed: cubit.onApplyParameters),
                  HealthifyButton(
                    text: l10n.dsCancel,
                    onPressed: cubit.onParametersDismissed,
                    style: HealthifyButtonStyle.text,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// "Enter my own values": energy and macros, and the reason (required, up to 500 characters).
class _OverrideSheet extends StatelessWidget {
  const _OverrideSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final cubit = context.read<TargetsStepCubit>();
    return _SheetCloser(
      closeWhen: (previous, current) => previous.showOverride && !current.showOverride,
      child: BlocBuilder<TargetsStepCubit, TargetsState>(
        buildWhen: (previous, current) =>
            previous.ownValues != current.ownValues ||
            previous.overrideProblems != current.overrideProblems ||
            previous.isSaving != current.isSaving,
        builder: (context, state) {
          final form = state.ownValues;
          final problems = state.overrideProblems;
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(dimens.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space16,
                children: [
                  Text(
                    l10n.targetsOverrideTitle,
                    style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface),
                  ),
                  HealthifyTextField(
                    value: form.energy,
                    onChanged: (text) => cubit.onOverrideChange(form.copyWith(energy: text)),
                    label: l10n.targetsEnergy,
                    type: HealthifyTextFieldType.decimal,
                    errorText: problems.contains(OverrideField.energy) ? l10n.targetsEnergyInvalid : null,
                    suffix: l10n.unitKcal,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: dimens.space8,
                    children: [
                      Expanded(
                        child: _GramsField(
                          value: form.protein,
                          label: l10n.macroProtein,
                          isError: problems.contains(OverrideField.protein),
                          onChanged: (text) => cubit.onOverrideChange(form.copyWith(protein: text)),
                        ),
                      ),
                      Expanded(
                        child: _GramsField(
                          value: form.carb,
                          label: l10n.macroCarbsShort,
                          isError: problems.contains(OverrideField.carb),
                          onChanged: (text) => cubit.onOverrideChange(form.copyWith(carb: text)),
                        ),
                      ),
                      Expanded(
                        child: _GramsField(
                          value: form.fat,
                          label: l10n.macroFat,
                          isError: problems.contains(OverrideField.fat),
                          onChanged: (text) => cubit.onOverrideChange(form.copyWith(fat: text)),
                        ),
                      ),
                    ],
                  ),
                  HealthifyTextField(
                    value: form.reason,
                    onChanged: (text) => cubit.onOverrideChange(form.copyWith(reason: text)),
                    label: l10n.targetsOverrideReason,
                    placeholder: l10n.targetsOverrideReasonPlaceholder,
                    supportingText: l10n.textCounter(form.reason.trim().length, OverrideReason.maxLength),
                    errorText: problems.contains(OverrideField.reason) ? l10n.targetsOverrideReasonRequired : null,
                    singleLine: false,
                  ),
                  HealthifyButton(
                    text: l10n.targetsOverrideSave,
                    onPressed: cubit.onSaveOverride,
                    loading: state.isSaving,
                  ),
                  HealthifyButton(
                    text: l10n.dsCancel,
                    onPressed: cubit.onOverrideDismissed,
                    style: HealthifyButtonStyle.text,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GramsField extends StatelessWidget {
  const _GramsField({required this.value, required this.label, required this.isError, required this.onChanged});

  final String value;
  final String label;
  final bool isError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => HealthifyTextField(
    value: value,
    onChanged: onChanged,
    label: label,
    type: HealthifyTextFieldType.decimal,
    isError: isError,
    suffix: AppLocalizations.of(context).unitG,
  );
}

class _FieldTitle extends StatelessWidget {
  const _FieldTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: context.textStyles.titleSmall!.copyWith(color: context.colors.onSurface));
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/common/route_resume_effect.dart';
import '../../../../core/designsystem/component/date_time_texts.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_chips.dart';
import '../../../../core/designsystem/component/healthify_dialog.dart';
import '../../../../core/designsystem/component/healthify_icon_dialog.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/number_texts.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../components/clinical_texts.dart';
import '../components/consultation_step_scaffold.dart';
import '../components/consultation_texts.dart';
import '../cubit/measurement_step_cubit.dart';
import '../state/consultation_step_states.dart';

/// Step 1, today's measurement (plus the exit dialog on ‹). Shows what the patient shared before the consultation, the
/// baseline (height is not asked again), the live BMI, the protocol checkboxes and the activity; habits and
/// biochemistry are optional.
///
/// [onEvent] gets what the cubit asks of the flow (next step, exit, closed); [onEditBaseline] opens the baseline form.
/// [resumePath] is the location of this step, to reread the baseline when coming back from editing it.
class MeasurementStepScreen extends StatelessWidget {
  const MeasurementStepScreen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.resumePath,
    required this.onEvent,
    required this.onEditBaseline,
  });

  final int patientId;
  final String patientName;
  final String resumePath;
  final void Function(BuildContext context, ConsultationStepEvent event) onEvent;
  final VoidCallback onEditBaseline;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<MeasurementStepCubit>(param1: patientId),
    child: Builder(
      builder: (context) {
        final cubit = context.read<MeasurementStepCubit>();
        final l10n = AppLocalizations.of(context);
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) cubit.onBack();
          },
          child: RouteResumeEffect(
            path: resumePath,
            onResume: cubit.onResume,
            child: ObserveEvents<ConsultationStepEvent>(
              events: cubit.events,
              onEvent: onEvent,
              child: MultiBlocListener(
                listeners: [
                  BlocListener<MeasurementStepCubit, MeasurementState>(
                    listenWhen: (previous, current) => !previous.showExitDialog && current.showExitDialog,
                    listener: (context, state) async {
                      final leave = await showHealthifyDialog<bool>(
                        context: context,
                        builder: (context) => HealthifyIconDialog(
                          icon: HealthifyIcons.warning,
                          title: l10n.consultationExitTitle,
                          text: l10n.consultationExitBody(patientName),
                          confirmLabel: l10n.consultationExitConfirm,
                          onConfirm: () => Navigator.of(context).pop(true),
                          dismissLabel: l10n.consultationExitStay,
                          onDismiss: () => Navigator.of(context).pop(false),
                        ),
                      );
                      if (leave == true) {
                        cubit.onExit();
                      } else {
                        cubit.onStay();
                      }
                    },
                  ),
                  BlocListener<MeasurementStepCubit, MeasurementState>(
                    listenWhen: (previous, current) => previous.saveFailure == null && current.saveFailure != null,
                    listener: (context, state) async {
                      final retry = await showServerErrorDialog(context);
                      if (!context.mounted) return;
                      cubit.onSaveFailureDismissed();
                      if (retry) await cubit.onContinue();
                    },
                  ),
                  BlocListener<MeasurementStepCubit, MeasurementState>(
                    listenWhen: (previous, current) => !previous.showDiscardDialog && current.showDiscardDialog,
                    listener: (context, state) async {
                      final discard = await showHealthifyDialog<bool>(
                        context: context,
                        builder: (context) => HealthifyIconDialog(
                          icon: HealthifyIcons.delete,
                          title: l10n.consultationDiscardTitle,
                          text: l10n.consultationDiscardBody(patientName),
                          confirmLabel: l10n.consultationDiscardConfirm,
                          onConfirm: () => Navigator.of(context).pop(true),
                          dismissLabel: l10n.consultationDiscardKeep,
                          onDismiss: () => Navigator.of(context).pop(false),
                        ),
                      );
                      if (discard == true) {
                        await cubit.onDiscardConfirmed();
                      } else {
                        cubit.onDiscardDismissed();
                      }
                    },
                  ),
                  BlocListener<MeasurementStepCubit, MeasurementState>(
                    listenWhen: (previous, current) => previous.discardFailure == null && current.discardFailure != null,
                    listener: (context, state) async {
                      final retry = await showServerErrorDialog(context);
                      if (!context.mounted) return;
                      cubit.onDiscardFailureDismissed();
                      if (retry) await cubit.onDiscardConfirmed();
                    },
                  ),
                ],
                child: BlocBuilder<MeasurementStepCubit, MeasurementState>(
                  builder: (context, state) => MeasurementStepContent(
                    state: state,
                    patientName: patientName,
                    cubit: cubit,
                    onEditBaseline: onEditBaseline,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class MeasurementStepContent extends StatelessWidget {
  const MeasurementStepContent({
    super.key,
    required this.state,
    required this.patientName,
    required this.cubit,
    required this.onEditBaseline,
  });

  final MeasurementState state;
  final String patientName;
  final MeasurementStepCubit cubit;
  final VoidCallback onEditBaseline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final form = state.form;
    final load = state.load;
    return ConsultationStepScaffold(
      step: ConsultationStep.measurement,
      load: load,
      onBack: cubit.onBack,
      onRetry: cubit.onRetry,
      subtitle: l10n.measurementSubtitle,
      // Only with the consultation loaded and no deletion in progress.
      onDiscard: !load.isLoading && !load.loadFailed && !state.isDiscarding ? cubit.onDiscard : null,
      actions: [
        HealthifyButton(
          text: l10n.measurementContinue,
          onPressed: cubit.onContinue,
          loading: state.isSaving,
          enabled: !load.isOffline,
        ),
      ],
      children: [
        if (state.checkIn != null) _CheckInCard(checkIn: state.checkIn!, patientName: patientName),
        if (state.baseline != null)
          _BaselineRowCard(baseline: state.baseline!, onEdit: onEditBaseline, enabled: !load.isOffline),
        _MeasuresCard(state: state, cubit: cubit),
        SectionCard(
          verticalSpacing: dimens.space8,
          children: [
            Text(l10n.measurementProtocol, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
            Wrap(
              spacing: dimens.space8,
              runSpacing: dimens.space8,
              children: [
                for (final check in ProtocolCheck.values)
                  HealthifyFilterChip(
                    text: l10n.protocolCheck(check),
                    selected: form.protocolChecks.contains(check),
                    onSelectedChange: (_) => cubit.onProtocolToggle(check),
                  ),
              ],
            ),
            if (state.problems[MeasurementField.protocol] != null) ErrorLine(l10n.measurementProtocolRequired),
          ],
        ),
        SectionCard(
          verticalSpacing: dimens.space8,
          children: [
            Text(l10n.measurementActivity, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
            Wrap(
              spacing: dimens.space8,
              runSpacing: dimens.space8,
              children: [
                for (final level in ActivityLevel.values)
                  HealthifyFilterChip(
                    text: l10n.activity(level),
                    selected: form.activityLevel == level,
                    onSelectedChange: (_) => cubit.onActivityChange(level),
                  ),
              ],
            ),
            if (state.problems[MeasurementField.activity] != null) ErrorLine(l10n.measurementActivityRequired),
          ],
        ),
        _OptionalSection(state: state, cubit: cubit),
      ],
    );
  }
}

/// "Before the consultation, Ana shared". The questions are the patient's: shown as is.
class _CheckInCard extends StatelessWidget {
  const _CheckInCard({required this.checkIn, required this.patientName});

  final PatientCheckIn checkIn;
  final String patientName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final trimmed = patientName.trim();
    final firstName = trimmed.contains(' ') ? trimmed.substring(0, trimmed.indexOf(' ')) : trimmed;
    return SectionCard(
      verticalSpacing: dimens.space8,
      children: [
        Row(
          spacing: dimens.space8,
          children: [
            HealthifyIcon(HealthifyIcons.help, color: scheme.onSurfaceVariant),
            Expanded(
              child: Text(
                l10n.measurementCheckInTitle(firstName.isEmpty ? trimmed : firstName),
                style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
              ),
            ),
          ],
        ),
        for (final line in l10n.checkInLines(checkIn))
          Text('• $line', style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface)),
        Text(
          l10n.measurementCheckInSent(mediumDateText(checkIn.submittedAt, l10n.locale)),
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// "Woman · 31 years · 168 cm · Hypothyroidism · from the baseline · Edit".
class _BaselineRowCard extends StatelessWidget {
  const _BaselineRowCard({required this.baseline, required this.onEdit, required this.enabled});

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
          title: l10n.baselineHeadline(baseline),
          supportingText: conditions == null
              ? l10n.measurementFromBaseline
              : l10n.measurementFromBaselineWith(conditions[0].toUpperCase() + conditions.substring(1)),
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

class _MeasuresCard extends StatelessWidget {
  const _MeasuresCard({required this.state, required this.cubit});

  final MeasurementState state;
  final MeasurementStepCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return SectionCard(
      verticalSpacing: dimens.space16,
      children: [
        Text(l10n.measurementMeasures, style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface)),
        NumberField(
          value: state.form.weight,
          onChanged: cubit.onWeightChange,
          label: l10n.measurementWeight,
          unit: l10n.unitKg,
          problem: state.problems[MeasurementField.weight],
          rangeError: l10n.measurementWeightRange,
          requiredError: l10n.measurementWeightRequired,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: dimens.space8,
          children: [
            Expanded(
              child: NumberField(
                value: state.form.waist,
                onChanged: cubit.onWaistChange,
                label: l10n.measurementWaist,
                unit: l10n.unitCm,
                problem: state.problems[MeasurementField.waist],
                rangeError: l10n.measurementWaistRange,
              ),
            ),
            Expanded(
              child: NumberField(
                value: state.form.bodyFat,
                onChanged: cubit.onBodyFatChange,
                label: l10n.measurementBodyFat,
                unit: l10n.unitPercent,
                placeholder: l10n.measurementBodyFatPlaceholder,
                problem: state.problems[MeasurementField.bodyFat],
                rangeError: l10n.measurementBodyFatRange,
              ),
            ),
          ],
        ),
        Text(
          l10n.measurementOptionalNote,
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
        _BmiResult(bmi: state.bmi),
      ],
    );
  }
}

/// "Calculated BMI · 26.3 kg/m²" (`surfaceContainer`, radius 12). Without a valid weight: "—".
class _BmiResult extends StatelessWidget {
  const _BmiResult({required this.bmi});

  final double? bmi;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dimens.space12, vertical: dimens.space8),
      decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(dimens.radiusMd)),
      child: Row(
        spacing: dimens.space8,
        children: [
          HealthifyIcon(HealthifyIcons.info, color: scheme.onSurfaceVariant),
          Expanded(
            child: Text(
              l10n.measurementBmi,
              style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          Text(
            bmi == null ? valueMissing : l10n.unitBmiValue(decimalText(bmi!, l10n.locale)),
            style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface),
          ),
        ],
      ),
    );
  }
}

/// "OPTIONAL": eating habits and biochemistry expand with "+".
class _OptionalSection extends StatelessWidget {
  const _OptionalSection({required this.state, required this.cubit});

  final MeasurementState state;
  final MeasurementStepCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final form = state.form;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: dimens.space8,
      children: [
        SectionOverline(l10n.measurementOptional),
        SectionCard(
          verticalSpacing: dimens.space16,
          children: [
            _ExpandableRow(
              title: l10n.measurementHabits,
              supporting: l10n.measurementHabitsHint,
              expanded: state.habitsExpanded,
              onToggle: cubit.onToggleHabits,
            ),
            if (state.habitsExpanded) ...[
              NumberField(
                value: form.mealsPerDay,
                onChanged: cubit.onMealsPerDayChange,
                label: l10n.measurementMealsPerDay,
                problem: state.problems[MeasurementField.mealsPerDay],
                rangeError: l10n.measurementMealsPerDayRange,
                whole: true,
              ),
              NumberField(
                value: form.waterLiters,
                onChanged: cubit.onWaterChange,
                label: l10n.measurementWater,
                unit: l10n.unitLitersPerDay,
                problem: state.problems[MeasurementField.water],
                rangeError: l10n.measurementWaterRange,
              ),
              NumberField(
                value: form.mealsOut,
                onChanged: cubit.onMealsOutChange,
                label: l10n.measurementMealsOut,
                problem: state.problems[MeasurementField.mealsOut],
                rangeError: l10n.measurementMealsOutRange,
                whole: true,
              ),
            ],
            const CardDivider(),
            _ExpandableRow(
              title: l10n.measurementBiochemistry,
              supporting: l10n.measurementBiochemistryHint,
              expanded: state.biochemistryExpanded,
              onToggle: cubit.onToggleBiochemistry,
            ),
            if (state.biochemistryExpanded) ...[
              NumberField(
                value: form.glucose,
                onChanged: cubit.onGlucoseChange,
                label: l10n.measurementGlucose,
                unit: l10n.unitMgDl,
                problem: state.problems[MeasurementField.glucose],
                rangeError: l10n.measurementGlucoseRange,
              ),
              NumberField(
                value: form.cholesterol,
                onChanged: cubit.onCholesterolChange,
                label: l10n.measurementCholesterol,
                unit: l10n.unitMgDl,
                problem: state.problems[MeasurementField.cholesterol],
                rangeError: l10n.measurementCholesterolRange,
              ),
              NumberField(
                value: form.triglycerides,
                onChanged: cubit.onTriglyceridesChange,
                label: l10n.measurementTriglycerides,
                unit: l10n.unitMgDl,
                problem: state.problems[MeasurementField.triglycerides],
                rangeError: l10n.measurementTriglyceridesRange,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _ExpandableRow extends StatelessWidget {
  const _ExpandableRow({required this.title, required this.supporting, required this.expanded, required this.onToggle});

  final String title;
  final String supporting;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Semantics(
      button: true,
      onTapHint: title,
      excludeSemantics: true,
      label: '$title. $supporting',
      onTap: onToggle,
      child: InkWell(
        onTap: onToggle,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: dimens.touchMin),
          child: Row(
            spacing: dimens.space8,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: dimens.space4,
                  children: [
                    Text(title, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
                    Text(supporting, style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              HealthifyIcon(expanded ? HealthifyIcons.close : HealthifyIcons.add, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// Numeric field with its unit and the range error from the design notes.
class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.problem,
    required this.rangeError,
    this.unit,
    this.placeholder,
    this.requiredError,
    this.whole = false,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String label;
  final FieldProblem? problem;
  final String rangeError;
  final String? unit;
  final String? placeholder;
  final String? requiredError;
  final bool whole;

  @override
  Widget build(BuildContext context) => HealthifyTextField(
    value: value,
    onChanged: onChanged,
    label: label,
    placeholder: placeholder,
    type: whole ? HealthifyTextFieldType.number : HealthifyTextFieldType.decimal,
    errorText: switch (problem) {
      FieldProblem.required => requiredError ?? rangeError,
      FieldProblem.outOfRange => rangeError,
      null => null,
    },
    suffix: unit,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_chips.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/read_only_clickable_field.dart';
import '../../../../core/designsystem/component/segmented_selector.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/entity/patient_baseline.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../components/clinical_texts.dart';
import '../cubit/baseline_cubit.dart';
import '../state/baseline_state.dart';

/// Baseline (only the first time; afterwards it is edited from Summary or Record). Back and "Save and exit" go back to
/// the screen it was opened from.
///
/// [onStartConsultation] receives the step the consultation started on ("Save and start consultation").
class BaselineScreen extends StatelessWidget {
  const BaselineScreen({
    super.key,
    required this.patientId,
    required this.editing,
    required this.onBack,
    required this.onSaved,
    required this.onStartConsultation,
  });

  final int patientId;
  final bool editing;
  final VoidCallback onBack;
  final VoidCallback onSaved;
  final ValueChanged<ConsultationStep> onStartConsultation;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<BaselineCubit>(param1: (patientId: patientId, editing: editing)),
    child: Builder(
      builder: (context) {
        final cubit = context.read<BaselineCubit>();
        return ObserveEvents<BaselineEvent>(
          events: cubit.events,
          onEvent: (context, event) => switch (event) {
            BaselineSaved() => onSaved(),
            ConsultationStarted(:final step) => onStartConsultation(step),
          },
          child: BlocConsumer<BaselineCubit, BaselineState>(
            listenWhen: (previous, current) => !previous.saveFailed && current.saveFailed,
            listener: (context, state) async {
              final retry = await showServerErrorDialog(context);
              if (!context.mounted) return;
              if (retry) {
                cubit.onRetrySave();
              } else {
                cubit.onSaveFailureDismissed();
              }
            },
            builder: (context, state) => BaselineContent(
              state: state,
              onBack: onBack,
              onBirthDateClick: () => _pickBirthDate(context, state.birthDate, cubit),
              onSexChange: cubit.onSexChange,
              onHeightChange: cubit.onHeightChange,
              onConditionToggle: cubit.onConditionToggle,
              onSaveAndStart: cubit.onSaveAndStart,
              onSaveAndExit: cubit.onSaveAndExit,
            ),
          ),
        );
      },
    ),
  );

  /// Date picker: past dates only.
  Future<void> _pickBirthDate(BuildContext context, DateTime? current, BaselineCubit cubit) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? today,
      firstDate: DateTime(today.year - 130),
      lastDate: today,
    );
    if (picked != null) cubit.onBirthDateChange(DateTime(picked.year, picked.month, picked.day));
  }
}

class BaselineContent extends StatelessWidget {
  const BaselineContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onBirthDateClick,
    required this.onSexChange,
    required this.onHeightChange,
    required this.onConditionToggle,
    required this.onSaveAndStart,
    required this.onSaveAndExit,
  });

  final BaselineState state;
  final VoidCallback onBack;
  final VoidCallback onBirthDateClick;
  final ValueChanged<BiologicalSex> onSexChange;
  final ValueChanged<String> onHeightChange;
  final ValueChanged<MedicalCondition> onConditionToggle;
  final VoidCallback onSaveAndStart;
  final VoidCallback onSaveAndExit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(title: l10n.baselineTitle, onBack: onBack),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(dimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space24,
                children: [
                  if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                  Text(
                    l10n.baselineIntro,
                    style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  if (state.isLoading)
                    const SkeletonCard()
                  else ...[
                    SectionCard(
                      verticalSpacing: dimens.space16,
                      children: [
                        _BirthDateField(state: state, onClick: onBirthDateClick),
                        _SexField(state: state, onSexChange: onSexChange),
                        HealthifyTextField(
                          value: state.heightText,
                          onChanged: onHeightChange,
                          label: l10n.baselineHeight,
                          type: HealthifyTextFieldType.decimal,
                          errorText: state.problems.contains(BaselineProblem.heightRequired)
                              ? l10n.baselineHeightRequired
                              : state.problems.contains(BaselineProblem.heightOutOfRange)
                              ? l10n.baselineHeightRange
                              : null,
                          suffix: l10n.unitCm,
                        ),
                      ],
                    ),
                    SectionCard(
                      verticalSpacing: dimens.space8,
                      children: [
                        Text(
                          l10n.baselineConditions,
                          style: context.textStyles.titleMedium!.copyWith(color: scheme.onSurface),
                        ),
                        Text(
                          l10n.baselineConditionsHint,
                          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        Wrap(
                          spacing: dimens.space8,
                          runSpacing: dimens.space8,
                          children: [
                            for (final condition in MedicalCondition.values)
                              HealthifyFilterChip(
                                text: l10n.condition(condition),
                                selected: state.conditions.contains(condition),
                                onSelectedChange: (_) => onConditionToggle(condition),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(dimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space12,
                children: [
                  if (state.editing)
                    HealthifyButton(
                      text: l10n.baselineSave,
                      onPressed: onSaveAndExit,
                      loading: state.isSaving,
                      enabled: !state.isOffline && !state.isLoading,
                    )
                  else ...[
                    HealthifyButton(
                      text: l10n.baselineSaveAndStart,
                      onPressed: onSaveAndStart,
                      loading: state.isSaving,
                      enabled: !state.isOffline,
                    ),
                    HealthifyButton(
                      text: l10n.baselineSaveAndExit,
                      onPressed: onSaveAndExit,
                      style: HealthifyButtonStyle.text,
                      enabled: !state.isOffline && !state.isSaving,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BirthDateField extends StatelessWidget {
  const _BirthDateField({required this.state, required this.onClick});

  final BaselineState state;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final birthDate = state.birthDate;
    final age = state.ageYears;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.dimens.space8,
      children: [
        ReadOnlyClickableField(
          value: birthDate == null ? '' : DateFormat.yMd(l10n.locale.toLanguageTag()).format(birthDate),
          label: l10n.baselineBirthDate,
          onTap: onClick,
          trailingIcon: HealthifyIcons.calendar,
          errorText: state.problems.contains(BaselineProblem.birthDateRequired)
              ? l10n.baselineBirthDateRequired
              : state.problems.contains(BaselineProblem.birthDateImplausible)
              ? l10n.baselineBirthDateRange
              : null,
        ),
        if (age != null)
          Text(
            l10n.baselineAgeAuto(l10n.baselineAgeYears(age)),
            style: context.textStyles.bodySmall!.copyWith(color: context.colors.primary),
          ),
      ],
    );
  }
}

class _SexField extends StatelessWidget {
  const _SexField({required this.state, required this.onSexChange});

  final BaselineState state;
  final ValueChanged<BiologicalSex> onSexChange;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colors;
    final hasError = state.problems.contains(BaselineProblem.sexRequired);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.dimens.space8,
      children: [
        Text(l10n.baselineSex, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
        SegmentedSelector<BiologicalSex>(
          options: BiologicalSex.values,
          selected: state.sex,
          onSelect: onSexChange,
          optionLabel: l10n.sexOption,
          isError: hasError,
        ),
        if (hasError)
          Text(l10n.baselineSexRequired, style: context.textStyles.bodySmall!.copyWith(color: scheme.error)),
      ],
    );
  }
}

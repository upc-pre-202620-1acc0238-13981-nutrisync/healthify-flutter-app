import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/failure_state.dart';
import '../../../../core/designsystem/component/healthify_bottom_sheet.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_chips.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/read_only_clickable_field.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/localization_extensions.dart';
import '../../domain/valueobject/monitoring_values.dart';
import '../components/agenda_texts.dart';
import '../cubit/schedule_follow_up_cubit.dart';
import '../state/practitioner_agenda_states.dart';

const _maxYearsAhead = 5;

/// Schedule a visit (with the non-future-date and could-not-schedule states) and reschedule.
class ScheduleFollowUpScreen extends StatelessWidget {
  const ScheduleFollowUpScreen({super.key, required this.args, required this.onBack, required this.onScheduled});

  final ScheduleFollowUpArgs args;
  final VoidCallback onBack;

  /// Scheduled or rescheduled: returns to where it was opened, with the snackbar.
  final void Function(DateTime scheduledFor, bool rescheduled) onScheduled;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<ScheduleFollowUpCubit>(param1: args),
    child: Builder(
      builder: (context) {
        final cubit = context.read<ScheduleFollowUpCubit>();
        return ObserveEvents<FollowUpSaved>(
          events: cubit.events,
          onEvent: (context, event) => onScheduled(event.scheduledFor, event.rescheduled),
          child: BlocBuilder<ScheduleFollowUpCubit, ScheduleFollowUpState>(
            builder: (context, state) => ScheduleFollowUpContent(
              state: state,
              onBack: onBack,
              onPatientFieldClick: () => _pickPatient(context, cubit),
              onDateFieldClick: () => _pickDate(context, cubit),
              onTimeFieldClick: () => _pickTime(context, cubit),
              onPreparationToggle: cubit.onPreparationToggle,
              onSubmit: cubit.onSubmit,
              onBackToForm: cubit.onBackToForm,
            ),
          ),
        );
      },
    ),
  );

  Future<void> _pickPatient(BuildContext context, ScheduleFollowUpCubit cubit) async {
    cubit.onPatientFieldClick();
    final option = await showHealthifyBottomSheet<PatientOption>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<ScheduleFollowUpCubit, ScheduleFollowUpState>(
          builder: (context, state) => _PatientPickerContent(state: state),
        ),
      ),
    );
    if (option != null) cubit.onPatientSelected(option);
  }

  Future<void> _pickDate(BuildContext context, ScheduleFollowUpCubit cubit) async {
    // From today on: the time decides whether the moment is in the future.
    final today = cubit.today;
    final initial = cubit.state.date;
    final date = await showDatePicker(
      context: context,
      initialDate: initial != null && !initial.isBefore(today) ? initial : today,
      firstDate: today,
      lastDate: DateTime(today.year + _maxYearsAhead, today.month, today.day),
      helpText: AppLocalizations.of(context).scheduleDate,
    );
    if (date != null) cubit.onDateSelected(date);
  }

  Future<void> _pickTime(BuildContext context, ScheduleFollowUpCubit cubit) async {
    final time = await showTimePicker(
      context: context,
      initialTime: cubit.state.time ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: AppLocalizations.of(context).scheduleTimeDialogTitle,
    );
    if (time != null) cubit.onTimeSelected(time);
  }
}

class ScheduleFollowUpContent extends StatelessWidget {
  const ScheduleFollowUpContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onPatientFieldClick,
    required this.onDateFieldClick,
    required this.onTimeFieldClick,
    required this.onPreparationToggle,
    required this.onSubmit,
    required this.onBackToForm,
  });

  final ScheduleFollowUpState state;
  final VoidCallback onBack;
  final VoidCallback onPatientFieldClick;
  final VoidCallback onDateFieldClick;
  final VoidCallback onTimeFieldClick;
  final void Function(PreparationCode code, bool selected) onPreparationToggle;
  final VoidCallback onSubmit;
  final VoidCallback onBackToForm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    if (state.failed) {
      // What was written is kept; "Try again" returns to the form.
      return ColoredBox(
        color: context.colors.surface,
        child: FailureState(
          title: l10n.scheduleFailedTitle,
          text: l10n.scheduleFailedBody,
          actionLabel: l10n.commonTryAgain,
          onAction: onBackToForm,
        ),
      );
    }
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(
            title: state.isRescheduling ? l10n.scheduleRescheduleTitle : l10n.scheduleTitle,
            onBack: onBack,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(dimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space24,
                children: [
                  if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                  _MomentCard(
                    state: state,
                    onPatientFieldClick: onPatientFieldClick,
                    onDateFieldClick: onDateFieldClick,
                    onTimeFieldClick: onTimeFieldClick,
                  ),
                  _PreparationCard(state: state, onToggle: onPreparationToggle),
                  HealthifyButton(
                    text: state.isSaving
                        ? l10n.scheduleSaving
                        : (state.isRescheduling ? l10n.scheduleRescheduleSubmit : l10n.scheduleSubmit),
                    onPressed: onSubmit,
                    loading: state.isSaving,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MomentCard extends StatelessWidget {
  const _MomentCard({
    required this.state,
    required this.onPatientFieldClick,
    required this.onDateFieldClick,
    required this.onTimeFieldClick,
  });

  final ScheduleFollowUpState state;
  final VoidCallback onPatientFieldClick;
  final VoidCallback onDateFieldClick;
  final VoidCallback onTimeFieldClick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final tag = l10n.locale.toLanguageTag();
    final date = state.date;
    final time = state.time;
    final momentError = switch (state.momentError) {
      ScheduleMomentError.missing => l10n.scheduleMomentMissing,
      ScheduleMomentError.notInFuture => l10n.scheduleMomentNotFuture,
      null => null,
    };
    return SectionCard(
      verticalSpacing: dimens.space16,
      children: [
        ReadOnlyClickableField(
          value: state.patient?.fullName ?? '',
          label: l10n.schedulePatient,
          onTap: onPatientFieldClick,
          enabled: !state.isSaving && !state.patientFixed,
          errorText: switch (state.patientError) {
            SchedulePatientError.missing => l10n.schedulePatientMissing,
            SchedulePatientError.alreadyScheduled => l10n.schedulePatientAlreadyScheduled,
            SchedulePatientError.noActiveLink => l10n.practitionerNoActiveLinkBody,
            null => null,
          },
          trailingIcon: state.patientFixed ? null : HealthifyIcons.chevronRight,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: dimens.space8,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: dimens.space12,
              children: [
                Expanded(
                  child: ReadOnlyClickableField(
                    value: date == null ? '' : DateFormat.yMd(tag).format(date),
                    label: l10n.scheduleDate,
                    onTap: onDateFieldClick,
                    enabled: !state.isSaving,
                    errorText: momentError,
                    trailingIcon: HealthifyIcons.calendar,
                  ),
                ),
                Expanded(
                  child: ReadOnlyClickableField(
                    value: time == null ? '' : DateFormat.jm(tag).format(DateTime(2000, 1, 1, time.hour, time.minute)),
                    label: l10n.scheduleTime,
                    onTap: onTimeFieldClick,
                    enabled: !state.isSaving,
                    trailingIcon: HealthifyIcons.clock,
                  ),
                ),
              ],
            ),
            Text(
              l10n.scheduleMomentHelp,
              style: context.textStyles.bodySmall!.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }
}

/// "How should they prepare?": the patient sees it in their app.
class _PreparationCard extends StatelessWidget {
  const _PreparationCard({required this.state, required this.onToggle});

  final ScheduleFollowUpState state;
  final void Function(PreparationCode code, bool selected) onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return SectionCard(
      children: [
        Text(l10n.schedulePreparationTitle, style: context.textStyles.titleSmall!.copyWith(color: scheme.onSurface)),
        Text(
          l10n.schedulePreparationHelp,
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
        Wrap(
          spacing: dimens.space8,
          runSpacing: dimens.space8,
          children: [
            for (final code in PreparationCode.values)
              HealthifyFilterChip(
                text: l10n.preparationChip(code),
                selected: state.preparation.contains(code),
                onSelectedChange: (selected) => onToggle(code, selected),
                enabled: !state.isSaving,
              ),
          ],
        ),
      ],
    );
  }
}

class _PatientPickerContent extends StatelessWidget {
  const _PatientPickerContent({required this.state});

  final ScheduleFollowUpState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final patients = state.patients;
    return Padding(
      padding: EdgeInsets.fromLTRB(dimens.space24, dimens.space16, dimens.space24, dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.space8,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.schedulePatientPickerTitle,
              style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface),
            ),
          ),
          if (patients == null && state.isLoadingPatients)
            for (var i = 0; i < 2; i++) const SkeletonListItem()
          else if (patients == null || patients.isEmpty)
            Text(
              l10n.schedulePatientPickerEmpty,
              style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
            )
          else
            for (var i = 0; i < patients.length; i++) ...[
              if (i > 0) Divider(height: dimens.borderThin, thickness: dimens.borderThin, color: scheme.outlineVariant),
              InkWell(
                onTap: () => Navigator.of(context).pop(patients[i]),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: dimens.button),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: dimens.space12),
                      child: Text(
                        patients[i].fullName,
                        style: context.textStyles.bodyLarge!.copyWith(color: scheme.onSurface),
                      ),
                    ),
                  ),
                ),
              ),
            ],
        ],
      ),
    );
  }
}

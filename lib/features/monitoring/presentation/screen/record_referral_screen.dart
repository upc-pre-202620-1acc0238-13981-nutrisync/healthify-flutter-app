import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/dialog_overlay.dart';
import '../../../../core/designsystem/component/failure_state.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_dialog.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/info_cards.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entity/referral.dart';
import '../cubit/record_referral_cubit.dart';
import '../state/practitioner_agenda_states.dart';

/// Record a referral (with required-field and send-error states).
class RecordReferralScreen extends StatelessWidget {
  const RecordReferralScreen({super.key, required this.patientId, required this.onBack, required this.onRecorded});

  final int patientId;
  final VoidCallback onBack;

  /// Referral recorded: returns to the patient file with the "Referral ... recorded" snackbar.
  final void Function(String specialty) onRecorded;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<RecordReferralCubit>(param1: patientId),
    child: Builder(
      builder: (context) {
        final cubit = context.read<RecordReferralCubit>();
        return ObserveEvents<String>(
          events: cubit.recorded,
          onEvent: (context, specialty) => onRecorded(specialty),
          child: BlocBuilder<RecordReferralCubit, RecordReferralState>(
            builder: (context, state) => RecordReferralContent(
              state: state,
              onBack: onBack,
              onSpecialtyChange: cubit.onSpecialtyChange,
              onReasonChange: cubit.onReasonChange,
              onSubmit: cubit.onSubmit,
              onBackToForm: cubit.onBackToForm,
              onNoActiveLinkDismissed: cubit.onNoActiveLinkDismissed,
            ),
          ),
        );
      },
    ),
  );
}

class RecordReferralContent extends StatelessWidget {
  const RecordReferralContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onSpecialtyChange,
    required this.onReasonChange,
    required this.onSubmit,
    required this.onBackToForm,
    required this.onNoActiveLinkDismissed,
  });

  final RecordReferralState state;
  final VoidCallback onBack;
  final ValueChanged<String> onSpecialtyChange;
  final ValueChanged<String> onReasonChange;
  final VoidCallback onSubmit;
  final VoidCallback onBackToForm;
  final VoidCallback onNoActiveLinkDismissed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    if (state.failed) {
      return ColoredBox(
        color: context.colors.surface,
        child: FailureState(
          title: l10n.referralFailedTitle,
          text: l10n.referralFailedBody,
          actionLabel: l10n.commonTryAgain,
          onAction: onBackToForm,
        ),
      );
    }
    final screen = Scaffold(
      backgroundColor: context.colors.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(title: l10n.referralTitle, onBack: onBack),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.all(dimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: dimens.space24,
                children: [
                  if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                  SectionCard(
                    verticalSpacing: dimens.space16,
                    children: [
                      HealthifyTextField(
                        value: state.specialty,
                        onChanged: onSpecialtyChange,
                        label: l10n.referralSpecialty,
                        placeholder: l10n.referralSpecialtyPlaceholder,
                        errorText: state.missing.contains(ReferralField.specialty) ? l10n.referralSpecialtyMissing : null,
                        enabled: !state.isSaving,
                        textInputAction: TextInputAction.next,
                      ),
                      // The practitioner's clinical text: saved and shown as is.
                      HealthifyTextField(
                        value: state.reason,
                        onChanged: onReasonChange,
                        label: l10n.referralReason,
                        placeholder: l10n.referralReasonPlaceholder,
                        errorText: state.missing.contains(ReferralField.reason) ? l10n.referralReasonMissing : null,
                        enabled: !state.isSaving,
                        singleLine: false,
                      ),
                    ],
                  ),
                  HealthifyButton(
                    text: state.isSaving ? l10n.commonSaving : l10n.referralSubmit,
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
    return StateDialogOverlay(
      dialog: state.noActiveLink
          ? HealthifyDialog(
              title: l10n.practitionerNoActiveLinkTitle,
              text: l10n.practitionerNoActiveLinkBody,
              confirmLabel: l10n.commonUnderstood,
              onConfirm: onNoActiveLinkDismissed,
              onDismiss: onNoActiveLinkDismissed,
              informational: true,
            )
          : null,
      onDismiss: onNoActiveLinkDismissed,
      child: screen,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_dialog.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/discharge_patient_cubit.dart';
import '../state/discharge_patient_state.dart';

const _warningIconSize = 48.0;

/// Clinical discharge (the design's dark screen) plus its confirmation.
class DischargePatientScreen extends StatelessWidget {
  const DischargePatientScreen({
    super.key,
    required this.careLinkId,
    required this.patientName,
    required this.onBack,
    required this.onDischarged,
  });

  final int careLinkId;
  final String patientName;
  final VoidCallback onBack;
  final void Function(String patientName) onDischarged;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<DischargePatientCubit>(
      param1: (careLinkId: careLinkId, patientName: patientName),
    ),
    child: Builder(
      builder: (context) {
        final cubit = context.read<DischargePatientCubit>();
        return ObserveEvents<DischargePatientEvent>(
          events: cubit.events,
          onEvent: (context, event) => switch (event) {
            Discharged(:final patientName) => onDischarged(patientName),
          },
          child: BlocBuilder<DischargePatientCubit, DischargePatientState>(
            builder: (context, state) => DischargePatientContent(
              state: state,
              onBack: onBack,
              onReasonChange: cubit.onReasonChange,
              onDischargeRequested: cubit.onDischargeRequested,
              onConfirmed: cubit.onConfirmed,
              onAlreadyDischargedConfirmed: cubit.onAlreadyDischargedConfirmed,
              onDialogDismissed: cubit.onDialogDismissed,
            ),
          ),
        );
      },
    ),
  );
}

class DischargePatientContent extends StatelessWidget {
  const DischargePatientContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onReasonChange,
    required this.onDischargeRequested,
    required this.onConfirmed,
    required this.onAlreadyDischargedConfirmed,
    required this.onDialogDismissed,
  });

  final DischargePatientState state;
  final VoidCallback onBack;
  final ValueChanged<String> onReasonChange;
  final VoidCallback onDischargeRequested;
  final VoidCallback onConfirmed;
  final VoidCallback onAlreadyDischargedConfirmed;
  final VoidCallback onDialogDismissed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final dialog = state.dialog;
    final screen = Scaffold(
      backgroundColor: scheme.inverseSurface,
      body: Column(
        children: [
          HealthifyTopAppBar(
            title: l10n.dischargeTitle,
            onBack: onBack,
            containerColor: scheme.inverseSurface,
            contentColor: scheme.onInverseSurface,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(dimens.space16, dimens.space16, dimens.space16, dimens.space40),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.isOffline) ...[
                      const OfflineBanner(type: OfflineBannerType.requiresNetwork),
                      SizedBox(height: dimens.space24),
                    ],
                    DecoratedBox(
                      decoration: BoxDecoration(color: scheme.onSurface, borderRadius: dimens.shapeExtraLarge),
                      child: Padding(
                        padding: EdgeInsets.all(dimens.space16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: HealthifyIcon(
                                HealthifyIcons.warning,
                                size: _warningIconSize,
                                color: scheme.onInverseSurface,
                              ),
                            ),
                            SizedBox(height: dimens.space16),
                            Text(
                              l10n.dischargeBody,
                              style: context.textStyles.bodyMedium!.copyWith(color: scheme.onInverseSurface),
                            ),
                            SizedBox(height: dimens.space16),
                            // The practitioner's clinical text: saved as is (never translated).
                            HealthifyTextField(
                              value: state.reason,
                              onChanged: onReasonChange,
                              label: l10n.dischargeReason,
                              placeholder: l10n.dischargeReasonPlaceholder,
                              errorText: state.reasonMissing ? l10n.dischargeReasonMissing : null,
                              enabled: !state.isDischarging,
                              singleLine: false,
                              labelColor: scheme.onInverseSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: dimens.space24),
                    HealthifyButton(
                      text: state.isDischarging ? l10n.dischargeProcessing : l10n.dischargeAction,
                      onPressed: onDischargeRequested,
                      loading: state.isDischarging,
                      enabled: !state.isOffline,
                      fullWidth: true,
                    ),
                    SizedBox(height: dimens.space12),
                    HealthifyButton(
                      text: l10n.dsCancel,
                      onPressed: onBack,
                      style: HealthifyButtonStyle.text,
                      contentColor: scheme.inversePrimary,
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (dialog == null) return screen;
    // Dialogs are part of the state (as in Compose), so the cubit closes them when the answer arrives.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _dismiss(dialog);
      },
      child: Stack(
        children: [
          screen,
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _dismiss(dialog),
              child: ColoredBox(color: scheme.scrim.withValues(alpha: dialogScrimAlpha)),
            ),
          ),
          Center(child: Material(type: MaterialType.transparency, child: _dialogFor(context, dialog))),
        ],
      ),
    );
  }

  void _dismiss(DischargeDialog dialog) => switch (dialog) {
    DischargeDialog.alreadyDischarged => onAlreadyDischargedConfirmed(),
    _ => onDialogDismissed(),
  };

  Widget _dialogFor(BuildContext context, DischargeDialog dialog) {
    final l10n = AppLocalizations.of(context);
    return switch (dialog) {
      DischargeDialog.confirm => HealthifyDialog(
        title: l10n.dischargeDialogTitle,
        text: l10n.dischargeDialogBody,
        confirmLabel: state.isDischarging ? l10n.dischargeProcessing : l10n.dischargeDialogConfirm,
        onConfirm: onConfirmed,
        onDismiss: onDialogDismissed,
        destructive: true,
        confirmLoading: state.isDischarging,
      ),
      DischargeDialog.alreadyDischarged => HealthifyDialog(
        title: l10n.dischargeAlreadyTitle,
        text: l10n.dischargeAlreadyBody,
        confirmLabel: l10n.commonUnderstood,
        onConfirm: onAlreadyDischargedConfirmed,
        onDismiss: onAlreadyDischargedConfirmed,
        informational: true,
      ),
      DischargeDialog.noActiveLink => HealthifyDialog(
        title: l10n.practitionerNoActiveLinkTitle,
        text: l10n.practitionerNoActiveLinkBody,
        confirmLabel: l10n.commonUnderstood,
        onConfirm: onDialogDismissed,
        onDismiss: onDialogDismissed,
        informational: true,
      ),
      DischargeDialog.serverError => ServerErrorDialog(onRetry: onConfirmed, onDismiss: onDialogDismissed),
    };
  }
}

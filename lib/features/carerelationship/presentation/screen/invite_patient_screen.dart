import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/designsystem/component/error_state.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_top_app_bar.dart';
import '../../../../core/designsystem/component/list_card.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/skeleton.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/valueobject/invitation_token.dart';
import '../../domain/valueobject/invitation_validity.dart';
import '../components/invitation_qr_code.dart';
import '../cubit/invite_patient_cubit.dart';
import '../state/invite_patient_state.dart';

/// Generate invitation (plus its loading state). Back returns to the roster.
class InvitePatientScreen extends StatelessWidget {
  const InvitePatientScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<InvitePatientCubit>(),
    child: BlocBuilder<InvitePatientCubit, InvitePatientState>(
      builder: (context, state) {
        final cubit = context.read<InvitePatientCubit>();
        return InvitePatientContent(
          state: state,
          onBack: onBack,
          onValidityChange: cubit.onValidityChange,
          onGenerateAnother: cubit.onGenerateAnother,
        );
      },
    ),
  );
}

class InvitePatientContent extends StatelessWidget {
  const InvitePatientContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onValidityChange,
    required this.onGenerateAnother,
  });

  final InvitePatientState state;
  final VoidCallback onBack;
  final ValueChanged<InvitationValidity> onValidityChange;
  final VoidCallback onGenerateAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final token = state.token;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          HealthifyTopAppBar(title: l10n.inviteTitle, onBack: onBack),
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
                    if (state.isGenerating && token == null) ...[
                      const SkeletonCard(),
                      SizedBox(height: dimens.space24),
                      Text(
                        l10n.inviteGenerating,
                        style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ] else if (token == null)
                      ErrorState(
                        onRetry: onGenerateAnother,
                        title: l10n.dsErrorStateTitle,
                        text: _errorMessage(l10n, state.error),
                      )
                    else
                      _InvitationBody(
                        state: state,
                        token: token,
                        onValidityChange: onValidityChange,
                        onGenerateAnother: onGenerateAnother,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitationBody extends StatelessWidget {
  const _InvitationBody({
    required this.state,
    required this.token,
    required this.onValidityChange,
    required this.onGenerateAnother,
  });

  final InvitePatientState state;
  final InvitationToken token;
  final ValueChanged<InvitationValidity> onValidityChange;
  final VoidCallback onGenerateAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final error = state.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.inviteInstructions,
          style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
        ),
        SizedBox(height: dimens.space24),
        HealthifyCard(
          shape: dimens.shapeExtraLarge,
          child: Padding(
            padding: EdgeInsets.all(dimens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.inviteExpiresInLabel,
                  style: context.textStyles.labelMedium!.copyWith(color: scheme.onSurface),
                ),
                SizedBox(height: dimens.space16),
                _ValiditySelector(
                  selected: state.validity,
                  enabled: !state.isGenerating && !state.isOffline,
                  onSelect: onValidityChange,
                ),
                SizedBox(height: dimens.space16),
                Center(
                  child: InvitationQrCode(content: token.value, contentDescription: l10n.inviteQrCd),
                ),
                SizedBox(height: dimens.space16),
                // The design's "Valid 24h · single use" becomes the validity countdown.
                Semantics(
                  liveRegion: true,
                  child: Text(
                    state.isExpired
                        ? l10n.inviteExpired
                        : l10n.inviteCountdown(_countdownText(l10n, state.remaining)),
                    style: context.textStyles.bodySmall!.copyWith(
                      color: state.isExpired ? scheme.error : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: dimens.space24),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: HealthifyButton(
            text: l10n.inviteGenerateAnother,
            onPressed: onGenerateAnother,
            style: HealthifyButtonStyle.text,
            enabled: !state.isOffline,
            loading: state.isGenerating,
          ),
        ),
        SizedBox(height: dimens.space4),
        Text(
          l10n.invitePreviousStillValid,
          style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
        if (error != null) ...[
          SizedBox(height: dimens.space4),
          Text(
            _errorMessage(l10n, error),
            style: context.textStyles.bodySmall!.copyWith(color: scheme.error),
          ),
        ],
      ],
    );
  }
}

/// "Expires in" field (52 dp in the design) that opens the available durations.
class _ValiditySelector extends StatelessWidget {
  const _ValiditySelector({required this.selected, required this.enabled, required this.onSelect});

  final InvitationValidity selected;
  final bool enabled;
  final ValueChanged<InvitationValidity> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return PopupMenuButton<InvitationValidity>(
      enabled: enabled,
      onSelected: onSelect,
      color: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        for (final validity in InvitationValidity.values)
          PopupMenuItem(
            value: validity,
            child: Text(
              _validityLabel(l10n, validity),
              style: context.textStyles.bodyLarge!.copyWith(color: scheme.onSurface),
            ),
          ),
      ],
      child: Container(
        constraints: BoxConstraints(minHeight: dimens.touchMin),
        padding: EdgeInsets.all(dimens.space16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: dimens.shapeMedium,
          border: Border.all(color: scheme.outlineVariant, width: dimens.borderThin),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _validityLabel(l10n, selected),
                style: context.textStyles.bodyMedium!.copyWith(color: scheme.onSurface),
              ),
            ),
            RotatedBox(
              quarterTurns: 1,
              child: HealthifyIcon(HealthifyIcons.chevronRight, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

String _validityLabel(AppLocalizations l10n, InvitationValidity validity) => switch (validity) {
  InvitationValidity.oneHour => l10n.inviteValidityOneHour,
  InvitationValidity.oneDay => l10n.inviteValidityOneDay,
  InvitationValidity.sevenDays => l10n.inviteValiditySevenDays,
};

String _errorMessage(AppLocalizations l10n, InviteError? error) => switch (error) {
  InviteError.offline => l10n.inviteErrorOffline,
  InviteError.expirationRequired => l10n.inviteErrorExpirationRequired,
  InviteError.generic || null => l10n.dsErrorStateBody,
};

/// "23:59:41" or, with more than a day, "6 d 23:59:41".
String _countdownText(AppLocalizations l10n, Duration? remaining) {
  final total = (remaining ?? Duration.zero).inSeconds.clamp(0, double.maxFinite.toInt());
  const secondsPerDay = 86400;
  final days = total ~/ secondsPerDay;
  final hours = (total % secondsPerDay) ~/ 3600;
  final minutes = (total % 3600) ~/ 60;
  final seconds = total % 60;
  final clock = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  return days > 0 ? l10n.inviteCountdownDays(days, clock) : clock;
}

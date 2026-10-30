import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/component_support.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_logo.dart';
import '../../../../core/designsystem/icon/healthify_icons.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/sign_out_cubit.dart';
import '../state/sign_out_state.dart';

// Measurements of the sign-out frame.
const _logoSize = Size(64, 57);
const _badgeSize = 80.0;
const _badgeIconSize = 36.0;

/// Sign out: full-screen confirmation in the session expired style (the practitioner reads that their patients and data
/// stay saved). Works the same offline; pending logs are kept and sent on the next sign-in.
class SignOutConfirmationScreen extends StatelessWidget {
  const SignOutConfirmationScreen({super.key, required this.onCancel, required this.onSignedOut});

  final VoidCallback onCancel;
  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SignOutCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<SignOutCubit>();
        return ObserveEvents<SignOutEvent>(
          events: cubit.events,
          onEvent: (context, event) => switch (event) {
            SignedOut() => onSignedOut(),
          },
          child: BlocBuilder<SignOutCubit, SignOutState>(
            builder: (context, state) =>
                SignOutConfirmationContent(state: state, onConfirm: cubit.onSignOut, onCancel: onCancel),
          ),
        );
      },
    ),
  );
}

class SignOutConfirmationContent extends StatelessWidget {
  const SignOutConfirmationContent({super.key, required this.state, required this.onConfirm, required this.onCancel});

  final SignOutState state;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return PopScope(
      // Leaving mid-way would strand the sign-out; the cancel button is disabled for the same reason.
      canPop: !state.isSigningOut,
      child: Scaffold(
        backgroundColor: scheme.inverseSurface,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: dimens.space16, vertical: dimens.space40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: HealthifyLogo(variant: HealthifyLogoVariant.white, size: _logoSize, decorative: true),
                  ),
                  SizedBox(height: dimens.space24),
                  Center(
                    child: ExcludeSemantics(
                      child: HealthifyCircle(
                        size: _badgeSize,
                        color: scheme.onSurface,
                        child: HealthifyIcon(HealthifyIcons.logout, size: _badgeIconSize, color: scheme.secondary),
                      ),
                    ),
                  ),
                  SizedBox(height: dimens.space24),
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.signOutTitle,
                      textAlign: TextAlign.center,
                      style: context.textStyles.headlineSmall!.copyWith(color: scheme.onInverseSurface),
                    ),
                  ),
                  SizedBox(height: dimens.space4),
                  Text(
                    l10n.signOutBody,
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMedium!.copyWith(color: scheme.onInverseSurface),
                  ),
                  SizedBox(height: dimens.space24),
                  HealthifyButton(
                    text: state.isSigningOut ? l10n.signOutInProgress : l10n.signOutConfirm,
                    onPressed: onConfirm,
                    loading: state.isSigningOut,
                    fullWidth: true,
                  ),
                  SizedBox(height: dimens.space12),
                  HealthifyButton(
                    text: l10n.dsCancel,
                    onPressed: onCancel,
                    style: HealthifyButtonStyle.text,
                    enabled: !state.isSigningOut,
                    contentColor: scheme.inversePrimary,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

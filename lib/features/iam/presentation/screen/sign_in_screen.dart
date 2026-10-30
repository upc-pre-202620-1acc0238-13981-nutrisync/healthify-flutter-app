import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/observe_events.dart';
import '../../../../core/designsystem/component/healthify_button.dart';
import '../../../../core/designsystem/component/healthify_logo.dart';
import '../../../../core/designsystem/component/healthify_text_field.dart';
import '../../../../core/designsystem/component/offline_banner.dart';
import '../../../../core/designsystem/component/server_error_dialog.dart';
import '../../../../core/designsystem/theme/healthify_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../components/auth_card_layout.dart';
import '../cubit/sign_in_cubit.dart';
import '../state/sign_in_state.dart';

// Measurements of the "Single sign-in" frame.
const _logoSize = Size(56, 50);
const _greenShapeOffsetY = 75.0;

/// Single sign-in (wrong credentials · account locked · keyboard).
class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
    required this.onSignedIn,
    required this.onCreateAccount,
    required this.onForgotPassword,
  });

  final VoidCallback onSignedIn;
  final VoidCallback onCreateAccount;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SignInCubit>(),
    child: Builder(
      builder: (context) => ObserveEvents<SignInEvent>(
        events: context.read<SignInCubit>().events,
        onEvent: (context, event) => switch (event) {
          NavigateToShellLoading() => onSignedIn(),
          NavigateToSignUp() => onCreateAccount(),
          NavigateToForgotPassword() => onForgotPassword(),
        },
        child: BlocListener<SignInCubit, SignInState>(
          listenWhen: (previous, current) => !previous.showErrorDialog && current.showErrorDialog,
          listener: (context, state) async {
            final cubit = context.read<SignInCubit>();
            final retry = await showServerErrorDialog(context);
            retry ? cubit.onErrorDialogRetry() : cubit.onErrorDialogDismiss();
          },
          child: BlocBuilder<SignInCubit, SignInState>(
            builder: (context, state) {
              final cubit = context.read<SignInCubit>();
              return SignInContent(
                state: state,
                onEmailChange: cubit.onEmailChange,
                onPasswordChange: cubit.onPasswordChange,
                onSubmit: cubit.onSubmit,
                onForgotPassword: cubit.onForgotPasswordClick,
                onCreateAccount: cubit.onCreateAccountClick,
              );
            },
          ),
        ),
      ),
    ),
  );
}

class SignInContent extends StatelessWidget {
  const SignInContent({
    super.key,
    required this.state,
    required this.onEmailChange,
    required this.onPasswordChange,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onCreateAccount,
  });

  final SignInState state;
  final ValueChanged<String> onEmailChange;
  final ValueChanged<String> onPasswordChange;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    final credentialsError = state.error == SignInError.invalidCredentials;

    void submit() {
      FocusScope.of(context).unfocus();
      onSubmit();
    }

    final submitButton = HealthifyButton(
      text: state.isSubmitting ? l10n.signInSubmitting : l10n.signInSubmit,
      onPressed: submit,
      loading: state.isSubmitting,
      fullWidth: true,
    );

    return AuthCardLayout(
      background: scheme.secondary,
      greenShapeOffsetY: _greenShapeOffsetY,
      keyboardAction: submitButton,
      header: const HealthifyLogo(variant: HealthifyLogoVariant.white, size: _logoSize),
      headerHeight: _logoSize.height,
      children: (keyboardOpen) => [
        if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
        Semantics(
          header: true,
          child: Text(l10n.signInTitle, style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.signInSubtitle,
              style: context.textStyles.labelMedium!.copyWith(color: scheme.onSurfaceVariant),
            ),
            SizedBox(height: dimens.space8),
            if (state.error == SignInError.accountLocked) const _AccountLockedNotice(),
            HealthifyTextField(
              value: state.email,
              onChanged: onEmailChange,
              label: l10n.authEmail,
              placeholder: l10n.authEmailPlaceholder,
              errorText: credentialsError ? l10n.signInErrorCredentials : null,
              type: HealthifyTextFieldType.email,
              textInputAction: TextInputAction.next,
              enabled: !state.isSubmitting,
            ),
          ],
        ),
        HealthifyTextField(
          value: state.password,
          onChanged: onPasswordChange,
          label: l10n.authPassword,
          placeholder: l10n.signInPasswordPlaceholder,
          // Wrong credentials: the password border also turns to error; the message shows only once (on the email).
          isError: credentialsError,
          type: HealthifyTextFieldType.password,
          textInputAction: TextInputAction.go,
          onSubmitted: (_) => submit(),
          enabled: !state.isSubmitting,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HealthifyButton(
              text: l10n.signInForgotPassword,
              onPressed: onForgotPassword,
              style: HealthifyButtonStyle.text,
              enabled: !state.isSubmitting,
              fullWidth: true,
            ),
            SizedBox(height: dimens.space12),
            if (!keyboardOpen) ...[submitButton, SizedBox(height: dimens.space12)],
            HealthifyButton(
              text: l10n.signInCreateAccount,
              onPressed: onCreateAccount,
              style: HealthifyButtonStyle.text,
              enabled: !state.isSubmitting,
              fullWidth: true,
            ),
          ],
        ),
      ],
    );
  }
}

/// The "account locked" notice.
class _AccountLockedNotice extends StatelessWidget {
  const _AccountLockedNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dimens.space8),
      child: Semantics(
        container: true,
        liveRegion: true,
        child: DecoratedBox(
          decoration: BoxDecoration(color: scheme.errorContainer, borderRadius: dimens.shapeLarge),
          child: Padding(
            padding: EdgeInsets.all(dimens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.signInLockedTitle,
                  style: context.textStyles.titleSmall!.copyWith(color: scheme.onErrorContainer),
                ),
                SizedBox(height: dimens.space4),
                Text(
                  l10n.signInLockedBody,
                  style: context.textStyles.bodyMedium!.copyWith(color: scheme.onErrorContainer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

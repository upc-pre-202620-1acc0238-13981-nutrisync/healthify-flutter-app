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
import '../cubit/forgot_password_cubit.dart';
import '../state/forgot_password_state.dart';

// There is no recovery frame; it reuses the sign-in frame (white logo on orange).
const _logoSize = Size(56, 50);
const _greenShapeOffsetY = 75.0;

/// Password recovery (email -> code -> new password -> done).
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key, required this.onGoToSignIn});

  final VoidCallback onGoToSignIn;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<ForgotPasswordCubit>(),
    child: Builder(
      builder: (context) => ObserveEvents<ForgotPasswordEvent>(
        events: context.read<ForgotPasswordCubit>().events,
        onEvent: (context, event) => switch (event) {
          ForgotPasswordNavigateToSignIn() => onGoToSignIn(),
        },
        child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listenWhen: (previous, current) => !previous.showErrorDialog && current.showErrorDialog,
          listener: (context, state) async {
            final cubit = context.read<ForgotPasswordCubit>();
            final retry = await showServerErrorDialog(context);
            retry ? cubit.onErrorDialogRetry() : cubit.onErrorDialogDismiss();
          },
          // System back walks the steps backwards; only the first step and the last one leave the screen.
          child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
            builder: (context, state) {
              final cubit = context.read<ForgotPasswordCubit>();
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, _) {
                  if (!didPop) cubit.onBack();
                },
                child: ForgotPasswordContent(
                  state: state,
                  onEmailChange: cubit.onEmailChange,
                  onCodeChange: cubit.onCodeChange,
                  onNewPasswordChange: cubit.onNewPasswordChange,
                  onSendCode: cubit.onSendCode,
                  onResendCode: cubit.onResendCode,
                  onVerifyCode: cubit.onVerifyCode,
                  onSubmitNewPassword: cubit.onSubmitNewPassword,
                  onChangeEmail: cubit.onChangeEmail,
                  onBack: cubit.onBack,
                  onGoToSignIn: cubit.onGoToSignIn,
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

class ForgotPasswordContent extends StatelessWidget {
  const ForgotPasswordContent({
    super.key,
    required this.state,
    required this.onEmailChange,
    required this.onCodeChange,
    required this.onNewPasswordChange,
    required this.onSendCode,
    required this.onResendCode,
    required this.onVerifyCode,
    required this.onSubmitNewPassword,
    required this.onChangeEmail,
    required this.onBack,
    required this.onGoToSignIn,
  });

  final ForgotPasswordState state;
  final ValueChanged<String> onEmailChange;
  final ValueChanged<String> onCodeChange;
  final ValueChanged<String> onNewPasswordChange;
  final VoidCallback onSendCode;
  final VoidCallback onResendCode;
  final VoidCallback onVerifyCode;
  final VoidCallback onSubmitNewPassword;
  final VoidCallback onChangeEmail;
  final VoidCallback onBack;
  final VoidCallback onGoToSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    void submit(VoidCallback action) {
      FocusScope.of(context).unfocus();
      action();
    }

    final primaryAction = switch (state.step) {
      ForgotPasswordStep.email => HealthifyButton(
        text: state.isSubmitting ? l10n.forgotPasswordSending : l10n.forgotPasswordSend,
        onPressed: () => submit(onSendCode),
        loading: state.isSubmitting,
        fullWidth: true,
      ),
      ForgotPasswordStep.code => HealthifyButton(
        text: state.isSubmitting ? l10n.forgotPasswordVerifying : l10n.forgotPasswordVerify,
        onPressed: () => submit(onVerifyCode),
        loading: state.isSubmitting,
        fullWidth: true,
      ),
      ForgotPasswordStep.newPassword => HealthifyButton(
        text: state.isSubmitting ? l10n.forgotPasswordSubmitting : l10n.forgotPasswordSubmit,
        onPressed: () => submit(onSubmitNewPassword),
        loading: state.isSubmitting,
        fullWidth: true,
      ),
      ForgotPasswordStep.done => HealthifyButton(
        text: l10n.forgotPasswordGoToSignIn,
        onPressed: onGoToSignIn,
        fullWidth: true,
      ),
    };

    return AuthCardLayout(
      background: context.colors.secondary,
      greenShapeOffsetY: _greenShapeOffsetY,
      keyboardAction: primaryAction,
      header: const HealthifyLogo(variant: HealthifyLogoVariant.white, size: _logoSize),
      headerHeight: _logoSize.height,
      children: (keyboardOpen) => [
        if (state.isOffline && state.step != ForgotPasswordStep.done)
          const OfflineBanner(type: OfflineBannerType.requiresNetwork),
        ...switch (state.step) {
          ForgotPasswordStep.email => _emailStep(context, keyboardOpen, primaryAction),
          ForgotPasswordStep.code => _codeStep(context, keyboardOpen, primaryAction),
          ForgotPasswordStep.newPassword => _newPasswordStep(context, keyboardOpen, primaryAction),
          ForgotPasswordStep.done => _doneStep(context, primaryAction),
        },
      ],
    );
  }

  List<Widget> _emailStep(BuildContext context, bool keyboardOpen, Widget primaryAction) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    return [
      _StepHeader(title: l10n.forgotPasswordTitle, body: l10n.forgotPasswordEmailSubtitle),
      HealthifyTextField(
        value: state.email,
        onChanged: onEmailChange,
        label: l10n.authEmail,
        placeholder: l10n.authEmailPlaceholder,
        errorText: state.invalidEmail ? l10n.forgotPasswordEmailError : null,
        type: HealthifyTextFieldType.email,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) {
          FocusScope.of(context).unfocus();
          onSendCode();
        },
        enabled: !state.isSubmitting,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!keyboardOpen) ...[primaryAction, SizedBox(height: dimens.space12)],
          HealthifyButton(
            text: l10n.forgotPasswordBackToSignIn,
            onPressed: onBack,
            style: HealthifyButtonStyle.text,
            enabled: !state.isSubmitting,
            fullWidth: true,
          ),
        ],
      ),
    ];
  }

  List<Widget> _codeStep(BuildContext context, bool keyboardOpen, Widget primaryAction) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return [
      _StepHeader(title: l10n.forgotPasswordTitle, body: l10n.forgotPasswordCodeSubtitle(state.email.trim())),
      if (state.tokenExpired) _Notice(text: l10n.forgotPasswordTokenExpired),
      if (state.codeResent)
        Semantics(
          liveRegion: true,
          child: Text(
            l10n.forgotPasswordResent,
            style: context.textStyles.bodySmall!.copyWith(color: scheme.primary),
          ),
        ),
      HealthifyTextField(
        value: state.code,
        onChanged: onCodeChange,
        label: l10n.forgotPasswordCodeLabel,
        placeholder: l10n.forgotPasswordCodePlaceholder,
        errorText: state.invalidCode ? l10n.forgotPasswordCodeError : null,
        type: HealthifyTextFieldType.number,
        textInputAction: TextInputAction.go,
        onSubmitted: (_) {
          FocusScope.of(context).unfocus();
          onVerifyCode();
        },
        enabled: !state.isSubmitting,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!keyboardOpen) ...[primaryAction, SizedBox(height: dimens.space12)],
          HealthifyButton(
            text: state.resendInSeconds > 0
                ? l10n.forgotPasswordResendIn(state.resendInSeconds)
                : l10n.forgotPasswordResend,
            onPressed: onResendCode,
            style: HealthifyButtonStyle.text,
            enabled: !state.isSubmitting && state.resendInSeconds == 0,
            fullWidth: true,
          ),
          SizedBox(height: dimens.space12),
          HealthifyButton(
            text: l10n.forgotPasswordChangeEmail,
            onPressed: onChangeEmail,
            style: HealthifyButtonStyle.text,
            enabled: !state.isSubmitting,
            fullWidth: true,
          ),
        ],
      ),
    ];
  }

  List<Widget> _newPasswordStep(BuildContext context, bool keyboardOpen, Widget primaryAction) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;
    return [
      _StepHeader(title: l10n.forgotPasswordTitle, body: l10n.forgotPasswordNewPasswordSubtitle),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HealthifyTextField(
            value: state.newPassword,
            onChanged: onNewPasswordChange,
            label: l10n.forgotPasswordNewPassword,
            placeholder: l10n.signUpPasswordPlaceholder,
            errorText: state.passwordReused
                ? l10n.forgotPasswordErrorReused
                : state.weakPassword
                ? l10n.signUpErrorPassword
                : null,
            type: HealthifyTextFieldType.password,
            textInputAction: TextInputAction.go,
            onSubmitted: (_) {
              FocusScope.of(context).unfocus();
              onSubmitNewPassword();
            },
            enabled: !state.isSubmitting,
          ),
          SizedBox(height: dimens.space4),
          Text(
            l10n.signUpPasswordHint,
            style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
      if (!keyboardOpen) primaryAction,
    ];
  }

  List<Widget> _doneStep(BuildContext context, Widget primaryAction) {
    final l10n = AppLocalizations.of(context);
    return [_StepHeader(title: l10n.forgotPasswordDoneTitle, body: l10n.forgotPasswordDoneBody), primaryAction];
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface)),
        ),
        SizedBox(height: context.dimens.space16),
        Text(body, style: context.textStyles.labelMedium!.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

/// Notice in the style of the sign-in "account locked" notice: the time to change the password ran out.
class _Notice extends StatelessWidget {
  const _Notice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final scheme = context.colors;
    return Semantics(
      liveRegion: true,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(color: scheme.errorContainer, borderRadius: dimens.shapeLarge),
        child: Padding(
          padding: EdgeInsets.all(dimens.space16),
          child: Text(text, style: context.textStyles.bodyMedium!.copyWith(color: scheme.onErrorContainer)),
        ),
      ),
    );
  }
}

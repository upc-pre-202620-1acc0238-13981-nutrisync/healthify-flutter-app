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
import '../../domain/valueobject/person_name.dart';
import '../components/auth_card_layout.dart';
import '../cubit/sign_up_cubit.dart';
import '../state/sign_up_state.dart';

// Measurements of the "Sign-up" frame.
const _logoSize = Size(44, 39);
const _greenShapeOffsetY = 9.0;

/// Sign-up (loading · offline · validation errors · keyboard). Always creates a practitioner account.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, required this.onSignedIn, required this.onSignIn});

  final VoidCallback onSignedIn;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SignUpCubit>(),
    child: Builder(
      builder: (context) => ObserveEvents<SignUpEvent>(
        events: context.read<SignUpCubit>().events,
        onEvent: (context, event) => switch (event) {
          SignUpNavigateToShellLoading() => onSignedIn(),
          SignUpNavigateToSignIn() => onSignIn(),
        },
        child: BlocListener<SignUpCubit, SignUpState>(
          listenWhen: (previous, current) => !previous.showErrorDialog && current.showErrorDialog,
          listener: (context, state) async {
            final cubit = context.read<SignUpCubit>();
            final retry = await showServerErrorDialog(context);
            retry ? cubit.onErrorDialogRetry() : cubit.onErrorDialogDismiss();
          },
          child: BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              final cubit = context.read<SignUpCubit>();
              return SignUpContent(
                state: state,
                onGivenNamesChange: cubit.onGivenNamesChange,
                onFamilyNamesChange: cubit.onFamilyNamesChange,
                onEmailChange: cubit.onEmailChange,
                onPasswordChange: cubit.onPasswordChange,
                onSubmit: cubit.onSubmit,
                onSignIn: cubit.onSignInClick,
              );
            },
          ),
        ),
      ),
    ),
  );
}

class SignUpContent extends StatelessWidget {
  const SignUpContent({
    super.key,
    required this.state,
    required this.onGivenNamesChange,
    required this.onFamilyNamesChange,
    required this.onEmailChange,
    required this.onPasswordChange,
    required this.onSubmit,
    required this.onSignIn,
  });

  final SignUpState state;
  final ValueChanged<String> onGivenNamesChange;
  final ValueChanged<String> onFamilyNamesChange;
  final ValueChanged<String> onEmailChange;
  final ValueChanged<String> onPasswordChange;
  final VoidCallback onSubmit;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dimens = context.dimens;
    final scheme = context.colors;

    void submit() {
      FocusScope.of(context).unfocus();
      onSubmit();
    }

    final submitButton = HealthifyButton(
      text: state.isSubmitting ? l10n.signUpSubmitting : l10n.signUpSubmit,
      onPressed: submit,
      loading: state.isSubmitting,
      fullWidth: true,
    );

    return AuthCardLayout(
      background: scheme.primary,
      greenShapeOffsetY: _greenShapeOffsetY,
      keyboardAction: submitButton,
      children: (keyboardOpen) => [
        if (state.isOffline) const OfflineBanner(type: OfflineBannerType.requiresNetwork),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.signUpTitle,
                      style: context.textStyles.headlineSmall!.copyWith(color: scheme.onSurface),
                    ),
                  ),
                ),
                const HealthifyLogo(variant: HealthifyLogoVariant.color, size: _logoSize),
              ],
            ),
            SizedBox(height: dimens.space8),
            Text(l10n.signUpSubtitle, style: context.textStyles.titleSmall!.copyWith(color: scheme.primary)),
            SizedBox(height: dimens.space8),
            _NameFields(
              state: state,
              onGivenNamesChange: onGivenNamesChange,
              onFamilyNamesChange: onFamilyNamesChange,
            ),
          ],
        ),
        HealthifyTextField(
          value: state.email,
          onChanged: onEmailChange,
          label: l10n.authEmail,
          placeholder: l10n.authEmailPlaceholder,
          errorText: switch (state.errors.email) {
            SignUpEmailError.invalid => l10n.signUpErrorEmail,
            SignUpEmailError.alreadyTaken => l10n.signUpErrorEmailTaken,
            null => null,
          },
          type: HealthifyTextFieldType.email,
          textInputAction: TextInputAction.next,
          enabled: !state.isSubmitting,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HealthifyTextField(
              value: state.password,
              onChanged: onPasswordChange,
              label: l10n.authPassword,
              placeholder: l10n.signUpPasswordPlaceholder,
              errorText: state.errors.weakPassword ? l10n.signUpErrorPassword : null,
              type: HealthifyTextFieldType.password,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
              enabled: !state.isSubmitting,
            ),
            SizedBox(height: dimens.space4),
            Text(
              l10n.signUpPasswordHint,
              style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!keyboardOpen) ...[submitButton, SizedBox(height: dimens.space12)],
            if (state.isOffline)
              Text(
                l10n.signUpOfflineHint,
                textAlign: TextAlign.center,
                style: context.textStyles.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
              )
            else if (!state.isSubmitting)
              // The "Loading" frame hides "I already have an account" while the account is being created.
              HealthifyButton(
                text: l10n.signUpHaveAccount,
                onPressed: onSignIn,
                style: HealthifyButtonStyle.text,
                fullWidth: true,
              ),
          ],
        ),
      ],
    );
  }
}

class _NameFields extends StatelessWidget {
  const _NameFields({required this.state, required this.onGivenNamesChange, required this.onFamilyNamesChange});

  final SignUpState state;
  final ValueChanged<String> onGivenNamesChange;
  final ValueChanged<String> onFamilyNamesChange;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: HealthifyTextField(
            value: state.givenNames,
            onChanged: onGivenNamesChange,
            label: l10n.signUpGivenNames,
            placeholder: l10n.signUpGivenNamesPlaceholder,
            errorText: state.errors.givenNames == null
                ? null
                : _nameMessage(l10n, state.errors.givenNames!, l10n.signUpErrorGivenNamesRequired),
            type: HealthifyTextFieldType.name,
            textInputAction: TextInputAction.next,
            enabled: !state.isSubmitting,
          ),
        ),
        SizedBox(width: context.dimens.space12),
        Expanded(
          child: HealthifyTextField(
            value: state.familyNames,
            onChanged: onFamilyNamesChange,
            label: l10n.signUpFamilyNames,
            placeholder: l10n.signUpFamilyNamesPlaceholder,
            errorText: state.errors.familyNames == null
                ? null
                : _nameMessage(l10n, state.errors.familyNames!, l10n.signUpErrorFamilyNamesRequired),
            type: HealthifyTextFieldType.name,
            textInputAction: TextInputAction.next,
            enabled: !state.isSubmitting,
          ),
        ),
      ],
    );
  }

  String _nameMessage(AppLocalizations l10n, PersonNameProblem problem, String requiredMessage) => switch (problem) {
    PersonNameProblem.required => requiredMessage,
    PersonNameProblem.invalidCharacters => l10n.signUpErrorNameCharacters,
    PersonNameProblem.tooLong => l10n.signUpErrorNameTooLong,
  };
}

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/valueobject/person_name.dart';

part 'sign_up_state.freezed.dart';

/// Email field error on sign-up.
enum SignUpEmailError { invalid, alreadyTaken }

/// Errors per field. `null` = the field is fine or not validated yet.
@freezed
abstract class SignUpFieldErrors with _$SignUpFieldErrors {
  const factory SignUpFieldErrors({
    PersonNameProblem? givenNames,
    PersonNameProblem? familyNames,
    SignUpEmailError? email,
    @Default(false) bool weakPassword,
  }) = _SignUpFieldErrors;
}

/// Sign-up. The password lives in memory only.
///
/// [isOffline]: the "You need a connection to continue" banner and the text under the button. Creating the account is
/// not attempted offline. [showErrorDialog]: unexpected server error ("Retry" / "Close").
@freezed
abstract class SignUpState with _$SignUpState {
  const SignUpState._();

  const factory SignUpState({
    @Default('') String givenNames,
    @Default('') String familyNames,
    @Default('') String email,
    @Default('') String password,
    @Default(SignUpFieldErrors()) SignUpFieldErrors errors,
    @Default(false) bool isSubmitting,
    @Default(false) bool isOffline,
    @Default(false) bool showErrorDialog,
  }) = _SignUpState;

  @override
  String toString() => 'SignUpState(errors: $errors, isSubmitting: $isSubmitting, isOffline: $isOffline)';
}

sealed class SignUpEvent {
  const SignUpEvent();
}

/// Account created and signed in -> loading.
final class SignUpNavigateToShellLoading extends SignUpEvent {
  const SignUpNavigateToShellLoading();
}

/// "I already have an account", or the account was created but the automatic sign-in failed -> sign-in.
final class SignUpNavigateToSignIn extends SignUpEvent {
  const SignUpNavigateToSignIn();
}

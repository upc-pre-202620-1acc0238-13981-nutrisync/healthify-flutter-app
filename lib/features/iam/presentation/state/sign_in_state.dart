import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

/// Sign-in errors that have their own frame.
enum SignInError {
  /// `InvalidCredentials` (the same whether or not the email exists).
  invalidCredentials,

  /// `AccountLocked`.
  accountLocked,
}

/// Single sign-in. The password lives in memory only.
///
/// [isOffline]: there is no offline frame for sign-in; it uses the same "You need a connection to continue" banner as
/// sign-up and does not try to sign in offline.
@freezed
abstract class SignInState with _$SignInState {
  const SignInState._();

  const factory SignInState({
    @Default('') String email,
    @Default('') String password,
    SignInError? error,
    @Default(false) bool isSubmitting,
    @Default(false) bool isOffline,
    @Default(false) bool showErrorDialog,
  }) = _SignInState;

  @override
  String toString() => 'SignInState(error: $error, isSubmitting: $isSubmitting, isOffline: $isOffline)';
}

sealed class SignInEvent {
  const SignInEvent();
}

final class NavigateToShellLoading extends SignInEvent {
  const NavigateToShellLoading();
}

final class NavigateToSignUp extends SignInEvent {
  const NavigateToSignUp();
}

/// "Forgot your password?" -> password recovery.
final class NavigateToForgotPassword extends SignInEvent {
  const NavigateToForgotPassword();
}

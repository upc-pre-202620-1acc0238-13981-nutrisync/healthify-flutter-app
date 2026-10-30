import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

/// Password recovery steps.
enum ForgotPasswordStep {
  /// The account email is typed.
  email,

  /// The received code is typed; the backend verifies it before asking for the password.
  code,

  /// Code verified: the new password is typed.
  newPassword,

  /// Password changed: all that is left is going back to sign-in.
  done,
}

/// Password recovery. The code and the password live in memory only; the verification token is not even in the state
/// (the cubit keeps it).
///
/// - [invalidEmail]: the email is not shaped like an email (checked before calling the backend).
/// - [invalidCode]: `PasswordResetCodeInvalid`, or a code that is not six digits.
/// - [weakPassword]: `WeakPassword`, or a password that does not meet the sign-up rules.
/// - [passwordReused]: `PasswordReuseNotAllowed`: it is the current password.
/// - [tokenExpired]: `PasswordResetTokenInvalid`: the time to change it ran out; it goes back to the code step.
/// - [resendInSeconds]: seconds left before another code can be requested; `0` = it can be now.
/// - [codeResent]: a new code was requested from the [ForgotPasswordStep.code] step.
@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const ForgotPasswordState._();

  const factory ForgotPasswordState({
    @Default(ForgotPasswordStep.email) ForgotPasswordStep step,
    @Default('') String email,
    @Default('') String code,
    @Default('') String newPassword,
    @Default(false) bool invalidEmail,
    @Default(false) bool invalidCode,
    @Default(false) bool weakPassword,
    @Default(false) bool passwordReused,
    @Default(false) bool tokenExpired,
    @Default(false) bool isSubmitting,
    @Default(false) bool isOffline,
    @Default(0) int resendInSeconds,
    @Default(false) bool codeResent,
    @Default(false) bool showErrorDialog,
  }) = _ForgotPasswordState;

  @override
  String toString() =>
      'ForgotPasswordState(step: $step, invalidEmail: $invalidEmail, invalidCode: $invalidCode, '
      'weakPassword: $weakPassword, passwordReused: $passwordReused, tokenExpired: $tokenExpired, '
      'isSubmitting: $isSubmitting, isOffline: $isOffline)';
}

sealed class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

/// "Back to sign in", "back" on the first step, or "Sign in" at the end -> sign-in.
final class ForgotPasswordNavigateToSignIn extends ForgotPasswordEvent {
  const ForgotPasswordNavigateToSignIn();
}

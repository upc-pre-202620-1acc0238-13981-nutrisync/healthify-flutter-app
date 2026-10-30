import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/password_reset_use_cases.dart';
import '../../domain/entity/password_reset.dart';
import '../../domain/valueobject/email_address.dart';
import '../../domain/valueobject/password.dart';
import '../../domain/valueobject/password_reset_code.dart';
import '../../domain/valueobject/password_reset_token.dart';
import '../state/forgot_password_state.dart';

/// Password recovery: email -> code -> new password -> done. Decides by `extensions.code`: `PasswordResetCodeInvalid`,
/// `WeakPassword` and `PasswordReuseNotAllowed` mark their field; `PasswordResetTokenInvalid` goes back to the code
/// step; any other error opens the retry dialog. Requesting the code always "works" (the backend does not say whether
/// the account exists), so the code step shows anyway.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(
    this._requestPasswordReset,
    this._verifyPasswordResetCode,
    this._resetPassword,
    ConnectivityObserver connectivityObserver,
  ) : super(const ForgotPasswordState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) => _emit(state.copyWith(isOffline: !online)));
  }

  /// Same as the backend's `Iam:PasswordResetResendSeconds`.
  static const resendCooldownSeconds = 60;

  static const _codeResetCodeInvalid = 'PasswordResetCodeInvalid';
  static const _codeResetTokenInvalid = 'PasswordResetTokenInvalid';
  static const _codeWeakPassword = 'WeakPassword';
  static const _codePasswordReuse = 'PasswordReuseNotAllowed';

  final RequestPasswordResetUseCase _requestPasswordReset;
  final VerifyPasswordResetCodeUseCase _verifyPasswordResetCode;
  final ResetPasswordUseCase _resetPassword;
  final _events = OneShotEvents<ForgotPasswordEvent>();
  late final StreamSubscription<bool> _connectivity;
  Timer? _countdown;

  /// The verification token. In memory only: never in the state.
  PasswordResetToken? _resetToken;

  /// The last backend call, for "Retry" in the error dialog.
  void Function()? _retry;

  Stream<ForgotPasswordEvent> get events => _events.stream;

  void onEmailChange(String value) => emit(state.copyWith(email: value, invalidEmail: false));

  void onCodeChange(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    final code = digits.length > PasswordResetCode.length ? digits.substring(0, PasswordResetCode.length) : digits;
    emit(state.copyWith(code: code, invalidCode: false));
  }

  void onNewPasswordChange(String value) =>
      emit(state.copyWith(newPassword: value, weakPassword: false, passwordReused: false));

  /// Step 1: "Send code".
  void onSendCode() {
    final current = state;
    if (current.isSubmitting || current.isOffline) return;
    final email = EmailAddress.parse(current.email);
    if (email == null) {
      emit(current.copyWith(invalidEmail: true));
      return;
    }
    _sendCode(email, resent: false);
  }

  /// Step 2: "Resend code", only once the wait is over.
  void onResendCode() {
    final current = state;
    if (current.isSubmitting || current.isOffline || current.resendInSeconds > 0) return;
    final email = EmailAddress.parse(current.email);
    if (email == null) return;
    _sendCode(email, resent: true);
  }

  /// Step 2: "Verify code". A code that is not six digits does not use up an attempt.
  Future<void> onVerifyCode() async {
    final current = state;
    if (current.isSubmitting || current.isOffline) return;
    final email = EmailAddress.parse(current.email);
    if (email == null) return;
    final code = PasswordResetCode.parse(current.code);
    if (code == null) {
      emit(current.copyWith(invalidCode: true));
      return;
    }
    _retry = onVerifyCode;
    emit(current.copyWith(isSubmitting: true, invalidCode: false, codeResent: false, tokenExpired: false));
    final result = await _verifyPasswordResetCode(email, code);
    if (isClosed) return;
    final error = result.errorOrNull;
    if (error == null) _resetToken = result.valueOrNull;
    emit(
      error == null
          ? state.copyWith(isSubmitting: false, step: ForgotPasswordStep.newPassword, code: '')
          : _hasCode(error, _codeResetCodeInvalid)
          ? state.copyWith(isSubmitting: false, invalidCode: true)
          : state.copyWith(isSubmitting: false, showErrorDialog: true),
    );
  }

  /// Step 3: "Change password". The password is checked against the sign-up rules before it is sent.
  Future<void> onSubmitNewPassword() async {
    final current = state;
    if (current.isSubmitting || current.isOffline) return;
    final token = _resetToken;
    if (token == null) return _backToCode(tokenExpired: true);
    final password = Password.parse(current.newPassword);
    if (password == null) {
      emit(current.copyWith(weakPassword: true));
      return;
    }
    _retry = onSubmitNewPassword;
    emit(current.copyWith(isSubmitting: true, weakPassword: false, passwordReused: false));
    final error = (await _resetPassword(PasswordReset(token: token, newPassword: password))).errorOrNull;
    if (isClosed) return;
    if (error == null) {
      _resetToken = null;
      emit(state.copyWith(isSubmitting: false, step: ForgotPasswordStep.done, newPassword: ''));
    } else if (_hasCode(error, _codeResetTokenInvalid)) {
      emit(state.copyWith(isSubmitting: false));
      _backToCode(tokenExpired: true);
    } else if (_hasCode(error, _codeWeakPassword)) {
      emit(state.copyWith(isSubmitting: false, weakPassword: true));
    } else if (_hasCode(error, _codePasswordReuse)) {
      emit(state.copyWith(isSubmitting: false, passwordReused: true));
    } else {
      emit(state.copyWith(isSubmitting: false, showErrorDialog: true));
    }
  }

  /// "Use another email": goes back to step 1 keeping what was typed.
  void onChangeEmail() {
    _resetToken = null;
    emit(
      state.copyWith(
        step: ForgotPasswordStep.email,
        code: '',
        newPassword: '',
        invalidCode: false,
        weakPassword: false,
        passwordReused: false,
        tokenExpired: false,
        codeResent: false,
      ),
    );
  }

  /// System "back": from the password to the code (the token is discarded and a new code is needed), from the code to
  /// the email, and from the email or at the end, to sign-in.
  void onBack() {
    switch (state.step) {
      case ForgotPasswordStep.newPassword:
        _backToCode(tokenExpired: false);
      case ForgotPasswordStep.code:
        onChangeEmail();
      case ForgotPasswordStep.email || ForgotPasswordStep.done:
        onGoToSignIn();
    }
  }

  void onGoToSignIn() => _events.emit(const ForgotPasswordNavigateToSignIn());

  void onErrorDialogDismiss() => emit(state.copyWith(showErrorDialog: false));

  /// Repeats the action that failed: send, resend, verify or change the password.
  void onErrorDialogRetry() {
    emit(state.copyWith(showErrorDialog: false));
    _retry?.call();
  }

  void _backToCode({required bool tokenExpired}) {
    _resetToken = null;
    emit(
      state.copyWith(
        step: ForgotPasswordStep.code,
        code: '',
        newPassword: '',
        weakPassword: false,
        passwordReused: false,
        tokenExpired: tokenExpired,
        codeResent: false,
      ),
    );
  }

  Future<void> _sendCode(EmailAddress email, {required bool resent}) async {
    _retry = resent ? onResendCode : onSendCode;
    emit(state.copyWith(isSubmitting: true, invalidEmail: false, codeResent: false));
    final error = (await _requestPasswordReset(email)).errorOrNull;
    if (isClosed) return;
    if (error != null) {
      emit(state.copyWith(isSubmitting: false, showErrorDialog: true));
      return;
    }
    emit(
      state.copyWith(
        isSubmitting: false,
        step: ForgotPasswordStep.code,
        codeResent: resent,
        tokenExpired: false,
        invalidCode: false,
      ),
    );
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _countdown?.cancel();
    var seconds = resendCooldownSeconds;
    emit(state.copyWith(resendInSeconds: seconds));
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds <= 0) timer.cancel();
      _emit(state.copyWith(resendInSeconds: seconds < 0 ? 0 : seconds));
    });
  }

  bool _hasCode(DomainError error, String code) => error is Validation && error.code == code;

  void _emit(ForgotPasswordState value) {
    if (!isClosed) emit(value);
  }

  @override
  Future<void> close() async {
    _countdown?.cancel();
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

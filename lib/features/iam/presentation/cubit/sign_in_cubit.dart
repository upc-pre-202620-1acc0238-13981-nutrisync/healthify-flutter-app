import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/sign_in_use_case.dart';
import '../../domain/entity/credentials.dart';
import '../state/sign_in_state.dart';

/// Single sign-in. Decides by `extensions.code`, never by the text: `InvalidCredentials` -> wrong credentials,
/// `AccountLocked` -> account locked (both 401). A 401 without a code is treated as wrong credentials.
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._signIn, ConnectivityObserver connectivityObserver) : super(const SignInState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) => _emit(state.copyWith(isOffline: !online)));
  }

  static const _codeAccountLocked = 'AccountLocked';

  final SignInUseCase _signIn;
  final _events = OneShotEvents<SignInEvent>();
  late final StreamSubscription<bool> _connectivity;

  Stream<SignInEvent> get events => _events.stream;

  void onEmailChange(String value) => emit(state.copyWith(email: value, error: _keepLock(state.error)));

  void onPasswordChange(String value) => emit(state.copyWith(password: value, error: _keepLock(state.error)));

  void onForgotPasswordClick() => _events.emit(const NavigateToForgotPassword());

  void onCreateAccountClick() => _events.emit(const NavigateToSignUp());

  void onErrorDialogDismiss() => emit(state.copyWith(showErrorDialog: false));

  void onErrorDialogRetry() {
    emit(state.copyWith(showErrorDialog: false));
    onSubmit();
  }

  Future<void> onSubmit() async {
    final current = state;
    if (current.isSubmitting || current.isOffline) return;
    // An email not shaped like an email or an empty password cannot sign in: same message as the backend (minimal
    // disclosure), without using up an attempt.
    final credentials = Credentials.parse(current.email, current.password);
    if (credentials == null) {
      emit(current.copyWith(error: SignInError.invalidCredentials));
      return;
    }
    emit(current.copyWith(isSubmitting: true, error: null));
    final result = await _signIn(credentials);
    if (isClosed) return;
    emit(state.copyWith(isSubmitting: false));
    final error = result.errorOrNull;
    if (error == null) {
      _events.emit(const NavigateToShellLoading());
    } else {
      _showError(error);
    }
  }

  void _showError(DomainError error) {
    emit(switch (error) {
      Unauthorized(code: _codeAccountLocked) => state.copyWith(error: SignInError.accountLocked),
      Unauthorized() => state.copyWith(error: SignInError.invalidCredentials),
      _ => state.copyWith(showErrorDialog: true),
    });
  }

  /// Editing clears the wrong credentials error; the account locked notice stays until the next attempt.
  SignInError? _keepLock(SignInError? error) => error == SignInError.accountLocked ? error : null;

  void _emit(SignInState value) {
    if (!isClosed) emit(value);
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

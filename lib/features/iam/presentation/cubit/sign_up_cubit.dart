import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/register_use_case.dart';
import '../../domain/entity/new_account.dart';
import '../../domain/valueobject/person_name.dart';
import '../../domain/valueobject/user_role.dart';
import '../state/sign_up_state.dart';

/// Sign-up. Validates with the value objects (same rules as the backend) before sending and maps the backend codes
/// (`InvalidEmail`, `WeakPassword`, `NameRequired`, `EmailAlreadyTaken`) to each field's error. The role is always
/// practitioner: this app does not serve patients, so the form does not ask for it.
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._register, ConnectivityObserver connectivityObserver) : super(const SignUpState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) => _emit(state.copyWith(isOffline: !online)));
  }

  // `extensions.code` values of sign-up.
  static const _codeInvalidEmail = 'InvalidEmail';
  static const _codeEmailTaken = 'EmailAlreadyTaken';
  static const _codeWeakPassword = 'WeakPassword';
  static const _codeNameRequired = 'NameRequired';

  final RegisterUseCase _register;
  final _events = OneShotEvents<SignUpEvent>();
  late final StreamSubscription<bool> _connectivity;

  Stream<SignUpEvent> get events => _events.stream;

  void onGivenNamesChange(String value) =>
      emit(state.copyWith(givenNames: value, errors: state.errors.copyWith(givenNames: null)));

  void onFamilyNamesChange(String value) =>
      emit(state.copyWith(familyNames: value, errors: state.errors.copyWith(familyNames: null)));

  void onEmailChange(String value) => emit(state.copyWith(email: value, errors: state.errors.copyWith(email: null)));

  void onPasswordChange(String value) =>
      emit(state.copyWith(password: value, errors: state.errors.copyWith(weakPassword: false)));

  void onSignInClick() => _events.emit(const SignUpNavigateToSignIn());

  void onErrorDialogDismiss() => emit(state.copyWith(showErrorDialog: false));

  void onErrorDialogRetry() {
    emit(state.copyWith(showErrorDialog: false));
    onSubmit();
  }

  Future<void> onSubmit() async {
    final current = state;
    if (current.isSubmitting || current.isOffline) return;
    final validation = validateNewAccount(
      givenNames: current.givenNames,
      familyNames: current.familyNames,
      email: current.email,
      password: current.password,
      role: UserRole.practitioner,
    );
    switch (validation) {
      case InvalidSignUp(:final problems):
        emit(current.copyWith(errors: _fieldErrorsOf(problems)));
      case ValidSignUp(:final account):
        emit(current.copyWith(isSubmitting: true, errors: const SignUpFieldErrors()));
        final result = await _register(account);
        if (isClosed) return;
        emit(state.copyWith(isSubmitting: false));
        _onRegisterResult(result);
    }
  }

  void _onRegisterResult(RegisterResult result) {
    switch (result) {
      case SignedIn():
        _events.emit(const SignUpNavigateToShellLoading());
      // The account already exists; "Create account" again would return EmailAlreadyTaken. Go on to sign-in.
      case CreatedWithoutSession():
        _events.emit(const SignUpNavigateToSignIn());
      case RegisterFailed(:final error):
        _showError(error);
    }
  }

  void _showError(DomainError error) {
    final fieldErrors = _fieldErrorsOfError(error);
    emit(fieldErrors != null ? state.copyWith(errors: fieldErrors) : state.copyWith(showErrorDialog: true));
  }

  SignUpFieldErrors? _fieldErrorsOfError(DomainError error) {
    final code = switch (error) {
      Validation(:final code) => code,
      Conflict(:final code) => code,
      _ => null,
    };
    return switch (code) {
      _codeInvalidEmail => const SignUpFieldErrors(email: SignUpEmailError.invalid),
      _codeEmailTaken => const SignUpFieldErrors(email: SignUpEmailError.alreadyTaken),
      _codeWeakPassword => const SignUpFieldErrors(weakPassword: true),
      _codeNameRequired => SignUpFieldErrors(
        givenNames: PersonName.problemOf(state.givenNames) ?? PersonNameProblem.required,
        familyNames: PersonName.problemOf(state.familyNames),
      ),
      _ => null,
    };
  }

  SignUpFieldErrors _fieldErrorsOf(Set<SignUpProblem> problems) => SignUpFieldErrors(
    givenNames: problems.whereType<GivenNamesProblem>().firstOrNull?.problem,
    familyNames: problems.whereType<FamilyNamesProblem>().firstOrNull?.problem,
    email: problems.contains(const InvalidEmailProblem()) ? SignUpEmailError.invalid : null,
    weakPassword: problems.contains(const WeakPasswordProblem()),
  );

  void _emit(SignUpState value) {
    if (!isClosed) emit(value);
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

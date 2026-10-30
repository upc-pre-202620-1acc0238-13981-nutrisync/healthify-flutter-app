import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/connectivity/connectivity_observer.dart';
import 'package:healthify/features/iam/application/usecase/password_reset_use_cases.dart';
import 'package:healthify/features/iam/domain/entity/password_reset.dart';
import 'package:healthify/features/iam/domain/repository/authentication_repository.dart';
import 'package:healthify/features/iam/domain/valueobject/email_address.dart';
import 'package:healthify/features/iam/domain/valueobject/password.dart';
import 'package:healthify/features/iam/domain/valueobject/password_reset_code.dart';
import 'package:healthify/features/iam/domain/valueobject/password_reset_token.dart';
import 'package:healthify/features/iam/presentation/cubit/forgot_password_cubit.dart';
import 'package:healthify/features/iam/presentation/state/forgot_password_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AuthenticationRepository {}

class _Online implements ConnectivityObserver {
  @override
  Stream<bool> get isOnline => Stream.value(true);
}

void main() {
  late _MockRepository repository;
  late ForgotPasswordCubit cubit;

  setUpAll(() {
    registerFallbackValue(EmailAddress('a@b.co'));
    registerFallbackValue(PasswordResetCode.parse('123456')!);
    registerFallbackValue(
      PasswordReset(token: PasswordResetToken('t'), newPassword: Password('Secreta#2026')),
    );
  });

  setUp(() {
    repository = _MockRepository();
    cubit = ForgotPasswordCubit(
      RequestPasswordResetUseCase(repository),
      VerifyPasswordResetCodeUseCase(repository),
      ResetPasswordUseCase(repository),
      _Online(),
    );
    when(() => repository.requestPasswordReset(any())).thenAnswer((_) async => const Result.success(null));
  });

  tearDown(() => cubit.close());

  Future<void> reachCodeStep() async {
    cubit.onEmailChange('ana@correo.com');
    cubit.onSendCode();
    await Future<void>.delayed(Duration.zero);
  }

  Future<void> reachPasswordStep() async {
    when(() => repository.verifyPasswordResetCode(any(), any()))
        .thenAnswer((_) async => Result.success(PasswordResetToken('tok')));
    await reachCodeStep();
    cubit.onCodeChange('123456');
    await cubit.onVerifyCode();
  }

  test('an invalid email is flagged without calling the backend', () {
    cubit.onEmailChange('nope');
    cubit.onSendCode();

    expect(cubit.state.invalidEmail, isTrue);
    verifyNever(() => repository.requestPasswordReset(any()));
  });

  test('sending the code moves to the code step and starts the resend wait', () async {
    await reachCodeStep();

    expect(cubit.state.step, ForgotPasswordStep.code);
    expect(cubit.state.resendInSeconds, ForgotPasswordCubit.resendCooldownSeconds);
  });

  test('the code input keeps up to six digits', () {
    cubit.onCodeChange('12 34a56789');

    expect(cubit.state.code, '123456');
  });

  test('a code that is not six digits does not use an attempt', () async {
    await reachCodeStep();
    cubit.onCodeChange('123');

    await cubit.onVerifyCode();

    expect(cubit.state.invalidCode, isTrue);
    verifyNever(() => repository.verifyPasswordResetCode(any(), any()));
  });

  test('PasswordResetCodeInvalid marks the code', () async {
    when(() => repository.verifyPasswordResetCode(any(), any()))
        .thenAnswer((_) async => const Result.failure(Validation('PasswordResetCodeInvalid')));
    await reachCodeStep();
    cubit.onCodeChange('123456');

    await cubit.onVerifyCode();

    expect(cubit.state.invalidCode, isTrue);
    expect(cubit.state.step, ForgotPasswordStep.code);
  });

  test('a correct code moves to the new password step', () async {
    await reachPasswordStep();

    expect(cubit.state.step, ForgotPasswordStep.newPassword);
  });

  test('a weak password is flagged locally', () async {
    await reachPasswordStep();
    cubit.onNewPasswordChange('weak');

    await cubit.onSubmitNewPassword();

    expect(cubit.state.weakPassword, isTrue);
    verifyNever(() => repository.resetPassword(any()));
  });

  test('PasswordReuseNotAllowed marks the password as reused', () async {
    await reachPasswordStep();
    when(() => repository.resetPassword(any()))
        .thenAnswer((_) async => const Result.failure(Validation('PasswordReuseNotAllowed')));
    cubit.onNewPasswordChange('Secreta#2026');

    await cubit.onSubmitNewPassword();

    expect(cubit.state.passwordReused, isTrue);
  });

  test('an expired token goes back to the code step', () async {
    await reachPasswordStep();
    when(() => repository.resetPassword(any()))
        .thenAnswer((_) async => const Result.failure(Validation('PasswordResetTokenInvalid')));
    cubit.onNewPasswordChange('Secreta#2026');

    await cubit.onSubmitNewPassword();

    expect(cubit.state.step, ForgotPasswordStep.code);
    expect(cubit.state.tokenExpired, isTrue);
  });

  test('changing the password finishes the flow', () async {
    await reachPasswordStep();
    when(() => repository.resetPassword(any())).thenAnswer((_) async => const Result.success(null));
    cubit.onNewPasswordChange('Secreta#2026');

    await cubit.onSubmitNewPassword();

    expect(cubit.state.step, ForgotPasswordStep.done);
  });

  test('back walks the steps backwards and ends in sign-in', () async {
    await reachPasswordStep();
    final events = <ForgotPasswordEvent>[];
    cubit.events.listen(events.add);

    cubit.onBack();
    expect(cubit.state.step, ForgotPasswordStep.code);
    cubit.onBack();
    expect(cubit.state.step, ForgotPasswordStep.email);
    cubit.onBack();
    await Future<void>.delayed(Duration.zero);

    expect(events.single, isA<ForgotPasswordNavigateToSignIn>());
  });

  test('a server error opens the dialog and retry repeats the call', () async {
    when(() => repository.requestPasswordReset(any())).thenAnswer((_) async => const Result.failure(Network()));
    cubit.onEmailChange('ana@correo.com');
    cubit.onSendCode();
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.showErrorDialog, isTrue);

    cubit.onErrorDialogRetry();
    await Future<void>.delayed(Duration.zero);

    verify(() => repository.requestPasswordReset(any())).called(2);
  });

  test('resending is blocked during the wait', () async {
    await reachCodeStep();

    cubit.onResendCode();

    verify(() => repository.requestPasswordReset(any())).called(1);
  });
}


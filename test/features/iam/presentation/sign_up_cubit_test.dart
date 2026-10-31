import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/connectivity/connectivity_observer.dart';
import 'package:healthify/features/iam/application/usecase/register_use_case.dart';
import 'package:healthify/features/iam/domain/entity/new_account.dart';
import 'package:healthify/features/iam/domain/entity/session_user.dart';
import 'package:healthify/features/iam/domain/valueobject/email_address.dart';
import 'package:healthify/features/iam/domain/valueobject/password.dart';
import 'package:healthify/features/iam/domain/valueobject/person_name.dart';
import 'package:healthify/features/iam/domain/valueobject/preferred_language.dart';
import 'package:healthify/features/iam/domain/valueobject/session_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_role.dart';
import 'package:healthify/features/iam/presentation/cubit/sign_up_cubit.dart';
import 'package:healthify/features/iam/presentation/state/sign_up_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockRegister extends Mock implements RegisterUseCase {}

class _FakeConnectivity implements ConnectivityObserver {
  _FakeConnectivity([this.online = true]);

  final bool online;

  @override
  Stream<bool> get isOnline => Stream.value(online);
}

final _user = SessionUser(
  id: UserId(1),
  email: EmailAddress('ana@correo.com'),
  name: PersonName('Ana', 'Lopez'),
  role: UserRole.practitioner,
  preferredLanguage: PreferredLanguage.spanish,
  sessionId: SessionId(9),
);

void main() {
  late _MockRegister register;

  setUpAll(() => registerFallbackValue(
      NewAccount(
        name: PersonName('Ana', 'Lopez'),
        email: EmailAddress('ana@correo.com'),
        password: Password('Secreta#2026'),
        role: UserRole.practitioner,
      ),
    ));
  setUp(() => register = _MockRegister());

  SignUpCubit validForm({bool online = true, bool acceptTerms = true}) =>
      SignUpCubit(register, _FakeConnectivity(online))
        ..onGivenNamesChange('Ana María')
        ..onFamilyNamesChange('Lopez')
        ..onEmailChange('ana@correo.com')
        ..onPasswordChange('Secreta#2026')
        ..onTermsAcceptedChange(acceptTerms);

  test('an empty form marks every field without calling the backend', () async {
    final cubit = SignUpCubit(register, _FakeConnectivity());

    await cubit.onSubmit();

    final errors = cubit.state.errors;
    expect(errors.givenNames, PersonNameProblem.required);
    expect(errors.familyNames, PersonNameProblem.required);
    expect(errors.email, SignUpEmailError.invalid);
    expect(errors.weakPassword, isTrue);
    expect(errors.termsNotAccepted, isTrue);
    verifyNever(() => register(any()));
    await cubit.close();
  });

  test('starts with the terms unchecked', () async {
    final cubit = SignUpCubit(register, _FakeConnectivity());

    expect(cubit.state.acceptedTerms, isFalse);
    await cubit.close();
  });

  test('a valid form without the terms accepted shows only the terms error and does not call the backend', () async {
    final cubit = validForm(acceptTerms: false);

    await cubit.onSubmit();

    expect(cubit.state.errors, const SignUpFieldErrors(termsNotAccepted: true));
    verifyNever(() => register(any()));
    await cubit.close();
  });

  test('checking the terms clears their error and lets the account be created', () async {
    when(() => register(any())).thenAnswer((_) async => SignedIn(_user));
    final cubit = validForm(acceptTerms: false);
    await cubit.onSubmit();

    cubit.onTermsAcceptedChange(true);
    expect(cubit.state.errors.termsNotAccepted, isFalse);

    await cubit.onSubmit();

    verify(() => register(any())).called(1);
    await cubit.close();
  });

  test('digits in a name are invalid characters', () async {
    final cubit = validForm()..onGivenNamesChange('Ana2');

    await cubit.onSubmit();

    expect(cubit.state.errors.givenNames, PersonNameProblem.invalidCharacters);
    await cubit.close();
  });

  test('editing a field clears only its error', () async {
    final cubit = SignUpCubit(register, _FakeConnectivity());
    await cubit.onSubmit();

    cubit.onEmailChange('ana@correo.com');

    expect(cubit.state.errors.email, isNull);
    expect(cubit.state.errors.weakPassword, isTrue);
    await cubit.close();
  });

  test('offline does not try to create the account', () async {
    final cubit = validForm(online: false);
    await Future<void>.delayed(Duration.zero);

    await cubit.onSubmit();

    verifyNever(() => register(any()));
    await cubit.close();
  });

  test('a signed-in account navigates to shell loading', () async {
    when(() => register(any())).thenAnswer((_) async => SignedIn(_user));
    final cubit = validForm();
    final events = <SignUpEvent>[];
    cubit.events.listen(events.add);

    await cubit.onSubmit();
    await Future<void>.delayed(Duration.zero);

    expect(events.single, isA<SignUpNavigateToShellLoading>());
    expect(cubit.state.isSubmitting, isFalse);
    await cubit.close();
  });

  test('an account created without session goes on to sign-in', () async {
    when(() => register(any())).thenAnswer((_) async => const CreatedWithoutSession(Network()));
    final cubit = validForm();
    final events = <SignUpEvent>[];
    cubit.events.listen(events.add);

    await cubit.onSubmit();
    await Future<void>.delayed(Duration.zero);

    expect(events.single, isA<SignUpNavigateToSignIn>());
    await cubit.close();
  });

  test('EmailAlreadyTaken marks the email field', () async {
    when(() => register(any())).thenAnswer((_) async => const RegisterFailed(Conflict('EmailAlreadyTaken')));
    final cubit = validForm();

    await cubit.onSubmit();

    expect(cubit.state.errors.email, SignUpEmailError.alreadyTaken);
    expect(cubit.state.showErrorDialog, isFalse);
    await cubit.close();
  });

  test('WeakPassword from the backend marks the password', () async {
    when(() => register(any())).thenAnswer((_) async => const RegisterFailed(Validation('WeakPassword')));
    final cubit = validForm();

    await cubit.onSubmit();

    expect(cubit.state.errors.weakPassword, isTrue);
    await cubit.close();
  });

  test('an unknown backend error opens the error dialog', () async {
    when(() => register(any())).thenAnswer((_) async => const RegisterFailed(Unexpected('HTTP_500')));
    final cubit = validForm();

    await cubit.onSubmit();

    expect(cubit.state.showErrorDialog, isTrue);
    await cubit.close();
  });

  test('registers the normalized account as a practitioner without asking for the role', () async {
    when(() => register(any())).thenAnswer((_) async => const RegisterFailed(Unexpected()));
    final cubit = validForm()..onGivenNamesChange('  Ana   María ');

    await cubit.onSubmit();

    final account = verify(() => register(captureAny())).captured.single as NewAccount;
    expect(account.name.givenNames, 'Ana María');
    expect(account.role, UserRole.practitioner);
    await cubit.close();
  });
}

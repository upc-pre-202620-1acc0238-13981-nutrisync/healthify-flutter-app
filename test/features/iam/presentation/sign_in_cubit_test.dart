import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/connectivity/connectivity_observer.dart';
import 'package:healthify/features/iam/application/usecase/sign_in_use_case.dart';
import 'package:healthify/features/iam/domain/entity/credentials.dart';
import 'package:healthify/features/iam/domain/entity/session_user.dart';
import 'package:healthify/features/iam/domain/valueobject/email_address.dart';
import 'package:healthify/features/iam/domain/valueobject/person_name.dart';
import 'package:healthify/features/iam/domain/valueobject/preferred_language.dart';
import 'package:healthify/features/iam/domain/valueobject/session_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_role.dart';
import 'package:healthify/features/iam/presentation/cubit/sign_in_cubit.dart';
import 'package:healthify/features/iam/presentation/state/sign_in_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignIn extends Mock implements SignInUseCase {}

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
  late _MockSignIn signIn;

  setUpAll(() => registerFallbackValue(Credentials.parse('a@b.co', 'x')!));
  setUp(() => signIn = _MockSignIn());

  SignInCubit build({bool online = true}) => SignInCubit(signIn, _FakeConnectivity(online));

  SignInCubit filled(SignInCubit cubit) {
    cubit
      ..onEmailChange('ana@correo.com')
      ..onPasswordChange('secreto');
    return cubit;
  }

  test('a malformed email shows invalid credentials without calling the backend', () async {
    final cubit = build()
      ..onEmailChange('not-an-email')
      ..onPasswordChange('secreto');

    await cubit.onSubmit();

    expect(cubit.state.error, SignInError.invalidCredentials);
    verifyNever(() => signIn(any()));
    await cubit.close();
  });

  test('an empty password shows invalid credentials without calling the backend', () async {
    final cubit = build()..onEmailChange('ana@correo.com');

    await cubit.onSubmit();

    expect(cubit.state.error, SignInError.invalidCredentials);
    verifyNever(() => signIn(any()));
    await cubit.close();
  });

  test('offline does not try to sign in', () async {
    final cubit = filled(build(online: false));
    await Future<void>.delayed(Duration.zero);

    await cubit.onSubmit();

    expect(cubit.state.isOffline, isTrue);
    verifyNever(() => signIn(any()));
    await cubit.close();
  });

  test('a successful sign-in navigates to shell loading', () async {
    when(() => signIn(any())).thenAnswer((_) async => Result.success(_user));
    final cubit = filled(build());
    final events = <SignInEvent>[];
    cubit.events.listen(events.add);

    await cubit.onSubmit();
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.isSubmitting, isFalse);
    expect(cubit.state.error, isNull);
    expect(events.single, isA<NavigateToShellLoading>());
    await cubit.close();
  });

  test('InvalidCredentials marks the credentials error', () async {
    when(() => signIn(any())).thenAnswer((_) async => const Result.failure(Unauthorized('InvalidCredentials')));
    final cubit = filled(build());

    await cubit.onSubmit();

    expect(cubit.state.error, SignInError.invalidCredentials);
    expect(cubit.state.showErrorDialog, isFalse);
    await cubit.close();
  });

  test('a 401 without a code is treated as wrong credentials', () async {
    when(() => signIn(any())).thenAnswer((_) async => const Result.failure(Unauthorized()));
    final cubit = filled(build());

    await cubit.onSubmit();

    expect(cubit.state.error, SignInError.invalidCredentials);
    await cubit.close();
  });

  test('AccountLocked shows the lock notice, which survives editing', () async {
    when(() => signIn(any())).thenAnswer((_) async => const Result.failure(Unauthorized('AccountLocked')));
    final cubit = filled(build());

    await cubit.onSubmit();
    cubit.onPasswordChange('otra');

    expect(cubit.state.error, SignInError.accountLocked);
    await cubit.close();
  });

  test('editing clears the wrong credentials error', () async {
    when(() => signIn(any())).thenAnswer((_) async => const Result.failure(Unauthorized('InvalidCredentials')));
    final cubit = filled(build());

    await cubit.onSubmit();
    cubit.onEmailChange('ana@correo.com ');

    expect(cubit.state.error, isNull);
    await cubit.close();
  });

  blocTest<SignInCubit, SignInState>(
    'a network failure opens the error dialog and retry submits again',
    build: () {
      when(() => signIn(any())).thenAnswer((_) async => const Result.failure(Network()));
      return filled(build());
    },
    act: (cubit) async {
      await cubit.onSubmit();
      cubit.onErrorDialogRetry();
    },
    verify: (_) => verify(() => signIn(any())).called(2),
  );

  blocTest<SignInCubit, SignInState>(
    'a server error ends with the dialog open and no submission pending',
    build: () {
      when(() => signIn(any())).thenAnswer((_) async => const Result.failure(Unexpected('HTTP_500')));
      return filled(build());
    },
    act: (cubit) => cubit.onSubmit(),
    verify: (cubit) {
      expect(cubit.state.showErrorDialog, isTrue);
      expect(cubit.state.isSubmitting, isFalse);
    },
  );
}

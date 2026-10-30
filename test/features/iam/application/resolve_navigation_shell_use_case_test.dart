import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/iam/application/usecase/resolve_navigation_shell_use_case.dart';
import 'package:healthify/features/iam/domain/entity/session_user.dart';
import 'package:healthify/features/iam/domain/repository/authentication_repository.dart';
import 'package:healthify/features/iam/domain/valueobject/email_address.dart';
import 'package:healthify/features/iam/domain/valueobject/navigation_shell.dart';
import 'package:healthify/features/iam/domain/valueobject/person_name.dart';
import 'package:healthify/features/iam/domain/valueobject/preferred_language.dart';
import 'package:healthify/features/iam/domain/valueobject/session_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_role.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

SessionUser _user(UserRole role) => SessionUser(
  id: UserId(1),
  email: EmailAddress('ana@correo.com'),
  name: PersonName('Ana', 'Lopez'),
  role: role,
  preferredLanguage: PreferredLanguage.spanish,
  sessionId: SessionId(9),
);

void main() {
  late _MockAuthenticationRepository repository;
  late ResolveNavigationShellUseCase useCase;

  setUpAll(() => registerFallbackValue(SessionId(1)));
  setUp(() {
    repository = _MockAuthenticationRepository();
    useCase = ResolveNavigationShellUseCase(repository);
  });

  void backendReturns(Result<NavigationShell?> result) =>
      when(() => repository.getNavigationShell(any())).thenAnswer((_) async => result);

  test('uses the shell the backend returns', () async {
    backendReturns(const Result.success(NavigationShell.patient));

    final result = await useCase(_user(UserRole.practitioner));

    expect(result, const Result.success(NavigationShell.patient));
  });

  test('falls back to the role shell when the session has none', () async {
    backendReturns(const Result.success(null));

    final result = await useCase(_user(UserRole.practitioner));

    expect(result, const Result.success(NavigationShell.practitioner));
  });

  test('falls back to the role shell when offline', () async {
    backendReturns(const Result.failure(Network()));

    final result = await useCase(_user(UserRole.patient));

    expect(result, const Result.success(NavigationShell.patient));
  });

  test('falls back to the role shell when the session is not found', () async {
    backendReturns(const Result.failure(NotFound('SessionNotFound')));

    final result = await useCase(_user(UserRole.practitioner));

    expect(result, const Result.success(NavigationShell.practitioner));
  });

  test('keeps any other failure', () async {
    backendReturns(const Result.failure(Unexpected('HTTP_500')));

    final result = await useCase(_user(UserRole.practitioner));

    expect(result, const Result.failure(Unexpected('HTTP_500')));
  });

  test('requests the shell of the user session', () async {
    backendReturns(const Result.success(NavigationShell.practitioner));

    await useCase(_user(UserRole.practitioner));

    verify(() => repository.getNavigationShell(SessionId(9))).called(1);
  });
}

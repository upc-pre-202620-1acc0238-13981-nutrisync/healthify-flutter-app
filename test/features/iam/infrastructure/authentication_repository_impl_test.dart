import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/features/iam/domain/entity/credentials.dart';
import 'package:healthify/features/iam/domain/entity/new_account.dart';
import 'package:healthify/features/iam/domain/valueobject/email_address.dart';
import 'package:healthify/features/iam/domain/valueobject/navigation_shell.dart';
import 'package:healthify/features/iam/domain/valueobject/password.dart';
import 'package:healthify/features/iam/domain/valueobject/password_reset_code.dart';
import 'package:healthify/features/iam/domain/valueobject/person_name.dart';
import 'package:healthify/features/iam/domain/valueobject/session_id.dart';
import 'package:healthify/features/iam/domain/valueobject/user_role.dart';
import 'package:healthify/features/iam/infrastructure/local/session_local_data_source.dart';
import 'package:healthify/features/iam/infrastructure/remote/authentication_service.dart';
import 'package:healthify/features/iam/infrastructure/remote/session_service.dart';
import 'package:healthify/features/iam/infrastructure/repository/authentication_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/auth/fakes.dart';

const _signInJson = {
  'userId': 7,
  'email': 'Ana@Correo.com',
  'role': 'Practitioner',
  'sessionId': 42,
  'token': 'access-1',
  'givenNames': 'Ana',
  'familyNames': 'Lopez',
  'preferredLanguage': 'en',
  'refreshToken': 'refresh-1',
};

http.Response _json(int status, Object? body) =>
    http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json; charset=utf-8'});

void main() {
  late FakeSessionTokenStore tokenStore;
  late SessionLocalDataSource localDataSource;
  late List<http.Request> requests;

  Future<AuthenticationRepositoryImpl> repository(http.Response Function(http.Request request) handler) async {
    SharedPreferences.setMockInitialValues({});
    tokenStore = FakeSessionTokenStore();
    localDataSource = SessionLocalDataSource(await SharedPreferences.getInstance(), tokenStore);
    requests = [];
    final api = ApiClient(
      MockClient((request) async {
        requests.add(request);
        return handler(request);
      }),
      baseUrl: Uri.parse('https://test.local/api/v1/'),
    );
    return AuthenticationRepositoryImpl(AuthenticationService(api), SessionService(api), localDataSource);
  }

  final credentials = Credentials.parse('ana@correo.com', 'secreto')!;

  group('signIn', () {
    test('maps the response, stores the tokens and the user', () async {
      final repo = await repository((_) => _json(200, _signInJson));

      final result = await repo.signIn(credentials);

      final user = result.valueOrNull!;
      expect(user.email.value, 'ana@correo.com');
      expect(user.role, UserRole.practitioner);
      expect(user.sessionId, SessionId(42));
      expect(user.preferredLanguage.code, 'en');
      expect(tokenStore.currentAccessToken, 'access-1');
      expect(tokenStore.currentRefreshToken, 'refresh-1');
      expect(await localDataSource.user.first, user);
      expect(await localDataSource.isLoggedIn.first, isTrue);
      final request = requests.single;
      expect(request.url.toString(), 'https://test.local/api/v1/authentication/sign-in');
      expect(jsonDecode(request.body), {'email': 'ana@correo.com', 'password': 'secreto'});
    });

    test('an account without names uses the email local part', () async {
      final repo = await repository((_) => _json(200, {..._signInJson, 'givenNames': null, 'familyNames': null}));

      final user = (await repo.signIn(credentials)).valueOrNull!;

      expect(user.name.givenNames, 'ana');
      expect(user.name.familyNames, isEmpty);
    });

    test('InvalidCredentials arrives as Unauthorized with its code and stores nothing', () async {
      final repo = await repository((_) => _json(401, {'code': 'InvalidCredentials'}));

      final result = await repo.signIn(credentials);

      expect(result.errorOrNull, const Unauthorized('InvalidCredentials'));
      expect(tokenStore.currentAccessToken, isNull);
      expect(await localDataSource.user.first, isNull);
    });

    test('an unknown role is a malformed response and stores nothing', () async {
      final repo = await repository((_) => _json(200, {..._signInJson, 'role': 'Admin'}));

      final result = await repo.signIn(credentials);

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
      expect(tokenStore.currentAccessToken, isNull);
    });

    test('a body with the wrong shape is a malformed response', () async {
      final repo = await repository((_) => _json(200, {'userId': 'x'}));

      final result = await repo.signIn(credentials);

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('no connection is a Network error', () async {
      final repo = await repository((_) => throw http.ClientException('offline'));

      final result = await repo.signIn(credentials);

      expect(result.errorOrNull, const Network());
    });
  });

  group('signUp', () {
    final account = NewAccount(
      name: PersonName.forSignUp('Ana', 'Lopez'),
      email: EmailAddress('ana@correo.com'),
      password: Password('Secreta#2026'),
      role: UserRole.practitioner,
    );

    test('posts the account with the backend role code', () async {
      final repo = await repository(
        (_) => _json(201, {'userId': 7, 'email': 'ana@correo.com', 'role': 'Practitioner'}),
      );

      final result = await repo.signUp(account);

      expect(result.isSuccess, isTrue);
      expect(jsonDecode(requests.single.body), {
        'email': 'ana@correo.com',
        'password': 'Secreta#2026',
        'role': 'Practitioner',
        'givenNames': 'Ana',
        'familyNames': 'Lopez',
      });
    });

    test('EmailAlreadyTaken arrives as Conflict', () async {
      final repo = await repository((_) => _json(409, {'code': 'EmailAlreadyTaken'}));

      final result = await repo.signUp(account);

      expect(result.errorOrNull, const Conflict('EmailAlreadyTaken'));
    });
  });

  group('password reset', () {
    test('request succeeds on an empty 202', () async {
      final repo = await repository((_) => http.Response('', 202));

      final result = await repo.requestPasswordReset(EmailAddress('ana@correo.com'));

      expect(result.isSuccess, isTrue);
      expect(requests.single.url.path, '/api/v1/authentication/password-reset-requests');
    });

    test('a correct code returns the token', () async {
      final repo = await repository((_) => _json(200, {'resetToken': 'tok-1'}));

      final result = await repo.verifyPasswordResetCode(EmailAddress('ana@correo.com'), PasswordResetCode.parse('123456')!);

      expect(result.valueOrNull!.value, 'tok-1');
      expect(jsonDecode(requests.single.body), {'email': 'ana@correo.com', 'code': '123456'});
    });

    test('a wrong code arrives as a Validation error', () async {
      final repo = await repository((_) => _json(400, {'code': 'PasswordResetCodeInvalid'}));

      final result = await repo.verifyPasswordResetCode(EmailAddress('ana@correo.com'), PasswordResetCode.parse('123456')!);

      expect(result.errorOrNull, const Validation('PasswordResetCodeInvalid'));
    });

    test('an empty token is a malformed response', () async {
      final repo = await repository((_) => _json(200, {'resetToken': ' '}));

      final result = await repo.verifyPasswordResetCode(EmailAddress('ana@correo.com'), PasswordResetCode.parse('123456')!);

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });
  });

  group('getNavigationShell', () {
    Future<NavigationShell?> shellFor(Map<String, Object?> body) async {
      final repo = await repository((_) => _json(200, body));
      return (await repo.getNavigationShell(SessionId(42))).valueOrNull;
    }

    test('maps the practitioner shell', () async {
      expect(await shellFor({'sessionId': 42, 'navigationShell': 'PractitionerShell', 'isActive': true}), NavigationShell.practitioner);
    });

    test('an inactive session has no shell', () async {
      expect(await shellFor({'sessionId': 42, 'navigationShell': 'PractitionerShell', 'isActive': false}), isNull);
    });

    test('an unknown shell reads as no shell', () async {
      expect(await shellFor({'sessionId': 42, 'navigationShell': 'Other', 'isActive': true}), isNull);
    });
  });

  test('signOutRemotely posts to sign-out', () async {
    final repo = await repository((_) => http.Response('', 204));

    final result = await repo.signOutRemotely();

    expect(result.isSuccess, isTrue);
    expect(requests.single.url.path, '/api/v1/authentication/sign-out');
  });
}

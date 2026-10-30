import 'package:flutter/services.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/error/result.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entity/credentials.dart';
import '../../domain/entity/new_account.dart';
import '../../domain/entity/password_reset.dart';
import '../../domain/entity/session_user.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/valueobject/email_address.dart';
import '../../domain/valueobject/navigation_shell.dart';
import '../../domain/valueobject/password_reset_code.dart';
import '../../domain/valueobject/password_reset_token.dart';
import '../../domain/valueobject/session_id.dart';
import '../local/session_local_data_source.dart';
import '../mapper/authentication_mappers.dart';
import '../mapper/session_mappers.dart';
import '../remote/authentication_service.dart';
import '../remote/dto/authentication_dtos.dart';
import '../remote/session_service.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl(this._authenticationService, this._sessionService, this._localDataSource);

  final AuthenticationService _authenticationService;
  final SessionService _sessionService;
  final SessionLocalDataSource _localDataSource;

  @override
  Future<Result<void>> signUp(NewAccount account) =>
      apiCall<void>(() async {
        await _authenticationService.signUp(account.toDto());
      });

  @override
  Future<Result<SessionUser>> signIn(Credentials credentials) async {
    // An invalid user (e.g. an unknown role) fails inside `apiCall` as MALFORMED_RESPONSE, and nothing is stored.
    final result = await apiCall(() async {
      final response = await _authenticationService.signIn(credentials.toDto());
      return (user: response.toDomain(), response: response);
    });
    final signedIn = result.valueOrNull;
    if (signedIn == null) return Result.failure(result.errorOrNull!);
    try {
      await _localDataSource.save(
        signedIn.user,
        accessToken: signedIn.response.token,
        refreshToken: signedIn.response.refreshToken,
      );
    } on PlatformException {
      return const Result.failure(Unexpected('SESSION_STORAGE_FAILED'));
    }
    return Result.success(signedIn.user);
  }

  @override
  Future<Result<void>> requestPasswordReset(EmailAddress email) => apiCall<void>(() async {
    await _authenticationService.requestPasswordReset(PasswordResetRequestDto(email: email.value));
  });

  @override
  Future<Result<PasswordResetToken>> verifyPasswordResetCode(EmailAddress email, PasswordResetCode code) =>
      apiCall(() async {
        final response = await _authenticationService.verifyPasswordResetCode(
          PasswordResetVerificationRequestDto(email: email.value, code: code.value),
        );
        return response.toDomain();
      });

  @override
  Future<Result<void>> resetPassword(PasswordReset reset) => apiCall<void>(() async {
    await _authenticationService.resetPassword(reset.toDto());
  });

  @override
  Future<Result<void>> signOutRemotely() => apiCall<void>(() async {
    await _sessionService.signOut();
  });

  @override
  Future<Result<NavigationShell?>> getNavigationShell(SessionId sessionId) =>
      apiCall(() async => (await _sessionService.getNavigationShell(sessionId.value)).toDomain());
}

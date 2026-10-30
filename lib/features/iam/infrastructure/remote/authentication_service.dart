import '../../../../core/network/api_client.dart';
import 'dto/authentication_dtos.dart';

/// Anonymous Iam endpoints. Built with the anonymous [ApiClient]: no bearer and no refresh. Each call throws
/// `ApiException` on non-2xx; the repository wraps it with `apiCall`.
class AuthenticationService {
  const AuthenticationService(this._api);

  final ApiClient _api;

  Future<UserDto> signUp(SignUpRequestDto body) async =>
      UserDto.fromJson(await _api.post('authentication/sign-up', body: body.toJson()) as Map<String, dynamic>);

  Future<SignInResponseDto> signIn(SignInRequestDto body) async => SignInResponseDto.fromJson(
    await _api.post('authentication/sign-in', body: body.toJson()) as Map<String, dynamic>,
  );

  /// `202` with no body, whether or not the account exists.
  Future<void> requestPasswordReset(PasswordResetRequestDto body) =>
      _api.post('authentication/password-reset-requests', body: body.toJson());

  /// `200` with the token; `400` with `PasswordResetCodeInvalid`.
  Future<PasswordResetVerificationResponseDto> verifyPasswordResetCode(
    PasswordResetVerificationRequestDto body,
  ) async => PasswordResetVerificationResponseDto.fromJson(
    await _api.post('authentication/password-reset-verifications', body: body.toJson()) as Map<String, dynamic>,
  );

  /// `204` with no body; `400` with `PasswordResetTokenInvalid`, `WeakPassword` or `PasswordReuseNotAllowed`.
  Future<void> resetPassword(PasswordResetDto body) =>
      _api.post('authentication/password-resets', body: body.toJson());

  /// Throws `ApiException` on 401/400 so the caller can tell a rejected token from a transient failure.
  Future<TokenRefreshResponseDto> refreshTokens(TokenRefreshRequestDto body) async =>
      TokenRefreshResponseDto.fromJson(
        await _api.post('authentication/token-refreshes', body: body.toJson()) as Map<String, dynamic>,
      );
}

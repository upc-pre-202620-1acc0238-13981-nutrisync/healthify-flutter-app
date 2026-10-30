/// Session tokens (access + refresh). Implemented by `SecureSessionTokenStore`.
/// The `iam` context uses it from its infrastructure to save/clear the session; `AuthenticatedClient` reads it and
/// `TokenRefreshCoordinator` rotates it.
abstract interface class SessionTokenStore {
  /// `true` while a refresh token is stored (the session can be used or renewed). Emits the current value on
  /// subscription and then every change.
  Stream<bool> get hasSession;

  Future<String?> accessToken();
  Future<String?> refreshToken();
  Future<void> save({required String accessToken, required String refreshToken});
  Future<void> clear();
}

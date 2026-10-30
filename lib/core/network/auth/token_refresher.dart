/// Port to redeem the refresh token (`POST /authentication/token-refreshes`). Implemented by the `iam` context in
/// its infrastructure, with the anonymous client (no `AuthenticatedClient`, so no recursion).
abstract interface class TokenRefresher {
  Future<TokenRefreshResult> refresh(String refreshToken);
}

sealed class TokenRefreshResult {
  const TokenRefreshResult();
}

/// `200`: the new pair. The refresh token rotates on every use.
final class Refreshed extends TokenRefreshResult {
  const Refreshed({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
}

/// `401` (`RefreshTokenInvalid`): expired, revoked by sign-out or reused. The session is over.
final class Rejected extends TokenRefreshResult {
  const Rejected();
}

/// No network, timeout or `5xx`: whether the session is still alive is unknown, so it is not closed.
final class Unavailable extends TokenRefreshResult {
  const Unavailable();
}

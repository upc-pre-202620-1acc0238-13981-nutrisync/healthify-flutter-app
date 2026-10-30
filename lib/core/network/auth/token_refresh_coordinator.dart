import 'package:http/http.dart' as http;

import '../../common/lock.dart';
import 'session_expiry_notifier.dart';
import 'session_token_store.dart';
import 'token_refresher.dart';

/// Renews the token pair **only once** even if several requests get a 401 at the same time.
///
/// They all go through a [Lock]. The first one redeems the refresh token; the others, once inside, see that the
/// stored access token is no longer the one that failed for them and reuse the new one without another call. (The
/// backend gives a 30 s grace period to retry the same refresh, but outside it reuse ends the session: no risk taken.)
class TokenRefreshCoordinator {
  TokenRefreshCoordinator(this._tokenStore, this._tokenRefresher, this._sessionExpiryNotifier);

  final SessionTokenStore _tokenStore;
  final TokenRefresher _tokenRefresher;
  final SessionExpiryNotifier _sessionExpiryNotifier;
  final _lock = Lock();

  /// Returns the access token to retry the request that failed with [failedAccessToken], or `null` if
  /// there is no session to renew (signed out or expired).
  ///
  /// Throws [TokenRefreshUnavailableException] if the backend could not be reached: the original request fails as
  /// a network error and the session is kept (being offline loses neither the session nor the pending queue).
  Future<String?> refreshAfter(String failedAccessToken) => _lock.synchronized(() async {
    final current = await _tokenStore.accessToken();
    if (current != null && current != failedAccessToken) return current;

    final refreshToken = await _tokenStore.refreshToken();
    if (refreshToken == null) return null;
    switch (await _tokenRefresher.refresh(refreshToken)) {
      case Refreshed(:final accessToken, refreshToken: final newRefreshToken):
        await _tokenStore.save(accessToken: accessToken, refreshToken: newRefreshToken);
        return accessToken;
      case Rejected():
        await _tokenStore.clear();
        _sessionExpiryNotifier.notifyExpired();
        return null;
      case Unavailable():
        throw TokenRefreshUnavailableException();
    }
  });
}

/// A [http.ClientException] so `apiCall` reads it as `Network`.
class TokenRefreshUnavailableException extends http.ClientException {
  TokenRefreshUnavailableException() : super('Token refresh unavailable');
}

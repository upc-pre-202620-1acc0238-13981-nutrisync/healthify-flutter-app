import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'session_token_store.dart';
import 'token_refresh_coordinator.dart';

/// Adds `Authorization: Bearer <access token>` when there is a session, except on the anonymous endpoints.
///
/// When the backend answers 401 to a request that carried a bearer, it renews the token pair with
/// [TokenRefreshCoordinator] and retries **once** with the new access token. If the renewal is rejected the
/// original 401 is returned (-> `Unauthorized`) and the coordinator has already emitted the session expiry event.
class AuthenticatedClient extends http.BaseClient {
  AuthenticatedClient(this._inner, this._tokenStore, this._coordinator);

  final http.Client _inner;
  final SessionTokenStore _tokenStore;
  final TokenRefreshCoordinator _coordinator;

  static const _authorization = 'Authorization';
  static const _bearerPrefix = 'Bearer ';

  // The bearer is never sent to the anonymous endpoints, so a 401 from sign-in
  // (InvalidCredentials/AccountLocked) or from token-refreshes never triggers a renewal.
  static const _anonymousPathSuffixes = [
    'authentication/sign-in',
    'authentication/sign-up',
    'authentication/token-refreshes',
  ];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // A request cannot be sent twice: keep its body to rebuild it for the retry.
    final body = await request.finalize().toBytes();
    if (_isAnonymousEndpoint(request.url)) return _inner.send(_rebuild(request, body, null));

    final stored = await _tokenStore.accessToken();
    final token = stored == null || stored.trim().isEmpty ? null : stored;
    final response = await _inner.send(_rebuild(request, body, token));
    // Without a bearer (no session) a 401 does not mean an expired token.
    if (response.statusCode != 401 || token == null) return response;

    final String? newToken;
    try {
      newToken = await _coordinator.refreshAfter(token);
    } catch (_) {
      await response.stream.drain<void>();
      rethrow;
    }
    if (newToken == null) return response;

    await response.stream.drain<void>();
    return _inner.send(_rebuild(request, body, newToken));
  }

  @override
  void close() => _inner.close();

  bool _isAnonymousEndpoint(Uri url) {
    var path = url.path;
    while (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return _anonymousPathSuffixes.any(path.endsWith);
  }

  http.Request _rebuild(http.BaseRequest original, Uint8List body, String? token) {
    final copy = http.Request(original.method, original.url)
      ..followRedirects = original.followRedirects
      ..maxRedirects = original.maxRedirects
      ..persistentConnection = original.persistentConnection
      ..headers.addAll(original.headers)
      ..bodyBytes = body;
    if (token != null) copy.headers[_authorization] = '$_bearerPrefix$token';
    return copy;
  }
}

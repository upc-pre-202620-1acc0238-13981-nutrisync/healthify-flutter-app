import 'dart:async';

import 'package:healthify/core/network/auth/session_token_store.dart';
import 'package:healthify/core/network/auth/token_refresher.dart';

/// In-memory [SessionTokenStore].
class FakeSessionTokenStore implements SessionTokenStore {
  FakeSessionTokenStore({String? accessToken, String? refreshToken})
    : currentAccessToken = accessToken,
      currentRefreshToken = refreshToken;

  String? currentAccessToken;
  String? currentRefreshToken;
  int saveCount = 0;

  @override
  Stream<bool> get hasSession => Stream.value(currentRefreshToken != null);

  @override
  Future<String?> accessToken() async => currentAccessToken;

  @override
  Future<String?> refreshToken() async => currentRefreshToken;

  @override
  Future<void> save({required String accessToken, required String refreshToken}) async {
    saveCount++;
    currentAccessToken = accessToken;
    currentRefreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {
    currentAccessToken = null;
    currentRefreshToken = null;
  }
}

/// [TokenRefresher] that answers after a short delay (so concurrent callers really overlap) and counts its calls.
class FakeTokenRefresher implements TokenRefresher {
  FakeTokenRefresher([this.result = const Refreshed(accessToken: 'access-2', refreshToken: 'refresh-2')]);

  TokenRefreshResult result;
  final refreshTokensReceived = <String>[];

  int get callCount => refreshTokensReceived.length;

  @override
  Future<TokenRefreshResult> refresh(String refreshToken) async {
    refreshTokensReceived.add(refreshToken);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return result;
  }
}

import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/auth/token_refresher.dart';
import 'authentication_service.dart';
import 'dto/authentication_dtos.dart';

/// Refresh token exchange for `TokenRefreshCoordinator`. Needs the anonymous service: no bearer, so a 401 here never
/// starts another refresh.
class HttpTokenRefresher implements TokenRefresher {
  const HttpTokenRefresher(this._service);

  final AuthenticationService _service;

  @override
  Future<TokenRefreshResult> refresh(String refreshToken) async {
    try {
      final response = await _service.refreshTokens(TokenRefreshRequestDto(refreshToken: refreshToken));
      return Refreshed(accessToken: response.token, refreshToken: response.refreshToken);
    } on ApiException catch (e) {
      // 401 RefreshTokenInvalid (expired, revoked or reused) or 400 (empty token): there is no session to save.
      return e.statusCode == 401 || e.statusCode == 400 ? const Rejected() : const Unavailable();
    } on http.ClientException {
      return const Unavailable();
    } on SocketException {
      return const Unavailable();
    } on TimeoutException {
      return const Unavailable();
    } on FormatException {
      return const Unavailable();
    } on CheckedFromJsonException {
      return const Unavailable();
    } on TypeError {
      return const Unavailable();
    }
  }
}

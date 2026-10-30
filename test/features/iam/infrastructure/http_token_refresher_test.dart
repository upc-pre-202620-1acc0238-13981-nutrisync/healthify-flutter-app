import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/core/network/auth/token_refresher.dart';
import 'package:healthify/features/iam/infrastructure/remote/authentication_service.dart';
import 'package:healthify/features/iam/infrastructure/remote/http_token_refresher.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  HttpTokenRefresher refresher(http.Response Function(http.Request) handler) => HttpTokenRefresher(
    AuthenticationService(
      ApiClient(MockClient((request) async => handler(request)), baseUrl: Uri.parse('https://test.local/api/v1/')),
    ),
  );

  test('a 200 gives the new pair', () async {
    final result = await refresher((request) {
      expect(jsonDecode(request.body), {'refreshToken': 'old'});
      return http.Response(jsonEncode({'token': 'a2', 'refreshToken': 'r2'}), 200);
    }).refresh('old');

    expect(result, isA<Refreshed>().having((r) => r.accessToken, 'accessToken', 'a2'));
  });

  test('401 and 400 are rejected', () async {
    expect(await refresher((_) => http.Response('{"code":"RefreshTokenInvalid"}', 401)).refresh('x'), isA<Rejected>());
    expect(await refresher((_) => http.Response('', 400)).refresh('x'), isA<Rejected>());
  });

  test('5xx, no network and malformed bodies are unavailable', () async {
    expect(await refresher((_) => http.Response('', 503)).refresh('x'), isA<Unavailable>());
    expect(await refresher((_) => throw http.ClientException('offline')).refresh('x'), isA<Unavailable>());
    expect(await refresher((_) => http.Response('{"token":1}', 200)).refresh('x'), isA<Unavailable>());
  });
}

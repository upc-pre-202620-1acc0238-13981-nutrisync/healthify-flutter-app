import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/network/accept_language_client.dart';
import 'package:healthify/core/network/app_language_provider.dart';
import 'package:healthify/core/network/auth/authenticated_client.dart';
import 'package:healthify/core/network/auth/session_expiry_notifier.dart';
import 'package:healthify/core/network/auth/token_refresh_coordinator.dart';
import 'package:healthify/core/network/auth/token_refresher.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'fakes.dart';

/// Real client stack (Accept-Language + AuthenticatedClient + coordinator) against a `MockClient` backend.
void main() {
  late FakeSessionTokenStore store;
  late FakeTokenRefresher refresher;
  late SessionExpiryNotifier notifier;
  late http.Client client;
  late List<http.Request> protectedRequests;
  late List<http.Request> anonymousRequests;

  /// Holds the stale-token 401s until N requests arrive, to force real concurrency.
  Completer<void>? gate;
  var staleArrivals = 0;
  var gateSize = 0;

  http.Response problem(int status, String code) =>
      http.Response('{"status":$status,"code":"$code"}', status, headers: {'content-type': 'application/problem+json'});

  setUp(() {
    store = FakeSessionTokenStore(accessToken: 'access-1', refreshToken: 'refresh-1');
    refresher = FakeTokenRefresher();
    notifier = SessionExpiryNotifier();
    protectedRequests = [];
    anonymousRequests = [];
    gate = null;
    staleArrivals = 0;

    final backend = MockClient((request) async {
      if (request.url.path.endsWith('authentication/sign-in')) {
        anonymousRequests.add(request);
        return problem(401, 'InvalidCredentials');
      }
      protectedRequests.add(request);
      if (request.headers['Authorization'] == 'Bearer access-2') {
        return http.Response('{"ok":true}', 200);
      }
      if (gate case final gate?) {
        if (++staleArrivals == gateSize) gate.complete();
        await gate.future;
      }
      return problem(401, 'AuthenticationRequired');
    });
    final coordinator = TokenRefreshCoordinator(store, refresher, notifier);
    client = AuthenticatedClient(AcceptLanguageClient(backend, _FixedLanguage('en')), store, coordinator);
  });

  final url = Uri.parse('https://host/api/v1/patients/7/active-targets');

  test('adds bearer and accept-language to protected requests', () async {
    store.currentAccessToken = 'access-2';

    final response = await client.get(url);

    expect(response.statusCode, 200);
    expect(protectedRequests.single.headers['Authorization'], 'Bearer access-2');
    expect(protectedRequests.single.headers['Accept-Language'], 'en');
  });

  test('anonymous endpoints never carry the bearer nor trigger a refresh', () async {
    final response = await client.post(Uri.parse('https://host/api/v1/authentication/sign-in'), body: '{}');

    expect(response.statusCode, 401);
    expect(anonymousRequests.single.headers.containsKey('Authorization'), isFalse);
    expect(refresher.callCount, 0);
    expect(store.currentAccessToken, 'access-1');
  });

  test('401 refreshes the pair, stores it and retries once with the new token', () async {
    final response = await client.get(url);

    expect(response.statusCode, 200);
    expect(refresher.refreshTokensReceived, ['refresh-1']);
    expect(protectedRequests.map((r) => r.headers['Authorization']), ['Bearer access-1', 'Bearer access-2']);
    expect(store.currentAccessToken, 'access-2');
    expect(store.currentRefreshToken, 'refresh-2');
  });

  test('the retry resends the same method, headers and body', () async {
    final response = await client.put(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'a': 1}));

    expect(response.statusCode, 200);
    expect(protectedRequests, hasLength(2));
    for (final request in protectedRequests) {
      expect(request.method, 'PUT');
      expect(request.headers['Content-Type'], startsWith('application/json'));
      expect(request.body, '{"a":1}');
    }
  });

  test('simultaneous 401s refresh only once and all requests succeed', () async {
    const parallel = 5;
    gate = Completer<void>();
    gateSize = parallel;

    final responses = await Future.wait(
      List.generate(parallel, (i) => client.get(Uri.parse('https://host/api/v1/patients/$i/active-targets'))),
    );

    expect(responses.map((r) => r.statusCode), List.filled(parallel, 200));
    expect(refresher.callCount, 1);
    expect(store.saveCount, 1);
    expect(protectedRequests.where((r) => r.headers['Authorization'] == 'Bearer access-1'), hasLength(parallel));
    expect(protectedRequests.where((r) => r.headers['Authorization'] == 'Bearer access-2'), hasLength(parallel));
  });

  test('rejected refresh expires the session and does not retry', () async {
    refresher.result = const Rejected();

    final response = await client.get(url);

    expect(response.statusCode, 401);
    expect(refresher.callCount, 1);
    expect(protectedRequests, hasLength(1));
    expect(store.currentAccessToken, isNull);
    expect(store.currentRefreshToken, isNull);
    await expectLater(notifier.events.first, completes);
  });

  test('unreachable refresh fails as a client exception and keeps the session', () async {
    refresher.result = const Unavailable();

    await expectLater(client.get(url), throwsA(isA<TokenRefreshUnavailableException>()));

    expect(store.currentAccessToken, 'access-1');
    expect(store.currentRefreshToken, 'refresh-1');
  });

  test('a 401 after the retry does not loop', () async {
    refresher.result = const Refreshed(accessToken: 'still-bad', refreshToken: 'refresh-3');

    final response = await client.get(url);

    expect(response.statusCode, 401);
    expect(refresher.callCount, 1);
    expect(protectedRequests.map((r) => r.headers['Authorization']), ['Bearer access-1', 'Bearer still-bad']);
  });

  test('without session a 401 is returned as is', () async {
    await store.clear();

    final response = await client.get(url);

    expect(response.statusCode, 401);
    expect(refresher.callCount, 0);
    expect(protectedRequests.single.headers.containsKey('Authorization'), isFalse);
  });
}

class _FixedLanguage implements AppLanguageProvider {
  _FixedLanguage(this._language);

  final String _language;

  @override
  String currentLanguage() => _language;
}

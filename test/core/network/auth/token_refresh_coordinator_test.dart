import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/network/auth/session_expiry_notifier.dart';
import 'package:healthify/core/network/auth/token_refresh_coordinator.dart';
import 'package:healthify/core/network/auth/token_refresher.dart';

import 'fakes.dart';

void main() {
  late FakeSessionTokenStore store;
  late FakeTokenRefresher refresher;
  late SessionExpiryNotifier notifier;
  late TokenRefreshCoordinator coordinator;

  setUp(() {
    store = FakeSessionTokenStore(accessToken: 'access-1', refreshToken: 'refresh-1');
    refresher = FakeTokenRefresher();
    notifier = SessionExpiryNotifier();
    coordinator = TokenRefreshCoordinator(store, refresher, notifier);
  });

  test('refreshes the pair, stores it and returns the new access token', () async {
    final token = await coordinator.refreshAfter('access-1');

    expect(token, 'access-2');
    expect(refresher.refreshTokensReceived, ['refresh-1']);
    expect(store.currentAccessToken, 'access-2');
    expect(store.currentRefreshToken, 'refresh-2');
  });

  test('concurrent refreshes call the backend only once and all get the new token', () async {
    final tokens = await Future.wait(List.generate(5, (_) => coordinator.refreshAfter('access-1')));

    expect(tokens, List.filled(5, 'access-2'));
    expect(refresher.callCount, 1);
    expect(store.saveCount, 1);
  });

  test('reuses the stored token when it already changed, without calling the backend', () async {
    store.currentAccessToken = 'access-9';

    final token = await coordinator.refreshAfter('access-1');

    expect(token, 'access-9');
    expect(refresher.callCount, 0);
  });

  test('returns null without a session to renew', () async {
    await store.clear();

    expect(await coordinator.refreshAfter('access-1'), isNull);
    expect(refresher.callCount, 0);
  });

  test('rejected refresh clears the tokens and emits session expired once', () async {
    refresher.result = const Rejected();
    final events = <void>[];
    final subscription = notifier.events.listen(events.add);

    final results = await Future.wait([coordinator.refreshAfter('access-1'), coordinator.refreshAfter('access-1')]);
    await pumpEventQueue();

    expect(results, [null, null]);
    expect(store.currentAccessToken, isNull);
    expect(store.currentRefreshToken, isNull);
    expect(events, hasLength(1));
    await subscription.cancel();
  });

  test('session expired raised before anyone listens is delivered later', () async {
    refresher.result = const Rejected();

    await coordinator.refreshAfter('access-1');

    await expectLater(notifier.events.first, completes);
  });

  test('unavailable refresh throws a network error and keeps the session', () async {
    refresher.result = const Unavailable();
    final events = <void>[];
    final subscription = notifier.events.listen(events.add);

    await expectLater(coordinator.refreshAfter('access-1'), throwsA(isA<TokenRefreshUnavailableException>()));
    await pumpEventQueue();

    expect(store.currentAccessToken, 'access-1');
    expect(store.currentRefreshToken, 'refresh-1');
    expect(events, isEmpty);
    await subscription.cancel();
  });

  test('a failed refresh does not block the next one', () async {
    refresher.result = const Unavailable();
    await expectLater(coordinator.refreshAfter('access-1'), throwsA(isA<TokenRefreshUnavailableException>()));

    refresher.result = const Refreshed(accessToken: 'access-3', refreshToken: 'refresh-3');

    expect(await coordinator.refreshAfter('access-1'), 'access-3');
  });
}

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Connection state for the offline banners and the offline states.
/// Pure Dart: cubits depend on it without knowing about the platform plugin.
abstract interface class ConnectivityObserver {
  /// Emits the current state on subscription and then every change (no repeats).
  Stream<bool> get isOnline;
}

/// [ConnectivityObserver] over `connectivity_plus`: online if any interface other than `none` is up.
/// (Unlike Android's `NET_CAPABILITY_VALIDATED`, the plugin does not verify that the network reaches the internet.)
class ConnectivityPlusObserver implements ConnectivityObserver {
  ConnectivityPlusObserver([Connectivity? connectivity]) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Stream<bool> get isOnline async* {
    yield _isOnline(await _connectivity.checkConnectivity());
    yield* _connectivity.onConnectivityChanged.map(_isOnline);
  }

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);
}

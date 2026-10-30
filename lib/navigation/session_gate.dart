import 'dart:async';

import 'package:flutter/foundation.dart';

import '../features/iam/application/usecase/session_use_cases.dart';

/// What the router needs to know about the session: whether someone is logged in and whether the session expired.
/// It is the router's `refreshListenable`, so the redirect runs again whenever either changes.
class SessionGate extends ChangeNotifier {
  SessionGate(ObserveIsLoggedInUseCase observeIsLoggedIn, ObserveSessionExpiredUseCase observeSessionExpired) {
    _loggedInSubscription = observeIsLoggedIn().listen((loggedIn) {
      _isLoggedIn = loggedIn;
      notifyListeners();
    });
    // Single listener of the expiry events, as the notifier requires.
    _expiredSubscription = observeSessionExpired().listen((_) {
      _hasExpired = true;
      notifyListeners();
    });
  }

  late final StreamSubscription<bool> _loggedInSubscription;
  late final StreamSubscription<void> _expiredSubscription;

  bool? _isLoggedIn;
  bool _hasExpired = false;

  /// `null` until the first read of the local session.
  bool? get isLoggedIn => _isLoggedIn;

  /// The refresh token was rejected and the person has not seen the session expired screen yet.
  bool get hasExpired => _hasExpired;

  /// The session expired screen was shown and the person moves on to sign-in.
  void acknowledgeExpiry() {
    if (!_hasExpired) return;
    _hasExpired = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _loggedInSubscription.cancel();
    _expiredSubscription.cancel();
    super.dispose();
  }
}

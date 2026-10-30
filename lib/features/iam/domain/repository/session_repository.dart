import '../entity/session_user.dart';

/// Local session on the device.
abstract interface class SessionRepository {
  /// Last user who signed in here. Still available after the session expires, so the session expired screen knows
  /// the role; cleared by [logoutLocally]. Emits the current value on subscription.
  Stream<SessionUser?> get currentUser;

  /// There is a user and refreshable tokens. Turns `false` when the session expires or is closed. Emits the current
  /// value on subscription.
  Stream<bool> get isLoggedIn;

  /// One-shot event: the backend rejected the refresh token (expired or revoked); shows the session expired screen.
  /// Single subscription: only the root listens.
  Stream<void> get sessionExpired;

  /// Clears the session on the device: deletes tokens and user.
  Future<void> logoutLocally();
}

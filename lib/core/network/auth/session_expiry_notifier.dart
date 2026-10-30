import 'dart:async';

/// One-shot "session expired" event (the refresh token was rejected). The root graph consumes it to open the
/// session expired screen. Conflated: several requests failing at once leave a single pending event, and an event
/// raised before anyone listens is kept until the (single) listener arrives.
class SessionExpiryNotifier {
  final _controller = StreamController<void>();
  bool _pending = false;

  /// Single-subscription stream: listen once, from the root.
  Stream<void> get events => _controller.stream.map((event) {
    _pending = false;
    return event;
  });

  void notifyExpired() {
    if (_pending) return;
    _pending = true;
    _controller.add(null);
  }
}

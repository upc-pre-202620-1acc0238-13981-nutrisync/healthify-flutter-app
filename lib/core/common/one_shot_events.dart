import 'dart:async';

/// One-shot UI effects (navigation, snackbars) kept out of the cubit state. Single-subscription, so an event emitted
/// before the screen starts listening is delivered once it does (the equivalent of a buffered `Channel`).
class OneShotEvents<T> {
  final _controller = StreamController<T>();

  Stream<T> get stream => _controller.stream;

  void emit(T event) {
    if (!_controller.isClosed) _controller.add(event);
  }

  /// Not awaited: a single-subscription controller only completes `close` once someone listens.
  void close() => unawaited(_controller.close());
}

import 'dart:async';

/// Async mutual exclusion: [synchronized] actions run one at a time, in call order (the equivalent of a
/// coroutine `Mutex.withLock`). Not reentrant.
class Lock {
  Future<void> _tail = Future.value();

  Future<T> synchronized<T>(Future<T> Function() action) {
    final previous = _tail;
    final done = Completer<void>();
    _tail = done.future;
    return previous.then((_) => action()).whenComplete(done.complete);
  }
}

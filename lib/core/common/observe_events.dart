import 'dart:async';

import 'package:flutter/widgets.dart';

/// Runs [onEvent] for every event of [events] while it is in the tree (the equivalent of Compose's `ObserveEvents`).
/// [events] is a single-subscription stream, so it is only listened once, in `initState`.
class ObserveEvents<T> extends StatefulWidget {
  const ObserveEvents({super.key, required this.events, required this.onEvent, required this.child});

  final Stream<T> events;
  final void Function(BuildContext context, T event) onEvent;
  final Widget child;

  @override
  State<ObserveEvents<T>> createState() => _ObserveEventsState<T>();
}

class _ObserveEventsState<T> extends State<ObserveEvents<T>> {
  late final StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.events.listen((event) {
      if (mounted) widget.onEvent(context, event);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

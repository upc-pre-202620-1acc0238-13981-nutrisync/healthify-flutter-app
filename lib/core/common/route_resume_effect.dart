import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Calls [onResume] each time [path] becomes the current location again (back from a screen pushed over it, or
/// switching back to its tab) and when the app returns to the foreground while [path] is current. The equivalent of
/// Compose's `LifecycleResumeEffect` on a destination. Tabs of a `StatefulShellRoute` stay alive, so their widgets do
/// not rebuild when they come back: this is what tells them.
///
/// It does not fire for the first appearance; the owner loads its data itself.
class RouteResumeEffect extends StatefulWidget {
  const RouteResumeEffect({super.key, required this.path, required this.onResume, required this.child});

  final String path;
  final VoidCallback onResume;
  final Widget child;

  @override
  State<RouteResumeEffect> createState() => _RouteResumeEffectState();
}

class _RouteResumeEffectState extends State<RouteResumeEffect> with WidgetsBindingObserver {
  GoRouter? _router;
  bool _wasCurrent = true;

  // `uri` keeps the base location while a screen is pushed over it; the last match is the one actually on top.
  bool get _isCurrent => _router?.routerDelegate.currentConfiguration.last.matchedLocation == widget.path;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.maybeOf(context);
    if (router == _router) return;
    _router?.routerDelegate.removeListener(_onRouteChanged);
    _router = router;
    router?.routerDelegate.addListener(_onRouteChanged);
    _wasCurrent = _isCurrent;
  }

  void _onRouteChanged() {
    final current = _isCurrent;
    final resumed = current && !_wasCurrent;
    _wasCurrent = current;
    if (resumed && mounted) widget.onResume();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isCurrent && mounted) widget.onResume();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router?.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

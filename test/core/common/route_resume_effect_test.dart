import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:healthify/core/common/route_resume_effect.dart';

void main() {
  late int resumes;
  late GoRouter router;

  setUp(() {
    resumes = 0;
    router = GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => shell,
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/patients',
                  builder: (context, state) => RouteResumeEffect(
                    path: '/patients',
                    onResume: () => resumes++,
                    child: const Text('patients'),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(routes: [GoRoute(path: '/inbox', builder: (_, _) => const Text('inbox'))]),
          ],
        ),
        GoRoute(path: '/invite', builder: (_, _) => const Text('invite')),
      ],
      initialLocation: '/patients',
    );
  });

  tearDown(() => router.dispose());

  Future<void> pumpApp(WidgetTester tester) => tester.pumpWidget(MaterialApp.router(routerConfig: router));

  testWidgets('does not fire on the first appearance', (tester) async {
    await pumpApp(tester);

    expect(resumes, 0);
  });

  testWidgets('fires when a screen pushed over the tab is closed', (tester) async {
    await pumpApp(tester);

    unawaited(router.push('/invite'));
    await tester.pumpAndSettle();
    expect(resumes, 0);

    router.pop();
    await tester.pumpAndSettle();
    expect(resumes, 1);
  });

  testWidgets('fires when the person comes back to the tab from another one', (tester) async {
    await pumpApp(tester);

    router.go('/inbox');
    await tester.pumpAndSettle();
    expect(resumes, 0);

    router.go('/patients');
    await tester.pumpAndSettle();
    expect(resumes, 1);
  });

  testWidgets('fires when the app returns to the foreground while the tab is current', (tester) async {
    await pumpApp(tester);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    expect(resumes, 1);
  });

  testWidgets('does not fire on foreground while another tab is current', (tester) async {
    await pumpApp(tester);
    router.go('/inbox');
    await tester.pumpAndSettle();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    expect(resumes, 0);
  });
}

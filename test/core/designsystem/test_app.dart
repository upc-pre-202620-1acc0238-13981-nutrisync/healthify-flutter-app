import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';

/// Pumps [child] inside the Healthify theme and localizations (Spanish unless [locale] says otherwise).
Future<void> pumpThemed(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('es'),
  Size surfaceSize = const Size(360, 800),
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: HealthifyTheme.light(),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

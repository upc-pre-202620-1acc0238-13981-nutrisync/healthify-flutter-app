import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/designsystem/theme/healthify_theme.dart';
import 'core/di/service_locator.dart';
import 'core/l10n/app_localizations.dart';
import 'core/network/app_language_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupCore();
  runApp(const HealthifyApp());
}

class HealthifyApp extends StatefulWidget {
  const HealthifyApp({super.key});

  @override
  State<HealthifyApp> createState() => _HealthifyAppState();
}

class _HealthifyAppState extends State<HealthifyApp> {
  final _languageProvider = getIt<PreferencesAppLanguageProvider>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _languageProvider.language,
      builder: (context, language, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        home: const _PlaceholderHome(),
        theme: HealthifyTheme.light(),
        locale: Locale(language),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text(AppLocalizations.of(context).appName)));
}

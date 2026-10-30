import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/designsystem/theme/healthify_theme.dart';
import 'core/di/service_locator.dart';
import 'core/l10n/app_localizations.dart';
import 'core/network/app_language_provider.dart';
import 'features/iam/application/usecase/session_use_cases.dart';
import 'features/iam/infrastructure/di/iam_module.dart';
import 'features/onboarding/presentation/di/onboarding_module.dart';
import 'navigation/app_router.dart';
import 'navigation/session_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupCore();
  registerFeatureModules();
  runApp(const HealthifyApp());
}

/// The bounded contexts' graphs, on top of `setupCore`. Tests call it too, so they exercise the graph the app runs with.
void registerFeatureModules() {
  registerIam();
  registerOnboarding();
}

class HealthifyApp extends StatefulWidget {
  const HealthifyApp({super.key});

  @override
  State<HealthifyApp> createState() => _HealthifyAppState();
}

class _HealthifyAppState extends State<HealthifyApp> {
  late final SessionGate _gate = SessionGate(getIt<ObserveIsLoggedInUseCase>(), getIt<ObserveSessionExpiredUseCase>());
  late final _router = createAppRouter(_gate);
  final _languageProvider = getIt<PreferencesAppLanguageProvider>();

  @override
  void dispose() {
    _router.dispose();
    _gate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _languageProvider.language,
      builder: (context, language, _) => MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        routerConfig: _router,
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

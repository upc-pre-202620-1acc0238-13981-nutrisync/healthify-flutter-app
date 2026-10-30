import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../connectivity/connectivity_observer.dart';
import '../network/accept_language_client.dart';
import '../network/api_client.dart';
import '../network/app_language_provider.dart';
import '../network/auth/authenticated_client.dart';
import '../network/auth/secure_session_token_store.dart';
import '../network/auth/session_expiry_notifier.dart';
import '../network/auth/session_token_store.dart';
import '../network/auth/token_refresh_coordinator.dart';
import '../network/auth/token_refresher.dart';
import '../network/http_client_factory.dart';

final getIt = GetIt.instance;

/// Name of the [ApiClient] without bearer or refresh, for sign-in, sign-up and token-refreshes (the equivalent of
/// Hilt's `@AnonymousApi`). The unnamed [ApiClient] is the authenticated one.
const anonymousApi = 'anonymousApi';

/// Registers the core graph. Context modules register theirs from their own `register*` function, called after this.
Future<void> setupCore() async {
  final preferences = await SharedPreferences.getInstance();
  final languageProvider = PreferencesAppLanguageProvider(
    preferences,
    systemLanguage: () => PlatformDispatcher.instance.locale.languageCode,
  );

  getIt
    ..registerSingleton<SharedPreferences>(preferences)
    // Same instance under both types: the network stack reads it, the root widget and settings change it.
    ..registerSingleton<PreferencesAppLanguageProvider>(languageProvider)
    ..registerSingleton<AppLanguageProvider>(languageProvider)
    ..registerLazySingleton<ConnectivityObserver>(ConnectivityPlusObserver.new)
    ..registerSingleton<SessionExpiryNotifier>(SessionExpiryNotifier())
    ..registerSingleton<SessionTokenStore>(SecureSessionTokenStore(const FlutterSecureStorage()))
    // Base client: language and timeouts. The anonymous and authenticated clients share it, so they reuse the
    // connection pool.
    ..registerLazySingleton<http.Client>(
      () => AcceptLanguageClient(createHttpClient(), getIt<AppLanguageProvider>()),
    )
    ..registerLazySingleton<ApiClient>(() => ApiClient(getIt<http.Client>()), instanceName: anonymousApi)
    // The `TokenRefresher` is registered by the `iam` module (`registerIam`); it is only resolved on the first 401.
    ..registerLazySingleton<TokenRefreshCoordinator>(
      () => TokenRefreshCoordinator(
        getIt<SessionTokenStore>(),
        getIt<TokenRefresher>(),
        getIt<SessionExpiryNotifier>(),
      ),
    )
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        AuthenticatedClient(
          getIt<http.Client>(),
          getIt<SessionTokenStore>(),
          getIt<TokenRefreshCoordinator>(),
        ),
      ),
    );
}

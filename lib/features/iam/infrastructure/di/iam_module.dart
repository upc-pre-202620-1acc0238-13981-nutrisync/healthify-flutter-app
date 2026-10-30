import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/app_language_provider.dart';
import '../../../../core/network/auth/session_expiry_notifier.dart';
import '../../../../core/network/auth/session_token_store.dart';
import '../../../../core/network/auth/token_refresher.dart';
import '../../application/usecase/account_use_cases.dart';
import '../../application/usecase/password_reset_use_cases.dart';
import '../../application/usecase/register_use_case.dart';
import '../../application/usecase/resolve_navigation_shell_use_case.dart';
import '../../application/usecase/session_use_cases.dart';
import '../../application/usecase/sign_in_use_case.dart';
import '../../application/usecase/sign_out_use_case.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/repository/app_language_repository.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/repository/session_repository.dart';
import '../../domain/repository/user_repository.dart';
import '../../presentation/cubit/app_language_cubit.dart';
import '../../presentation/cubit/forgot_password_cubit.dart';
import '../../presentation/cubit/practitioner_only_cubit.dart';
import '../../presentation/cubit/session_expired_cubit.dart';
import '../../presentation/cubit/shell_loading_cubit.dart';
import '../../presentation/cubit/sign_in_cubit.dart';
import '../../presentation/cubit/sign_up_cubit.dart';
import '../local/preferences_app_language_repository.dart';
import '../local/session_local_data_source.dart';
import '../remote/authentication_service.dart';
import '../remote/http_token_refresher.dart';
import '../remote/session_service.dart';
import '../repository/account_repository_impl.dart';
import '../repository/authentication_repository_impl.dart';
import '../repository/session_repository_impl.dart';
import '../repository/user_repository_impl.dart';

/// Registers the `iam` graph. Called from `main` after `setupCore`.
void registerIam() {
  getIt
    // Infrastructure. The anonymous client serves sign-in, sign-up, password reset and token refreshes.
    ..registerLazySingleton<AuthenticationService>(
      () => AuthenticationService(getIt<ApiClient>(instanceName: anonymousApi)),
    )
    ..registerLazySingleton<SessionService>(() => SessionService(getIt<ApiClient>()))
    ..registerLazySingleton<TokenRefresher>(() => HttpTokenRefresher(getIt<AuthenticationService>()))
    ..registerLazySingleton<SessionLocalDataSource>(
      () => SessionLocalDataSource(getIt(), getIt<SessionTokenStore>()),
    )
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
        getIt<AuthenticationService>(),
        getIt<SessionService>(),
        getIt<SessionLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<SessionRepository>(
      () => SessionRepositoryImpl(getIt<SessionLocalDataSource>(), getIt<SessionExpiryNotifier>()),
    )
    ..registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(getIt<SessionService>(), getIt<SessionLocalDataSource>()),
    )
    ..registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(getIt<SessionService>(), getIt<SessionLocalDataSource>()),
    )
    ..registerLazySingleton<AppLanguageRepository>(
      () => PreferencesAppLanguageRepository(getIt<PreferencesAppLanguageProvider>()),
    )
    // Use cases.
    ..registerFactory(() => SignInUseCase(getIt<AuthenticationRepository>()))
    ..registerFactory(() => RegisterUseCase(getIt<AuthenticationRepository>()))
    ..registerFactory(() => SignOutUseCase(getIt<AuthenticationRepository>(), getIt<SessionRepository>()))
    ..registerFactory(() => LogoutLocallyUseCase(getIt<SessionRepository>()))
    ..registerFactory(() => ObserveCurrentUserUseCase(getIt<SessionRepository>()))
    ..registerFactory(() => ObserveIsLoggedInUseCase(getIt<SessionRepository>()))
    ..registerFactory(() => ObserveSessionExpiredUseCase(getIt<SessionRepository>()))
    ..registerFactory(() => ResolveNavigationShellUseCase(getIt<AuthenticationRepository>()))
    ..registerFactory(() => RequestPasswordResetUseCase(getIt<AuthenticationRepository>()))
    ..registerFactory(() => VerifyPasswordResetCodeUseCase(getIt<AuthenticationRepository>()))
    ..registerFactory(() => ResetPasswordUseCase(getIt<AuthenticationRepository>()))
    ..registerFactory(() => ChangePreferredLanguageUseCase(getIt<SessionRepository>(), getIt<UserRepository>()))
    ..registerFactory(() => GetAccountCreatedOnUseCase(getIt<AccountRepository>()))
    ..registerFactory(() => GetAppLanguageUseCase(getIt<AppLanguageRepository>()))
    ..registerFactory(() => ApplyAppLanguageUseCase(getIt<AppLanguageRepository>()))
    // Cubits: one per screen instance.
    ..registerFactory(() => SignInCubit(getIt(), getIt<ConnectivityObserver>()))
    ..registerFactory(() => SignUpCubit(getIt(), getIt<ConnectivityObserver>()))
    ..registerFactory(
      () => ForgotPasswordCubit(getIt(), getIt(), getIt(), getIt<ConnectivityObserver>()),
    )
    ..registerFactory(() => ShellLoadingCubit(getIt(), getIt()))
    ..registerFactory(() => SessionExpiredCubit(getIt<ConnectivityObserver>()))
    ..registerFactory(() => PractitionerOnlyCubit(getIt()))
    ..registerFactory(() => AppLanguageCubit(getIt(), getIt(), getIt(), getIt()));
}

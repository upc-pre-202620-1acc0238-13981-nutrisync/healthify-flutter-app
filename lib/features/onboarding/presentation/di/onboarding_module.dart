import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/welcome_cubit.dart';

/// Registers the `onboarding` graph. Called from `main` after `registerIam` (the splash reads the iam session).
void registerOnboarding() {
  getIt
    ..registerFactory(() => SplashCubit(getIt(), getIt()))
    ..registerFactory(() => WelcomeCubit(getIt<ConnectivityObserver>()));
}

import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/patient_history_cubit.dart';
import '../cubit/practitioner_settings_cubit.dart';
import '../cubit/practitioner_shell_cubit.dart';
import '../cubit/sign_out_cubit.dart';
import '../state/practitioner_shell_state.dart';

/// Registers the `main` graph (the nutritionist's shell). Called from `main` after `setupCore` and `registerIam`.
void registerMain() {
  getIt
    // One bus for the whole app: full-screen routes leave their message there for the shell underneath.
    ..registerLazySingleton<PractitionerShellMessages>(PractitionerShellMessages.new)
    ..registerFactory(() => PractitionerShellCubit(getIt(), getIt<PractitionerShellMessages>()))
    ..registerFactory(() => PractitionerSettingsCubit(getIt(), getIt(), getIt(), getIt(), getIt<ConnectivityObserver>()))
    ..registerFactory(() => SignOutCubit(getIt()))
    ..registerFactoryParam<PatientHistoryCubit, int, void>(
      (patientId, _) => PatientHistoryCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt<ConnectivityObserver>(),
        patientId: patientId,
      ),
    );
}

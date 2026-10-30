import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/api_client.dart';
import '../../application/usecase/monitoring_use_cases.dart';
import '../../domain/repository/monitoring_repositories.dart';
import '../../presentation/cubit/patient_follow_up_cubit.dart';
import '../remote/monitoring_services.dart';
import '../repository/monitoring_repositories_impl.dart';

/// Registers the `monitoring` graph (what the nutritionist sees of a patient's follow-up). Called from `main` after
/// `setupCore`.
void registerMonitoring() {
  getIt
    ..registerLazySingleton<PractitionerMonitoringService>(() => PractitionerMonitoringService(getIt<ApiClient>()))
    ..registerLazySingleton<PractitionerMonitoringRepository>(
      () => PractitionerMonitoringRepositoryImpl(getIt<PractitionerMonitoringService>()),
    )
    ..registerFactory(() => GetMonitoringPanelUseCase(getIt<PractitionerMonitoringRepository>(), DateTime.now))
    ..registerFactory(() => GetMonitoringSummaryUseCase(getIt<PractitionerMonitoringRepository>()))
    // One cubit per patient file instance.
    ..registerFactoryParam<PatientFollowUpCubit, int, void>(
      (patientId, _) => PatientFollowUpCubit(getIt(), getIt(), getIt<ConnectivityObserver>(), patientId: patientId),
    );
}

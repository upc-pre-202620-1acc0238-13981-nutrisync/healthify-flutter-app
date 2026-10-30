import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/api_client.dart';
import '../../application/usecase/find_active_care_link_use_case.dart';
import '../../application/usecase/practitioner_care_link_use_cases.dart';
import '../../domain/repository/practitioner_care_link_repository.dart';
import '../../presentation/cubit/discharge_patient_cubit.dart';
import '../../presentation/cubit/invite_patient_cubit.dart';
import '../../presentation/cubit/patient_roster_cubit.dart';
import '../remote/practitioner_care_link_service.dart';
import '../repository/practitioner_care_link_repository_impl.dart';

/// Registers the `carerelationship` graph (nutritionist side only). Called from `main` after `setupCore`.
void registerCareRelationship() {
  getIt
    ..registerLazySingleton<PractitionerCareLinkService>(() => PractitionerCareLinkService(getIt<ApiClient>()))
    ..registerLazySingleton<PractitionerCareLinkRepository>(
      () => PractitionerCareLinkRepositoryImpl(getIt<PractitionerCareLinkService>()),
    )
    // Use cases.
    ..registerFactory(() => GetPatientRosterUseCase(getIt<PractitionerCareLinkRepository>()))
    ..registerFactory(() => IssueInvitationUseCase(getIt<PractitionerCareLinkRepository>(), DateTime.now))
    ..registerFactory(() => DischargePatientUseCase(getIt<PractitionerCareLinkRepository>()))
    ..registerFactory(() => GetLinkTargetsReadStatusUseCase(getIt<PractitionerCareLinkRepository>()))
    ..registerFactory(() => FindActiveRosterPatientUseCase(getIt(), getIt()))
    // Cubits: one per screen instance.
    ..registerFactory(() => PatientRosterCubit(getIt(), getIt(), getIt<ConnectivityObserver>()))
    ..registerFactory(() => InvitePatientCubit(getIt(), getIt<ConnectivityObserver>(), DateTime.now))
    ..registerFactoryParam<DischargePatientCubit, DischargeArgs, void>(
      (args, _) => DischargePatientCubit(
        getIt(),
        getIt<ConnectivityObserver>(),
        careLinkId: args.careLinkId,
        patientName: args.patientName,
      ),
    );
}

/// Route arguments of the discharge screen.
typedef DischargeArgs = ({int careLinkId, String patientName});

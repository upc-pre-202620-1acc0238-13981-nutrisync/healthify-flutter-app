import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/api_client.dart';
import '../../../carerelationship/application/usecase/find_active_care_link_use_case.dart';
import '../../../carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../../application/usecase/review_inbox_use_cases.dart';
import '../../domain/repository/practitioner_care_repositories.dart';
import '../../domain/repository/review_inbox_repository.dart';
import '../../presentation/cubit/adjust_proposal_cubit.dart';
import '../../presentation/cubit/baseline_cubit.dart';
import '../../presentation/cubit/diagnosis_step_cubit.dart';
import '../../presentation/cubit/measurement_step_cubit.dart';
import '../../presentation/cubit/publication_step_cubit.dart';
import '../../presentation/cubit/targets_step_cubit.dart';
import '../../presentation/cubit/patient_plan_cubit.dart';
import '../../presentation/cubit/patient_summary_cubit.dart';
import '../../presentation/cubit/review_inbox_cubit.dart';
import '../../presentation/cubit/review_item_cubit.dart';
import '../remote/practitioner_care_services.dart';
import '../remote/review_item_service.dart';
import '../repository/practitioner_care_repositories_impl.dart';
import '../repository/review_inbox_repository_impl.dart';

/// Registers the `nutritionalcare` graph (nutritionist side only). Called from `main` after `setupCore`.
void registerNutritionalCare() {
  getIt
    ..registerLazySingleton<PatientBaselineService>(() => PatientBaselineService(getIt<ApiClient>()))
    ..registerLazySingleton<ConsultationService>(() => ConsultationService(getIt<ApiClient>()))
    ..registerLazySingleton<PractitionerPatientService>(() => PractitionerPatientService(getIt<ApiClient>()))
    ..registerLazySingleton<ReviewItemService>(() => ReviewItemService(getIt<ApiClient>()))
    ..registerLazySingleton<ReviewInboxRepository>(() => ReviewInboxRepositoryImpl(getIt<ReviewItemService>()))
    ..registerLazySingleton<PatientBaselineRepository>(
      () => PatientBaselineRepositoryImpl(getIt<PatientBaselineService>()),
    )
    ..registerLazySingleton<PatientSummaryRepository>(
      () => PatientSummaryRepositoryImpl(getIt<PractitionerPatientService>()),
    )
    ..registerLazySingleton<NutritionPlanRepository>(
      () => NutritionPlanRepositoryImpl(getIt<PractitionerPatientService>()),
    )
    ..registerLazySingleton<PractitionerRecordRepository>(
      () => PractitionerRecordRepositoryImpl(getIt<PractitionerPatientService>()),
    )
    ..registerLazySingleton<ConsultationRepository>(() => ConsultationRepositoryImpl(getIt<ConsultationService>()))
    // One store for the whole app: the key has to survive leaving the publication step and coming back.
    ..registerLazySingleton<IdempotencyKeyStore>(IdempotencyKeyStore.new)
    // Use cases.
    ..registerFactory(() => GetPatientSummaryUseCase(getIt<PatientSummaryRepository>()))
    ..registerFactory(() => GetPlanHistoryUseCase(getIt<NutritionPlanRepository>()))
    ..registerFactory(() => GetPractitionerRecordUseCase(getIt<PractitionerRecordRepository>()))
    ..registerFactory(() => GetEvaluationDetailUseCase(getIt<PractitionerRecordRepository>()))
    ..registerFactory(() => GetPatientBaselineUseCase(getIt<PatientBaselineRepository>()))
    ..registerFactory(() => SavePatientBaselineUseCase(getIt<PatientBaselineRepository>()))
    ..registerFactory(() => StartOrResumeConsultationUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => GetConsultationInProgressUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => RecordConsultationMeasurementUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => SuggestDiagnosisUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => IssueConsultationDiagnosisUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => ProposeConsultationTargetsUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => PrescribeConsultationTargetsUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => SuggestGuidelinesUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => SavePublicationDraftUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => PublishConsultationUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => DiscardConsultationUseCase(getIt<ConsultationRepository>()))
    ..registerFactory(() => GetOpenReviewItemsUseCase(getIt<ReviewInboxRepository>()))
    ..registerFactory(() => GetOpenReviewItemUseCase(getIt<ReviewInboxRepository>()))
    ..registerFactory(() => ResolveReviewItemUseCase(getIt<ReviewInboxRepository>()))
    ..registerFactory(() => AwaitPlanProposalUseCase(getIt<ReviewInboxRepository>()))
    ..registerFactory(() => AcceptPlanProposalUseCase(getIt<ReviewInboxRepository>()))
    // Cubits: one per screen instance, built with the route arguments.
    ..registerFactoryParam<PatientSummaryCubit, int, void>(
      (patientId, _) => PatientSummaryCubit(getIt(), getIt(), getIt<ConnectivityObserver>(), DateTime.now, patientId: patientId),
    )
    ..registerFactoryParam<PatientPlanCubit, PatientPlanArgs, void>(
      (args, _) => PatientPlanCubit(
        getIt(),
        getIt<GetLinkTargetsReadStatusUseCase>(),
        getIt(),
        getIt<ConnectivityObserver>(),
        patientId: args.patientId,
        careLinkId: args.careLinkId,
      ),
    )
    ..registerFactoryParam<BaselineCubit, BaselineArgs, void>(
      (args, _) => BaselineCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt<ConnectivityObserver>(),
        DateTime.now,
        patientId: args.patientId,
        editing: args.editing,
      ),
    )
    ..registerFactory(() => ReviewInboxCubit(getIt(), getIt<ConnectivityObserver>()))
    ..registerFactoryParam<ReviewItemCubit, int, void>(
      (reviewItemId, _) => ReviewItemCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt<FindActiveRosterPatientUseCase>(),
        getIt<ConnectivityObserver>(),
        reviewItemId: reviewItemId,
      ),
    )
    ..registerFactoryParam<AdjustProposalCubit, int, void>(
      (reviewItemId, _) => AdjustProposalCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt<ConnectivityObserver>(),
        reviewItemId: reviewItemId,
      ),
    )
    // The four steps of the guided consultation: one cubit per step instance, built with the patient id.
    ..registerFactoryParam<MeasurementStepCubit, int, void>(
      (patientId, _) => MeasurementStepCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt<ConnectivityObserver>(),
        patientId: patientId,
      ),
    )
    ..registerFactoryParam<DiagnosisStepCubit, int, void>(
      (patientId, _) => DiagnosisStepCubit(getIt(), getIt(), getIt(), getIt<ConnectivityObserver>(), patientId: patientId),
    )
    ..registerFactoryParam<TargetsStepCubit, int, void>(
      (patientId, _) => TargetsStepCubit(getIt(), getIt(), getIt(), getIt<ConnectivityObserver>(), patientId: patientId),
    )
    ..registerFactoryParam<PublicationStepCubit, int, void>(
      (patientId, _) => PublicationStepCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt<ConnectivityObserver>(),
        patientId: patientId,
      ),
    );
}

/// Arguments of the Plan tab's cubit.
typedef PatientPlanArgs = ({int patientId, int careLinkId});

/// Arguments of the baseline form's cubit.
typedef BaselineArgs = ({int patientId, bool editing});

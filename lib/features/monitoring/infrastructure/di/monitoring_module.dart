import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/app_language_provider.dart';
import '../../../carerelationship/application/usecase/find_active_care_link_use_case.dart';
import '../../../iam/application/usecase/session_use_cases.dart';
import '../../application/usecase/consultation_reminder_use_cases.dart';
import '../../application/usecase/monitoring_use_cases.dart';
import '../../application/usecase/practitioner_agenda_use_cases.dart';
import '../../domain/repository/consultation_reminder_scheduler.dart';
import '../../domain/repository/monitoring_repositories.dart';
import '../../domain/repository/practitioner_agenda_repository.dart';
import '../../presentation/cubit/patient_follow_up_cubit.dart';
import '../../presentation/cubit/practitioner_agenda_cubit.dart';
import '../../presentation/cubit/record_referral_cubit.dart';
import '../../presentation/cubit/schedule_follow_up_cubit.dart';
import '../../presentation/state/practitioner_agenda_states.dart';
import '../local/local_notifications_consultation_reminder_scheduler.dart';
import '../remote/monitoring_services.dart';
import '../remote/practitioner_agenda_service.dart';
import '../repository/monitoring_repositories_impl.dart';
import '../repository/practitioner_agenda_repository_impl.dart';

/// Registers the `monitoring` graph (what the nutritionist sees of a patient's follow-up). Called from `main` after
/// `setupCore`.
void registerMonitoring() {
  getIt
    ..registerLazySingleton<PractitionerMonitoringService>(() => PractitionerMonitoringService(getIt<ApiClient>()))
    ..registerLazySingleton<PractitionerAgendaService>(() => PractitionerAgendaService(getIt<ApiClient>()))
    ..registerLazySingleton<PractitionerAgendaRepository>(
      () => PractitionerAgendaRepositoryImpl(
        getIt<PractitionerAgendaService>(),
        // Resolved on each change: the sync itself reads the agenda through this repository.
        onAgendaChanged: () => unawaited(getIt<ConsultationRemindersSync>().requestRefresh()),
      ),
    )
    ..registerLazySingleton<ConsultationReminderScheduler>(
      () => LocalNotificationsConsultationReminderScheduler(
        AndroidFlutterLocalNotificationsPlugin(),
        getIt<AppLanguageProvider>(),
        DateTime.now,
      ),
    )
    ..registerLazySingleton<ConsultationRemindersSync>(
      () => ConsultationRemindersSync(
        RefreshConsultationRemindersUseCase(
          getIt<PractitionerAgendaRepository>(),
          getIt<ConsultationReminderScheduler>(),
          DateTime.now,
        ),
        getIt<ConsultationReminderScheduler>(),
        getIt<ObserveCurrentUserUseCase>(),
        getIt<ObserveIsLoggedInUseCase>(),
        getIt<ConnectivityObserver>(),
      ),
    )
    ..registerLazySingleton<PractitionerMonitoringRepository>(
      () => PractitionerMonitoringRepositoryImpl(getIt<PractitionerMonitoringService>()),
    )
    ..registerFactory(() => GetMonitoringPanelUseCase(getIt<PractitionerMonitoringRepository>(), DateTime.now))
    ..registerFactory(() => GetMonitoringSummaryUseCase(getIt<PractitionerMonitoringRepository>()))
    ..registerFactory(() => GetUpcomingFollowUpsUseCase(getIt<PractitionerAgendaRepository>(), DateTime.now))
    ..registerFactory(() => ScheduleFollowUpUseCase(getIt<PractitionerAgendaRepository>(), DateTime.now))
    ..registerFactory(() => RescheduleFollowUpUseCase(getIt<PractitionerAgendaRepository>(), DateTime.now))
    ..registerFactory(() => CancelFollowUpUseCase(getIt<PractitionerAgendaRepository>()))
    ..registerFactory(() => RecordReferralUseCase(getIt<PractitionerAgendaRepository>()))
    ..registerFactory(
      () => PractitionerAgendaCubit(
        getIt<ObserveCurrentUserUseCase>(),
        getIt(),
        getIt(),
        getIt<FindActiveRosterPatientUseCase>(),
        getIt<ConnectivityObserver>(),
      ),
    )
    ..registerFactoryParam<ScheduleFollowUpCubit, ScheduleFollowUpArgs, void>(
      (args, _) => ScheduleFollowUpCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt<ObserveCurrentUserUseCase>(),
        getIt<ConnectivityObserver>(),
        DateTime.now,
        args: args,
      ),
    )
    ..registerFactoryParam<RecordReferralCubit, int, void>(
      (patientId, _) => RecordReferralCubit(getIt(), getIt<ConnectivityObserver>(), patientId: patientId),
    )
    // One cubit per patient file instance.
    ..registerFactoryParam<PatientFollowUpCubit, int, void>(
      (patientId, _) => PatientFollowUpCubit(getIt(), getIt(), getIt<ConnectivityObserver>(), patientId: patientId),
    );
}

/// Starts the consultation reminders for the whole run: removes them when the session ends, retries a failed read when
/// the connection comes back and rewrites them in a newly picked language. Called once from `main`, not from tests.
void startConsultationReminders() {
  final sync = getIt<ConsultationRemindersSync>()..start();
  getIt<PreferencesAppLanguageProvider>().language.addListener(() => unawaited(sync.requestRefresh()));
}

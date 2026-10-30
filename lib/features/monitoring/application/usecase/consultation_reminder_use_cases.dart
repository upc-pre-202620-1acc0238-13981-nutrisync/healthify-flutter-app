import 'dart:async';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/error/result.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../iam/application/usecase/session_use_cases.dart';
import '../../domain/entity/consultation_reminder.dart';
import '../../domain/entity/practitioner_agenda.dart';
import '../../domain/repository/consultation_reminder_scheduler.dart';
import '../../domain/repository/practitioner_agenda_repository.dart';

/// Re-reads the nutritionist's visits scheduled from now on and reschedules their reminders. If the read fails, the
/// existing reminders stay as they were.
class RefreshConsultationRemindersUseCase {
  const RefreshConsultationRemindersUseCase(this._agendaRepository, this._scheduler, this._now);

  /// Only the nearest visits get reminders: two alarms each keeps the app well below Android's 500 alarms per app.
  static const maxVisits = 100;

  final PractitionerAgendaRepository _agendaRepository;
  final ConsultationReminderScheduler _scheduler;
  final DateTime Function() _now;

  Future<Result<void>> call(int practitionerId) async {
    final result = await _agendaRepository.getAgenda(practitionerId, FollowUpState.scheduled, _now());
    switch (result) {
      case Failure(:final error):
        return Result.failure(error);
      case Success(value: final visits):
        final nearest = [...visits]..sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
        await _scheduler.replaceAll([
          for (final visit in nearest.take(maxVisits))
            ConsultationReminder(
              followUpId: visit.id,
              scheduledFor: visit.scheduledFor,
              patientFullName: visit.patientFullName,
            ),
        ]);
        return const Result.success(null);
    }
  }
}

/// Keeps the visit reminders in step with the agenda while the app runs (there is no background re-read): on entering
/// the shell, after the agenda changes, after the language changes and, if the last read failed offline, when the
/// connection comes back. Signed out or with the session expired, it removes them.
class ConsultationRemindersSync {
  ConsultationRemindersSync(
    this._refresh,
    this._scheduler,
    this._observeCurrentUser,
    this._observeIsLoggedIn,
    this._connectivity,
  );

  final RefreshConsultationRemindersUseCase _refresh;
  final ConsultationReminderScheduler _scheduler;
  final ObserveCurrentUserUseCase _observeCurrentUser;
  final ObserveIsLoggedInUseCase _observeIsLoggedIn;
  final ConnectivityObserver _connectivity;

  StreamSubscription<bool>? _session;
  StreamSubscription<bool>? _online;
  Future<void> _last = Future.value();
  bool _retryWhenOnline = false;

  /// Called once from `main`, so reminders left by an expired session are removed even if the shell never opens.
  void start() {
    _session ??= _observeIsLoggedIn().listen((isLoggedIn) {
      if (isLoggedIn) return;
      _retryWhenOnline = false;
      unawaited(_scheduler.cancelAll());
    });
    _online ??= _connectivity.isOnline.listen((isOnline) {
      if (isOnline && _retryWhenOnline) unawaited(requestRefresh());
    });
  }

  /// On entering the shell: asks for the notification permission and reschedules the reminders.
  Future<void> onShellEntered() async {
    await _scheduler.requestPermission();
    await requestRefresh();
  }

  /// Requests run one after another, so an older agenda never overwrites a newer one.
  Future<void> requestRefresh() => _last = _last.then((_) => _refreshOnce());

  Future<void> _refreshOnce() async {
    final user = await _observeCurrentUser().first;
    if (user == null || !user.isPractitioner || !await _observeIsLoggedIn().first) return;
    final result = await _refresh(user.id.value);
    _retryWhenOnline = result.errorOrNull is Network;
    // Signed out (or someone else signed in) while the agenda was read: its reminders must not stay.
    final now = await _observeCurrentUser().first;
    if (now?.id != user.id || !await _observeIsLoggedIn().first) await _scheduler.cancelAll();
  }

  Future<void> dispose() async {
    await _session?.cancel();
    await _online?.cancel();
  }
}

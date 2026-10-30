import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/iam/application/usecase/session_use_cases.dart';
import 'package:healthify/features/iam/domain/entity/session_user.dart';
import 'package:healthify/features/iam/domain/repository/session_repository.dart';
import 'package:healthify/features/iam/domain/valueobject/user_role.dart';
import 'package:healthify/features/monitoring/application/usecase/consultation_reminder_use_cases.dart';
import 'package:healthify/features/monitoring/domain/entity/consultation_reminder.dart';
import 'package:healthify/features/monitoring/domain/entity/practitioner_agenda.dart';

import '../../carerelationship/fakes.dart';
import '../agenda_fakes.dart';
import '../reminder_fakes.dart';

final _now = DateTime.utc(2026, 10, 30, 12);

/// Session the test signs in and out by hand.
class _Session implements SessionRepository {
  _Session(this.user);

  SessionUser? user;
  bool loggedIn = true;
  final _loggedIn = StreamController<bool>.broadcast(sync: true);

  void signOut() {
    user = null;
    loggedIn = false;
    _loggedIn.add(false);
  }

  @override
  Stream<SessionUser?> get currentUser => Stream.value(user);

  @override
  Stream<bool> get isLoggedIn async* {
    yield loggedIn;
    yield* _loggedIn.stream;
  }

  @override
  Stream<void> get sessionExpired => const Stream.empty();

  @override
  Future<void> logoutLocally() async => signOut();
}

void main() {
  group('ConsultationReminder', () {
    final visit = DateTime.utc(2026, 11, 2, 15);

    test('fires a day and an hour before, soonest first', () {
      final reminder = ConsultationReminder(followUpId: 1, scheduledFor: visit);

      expect(reminder.triggersAfter(_now), [
        ReminderTrigger(const Duration(hours: 24), DateTime.utc(2026, 11, 1, 15)),
        ReminderTrigger(const Duration(hours: 1), DateTime.utc(2026, 11, 2, 14)),
      ]);
    });

    test('leaves out the reminders that already passed', () {
      final reminder = ConsultationReminder(followUpId: 1, scheduledFor: visit);

      expect(reminder.triggersAfter(DateTime.utc(2026, 11, 2, 9)), [
        ReminderTrigger(const Duration(hours: 1), DateTime.utc(2026, 11, 2, 14)),
      ]);
      expect(reminder.triggersAfter(DateTime.utc(2026, 11, 2, 14)), isEmpty);
    });
  });

  group('RefreshConsultationRemindersUseCase', () {
    late FakePractitionerAgendaRepository agenda;
    late FakeConsultationReminderScheduler scheduler;
    late RefreshConsultationRemindersUseCase refresh;

    setUp(() {
      agenda = FakePractitionerAgendaRepository();
      scheduler = FakeConsultationReminderScheduler();
      refresh = RefreshConsultationRemindersUseCase(agenda, scheduler, () => _now);
    });

    test('reads the visits scheduled from now on and schedules one reminder per visit', () async {
      agenda.agendaResult = Result.success([
        agendaVisit(id: 7, name: 'Ana Flores', scheduledFor: DateTime.utc(2026, 11, 3, 15)),
        agendaVisit(id: 8, name: null, scheduledFor: DateTime.utc(2026, 11, 1, 15)),
      ]);

      final result = await refresh(3);

      expect(result.isSuccess, isTrue);
      expect(agenda.agendaRequests.single, (3, FollowUpState.scheduled, _now));
      expect(scheduler.scheduled, [
        ConsultationReminder(followUpId: 8, scheduledFor: DateTime.utc(2026, 11, 1, 15)),
        ConsultationReminder(followUpId: 7, scheduledFor: DateTime.utc(2026, 11, 3, 15), patientFullName: 'Ana Flores'),
      ]);
    });

    test('with more than 100 visits only the 100 nearest get reminders', () async {
      // 150 visits an hour apart, in no particular order: ids 1..150, the visit with id n is n hours away.
      final ids = [for (var id = 1; id <= 150; id++) id]..shuffle();
      agenda.agendaResult = Result.success([
        for (final id in ids)
          agendaVisit(
            id: id,
            scheduledFor: _now.add(Duration(hours: id)),
          ),
      ]);

      await refresh(3);

      final scheduled = scheduler.scheduled!;
      expect(scheduled, hasLength(RefreshConsultationRemindersUseCase.maxVisits));
      expect(scheduled.map((reminder) => reminder.followUpId), [for (var id = 1; id <= 100; id++) id]);
    });

    test('if the agenda cannot be read the reminders stay as they were', () async {
      agenda.agendaResult = const Result.failure(Network());

      final result = await refresh(3);

      expect(result.errorOrNull, const Network());
      expect(scheduler.replaced, isEmpty);
    });
  });

  group('ConsultationRemindersSync', () {
    late FakePractitionerAgendaRepository agenda;
    late FakeConsultationReminderScheduler scheduler;
    late FakeConnectivity connectivity;
    late _Session session;
    late ConsultationRemindersSync sync;

    setUp(() {
      agenda = FakePractitionerAgendaRepository();
      scheduler = FakeConsultationReminderScheduler();
      connectivity = FakeConnectivity();
      session = _Session(practitionerUser(id: 3));
      sync = ConsultationRemindersSync(
        RefreshConsultationRemindersUseCase(agenda, scheduler, () => _now),
        scheduler,
        ObserveCurrentUserUseCase(session),
        ObserveIsLoggedInUseCase(session),
        connectivity,
      );
    });

    tearDown(() => sync.dispose());

    test('on entering the shell it asks for the permission and schedules the agenda reminders', () async {
      await sync.onShellEntered();

      expect(scheduler.permissionRequests, 1);
      expect(agenda.agendaRequests.single.$1, 3);
      expect(scheduler.scheduled!.single.followUpId, 1);
    });

    test('nobody signed in, or a patient, reads nothing', () async {
      session.signOut();
      await sync.requestRefresh();

      session
        ..user = SessionUser(
          id: practitionerUser().id,
          email: practitionerUser().email,
          name: practitionerUser().name,
          role: UserRole.patient,
          preferredLanguage: practitionerUser().preferredLanguage,
          sessionId: practitionerUser().sessionId,
        )
        ..loggedIn = true;
      await sync.requestRefresh();

      expect(agenda.agendaCalls, 0);
      expect(scheduler.replaced, isEmpty);
    });

    test('ending the session removes the reminders', () async {
      sync.start();
      await sync.requestRefresh();

      session.signOut();
      await pumpEventQueue();

      expect(scheduler.cancelAllCalls, 1);
    });

    test('a read that failed offline is retried when the connection comes back', () async {
      connectivity.set(false);
      sync.start();
      agenda.agendaResult = const Result.failure(Network());
      await sync.requestRefresh();
      expect(scheduler.replaced, isEmpty);

      agenda.agendaResult = Result.success([agendaVisit(id: 4)]);
      connectivity.set(true);
      await pumpEventQueue();

      expect(agenda.agendaCalls, 2);
      expect(scheduler.scheduled!.single.followUpId, 4);
    });

    test('any other failure is not retried on reconnecting', () async {
      connectivity.set(false);
      sync.start();
      agenda.agendaResult = const Result.failure(Unexpected('HTTP_500'));
      await sync.requestRefresh();

      connectivity.set(true);
      await pumpEventQueue();

      expect(agenda.agendaCalls, 1);
    });

    test('signing out while the agenda is read leaves no reminders behind', () async {
      final gate = Completer<Result<List<AgendaVisit>>>();
      agenda.agendaGate = gate;
      final refreshing = sync.requestRefresh();
      await pumpEventQueue();

      session.signOut();
      gate.complete(Result.success([agendaVisit()]));
      await refreshing;

      expect(scheduler.scheduled, isNotNull);
      expect(scheduler.cancelAllCalls, 1);
    });

    test('refreshes run one after another, so the newest agenda is the one left', () async {
      final first = Completer<Result<List<AgendaVisit>>>();
      agenda.agendaGate = first;
      final older = sync.requestRefresh();
      agenda.agendaResult = Result.success([agendaVisit(id: 9)]);
      final newer = sync.requestRefresh();

      first.complete(Result.success([agendaVisit(id: 8)]));
      await Future.wait([older, newer]);

      expect(scheduler.replaced.map((reminders) => reminders.single.followUpId), [8, 9]);
    });
  });
}

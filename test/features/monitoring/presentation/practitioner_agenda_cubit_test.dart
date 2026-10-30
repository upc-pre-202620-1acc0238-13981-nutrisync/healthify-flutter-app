import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/carerelationship/application/usecase/find_active_care_link_use_case.dart';
import 'package:healthify/features/carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import 'package:healthify/features/carerelationship/domain/entity/patient_roster.dart';
import 'package:healthify/features/iam/application/usecase/session_use_cases.dart';
import 'package:healthify/features/monitoring/application/usecase/practitioner_agenda_use_cases.dart';
import 'package:healthify/features/monitoring/domain/entity/practitioner_agenda.dart';
import 'package:healthify/features/monitoring/presentation/cubit/practitioner_agenda_cubit.dart';
import 'package:healthify/features/monitoring/presentation/state/practitioner_agenda_states.dart';

import '../../carerelationship/fakes.dart';
import '../agenda_fakes.dart';

void main() {
  final now = DateTime.utc(2026, 10, 30, 12);
  late FakePractitionerAgendaRepository repository;
  late FakePractitionerCareLinkRepository careLinks;
  late FakeConnectivity connectivity;
  late List<AgendaEvent> events;

  setUp(() {
    repository = FakePractitionerAgendaRepository();
    careLinks = FakePractitionerCareLinkRepository()
      ..rosterResult = Result.success(PatientRoster([rosterPatient(11, 'Ana Flores')]));
    connectivity = FakeConnectivity();
    events = [];
  });

  PractitionerAgendaCubit build({int practitionerId = 3}) {
    final cubit = PractitionerAgendaCubit(
      ObserveCurrentUserUseCase(FakeSessionRepository(practitionerUser(id: practitionerId))),
      GetUpcomingFollowUpsUseCase(repository, () => now),
      CancelFollowUpUseCase(repository),
      FindActiveRosterPatientUseCase(
        ObserveCurrentUserUseCase(FakeSessionRepository(practitionerUser())),
        GetPatientRosterUseCase(careLinks),
      ),
      connectivity,
    );
    cubit.events.listen(events.add);
    return cubit;
  }

  Future<void> settle() => pumpEventQueue();

  group('reading the agenda', () {
    test('it starts loading, with nothing read yet', () async {
      final cubit = build();

      expect(cubit.state.isLoading, isTrue);
      expect(cubit.state.visits, isNull);
      await cubit.close();
    });

    test('asks for the scheduled visits of the signed-in nutritionist from now on, nearest first', () async {
      repository.agendaResult = Result.success([
        agendaVisit(id: 2, name: 'Carlos Quispe', scheduledFor: DateTime.utc(2026, 12, 1, 15)),
        agendaVisit(id: 1, scheduledFor: DateTime.utc(2026, 11, 18, 15)),
      ]);

      final cubit = build(practitionerId: 42);
      await settle();

      expect(repository.agendaRequests.single, (42, FollowUpState.scheduled, now));
      expect(cubit.state.visits!.map((row) => row.followUpId), [1, 2]);
      expect(cubit.state.visits!.first.patientName, 'Ana Flores');
      expect(cubit.state.visits!.first.preparation, isNotEmpty);
      expect(cubit.state.isLoading, isFalse);
      await cubit.close();
    });

    test('an empty agenda is the empty state', () async {
      repository.agendaResult = const Result.success([]);

      final cubit = build();
      await settle();

      expect(cubit.state.isEmpty, isTrue);
      expect(cubit.state.loadFailed, isFalse);
      await cubit.close();
    });

    test('offline with nothing read shows the offline state, and retrying recovers', () async {
      repository.agendaResult = const Result.failure(Network());
      final cubit = build();
      await settle();

      expect(cubit.state.needsConnection, isTrue);

      repository.agendaResult = Result.success([agendaVisit()]);
      cubit.onRetry();
      await settle();

      expect(cubit.state.visits, hasLength(1));
      expect(cubit.state.needsConnection, isFalse);
      await cubit.close();
    });

    test('a server error with nothing read is the error state', () async {
      repository.agendaResult = const Result.failure(Unexpected('HTTP_500'));

      final cubit = build();
      await settle();

      expect(cubit.state.loadFailed, isTrue);
      expect(cubit.state.needsConnection, isFalse);
      await cubit.close();
    });

    test('the connection coming back reloads', () async {
      connectivity.set(false);
      final cubit = build();
      await settle();
      expect(repository.agendaCalls, 1);

      connectivity.set(true);
      await settle();

      expect(repository.agendaCalls, 2);
      await cubit.close();
    });

    test('returning to the tab rereads, but only after a first read', () async {
      final gate = repository.agendaGate = Completer();
      final cubit = build();
      await settle();
      cubit.onResume();
      expect(repository.agendaCalls, 1);

      gate.complete(Result.success([agendaVisit()]));
      await settle();
      cubit.onResume();
      await settle();

      expect(repository.agendaCalls, 2);
      await cubit.close();
    });

    test('a refresh that fails keeps the list on screen', () async {
      final cubit = build();
      await settle();

      repository.agendaResult = const Result.failure(Network());
      cubit.onResume();
      await settle();

      expect(cubit.state.visits, hasLength(1));
      expect(cubit.state.loadFailed, isFalse);
      await cubit.close();
    });

    test('an old answer never overwrites a newer one', () async {
      final slow = repository.agendaGate = Completer();
      final cubit = build();
      await settle();

      repository.agendaResult = Result.success([agendaVisit(id: 7)]);
      cubit.onRetry();
      await settle();
      slow.complete(Result.success([agendaVisit(id: 1)]));
      await settle();

      expect(cubit.state.visits!.single.followUpId, 7);
      await cubit.close();
    });
  });

  group('the visit sheet', () {
    Future<PractitionerAgendaCubit> ready() async {
      final cubit = build();
      await settle();
      cubit.onVisitSelected(cubit.state.visits!.single);
      return cubit;
    }

    test('"Reschedule" hands the visit to the schedule form', () async {
      final cubit = await ready();

      cubit.onReschedule();
      await settle();

      expect(cubit.state.selected, isNull);
      expect(events.single, isA<OpenReschedule>().having((e) => e.row.followUpId, 'visit', 1));
      await cubit.close();
    });

    test('dismissing the sheet forgets the selected visit', () async {
      final cubit = await ready();

      cubit.onSheetDismissed();

      expect(cubit.state.selected, isNull);
      await cubit.close();
    });

    test('"View patient" opens the file with the care link of the roster', () async {
      final cubit = await ready();

      await cubit.onViewPatient();
      await settle();

      expect(
        events.single,
        isA<OpenAgendaPatient>()
            .having((e) => e.patientId, 'patient', 11)
            .having((e) => e.careLinkId, 'care link', 111)
            .having((e) => e.patientName, 'name', 'Ana Flores'),
      );
      expect(cubit.state.isOpeningPatient, isFalse);
      await cubit.close();
    });

    test('a patient without an active link only informs', () async {
      careLinks.rosterResult = Result.success(PatientRoster([rosterPatient(99, 'Otra Persona')]));
      final cubit = await ready();

      await cubit.onViewPatient();

      expect(cubit.state.dialog, AgendaDialog.noActiveLink);
      expect(events, isEmpty);
      cubit.onDialogDismissed();
      expect(cubit.state.dialog, isNull);
      expect(cubit.state.selected, isNull);
      await cubit.close();
    });

    test('a roster that cannot be read shows the server error', () async {
      careLinks.rosterResult = const Result.failure(Network());
      final cubit = await ready();

      await cubit.onViewPatient();

      expect(cubit.state.dialog, AgendaDialog.serverError);
      await cubit.close();
    });
  });

  group('cancelling a visit', () {
    Future<PractitionerAgendaCubit> ready() async {
      repository.agendaResult = Result.success([agendaVisit(id: 1), agendaVisit(id: 2, name: 'Carlos Quispe')]);
      final cubit = build();
      await settle();
      cubit.onVisitSelected(cubit.state.visits!.first);
      cubit.onCancelRequested();
      return cubit;
    }

    test('asks for confirmation first, and keeping the visit brings its sheet back', () async {
      final cubit = await ready();

      expect(cubit.state.dialog, AgendaDialog.confirmCancel);
      cubit.onDialogDismissed();

      expect(cubit.state.dialog, isNull);
      expect(cubit.state.selected, isNotNull);
      expect(repository.cancelled, isEmpty);
      await cubit.close();
    });

    test('cancels the visit, removes it, tells the shell and rereads', () async {
      final cubit = await ready();
      repository.agendaResult = Result.success([agendaVisit(id: 2, name: 'Carlos Quispe')]);

      await cubit.onCancelConfirmed();
      await settle();

      expect(repository.cancelled.single.$1, 1);
      expect(repository.cancelled.single.$2, isNull);
      expect(cubit.state.visits!.map((row) => row.followUpId), [2]);
      expect(cubit.state.dialog, isNull);
      expect(cubit.state.selected, isNull);
      expect(events.single, isA<VisitCancelled>());
      expect(repository.agendaCalls, 2);
      await cubit.close();
    });

    test('a visit that is no longer scheduled says so and rereads', () async {
      for (final failure in <DomainError>[const NotFound(), const Conflict(), const Forbidden()]) {
        final cubit = await ready();
        repository.cancelResult = Result.failure(failure);
        final readsBefore = repository.agendaCalls;

        await cubit.onCancelConfirmed();
        await settle();

        expect(cubit.state.dialog, AgendaDialog.notCancellable, reason: '$failure');
        expect(repository.agendaCalls, readsBefore + 1);
        expect(events, isEmpty);
        await cubit.close();
      }
    });

    test('a network failure offers "Retry", which cancels again', () async {
      final cubit = await ready();
      repository.cancelResult = const Result.failure(Network());
      await cubit.onCancelConfirmed();
      expect(cubit.state.dialog, AgendaDialog.serverError);

      repository.cancelResult = const Result.success(null);
      await cubit.onCancelConfirmed();
      await settle();

      expect(repository.cancelled, hasLength(2));
      expect(events.single, isA<VisitCancelled>());
      await cubit.close();
    });

    test('a second tap while cancelling is ignored', () async {
      final cubit = await ready();

      final first = cubit.onCancelConfirmed();
      final second = cubit.onCancelConfirmed();
      await Future.wait([first, second]);

      expect(repository.cancelled, hasLength(1));
      await cubit.close();
    });
  });
}

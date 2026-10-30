import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import 'package:healthify/features/carerelationship/domain/entity/patient_roster.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/roster_attention.dart';
import 'package:healthify/features/carerelationship/presentation/cubit/patient_roster_cubit.dart';
import 'package:healthify/features/iam/application/usecase/session_use_cases.dart';

import '../fakes.dart';

void main() {
  late FakePractitionerCareLinkRepository repository;
  late FakeConnectivity connectivity;

  setUp(() {
    repository = FakePractitionerCareLinkRepository();
    connectivity = FakeConnectivity();
  });

  PatientRosterCubit build({int practitionerId = 3}) => PatientRosterCubit(
    ObserveCurrentUserUseCase(FakeSessionRepository(practitionerUser(id: practitionerId))),
    GetPatientRosterUseCase(repository),
    connectivity,
  );

  /// Lets the cubit's startup (read the user, subscribe, first load) run to completion.
  Future<void> settle() => pumpEventQueue();

  test('an empty roster is the first-time state', () async {
    repository.rosterResult = const Result.success(PatientRoster([]));

    final cubit = build();
    await settle();

    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.isEmpty, isTrue);
    expect(cubit.state.needsConnection, isFalse);
    await cubit.close();
  });

  test('it starts loading, with nothing read yet', () {
    final cubit = build();

    expect(cubit.state.isLoading, isTrue);
    expect(cubit.state.patients, isNull);
    cubit.close();
  });

  test('lists the patients and marks the new ones', () async {
    repository.rosterResult = Result.success(
      PatientRoster([
        rosterPatient(1, 'Ana Flores'),
        rosterPatient(2, 'Carlos Quispe'),
        rosterPatient(3, 'Luz Ramírez', isNew: true),
      ]),
    );

    final cubit = build();
    await settle();

    final patients = cubit.state.patients!;
    expect(patients.map((p) => p.fullName), ['Ana Flores', 'Carlos Quispe', 'Luz Ramírez']);
    expect(patients.map((p) => p.isNew), [false, false, true]);
    expect(patients.last.careLinkId, 103);
    await cubit.close();
  });

  test('loads the roster of the signed-in practitioner', () async {
    final ids = <int>[];
    final cubit = PatientRosterCubit(
      ObserveCurrentUserUseCase(FakeSessionRepository(practitionerUser(id: 42))),
      GetPatientRosterUseCase(_RecordingRepository(ids)),
      connectivity,
    );
    await settle();

    expect(ids, [42]);
    await cubit.close();
  });

  test('offline without a previous read asks for a connection and reloads when it comes back', () async {
    connectivity.set(false);
    repository.rosterResult = failureOf(const Network());
    final cubit = build();
    await settle();
    expect(cubit.state.needsConnection, isTrue);
    expect(cubit.state.isLoading, isFalse);

    repository.rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
    connectivity.set(true);
    await settle();

    expect(cubit.state.needsConnection, isFalse);
    expect(cubit.state.isOffline, isFalse);
    expect(cubit.state.patients, hasLength(1));
    await cubit.close();
  });

  test('losing the connection with a roster on screen shows the offline flag and keeps the list', () async {
    repository.rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
    final cubit = build();
    await settle();

    connectivity.set(false);
    await settle();

    expect(cubit.state.isOffline, isTrue);
    expect(cubit.state.needsConnection, isFalse);
    expect(cubit.state.patients, hasLength(1));
    await cubit.close();
  });

  test('coming back online reloads the roster', () async {
    repository.rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
    final cubit = build();
    await settle();
    connectivity.set(false);
    await settle();
    expect(repository.rosterCalls, 1);

    repository.rosterResult = Result.success(
      PatientRoster([rosterPatient(1, 'Ana Flores'), rosterPatient(2, 'Carlos Quispe')]),
    );
    connectivity.set(true);
    await settle();

    expect(repository.rosterCalls, 2);
    expect(cubit.state.patients, hasLength(2));
    await cubit.close();
  });

  test('retry reads the roster again after an error', () async {
    repository.rosterResult = failureOf(const Unexpected('HTTP_500'));
    final cubit = build();
    await settle();
    expect(cubit.state.loadFailed, isTrue);
    expect(cubit.state.needsConnection, isFalse);

    repository.rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
    cubit.onRetry();
    await settle();

    expect(cubit.state.loadFailed, isFalse);
    expect(cubit.state.patients, hasLength(1));
    await cubit.close();
  });

  test('keeps the last list when a refresh fails', () async {
    repository.rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
    final cubit = build();
    await settle();

    repository.rosterResult = failureOf(const Unexpected('HTTP_500'));
    cubit.onResume();
    await settle();

    expect(cubit.state.patients, hasLength(1));
    expect(cubit.state.loadFailed, isFalse);
    await cubit.close();
  });

  test('a network failure on refresh marks the roster offline without dropping it', () async {
    repository.rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
    final cubit = build();
    await settle();

    repository.rosterResult = failureOf(const Network());
    cubit.onResume();
    await settle();

    expect(cubit.state.isOffline, isTrue);
    expect(cubit.state.patients, hasLength(1));
    await cubit.close();
  });

  test('resume refreshes only what was already read', () async {
    final gate = Completer<Result<PatientRoster>>();
    repository.rosterGate = gate;
    final cubit = build();
    await settle();

    cubit.onResume();
    expect(repository.rosterCalls, 1, reason: 'nothing on screen yet: the first read is still pending');

    gate.complete(Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')])));
    await settle();
    cubit.onResume();
    await settle();

    expect(repository.rosterCalls, 2);
    await cubit.close();
  });

  test('a slow answer does not overwrite a newer one', () async {
    repository.rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
    final cubit = build();
    await settle();

    final slow = Completer<Result<PatientRoster>>();
    repository.rosterGate = slow;
    cubit.onResume();
    await settle();

    repository.rosterResult = Result.success(
      PatientRoster([rosterPatient(1, 'Ana Flores'), rosterPatient(2, 'Carlos Quispe')]),
    );
    cubit.onRetry();
    await settle();
    expect(cubit.state.patients, hasLength(2));

    slow.complete(Result.success(PatientRoster([rosterPatient(9, 'Respuesta vieja')])));
    await settle();

    expect(cubit.state.patients!.map((p) => p.fullName), ['Ana Flores', 'Carlos Quispe']);
    await cubit.close();
  });

  test('groups patients by action with the first reason by priority, and the rest as up to date', () async {
    repository.rosterResult = Result.success(
      PatientRoster([
        rosterPatient(1, 'Jorge Salas'),
        rosterPatient(2, 'Luz Ramírez', isNew: true, hasBaseline: false),
        rosterPatient(3, 'Carlos Quispe', hasConsultationInProgress: true),
        rosterPatient(4, 'Ana Flores', hasConsultationInProgress: true, hasOpenReviewItem: true),
        rosterPatient(5, 'Rosa Vega', isNew: true),
      ]),
    );

    final cubit = build();
    await settle();
    final state = cubit.state;

    expect(state.needsAction.map((p) => p.fullName), ['Ana Flores', 'Carlos Quispe', 'Luz Ramírez', 'Rosa Vega']);
    expect(state.needsAction.map((p) => p.attention), [
      RosterAttention.openReview,
      RosterAttention.consultationInProgress,
      RosterAttention.missingBaseline,
      RosterAttention.planNotPublished,
    ]);
    expect(state.upToDate.map((p) => p.fullName), ['Jorge Salas']);
    await cubit.close();
  });

  test('rows with the same reason keep the backend order', () async {
    repository.rosterResult = Result.success(
      PatientRoster([
        rosterPatient(1, 'Zoe', hasOpenReviewItem: true),
        rosterPatient(2, 'Ana', hasOpenReviewItem: true),
        rosterPatient(3, 'Mario', hasOpenReviewItem: true),
      ]),
    );

    final cubit = build();
    await settle();

    expect(cubit.state.needsAction.map((p) => p.fullName), ['Zoe', 'Ana', 'Mario']);
    await cubit.close();
  });

  test('search filters by name on the phone, ignoring case and accents, without a new call', () async {
    repository.rosterResult = Result.success(
      PatientRoster([rosterPatient(1, 'Ana Flores'), rosterPatient(2, 'Luz Ramírez', isNew: true)]),
    );
    final cubit = build();
    await settle();

    cubit.onQueryChange('ramirez');

    expect(cubit.state.needsAction.map((p) => p.fullName), ['Luz Ramírez']);
    expect(cubit.state.upToDate, isEmpty);
    expect(repository.rosterCalls, 1);

    cubit.onQueryChange('Zoila');
    expect(cubit.state.noSearchResults, isTrue);

    cubit.onQueryChange('  ');
    expect(cubit.state.noSearchResults, isFalse);
    expect(cubit.state.upToDate.map((p) => p.fullName), ['Ana Flores']);
    await cubit.close();
  });

  test('the up to date row unfolds in place and folds back', () async {
    repository.rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
    final cubit = build();
    await settle();

    cubit.onToggleUpToDate();
    expect(cubit.state.isUpToDateExpanded, isTrue);

    cubit.onToggleUpToDate();
    expect(cubit.state.isUpToDateExpanded, isFalse);
    await cubit.close();
  });
}

class _RecordingRepository extends FakePractitionerCareLinkRepository {
  _RecordingRepository(this.ids);

  final List<int> ids;

  @override
  Future<Result<PatientRoster>> getRoster(int practitionerId) {
    ids.add(practitionerId);
    return super.getRoster(practitionerId);
  }
}

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import 'package:healthify/features/carerelationship/domain/entity/patient_roster.dart';
import 'package:healthify/features/iam/application/usecase/session_use_cases.dart';
import 'package:healthify/features/monitoring/application/usecase/practitioner_agenda_use_cases.dart';
import 'package:healthify/features/monitoring/domain/valueobject/monitoring_values.dart';
import 'package:healthify/features/monitoring/presentation/cubit/schedule_follow_up_cubit.dart';
import 'package:healthify/features/monitoring/presentation/state/practitioner_agenda_states.dart';

import '../../carerelationship/fakes.dart';
import '../agenda_fakes.dart';

void main() {
  // The phone's wall clock: 30 Oct 2026, noon.
  final now = DateTime(2026, 10, 30, 12);
  late FakePractitionerAgendaRepository repository;
  late FakePractitionerCareLinkRepository careLinks;
  late FakeConnectivity connectivity;
  late List<FollowUpSaved> saved;

  setUp(() {
    repository = FakePractitionerAgendaRepository();
    careLinks = FakePractitionerCareLinkRepository()
      ..rosterResult = Result.success(
        PatientRoster([rosterPatient(11, 'Ana Flores'), rosterPatient(12, 'Carlos Quispe')]),
      );
    connectivity = FakeConnectivity();
    saved = [];
  });

  ScheduleFollowUpArgs agendaArgs() =>
      (patientId: 0, patientName: '', followUpId: 0, scheduledFor: null, preparation: const <PreparationCode>{});

  ScheduleFollowUpCubit build([ScheduleFollowUpArgs? args]) {
    final cubit = ScheduleFollowUpCubit(
      ScheduleFollowUpUseCase(repository, () => now),
      RescheduleFollowUpUseCase(repository, () => now),
      GetPatientRosterUseCase(careLinks),
      ObserveCurrentUserUseCase(FakeSessionRepository(practitionerUser())),
      connectivity,
      () => now,
      args: args ?? agendaArgs(),
    );
    cubit.events.listen(saved.add);
    return cubit;
  }

  Future<void> settle() => pumpEventQueue();

  group('opening the form', () {
    test('from the Agenda it has no patient and lists the active ones from the roster', () async {
      careLinks.rosterResult = Result.success(
        PatientRoster([
          rosterPatient(11, 'Ana Flores'),
          RosterPatient(
            patientId: 13,
            careLinkId: rosterPatient(13, 'x').careLinkId,
            fullName: 'Ya Dada De Alta',
            linkedSince: DateTime.utc(2026),
            isLinkActive: false,
            hasBaseline: true,
            isNew: false,
            hasConsultationInProgress: false,
          ),
        ]),
      );

      final cubit = build();
      await settle();

      expect(cubit.state.patient, isNull);
      expect(cubit.state.patientFixed, isFalse);
      expect(cubit.state.patients!.map((p) => p.fullName), ['Ana Flores']);
      expect(cubit.state.isRescheduling, isFalse);
      await cubit.close();
    });

    test('from the patient file the patient is fixed and the roster is not read', () async {
      final cubit = build((
        patientId: 11,
        patientName: 'Ana Flores',
        followUpId: 0,
        scheduledFor: null,
        preparation: const <PreparationCode>{},
      ));
      await settle();

      expect(cubit.state.patient!.fullName, 'Ana Flores');
      expect(cubit.state.patientFixed, isTrue);
      expect(cubit.state.patients, isNull);
      expect(careLinks.rosterCalls, 0);
      await cubit.close();
    });

    test('rescheduling starts from the previous date, time and preparation', () async {
      final previous = DateTime(2026, 11, 18, 10, 30).toUtc();

      final cubit = build((
        patientId: 11,
        patientName: 'Ana Flores',
        followUpId: 5,
        scheduledFor: previous,
        preparation: const {PreparationCode.fasting, PreparationCode.emptyBladder},
      ));
      await settle();

      expect(cubit.state.isRescheduling, isTrue);
      expect(cubit.state.rescheduleId, 5);
      expect(cubit.state.date, DateTime(2026, 11, 18));
      expect(cubit.state.time, const TimeOfDay(hour: 10, minute: 30));
      expect(cubit.state.preparation, {PreparationCode.fasting, PreparationCode.emptyBladder});
      await cubit.close();
    });

    test('tapping the patient field reads the roster again if the first read failed', () async {
      careLinks.rosterResult = const Result.failure(Network());
      final cubit = build();
      await settle();
      expect(cubit.state.patients, isNull);

      careLinks.rosterResult = Result.success(PatientRoster([rosterPatient(11, 'Ana Flores')]));
      cubit.onPatientFieldClick();
      await settle();

      expect(cubit.state.patients, hasLength(1));
      await cubit.close();
    });
  });

  group('scheduling', () {
    Future<ScheduleFollowUpCubit> filled() async {
      final cubit = build();
      await settle();
      cubit
        ..onPatientSelected(cubit.state.patients!.first)
        ..onDateSelected(DateTime(2026, 11, 18, 5, 5))
        ..onTimeSelected(const TimeOfDay(hour: 10, minute: 0));
      return cubit;
    }

    test('sends the patient, the moment and the preparation in catalog order, in person', () async {
      final cubit = await filled();
      cubit
        ..onPreparationToggle(PreparationCode.emptyBladder, true)
        ..onPreparationToggle(PreparationCode.fasting, true)
        ..onPreparationToggle(PreparationCode.lightClothing, true)
        ..onPreparationToggle(PreparationCode.lightClothing, false);

      await cubit.onSubmit();
      await settle();

      final sent = repository.scheduled.single;
      expect(sent.patientId.value, 11);
      expect(sent.scheduledFor, DateTime(2026, 11, 18, 10).toUtc());
      expect(sent.preparation.orderedCodes, [PreparationCode.fasting, PreparationCode.emptyBladder]);
      expect(sent.modality, ConsultationModality.inPerson);
      expect(saved.single.rescheduled, isFalse);
      expect(saved.single.scheduledFor, DateTime(2026, 11, 18, 10).toUtc());
      await cubit.close();
    });

    test('without a patient, a date or a time it marks them and sends nothing', () async {
      final cubit = build();
      await settle();

      await cubit.onSubmit();

      expect(cubit.state.patientError, SchedulePatientError.missing);
      expect(cubit.state.momentError, ScheduleMomentError.missing);
      expect(repository.scheduled, isEmpty);

      cubit.onDateSelected(DateTime(2026, 11, 18));
      expect(cubit.state.momentError, isNull);
      await cubit.close();
    });

    test('a date and time that already passed are rejected on the phone', () async {
      final cubit = await filled();
      cubit
        ..onDateSelected(DateTime(2026, 10, 30))
        ..onTimeSelected(const TimeOfDay(hour: 11, minute: 59));

      await cubit.onSubmit();

      expect(cubit.state.momentError, ScheduleMomentError.notInFuture);
      expect(repository.scheduled, isEmpty);
      await cubit.close();
    });

    test('the same minute as now is not in the future either', () async {
      final cubit = await filled();
      cubit
        ..onDateSelected(DateTime(2026, 10, 30))
        ..onTimeSelected(const TimeOfDay(hour: 12, minute: 0));

      await cubit.onSubmit();

      expect(cubit.state.momentError, ScheduleMomentError.notInFuture);
      await cubit.close();
    });

    test('the backend rejecting the moment marks the moment, also with the older 404', () async {
      for (final failure in <DomainError>[
        const Validation('ScheduledForMustBeInFuture'),
        const NotFound('ScheduledFollowUpNotFound'),
      ]) {
        repository.scheduleResult = Result.failure(failure);
        final cubit = await filled();

        await cubit.onSubmit();

        expect(cubit.state.momentError, ScheduleMomentError.notInFuture, reason: '$failure');
        expect(cubit.state.failed, isFalse);
        await cubit.close();
      }
    });

    test('a patient who already has a visit, or no active link, is marked on the patient', () async {
      repository.scheduleResult = const Result.failure(Conflict('PatientAlreadyHasActiveScheduledFollowUp'));
      var cubit = await filled();
      await cubit.onSubmit();
      expect(cubit.state.patientError, SchedulePatientError.alreadyScheduled);
      await cubit.close();

      repository.scheduleResult = const Result.failure(Forbidden('ActiveCareLinkRequired'));
      cubit = await filled();
      await cubit.onSubmit();
      expect(cubit.state.patientError, SchedulePatientError.noActiveLink);
      await cubit.close();
    });

    test('any other failure shows "Could not schedule" and keeps what was written', () async {
      repository.scheduleResult = const Result.failure(Network());
      final cubit = await filled();
      cubit.onPreparationToggle(PreparationCode.fasting, true);

      await cubit.onSubmit();
      expect(cubit.state.failed, isTrue);
      expect(cubit.state.isSaving, isFalse);

      cubit.onBackToForm();
      expect(cubit.state.failed, isFalse);
      expect(cubit.state.patient!.fullName, 'Ana Flores');
      expect(cubit.state.time, const TimeOfDay(hour: 10, minute: 0));
      expect(cubit.state.preparation, {PreparationCode.fasting});
      await cubit.close();
    });

    test('a second tap while saving is ignored', () async {
      final cubit = await filled();

      final first = cubit.onSubmit();
      final second = cubit.onSubmit();
      await Future.wait([first, second]);

      expect(repository.scheduled, hasLength(1));
      await cubit.close();
    });
  });

  group('rescheduling', () {
    ScheduleFollowUpArgs rescheduleArgs() => (
      patientId: 11,
      patientName: 'Ana Flores',
      followUpId: 5,
      scheduledFor: DateTime(2026, 11, 18, 10).toUtc(),
      preparation: const {PreparationCode.fasting},
    );

    test('moves the visit and replaces the preparation', () async {
      final cubit = build(rescheduleArgs());
      await settle();
      cubit
        ..onDateSelected(DateTime(2026, 11, 20))
        ..onTimeSelected(const TimeOfDay(hour: 16, minute: 45))
        ..onPreparationToggle(PreparationCode.fasting, false)
        ..onPreparationToggle(PreparationCode.bringBloodTests, true);

      await cubit.onSubmit();
      await settle();

      final (id, moment, preparation) = repository.rescheduled.single;
      expect(id, 5);
      expect(moment, DateTime(2026, 11, 20, 16, 45).toUtc());
      expect(preparation.orderedCodes, [PreparationCode.bringBloodTests]);
      expect(repository.scheduled, isEmpty);
      expect(saved.single.rescheduled, isTrue);
      await cubit.close();
    });

    test('an old backend 404 is not read as a past date when rescheduling', () async {
      repository.rescheduleResult = const Result.failure(NotFound('ScheduledFollowUpNotFound'));
      final cubit = build(rescheduleArgs());
      await settle();

      await cubit.onSubmit();

      expect(cubit.state.momentError, isNull);
      expect(cubit.state.failed, isTrue);
      await cubit.close();
    });

    test('a past moment is rejected on the phone as well', () async {
      final cubit = build(rescheduleArgs());
      await settle();
      cubit.onDateSelected(DateTime(2026, 10, 29));

      await cubit.onSubmit();

      expect(cubit.state.momentError, ScheduleMomentError.notInFuture);
      expect(repository.rescheduled, isEmpty);
      await cubit.close();
    });
  });

  test('the first selectable day is today', () async {
    final cubit = build();

    expect(cubit.today, DateTime(2026, 10, 30));
    await cubit.close();
  });

  test('offline is reflected, so the screen can warn', () async {
    connectivity.set(false);
    final cubit = build();
    await settle();

    expect(cubit.state.isOffline, isTrue);
    await cubit.close();
  });
}

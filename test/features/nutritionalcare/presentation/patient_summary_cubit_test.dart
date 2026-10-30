import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_summary.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/patient_summary_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/patient_tab_states.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakePatientSummaryRepository repository;
  late FakeConsultationRepository consultations;
  late FakeConnectivity connectivity;
  late List<PatientTabEvent> events;
  final now = DateTime(2026, 10, 30, 9);

  setUp(() {
    repository = FakePatientSummaryRepository();
    consultations = FakeConsultationRepository();
    connectivity = FakeConnectivity();
  });

  PatientSummaryCubit build() {
    final cubit = PatientSummaryCubit(
      GetPatientSummaryUseCase(repository),
      StartOrResumeConsultationUseCase(consultations),
      connectivity,
      () => now,
      patientId: 7,
    );
    events = [];
    cubit.events.listen(events.add);
    return cubit;
  }

  ConsultationInProgress inProgress(ConsultationStep step) =>
      ConsultationInProgress(id: ConsultationId(9), step: step, lastSavedAt: DateTime.utc(2026, 10, 30, 14));

  test('it starts loading, with nothing read yet', () {
    final cubit = build();

    expect(cubit.state.isLoading, isTrue);
    expect(cubit.state.summary, isNull);
    cubit.close();
  });

  test('loads the summary of the patient', () async {
    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.loadFailed, isFalse);
    expect(cubit.state.summary!.fullName, 'Ana Flores');
    expect(repository.calls, 1);
    await cubit.close();
  });

  test('a patient without a baseline loads too, ready for the empty state', () async {
    repository.result = Result.success(summary(withBaseline: false, activePlanVersion: null));

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.summary!.hasBaseline, isFalse);
    expect(cubit.state.summary!.isNew, isTrue);
    await cubit.close();
  });

  test('offline with nothing read asks for a connection', () async {
    repository.result = const Result.failure(Network());

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.loadFailed, isTrue);
    expect(cubit.state.isOffline, isTrue);
    expect(cubit.state.summary, isNull);
    await cubit.close();
  });

  test('a server error is an error state, not an offline one', () async {
    repository.result = const Result.failure(Unexpected('HTTP_500'));

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.loadFailed, isTrue);
    expect(cubit.state.isOffline, isFalse);
    await cubit.close();
  });

  test('retry reads again and recovers', () async {
    repository.result = const Result.failure(Unexpected('HTTP_500'));
    final cubit = build();
    await pumpEventQueue();

    repository.result = Result.success(summary());
    cubit.onRetry();
    await pumpEventQueue();

    expect(cubit.state.loadFailed, isFalse);
    expect(cubit.state.summary, isNotNull);
    await cubit.close();
  });

  test('coming back to the tab refreshes what is on screen', () async {
    final cubit = build();
    await pumpEventQueue();

    repository.result = Result.success(summary(fullName: 'Ana M. Flores'));
    cubit.onResume();
    await pumpEventQueue();

    expect(repository.calls, 2);
    expect(cubit.state.summary!.fullName, 'Ana M. Flores');
    await cubit.close();
  });

  test('before the first read there is nothing to refresh', () async {
    final gate = Completer<Result<PatientSummary>>();
    repository.gate = gate;
    final cubit = build();

    cubit.onResume();

    expect(repository.calls, 1);
    gate.complete(Result.success(summary()));
    await pumpEventQueue();
    await cubit.close();
  });

  test('a refresh that fails keeps the last summary', () async {
    final cubit = build();
    await pumpEventQueue();

    repository.result = const Result.failure(Unexpected('HTTP_500'));
    cubit.onResume();
    await pumpEventQueue();

    expect(cubit.state.summary, isNotNull);
    expect(cubit.state.loadFailed, isFalse);
    await cubit.close();
  });

  test('reloads when the connection comes back, and not when it was never lost', () async {
    final cubit = build();
    await pumpEventQueue();
    expect(repository.calls, 1);

    connectivity.set(true);
    await pumpEventQueue();
    expect(repository.calls, 1);

    connectivity.set(false);
    await pumpEventQueue();
    expect(cubit.state.isOffline, isTrue);

    connectivity.set(true);
    await pumpEventQueue();
    expect(cubit.state.isOffline, isFalse);
    expect(repository.calls, 2);
    await cubit.close();
  });

  test('an old answer that arrives late does not overwrite the newer one', () async {
    final slow = Completer<Result<PatientSummary>>();
    repository.gate = slow;
    final cubit = build();
    await pumpEventQueue();

    repository.result = Result.success(summary(fullName: 'Nuevo'));
    cubit.onRetry();
    await pumpEventQueue();
    slow.complete(Result.success(summary(fullName: 'Viejo')));
    await pumpEventQueue();

    expect(cubit.state.summary!.fullName, 'Nuevo');
    await cubit.close();
  });

  group('the pinned button', () {
    test('no baseline: record it, without starting anything', () async {
      repository.result = Result.success(summary(withBaseline: false, activePlanVersion: null));

      final cubit = build();
      await pumpEventQueue();
      cubit.onPrimaryAction();
      await pumpEventQueue();

      expect(events.single, isA<OpenBaseline>().having((e) => e.editing, 'editing', isFalse));
      expect(consultations.startedWith, isEmpty);
      await cubit.close();
    });

    test('before the summary is read it does nothing', () async {
      final gate = Completer<Result<PatientSummary>>();
      repository.gate = gate;
      final cubit = build();

      cubit.onPrimaryAction();
      await pumpEventQueue();

      expect(events, isEmpty);
      expect(consultations.startedWith, isEmpty);
      gate.complete(Result.success(summary()));
      await pumpEventQueue();
      await cubit.close();
    });

    test('a consultation in progress: continue it at its step, without starting another', () async {
      repository.result = Result.success(summary(inProgress: inProgress(ConsultationStep.diagnosis)));

      final cubit = build();
      await pumpEventQueue();
      cubit.onPrimaryAction();
      await pumpEventQueue();

      expect(events.single, isA<OpenConsultation>().having((e) => e.step, 'step', ConsultationStep.diagnosis));
      expect(consultations.startedWith, isEmpty);
      await cubit.close();
    });

    test('otherwise a new consultation starts and opens on its step', () async {
      final cubit = build();
      await pumpEventQueue();
      cubit.onPrimaryAction();
      expect(cubit.state.isStartingConsultation, isTrue);
      await pumpEventQueue();

      expect(consultations.startedWith, [null]);
      expect(events.single, isA<OpenConsultation>().having((e) => e.step, 'step', ConsultationStep.measurement));
      expect(cubit.state.isStartingConsultation, isFalse);
      await cubit.close();
    });

    test('an appointment today, from the summary, is linked to the new consultation', () async {
      repository.result = Result.success(
        summary(nextFollowUp: SummaryFollowUp(4, DateTime(2026, 10, 30, 17).toUtc())),
      );

      final cubit = build();
      await pumpEventQueue();
      cubit.onPrimaryAction();
      await pumpEventQueue();

      expect(consultations.startedWith, [4]);
      await cubit.close();
    });

    test('an appointment on another day is not linked', () async {
      repository.result = Result.success(
        summary(nextFollowUp: SummaryFollowUp(4, DateTime(2026, 11, 2, 10).toUtc())),
      );

      final cubit = build();
      await pumpEventQueue();
      cubit.onPrimaryAction();
      await pumpEventQueue();

      expect(consultations.startedWith, [null]);
      await cubit.close();
    });

    test('422 BaselineRequired sends the practitioner to the baseline', () async {
      consultations.startResult = const Result.failure(Validation('BaselineRequired'));

      final cubit = build();
      await pumpEventQueue();
      cubit.onPrimaryAction();
      await pumpEventQueue();

      expect(events.single, isA<OpenBaseline>().having((e) => e.editing, 'editing', isFalse));
      expect(cubit.state.showStartError, isFalse);
      await cubit.close();
    });

    test('any other failure shows the notice, and retry starts again', () async {
      consultations.startResult = const Result.failure(Unexpected('HTTP_500'));
      final cubit = build();
      await pumpEventQueue();
      cubit.onPrimaryAction();
      await pumpEventQueue();
      expect(cubit.state.showStartError, isTrue);
      expect(events, isEmpty);

      consultations.startResult = Result.success(consultation());
      cubit.onRetryStart();
      await pumpEventQueue();

      expect(cubit.state.showStartError, isFalse);
      expect(consultations.startedWith, hasLength(2));
      expect(events.single, isA<OpenConsultation>());
      await cubit.close();
    });

    test('dismissing the notice clears it', () async {
      consultations.startResult = const Result.failure(Unexpected('HTTP_500'));
      final cubit = build();
      await pumpEventQueue();
      cubit.onPrimaryAction();
      await pumpEventQueue();

      cubit.onStartErrorDismissed();

      expect(cubit.state.showStartError, isFalse);
      await cubit.close();
    });

    test('a second tap while starting does nothing', () async {
      final cubit = build();
      await pumpEventQueue();

      cubit.onPrimaryAction();
      cubit.onPrimaryAction();
      await pumpEventQueue();

      expect(consultations.startedWith, hasLength(1));
      await cubit.close();
    });

    test('closing while it starts drops the answer', () async {
      final gate = consultations.startGate = Completer<void>();
      final cubit = build();
      await pumpEventQueue();

      cubit.onPrimaryAction();
      await cubit.close();
      gate.complete();
      await pumpEventQueue();

      expect(events, isEmpty);
    });
  });

  test('"Edit" asks to open the baseline form editing', () async {
    final cubit = build();
    await pumpEventQueue();

    cubit.onEditBaseline();
    await pumpEventQueue();

    expect(events.single, isA<OpenBaseline>().having((e) => e.editing, 'editing', isTrue));
    await cubit.close();
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/clinical_reason.dart';
import 'package:healthify/features/carerelationship/presentation/cubit/discharge_patient_cubit.dart';
import 'package:healthify/features/carerelationship/presentation/state/discharge_patient_state.dart';

import '../fakes.dart';

void main() {
  late FakePractitionerCareLinkRepository repository;

  setUp(() => repository = FakePractitionerCareLinkRepository());

  DischargePatientCubit build() => DischargePatientCubit(
    DischargePatientUseCase(repository),
    FakeConnectivity(),
    careLinkId: 8,
    patientName: 'Ana Flores',
  );

  test('the clinical reason is required and blank text is not a reason', () {
    expect(ClinicalReason.of('   '), isNull);
    expect(ClinicalReason.of(' Objetivos alcanzados ')?.text, 'Objetivos alcanzados');
  });

  test('without a reason the confirmation does not open', () async {
    final cubit = build()..onDischargeRequested();

    expect(cubit.state.reasonMissing, isTrue);
    expect(cubit.state.dialog, isNull);
    expect(repository.discharges, isEmpty);
    await cubit.close();
  });

  test('typing a reason clears the missing-reason error', () async {
    final cubit = build()
      ..onDischargeRequested()
      ..onReasonChange('Objetivos');

    expect(cubit.state.reasonMissing, isFalse);
    await cubit.close();
  });

  test('confirms first and then discharges with the reason', () async {
    final cubit = build()
      ..onReasonChange('Objetivos alcanzados')
      ..onDischargeRequested();
    expect(cubit.state.dialog, DischargeDialog.confirm);
    expect(repository.discharges, isEmpty);

    final event = cubit.events.first;
    await cubit.onConfirmed();

    expect(await event, isA<Discharged>().having((e) => e.patientName, 'patientName', 'Ana Flores'));
    expect(repository.discharges, [(8, 'Objetivos alcanzados')]);
    expect(cubit.state.dialog, isNull);
    expect(cubit.state.isDischarging, isFalse);
    await cubit.close();
  });

  test('an already discharged link says so, and acknowledging it returns like a discharge', () async {
    repository.dischargeResult = failureOf(const Conflict('DischargedLinkCannotBeReactivated'));
    final cubit = build()..onReasonChange('Objetivos alcanzados');

    await cubit.onConfirmed();
    expect(cubit.state.dialog, DischargeDialog.alreadyDischarged);

    final event = cubit.events.first;
    cubit.onAlreadyDischargedConfirmed();

    expect(await event, isA<Discharged>());
    expect(cubit.state.dialog, isNull);
    await cubit.close();
  });

  test('a link that is not the practitioner\'s, or is gone, says there is no active link', () async {
    for (final error in const [Forbidden('PractitionerOnly'), NotFound('CareLinkNotFound')]) {
      repository.dischargeResult = failureOf(error);
      final cubit = build()..onReasonChange('Objetivos alcanzados');

      await cubit.onConfirmed();

      expect(cubit.state.dialog, DischargeDialog.noActiveLink, reason: '$error');
      await cubit.close();
    }
  });

  test('a network or server failure offers to retry, and retrying sends again', () async {
    repository.dischargeResult = failureOf(const Network());
    final cubit = build()..onReasonChange('Objetivos alcanzados');

    await cubit.onConfirmed();
    expect(cubit.state.dialog, DischargeDialog.serverError);

    repository.dischargeResult = const Result.success(null);
    await cubit.onConfirmed();

    expect(cubit.state.dialog, isNull);
    expect(repository.discharges, hasLength(2));
    await cubit.close();
  });

  test('the backend rejecting an empty reason sends the person back to the field', () async {
    repository.dischargeResult = failureOf(const Validation('ClinicalReasonRequired'));
    final cubit = build()..onReasonChange('Objetivos alcanzados');

    await cubit.onConfirmed();

    expect(cubit.state.reasonMissing, isTrue);
    expect(cubit.state.dialog, isNull);
    await cubit.close();
  });

  test('dismissing a dialog closes it', () async {
    final cubit = build()
      ..onReasonChange('Objetivos alcanzados')
      ..onDischargeRequested()
      ..onDialogDismissed();

    expect(cubit.state.dialog, isNull);
    await cubit.close();
  });

  test('tracks the connection for the offline banner', () async {
    final connectivity = FakeConnectivity();
    final cubit = DischargePatientCubit(
      DischargePatientUseCase(repository),
      connectivity,
      careLinkId: 8,
      patientName: 'Ana Flores',
    );
    await pumpEventQueue();

    connectivity.set(false);
    await pumpEventQueue();

    expect(cubit.state.isOffline, isTrue);
    await cubit.close();
  });
}

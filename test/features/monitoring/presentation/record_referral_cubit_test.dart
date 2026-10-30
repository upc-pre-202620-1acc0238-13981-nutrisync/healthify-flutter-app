import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/monitoring/application/usecase/practitioner_agenda_use_cases.dart';
import 'package:healthify/features/monitoring/domain/entity/referral.dart';
import 'package:healthify/features/monitoring/presentation/cubit/record_referral_cubit.dart';

import '../../carerelationship/fakes.dart';
import '../agenda_fakes.dart';

void main() {
  late FakePractitionerAgendaRepository repository;
  late FakeConnectivity connectivity;
  late List<String> recorded;

  setUp(() {
    repository = FakePractitionerAgendaRepository();
    connectivity = FakeConnectivity();
    recorded = [];
  });

  RecordReferralCubit build() {
    final cubit = RecordReferralCubit(RecordReferralUseCase(repository), connectivity, patientId: 11);
    cubit.recorded.listen(recorded.add);
    return cubit;
  }

  Future<void> settle() => pumpEventQueue();

  test('records the trimmed specialty and reason for the patient and reports the specialty', () async {
    final cubit = build();
    cubit
      ..onSpecialtyChange('  Endocrinología ')
      ..onReasonChange(' Hipotiroidismo sin control ');

    await cubit.onSubmit();
    await settle();

    final sent = repository.referrals.single;
    expect(sent.patientId.value, 11);
    expect(sent.specialty.text, 'Endocrinología');
    expect(sent.reason.text, 'Hipotiroidismo sin control');
    expect(recorded, ['Endocrinología']);
    expect(cubit.state.isSaving, isFalse);
    await cubit.close();
  });

  test('empty or blank fields are marked and nothing is sent', () async {
    final cubit = build();
    cubit.onReasonChange('   ');

    await cubit.onSubmit();

    expect(cubit.state.missing, {ReferralField.specialty, ReferralField.reason});
    expect(repository.referrals, isEmpty);

    cubit.onSpecialtyChange('Cardiología');
    expect(cubit.state.missing, {ReferralField.reason});
    cubit.onReasonChange('Soplo');
    expect(cubit.state.missing, isEmpty);
    await cubit.close();
  });

  test('the fields are cut at their maximum length', () async {
    final cubit = build();

    cubit
      ..onSpecialtyChange('a' * 200)
      ..onReasonChange('b' * 1200);

    expect(cubit.state.specialty.length, ReferralSpecialty.maxLength);
    expect(cubit.state.reason.length, ReferralReason.maxLength);
    await cubit.close();
  });

  test('the backend asking for both fields marks both', () async {
    repository.referralResult = const Result.failure(Validation('SpecialtyAndReasonRequired'));
    final cubit = build();
    cubit
      ..onSpecialtyChange('Cardiología')
      ..onReasonChange('Soplo');

    await cubit.onSubmit();

    expect(cubit.state.missing, {ReferralField.specialty, ReferralField.reason});
    expect(cubit.state.failed, isFalse);
    expect(recorded, isEmpty);
    await cubit.close();
  });

  test('a missing care link only informs, and what was written is kept', () async {
    repository.referralResult = const Result.failure(Forbidden('ActiveCareLinkRequired'));
    final cubit = build();
    cubit
      ..onSpecialtyChange('Cardiología')
      ..onReasonChange('Soplo');

    await cubit.onSubmit();
    expect(cubit.state.noActiveLink, isTrue);

    cubit.onNoActiveLinkDismissed();
    expect(cubit.state.noActiveLink, isFalse);
    expect(cubit.state.specialty, 'Cardiología');
    expect(cubit.state.reason, 'Soplo');
    await cubit.close();
  });

  test('any other failure shows the error and "Try again" returns to the form with what was written', () async {
    repository.referralResult = const Result.failure(Network());
    final cubit = build();
    cubit
      ..onSpecialtyChange('Cardiología')
      ..onReasonChange('Soplo');

    await cubit.onSubmit();
    expect(cubit.state.failed, isTrue);
    expect(cubit.state.isSaving, isFalse);

    cubit.onBackToForm();
    expect(cubit.state.failed, isFalse);
    expect(cubit.state.reason, 'Soplo');

    repository.referralResult = const Result.success(null);
    await cubit.onSubmit();
    await settle();
    expect(recorded, ['Cardiología']);
    await cubit.close();
  });

  test('a second tap while saving is ignored', () async {
    final cubit = build();
    cubit
      ..onSpecialtyChange('Cardiología')
      ..onReasonChange('Soplo');

    final first = cubit.onSubmit();
    final second = cubit.onSubmit();
    await Future.wait([first, second]);

    expect(repository.referrals, hasLength(1));
    await cubit.close();
  });
}

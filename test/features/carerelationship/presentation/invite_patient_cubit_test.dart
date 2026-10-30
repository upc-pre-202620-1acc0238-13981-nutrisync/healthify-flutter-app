import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/invitation_validity.dart';
import 'package:healthify/features/carerelationship/presentation/cubit/invite_patient_cubit.dart';
import 'package:healthify/features/carerelationship/presentation/state/invite_patient_state.dart';

import '../fakes.dart';

void main() {
  late FakePractitionerCareLinkRepository repository;
  late FakeConnectivity connectivity;
  late DateTime now;

  setUp(() {
    repository = FakePractitionerCareLinkRepository();
    connectivity = FakeConnectivity();
    now = fixedNow;
  });

  InvitePatientCubit build() =>
      InvitePatientCubit(IssueInvitationUseCase(repository, () => now), connectivity, () => now);

  test('generates a code valid for 24 hours on entry and counts down', () async {
    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.isGenerating, isFalse);
    expect(cubit.state.token?.value, validToken);
    expect(cubit.state.remaining, const Duration(hours: 24));
    expect(repository.issuedExpirations, [fixedNow.add(const Duration(hours: 24))]);
    await cubit.close();
  });

  test('changing the validity issues a new code with it', () async {
    final cubit = build();
    await pumpEventQueue();

    await cubit.onValidityChange(InvitationValidity.oneHour);

    expect(repository.issuedExpirations.last, fixedNow.add(const Duration(hours: 1)));
    expect(cubit.state.validity, InvitationValidity.oneHour);
    await cubit.close();
  });

  test('picking the validity already in use does not issue another code', () async {
    final cubit = build();
    await pumpEventQueue();

    await cubit.onValidityChange(InvitationValidity.oneDay);

    expect(repository.issuedExpirations, hasLength(1));
    await cubit.close();
  });

  test('generate another code issues a second invitation', () async {
    final cubit = build();
    await pumpEventQueue();
    repository.invitationResult = Result.success(invitation(id: 6));

    await cubit.onGenerateAnother();

    expect(repository.issuedExpirations, hasLength(2));
    await cubit.close();
  });

  test('an expired code is shown as expired', () async {
    repository.invitationResult = Result.success(invitation(expiresAt: fixedNow));

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.isExpired, isTrue);
    expect(cubit.state.remaining, Duration.zero);
    await cubit.close();
  });

  test('offline on entry does not call the backend and shows the notes text', () async {
    connectivity.set(false);

    final cubit = build();
    await pumpEventQueue();

    expect(cubit.state.error, InviteError.offline);
    expect(cubit.state.token, isNull);
    expect(cubit.state.isGenerating, isFalse);
    expect(repository.issuedExpirations, isEmpty);
    await cubit.close();
  });

  test('errors map to the notes texts', () async {
    repository.invitationResult = failureOf(const Validation('ExpirationDateRequired'));
    var cubit = build();
    await pumpEventQueue();
    expect(cubit.state.error, InviteError.expirationRequired);
    await cubit.close();

    repository.invitationResult = failureOf(const Forbidden('PractitionerOnly'));
    cubit = build();
    await pumpEventQueue();
    expect(cubit.state.error, InviteError.generic);
    await cubit.close();

    repository.invitationResult = failureOf(const Network());
    cubit = build();
    await pumpEventQueue();
    expect(cubit.state.error, InviteError.offline);
    await cubit.close();
  });

  test('retry after an error issues the code again', () async {
    repository.invitationResult = failureOf(const Unexpected('HTTP_500'));
    final cubit = build();
    await pumpEventQueue();
    expect(cubit.state.error, InviteError.generic);

    repository.invitationResult = Result.success(invitation());
    await cubit.onGenerateAnother();

    expect(cubit.state.error, isNull);
    expect(cubit.state.token, isNotNull);
    await cubit.close();
  });

  test('the countdown ticks with the phone clock and flags the code as expired at the end', () async {
    repository.invitationResult = Result.success(invitation(expiresAt: fixedNow.add(const Duration(seconds: 3))));
    final cubit = InvitePatientCubit(
      IssueInvitationUseCase(repository, () => now),
      connectivity,
      () => now,
      tick: const Duration(milliseconds: 5),
    );
    await pumpEventQueue();
    expect(cubit.state.remaining, const Duration(seconds: 3));

    now = now.add(const Duration(seconds: 2));
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(cubit.state.remaining, const Duration(seconds: 1));
    expect(cubit.state.isExpired, isFalse);

    now = now.add(const Duration(seconds: 1));
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(cubit.state.isExpired, isTrue);
    expect(cubit.state.remaining, Duration.zero);
    await cubit.close();
  });
}

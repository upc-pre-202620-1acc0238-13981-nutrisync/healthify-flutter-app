import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/carerelationship/application/usecase/find_active_care_link_use_case.dart';
import 'package:healthify/features/carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import 'package:healthify/features/carerelationship/domain/entity/patient_roster.dart';
import 'package:healthify/features/iam/application/usecase/session_use_cases.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/review_inbox_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_proposal.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/review_values.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/review_item_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/review_states.dart';

import '../../carerelationship/fakes.dart';
import '../review_fakes.dart';

void main() {
  late FakeReviewInboxRepository repository;
  late FakePractitionerCareLinkRepository careLinks;
  late FakeConnectivity connectivity;
  late List<ReviewItemEvent> events;

  setUp(() {
    repository = FakeReviewInboxRepository()
      ..itemsResult = Result.success([reviewItem()])
      ..proposalAnswers.clear();
    careLinks = FakePractitionerCareLinkRepository()
      ..rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
    connectivity = FakeConnectivity();
    events = [];
  });

  ReviewItemCubit build({int id = 1}) {
    final cubit = ReviewItemCubit(
      GetOpenReviewItemUseCase(repository),
      AwaitPlanProposalUseCase(repository, wait: (_) async {}),
      ResolveReviewItemUseCase(repository),
      AcceptPlanProposalUseCase(repository),
      FindActiveRosterPatientUseCase(
        ObserveCurrentUserUseCase(FakeSessionRepository(practitionerUser())),
        GetPatientRosterUseCase(careLinks),
      ),
      connectivity,
      reviewItemId: id,
    );
    cubit.events.listen(events.add);
    return cubit;
  }

  Future<void> settle() => pumpEventQueue();

  void withProposal({List<Result<PlanProposalLookup>>? answers}) {
    repository.itemsResult = Result.success([reviewItem(hasPlanProposal: true)]);
    repository.proposalAnswers
      ..clear()
      ..addAll(answers ?? [Result.success(ProposalReady(proposal()))]);
  }

  group('opening an item', () {
    test('a signal without an AI proposal shows the resolution form', () async {
      repository.itemsResult = Result.success([reviewItem(signal: const ScheduledRecheck(), hasPlanProposal: true)]);

      final cubit = build();
      await settle();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.item!.id.value, 1);
      expect(cubit.state.proposal, isA<ProposalNotOffered>());
      expect(cubit.state.showsResolutionForm, isTrue);
      expect(repository.proposalCalls, 0);
      await cubit.close();
    });

    test('an item that is no longer open is not available', () async {
      repository.itemsResult = Result.success([reviewItem(id: 9)]);

      final cubit = build(id: 1);
      await settle();

      expect(cubit.state.loadError, ReviewLoadError.notAvailable);
      await cubit.close();
    });

    test('offline is its own load error, a server failure the generic one', () async {
      repository.itemsResult = const Result.failure(Network());
      final cubit = build();
      await settle();
      expect(cubit.state.loadError, ReviewLoadError.offline);

      repository.itemsResult = const Result.failure(Unexpected('HTTP_500'));
      cubit.onRetryLoad();
      await settle();
      expect(cubit.state.loadError, ReviewLoadError.generic);

      repository.itemsResult = Result.success([reviewItem()]);
      cubit.onRetryLoad();
      await settle();
      expect(cubit.state.loadError, isNull);
      expect(cubit.state.item, isNotNull);
      await cubit.close();
    });

    test('a sustained deviation with a proposal waits for it and then shows it', () async {
      withProposal(answers: [Result.success(ProposalGenerating(1)), Result.success(ProposalReady(proposal()))]);

      final cubit = build();
      await settle();

      expect(repository.proposalCalls, 2);
      expect(cubit.state.proposal, isA<ProposalLoaded>());
      expect(cubit.state.showsResolutionForm, isFalse);
      await cubit.close();
    });

    test('while the AI prepares the proposal the item can already be resolved', () async {
      withProposal(answers: [Result.success(ProposalGenerating(1))]);
      repository.proposalAnswers.add(Result.success(ProposalGenerating(1)));
      final gate = Completer<void>();
      final cubit = ReviewItemCubit(
        GetOpenReviewItemUseCase(repository),
        AwaitPlanProposalUseCase(repository, wait: (_) => gate.future),
        ResolveReviewItemUseCase(repository),
        AcceptPlanProposalUseCase(repository),
        FindActiveRosterPatientUseCase(
          ObserveCurrentUserUseCase(FakeSessionRepository(practitionerUser())),
          GetPatientRosterUseCase(careLinks),
        ),
        connectivity,
        reviewItemId: 1,
      );
      await settle();

      expect(cubit.state.proposal, isA<ProposalPreparing>());
      expect(cubit.state.showsResolutionForm, isFalse);
      cubit.onResolveWithoutProposal();
      expect(cubit.state.showsResolutionForm, isTrue);
      gate.complete();
      await cubit.close();
    });

    test('a proposal that is still generating after every attempt falls back to the plain item', () async {
      withProposal(answers: [Result.success(ProposalGenerating(1))]);

      final cubit = build();
      await settle();

      expect(repository.proposalCalls, AwaitPlanProposalUseCase.defaultMaxAttempts);
      expect(cubit.state.proposal, isA<ProposalNotOffered>());
      await cubit.close();
    });

    test('no proposal (404) or a failure reading it opens the plain item', () async {
      withProposal(answers: [const Result.success(NoProposal())]);
      var cubit = build();
      await settle();
      expect(cubit.state.proposal, isA<ProposalNotOffered>());
      await cubit.close();

      withProposal(answers: [const Result.failure(Network())]);
      cubit = build();
      await settle();
      expect(cubit.state.proposal, isA<ProposalNotOffered>());
      expect(cubit.state.showsResolutionForm, isTrue);
      await cubit.close();
    });

    test('a proposal that was already decided is not offered', () async {
      withProposal(answers: [Result.success(ProposalReady(proposal(status: PlanProposalStatus.dismissed)))]);

      final cubit = build();
      await settle();

      expect(cubit.state.proposal, isA<ProposalNotOffered>());
      await cubit.close();
    });

    test('"Resolve without assigning this plan" shows the plain form next to the proposal', () async {
      withProposal();
      final cubit = build();
      await settle();

      cubit.onResolveWithoutProposal();

      expect(cubit.state.proposal, isA<ProposalLoaded>());
      expect(cubit.state.showsResolutionForm, isTrue);
      await cubit.close();
    });
  });

  group('resolving', () {
    test('without answering Yes or No it asks for the answer and sends nothing', () async {
      final cubit = build();
      await settle();

      await cubit.onResolve();

      expect(cubit.state.showOutcomeError, isTrue);
      expect(repository.resolutions, isEmpty);

      cubit.onAdjustedChange(false);
      expect(cubit.state.showOutcomeError, isFalse);
      await cubit.close();
    });

    test('sends the answer and the trimmed note, then closes with the patient name', () async {
      repository.resolveResult = Result.success(reviewItem(isOpen: false, name: 'Ana Flores'));
      final cubit = build();
      await settle();
      cubit
        ..onAdjustedChange(true)
        ..onNoteChange('  se habló en consulta ');

      await cubit.onResolve();
      await settle();

      final (id, resolution) = repository.resolutions.single;
      expect(id, 1);
      expect(resolution.resolvedWithAdjustment, isTrue);
      expect(resolution.note, 'se habló en consulta');
      expect(events.single, isA<ReviewResolved>().having((e) => e.patientName, 'name', 'Ana Flores'));
      expect(cubit.state.isResolving, isFalse);
      await cubit.close();
    });

    test('an empty note is not sent', () async {
      final cubit = build();
      await settle();
      cubit
        ..onAdjustedChange(false)
        ..onNoteChange('   ');

      await cubit.onResolve();

      expect(repository.resolutions.single.$2.note, isNull);
      await cubit.close();
    });

    test('a second tap while resolving is ignored', () async {
      final cubit = build();
      await settle();
      cubit.onAdjustedChange(true);

      final first = cubit.onResolve();
      final second = cubit.onResolve();
      await Future.wait([first, second]);

      expect(repository.resolutions, hasLength(1));
      await cubit.close();
    });

    test('the backend asking for the answer marks it', () async {
      repository.resolveResult = const Result.failure(Validation('ResolutionOutcomeRequired'));
      final cubit = build();
      await settle();
      cubit.onAdjustedChange(true);

      await cubit.onResolve();

      expect(cubit.state.showOutcomeError, isTrue);
      expect(cubit.state.dialog, isNull);
      await cubit.close();
    });

    test('an item that is gone shows the notice, and confirming goes back to the inbox', () async {
      repository.resolveResult = const Result.failure(NotFound('ReviewItemNotFound'));
      final cubit = build();
      await settle();
      cubit.onAdjustedChange(true);

      await cubit.onResolve();
      expect(cubit.state.dialog, ReviewDialog.notAvailable);

      cubit.onDialogConfirmed();
      await settle();
      expect(cubit.state.dialog, isNull);
      expect(events.single, isA<CloseReviewItem>());
      await cubit.close();
    });

    test('a network failure offers "Retry", which sends the same resolution again', () async {
      repository.resolveResult = const Result.failure(Network());
      final cubit = build();
      await settle();
      cubit
        ..onAdjustedChange(false)
        ..onNoteChange('nota');
      await cubit.onResolve();
      expect(cubit.state.dialog, ReviewDialog.serverError);

      repository.resolveResult = Result.success(reviewItem(isOpen: false));
      cubit.onDialogConfirmed();
      await settle();

      expect(repository.resolutions, hasLength(2));
      expect(repository.resolutions.last.$2.note, 'nota');
      expect(events.single, isA<ReviewResolved>());
      await cubit.close();
    });
  });

  group('the AI proposal', () {
    Future<ReviewItemCubit> ready() async {
      withProposal();
      final cubit = build();
      await settle();
      return cubit;
    }

    test('"Resolve" assigns the proposal as it is and leaves with the patient name', () async {
      repository.acceptResult = Result.success(AcceptedProposal(reviewItem(isOpen: false), 4));
      final cubit = await ready();

      await cubit.onAcceptAsIs();
      await settle();

      expect(repository.acceptances.single.$1, 1);
      expect(repository.acceptances.single.$2, isA<AcceptAsIs>());
      expect(events.single, isA<ReviewResolved>().having((e) => e.patientName, 'name', 'Ana Flores'));
      await cubit.close();
    });

    test('it cannot be accepted while it is not there', () async {
      repository.itemsResult = Result.success([reviewItem()]);
      final cubit = build();
      await settle();

      await cubit.onAcceptAsIs();

      expect(repository.acceptances, isEmpty);
      await cubit.close();
    });

    test('"Adjust" opens the adjust screen for this item', () async {
      final cubit = await ready();

      cubit.onAdjust();
      await settle();

      expect(events.single, isA<OpenAdjust>().having((e) => e.reviewItemId, 'id', 1));
      await cubit.close();
    });

    test('the plan changing meanwhile says so and rereads the item', () async {
      repository.acceptResult = const Result.failure(Conflict('PlanVersionAlreadySuperseded'));
      final cubit = await ready();
      await cubit.onAcceptAsIs();
      expect(cubit.state.dialog, ReviewDialog.planChanged);

      final readsBefore = repository.itemsCalls;
      cubit.onDialogConfirmed();
      await settle();

      expect(repository.itemsCalls, readsBefore + 1);
      await cubit.close();
    });

    test('another conflict means it was already resolved', () async {
      repository.acceptResult = const Result.failure(Conflict('PlanProposalAlreadyDecided'));
      final cubit = await ready();

      await cubit.onAcceptAsIs();

      expect(cubit.state.dialog, ReviewDialog.alreadyResolved);
      await cubit.close();
    });

    test('an item that stopped being a sustained deviation, or a proposal that is gone, opens without AI', () async {
      repository.acceptResult = const Result.failure(Conflict('ReviewItemNotSustainedDeviation'));
      var cubit = await ready();
      await cubit.onAcceptAsIs();
      expect(cubit.state.proposal, isA<ProposalNotOffered>());
      expect(cubit.state.dialog, isNull);
      await cubit.close();

      repository.acceptResult = const Result.failure(NotFound('PlanProposalNotFound'));
      cubit = await ready();
      await cubit.onAcceptAsIs();
      expect(cubit.state.proposal, isA<ProposalNotOffered>());
      expect(cubit.state.dialog, isNull);
      await cubit.close();
    });

    test('a missing care link and an item that is gone have their own notices', () async {
      repository.acceptResult = const Result.failure(Forbidden('ActiveCareLinkRequired'));
      var cubit = await ready();
      await cubit.onAcceptAsIs();
      expect(cubit.state.dialog, ReviewDialog.noActiveLink);
      await cubit.close();

      repository.acceptResult = const Result.failure(NotFound('ReviewItemNotFound'));
      cubit = await ready();
      await cubit.onAcceptAsIs();
      expect(cubit.state.dialog, ReviewDialog.notAvailable);
      await cubit.close();
    });

    test('a server failure offers "Retry", which accepts again', () async {
      repository.acceptResult = const Result.failure(Unexpected('HTTP_503'));
      final cubit = await ready();
      await cubit.onAcceptAsIs();
      expect(cubit.state.dialog, ReviewDialog.serverError);

      repository.acceptResult = Result.success(AcceptedProposal(reviewItem(isOpen: false), 4));
      cubit.onDialogConfirmed();
      await settle();

      expect(repository.acceptances, hasLength(2));
      expect(events.single, isA<ReviewResolved>());
      await cubit.close();
    });
  });

  group('"Adjust the plan now"', () {
    test('opens the patient file with the care link of the roster', () async {
      final cubit = build();
      await settle();

      await cubit.onAdjustPlanNow();
      await settle();

      expect(
        events.single,
        isA<OpenPatientFile>()
            .having((e) => e.patientId, 'patient', 1)
            .having((e) => e.careLinkId, 'care link', 101)
            .having((e) => e.patientName, 'name', 'Ana Flores'),
      );
      expect(cubit.state.isOpeningPatient, isFalse);
      await cubit.close();
    });

    test('a patient who is not in the roster has no active link', () async {
      careLinks.rosterResult = Result.success(PatientRoster([rosterPatient(2, 'Jorge Salas')]));
      final cubit = build();
      await settle();

      await cubit.onAdjustPlanNow();

      expect(cubit.state.dialog, ReviewDialog.noActiveLink);
      expect(events, isEmpty);
      await cubit.close();
    });

    test('a roster that cannot be read offers "Retry"', () async {
      careLinks.rosterResult = const Result.failure(Network());
      final cubit = build();
      await settle();
      await cubit.onAdjustPlanNow();
      expect(cubit.state.dialog, ReviewDialog.serverError);

      careLinks.rosterResult = Result.success(PatientRoster([rosterPatient(1, 'Ana Flores')]));
      cubit.onDialogConfirmed();
      await settle();

      expect(events.single, isA<OpenPatientFile>());
      await cubit.close();
    });
  });
}

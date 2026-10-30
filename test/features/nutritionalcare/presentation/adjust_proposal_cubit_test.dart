import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/review_inbox_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_proposal.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/adjust_proposal_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/review_states.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';
import '../review_fakes.dart';

void main() {
  late FakeReviewInboxRepository repository;
  late FakeNutritionPlanRepository plans;
  late FakeConnectivity connectivity;
  late List<AdjustProposalEvent> events;

  setUp(() {
    repository = FakeReviewInboxRepository()
      ..itemsResult = Result.success([reviewItem(hasPlanProposal: true)])
      ..proposalAnswers.clear()
      ..proposalAnswers.add(Result.success(ProposalReady(proposal())));
    plans = FakeNutritionPlanRepository();
    connectivity = FakeConnectivity();
    events = [];
  });

  AdjustProposalCubit build() {
    final cubit = AdjustProposalCubit(
      GetOpenReviewItemUseCase(repository),
      AwaitPlanProposalUseCase(repository, wait: (_) async {}),
      GetPlanHistoryUseCase(plans),
      AcceptPlanProposalUseCase(repository),
      connectivity,
      reviewItemId: 1,
    );
    cubit.events.listen(events.add);
    return cubit;
  }

  Future<void> settle() => pumpEventQueue();

  group('opening the form', () {
    test('everything comes prefilled from the proposal and the current plan', () async {
      final cubit = build();
      await settle();

      final state = cubit.state;
      expect(state.isLoading, isFalse);
      expect(state.loadError, isNull);
      expect(state.patientFirstName, 'Ana');
      expect(state.previousEnergyKcal, 1796);
      expect(state.energy, '1650');
      expect(state.protein, '119');
      expect(state.carb, '170');
      expect(state.fat, '55');
      // Current catalog guidelines, minus what the AI removes, plus what it adds; the custom one is not touched here.
      expect(state.guidelines, {PlanGuidelineCode.prioritizeVegetables, PlanGuidelineCode.proteinAndVegetablesAtDinner});
      expect(state.message, 'Notamos que tus cenas son más ligeras.');
      await cubit.close();
    });

    test('a macro with a decimal keeps one decimal', () async {
      repository.proposalAnswers
        ..clear()
        ..add(
          Result.success(
            ProposalReady(
              PlanAdjustmentProposal(
                reviewItemId: proposal().reviewItemId,
                title: 'Ajuste',
                currentEnergyKcal: null,
                proposed: proposal().proposed,
                addedGuidelines: const [],
                removedGuidelines: const [],
                patientMessage: '',
                recheckAfterDays: 7,
                rationale: '',
                generatedAt: DateTime.utc(2026, 9, 8),
                status: PlanProposalStatus.proposed,
              ),
            ),
          ),
        );

      final cubit = build();
      await settle();

      expect(cubit.state.previousEnergyKcal, isNull);
      expect(cubit.state.guidelines, {PlanGuidelineCode.prioritizeVegetables});
      await cubit.close();
    });

    test('an item or a proposal that is gone is not available', () async {
      repository.proposalAnswers
        ..clear()
        ..add(const Result.success(NoProposal()));
      final cubit = build();
      await settle();

      expect(cubit.state.loadError, ReviewLoadError.notAvailable);
      await cubit.close();
    });

    test('a proposal that is still generating cannot be adjusted yet', () async {
      repository.proposalAnswers
        ..clear()
        ..add(Result.success(ProposalGenerating(5)));
      final cubit = build();
      await settle();

      // The adjust screen reads once (it opens from a ready proposal).
      expect(repository.proposalCalls, 1);
      expect(cubit.state.loadError, ReviewLoadError.notAvailable);
      await cubit.close();
    });

    test('a decided proposal is not adjustable', () async {
      repository.proposalAnswers
        ..clear()
        ..add(Result.success(ProposalReady(proposal(status: PlanProposalStatus.acceptedAsIs))));
      final cubit = build();
      await settle();

      expect(cubit.state.loadError, ReviewLoadError.notAvailable);
      await cubit.close();
    });

    test('offline and server failures are told apart, and retrying recovers', () async {
      plans.result = const Result.failure(Network());
      final cubit = build();
      await settle();
      expect(cubit.state.loadError, ReviewLoadError.offline);

      plans.result = const Result.failure(Unexpected('HTTP_500'));
      cubit.onRetryLoad();
      await settle();
      expect(cubit.state.loadError, ReviewLoadError.generic);

      plans.result = Result.success(planHistory());
      cubit.onRetryLoad();
      await settle();
      expect(cubit.state.loadError, isNull);
      expect(cubit.state.energy, '1650');
      await cubit.close();
    });
  });

  group('assigning the adjusted plan', () {
    Future<AdjustProposalCubit> ready() async {
      final cubit = build();
      await settle();
      return cubit;
    }

    test('sends the edits with the whole list of catalog guidelines in catalog order', () async {
      final cubit = await ready();
      cubit
        ..onEnergyChange('1 600')
        ..onProteinChange('120,5')
        ..onGuidelineToggle(PlanGuidelineCode.drink2lWater, true)
        ..onMessageChange('  Probemos esto  ');

      await cubit.onAssign();
      await settle();

      final (id, acceptance) = repository.acceptances.single;
      expect(id, 1);
      final edits = (acceptance as AcceptWithEdits).edits;
      expect(edits.targets.energyKcal, 1600);
      expect(edits.targets.proteinG, 120.5);
      expect(edits.targets.carbG, 170);
      expect(edits.guidelines, {
        PlanGuidelineCode.prioritizeVegetables,
        PlanGuidelineCode.drink2lWater,
        PlanGuidelineCode.proteinAndVegetablesAtDinner,
      });
      expect(edits.patientMessage!.text, 'Probemos esto');
      expect(events.single, isA<ProposalAssigned>().having((e) => e.patientName, 'name', 'Ana Flores'));
      await cubit.close();
    });

    test('a value that is not a positive number is marked and nothing is sent', () async {
      final cubit = await ready();
      cubit
        ..onEnergyChange('0')
        ..onFatChange('abc');

      await cubit.onAssign();

      expect(cubit.state.invalidFields, {ProposalEditField.energy, ProposalEditField.fat});
      expect(repository.acceptances, isEmpty);

      // Editing a field clears its own mark only.
      cubit.onEnergyChange('1500');
      expect(cubit.state.invalidFields, {ProposalEditField.fat});
      await cubit.close();
    });

    test('the message is cut at 500 characters', () async {
      final cubit = await ready();

      cubit.onMessageChange('a' * 600);

      expect(cubit.state.message.length, 500);
      await cubit.close();
    });

    test('an energy below the safe minimum marks the energy and keeps what was typed', () async {
      repository.acceptResult = const Result.failure(Validation('PlanProposalOutOfSafetyBounds'));
      final cubit = await ready();
      cubit.onEnergyChange('900');

      await cubit.onAssign();

      expect(cubit.state.belowSafetyFloor, isTrue);
      expect(cubit.state.energy, '900');
      expect(cubit.state.isAssigning, isFalse);
      expect(events, isEmpty);

      cubit.onEnergyChange('1400');
      expect(cubit.state.belowSafetyFloor, isFalse);
      await cubit.close();
    });

    test('a message the backend rejects marks the message', () async {
      repository.acceptResult = const Result.failure(Validation('InvalidPatientMessage'));
      final cubit = await ready();

      await cubit.onAssign();

      expect(cubit.state.invalidFields, {ProposalEditField.message});
      await cubit.close();
    });

    test('the plan changing meanwhile, a decided item or a gone item close the screen after the notice', () async {
      for (final (failure, dialog) in <(DomainError, ReviewDialog)>[
        (const Conflict('PlanVersionAlreadySuperseded'), ReviewDialog.planChanged),
        (const Conflict('PlanProposalAlreadyDecided'), ReviewDialog.alreadyResolved),
        (const NotFound('ReviewItemNotFound'), ReviewDialog.notAvailable),
        (const Forbidden(), ReviewDialog.notAvailable),
      ]) {
        events.clear();
        repository.acceptResult = Result.failure(failure);
        final cubit = await ready();

        await cubit.onAssign();
        expect(cubit.state.dialog, dialog, reason: '$failure');

        cubit.onDialogConfirmed();
        await settle();
        expect(events.single, isA<CloseAdjustProposal>(), reason: '$failure');
        await cubit.close();
      }
    });

    test('a missing care link only informs', () async {
      repository.acceptResult = const Result.failure(Forbidden('ActiveCareLinkRequired'));
      final cubit = await ready();

      await cubit.onAssign();
      cubit.onDialogConfirmed();
      await settle();

      expect(cubit.state.dialog, isNull);
      expect(events, isEmpty);
      await cubit.close();
    });

    test('a network failure offers "Retry", which assigns again', () async {
      repository.acceptResult = const Result.failure(Network());
      final cubit = await ready();
      await cubit.onAssign();
      expect(cubit.state.dialog, ReviewDialog.serverError);

      repository.acceptResult = Result.success(AcceptedProposal(reviewItem(isOpen: false), 4));
      cubit.onDialogConfirmed();
      await settle();

      expect(repository.acceptances, hasLength(2));
      expect(events.single, isA<ProposalAssigned>());
      await cubit.close();
    });

    test('a second tap while assigning is ignored', () async {
      final cubit = await ready();

      final first = cubit.onAssign();
      final second = cubit.onAssign();
      await Future.wait([first, second]);

      expect(repository.acceptances, hasLength(1));
      await cubit.close();
    });
  });
}

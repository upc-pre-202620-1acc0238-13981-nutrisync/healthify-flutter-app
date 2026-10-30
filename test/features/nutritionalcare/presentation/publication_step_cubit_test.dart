import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/publication_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/consultation_step_states.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakeConsultationRepository consultations;
  late FakeConnectivity connectivity;
  late IdempotencyKeyStore keys;
  late List<ConsultationStepEvent> events;

  setUp(() {
    consultations = FakeConsultationRepository()..inProgressResult = Result.success(consultationAtPublication());
    connectivity = FakeConnectivity();
    keys = IdempotencyKeyStore();
  });

  Future<PublicationStepCubit> build() async {
    final cubit = PublicationStepCubit(
      GetConsultationInProgressUseCase(consultations),
      SuggestGuidelinesUseCase(consultations),
      SavePublicationDraftUseCase(consultations),
      PublishConsultationUseCase(consultations),
      keys,
      connectivity,
      patientId: 7,
    );
    events = [];
    cubit.events.listen(events.add);
    await pumpEventQueue();
    return cubit;
  }

  Future<List<ConsultationStepEvent>> delivered() async {
    await pumpEventQueue();
    return events;
  }

  group('the suggested guidelines', () {
    test('arrive selected when there is no draft, with the AI mark', () async {
      final cubit = await build();

      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      expect(cubit.state.suggested, [PlanGuidelineCode.prioritizeVegetables, PlanGuidelineCode.reduceSalt]);
      expect(cubit.state.suggestedByAi, isTrue);
      expect(cubit.state.guidelines, {PlanGuidelineCode.prioritizeVegetables, PlanGuidelineCode.reduceSalt});
      await cubit.close();
    });

    test('the form is usable while the AI works, and a choice made meanwhile is not overridden', () async {
      consultations.suggestGuidelinesGate = Completer<void>();
      final cubit = await build();

      expect(cubit.state.load.isLoading, isFalse);
      expect(cubit.state.suggestionStatus, AiRequestStatus.loading);
      cubit.onGuidelineToggle(PlanGuidelineCode.drink2lWater);

      consultations.suggestGuidelinesGate!.complete();
      await pumpEventQueue();

      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      expect(cubit.state.suggested, hasLength(2));
      expect(cubit.state.guidelines, {PlanGuidelineCode.drink2lWater});
      await cubit.close();
    });

    test('a saved draft decides the guidelines; the suggestions are only chips', () async {
      consultations.inProgressResult = Result.success(
        consultationAtPublication(
          draft: const PublicationDraft(
            restrictions: {PlanRestrictionCode.halal},
            guidelines: {PlanGuidelineCode.avoidSugaryDrinks},
            customGuidelines: ['Caminar 20 minutos', 'x', ' '],
            patientMessage: 'Vamos bien',
          ),
        ),
      );

      final cubit = await build();

      expect(cubit.state.restrictions, {PlanRestrictionCode.halal});
      expect(cubit.state.guidelines, {PlanGuidelineCode.avoidSugaryDrinks});
      expect(cubit.state.customGuidelines, ['Caminar 20 minutos']);
      expect(cubit.state.patientMessage, 'Vamos bien');
      expect(cubit.state.suggested, hasLength(2));
      await cubit.close();
    });

    test('an AI that fails or times out leaves the form as it is and offers retry', () async {
      consultations.suggestGuidelinesResult = const Result.failure(Network());
      final cubit = await build();
      cubit
        ..onRestrictionToggle(PlanRestrictionCode.vegan)
        ..onPatientMessageChange('Hola');

      expect(cubit.state.suggestionStatus, AiRequestStatus.failed);
      expect(cubit.state.suggested, isEmpty);
      expect(cubit.state.load.loadFailed, isFalse);

      consultations.suggestGuidelinesResult = Result.success(guidelineSuggestions(fromAi: false));
      await cubit.onRetrySuggestions();

      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      expect(cubit.state.suggestedByAi, isFalse);
      expect(cubit.state.restrictions, {PlanRestrictionCode.vegan});
      expect(cubit.state.patientMessage, 'Hola');
      await cubit.close();
    });

    test('coming back online retries the failed suggestions by itself', () async {
      consultations.suggestGuidelinesResult = const Result.failure(Network());
      final cubit = await build();

      consultations.suggestGuidelinesResult = Result.success(guidelineSuggestions());
      connectivity.set(true);
      await pumpEventQueue();

      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      await cubit.close();
    });
  });

  group('the form', () {
    test('restrictions and guidelines toggle on and off', () async {
      final cubit = await build();

      cubit
        ..onRestrictionToggle(PlanRestrictionCode.halal)
        ..onRestrictionToggle(PlanRestrictionCode.kosher)
        ..onRestrictionToggle(PlanRestrictionCode.halal)
        ..onGuidelineToggle(PlanGuidelineCode.reduceSalt);

      expect(cubit.state.restrictions, {PlanRestrictionCode.kosher});
      expect(cubit.state.guidelines, {PlanGuidelineCode.prioritizeVegetables});
      await cubit.close();
    });

    test('"Other guideline" takes 3 to 140 characters, at most 5, without repeats', () async {
      final cubit = await build();
      cubit.onAddCustomClick();
      expect(cubit.state.showCustomField, isTrue);

      cubit.onCustomDraftChange('ab');
      cubit.onConfirmCustom();
      expect(cubit.state.customError, isTrue);

      cubit.onCustomDraftChange('  Caminar 20 minutos  ');
      expect(cubit.state.customError, isFalse);
      cubit.onConfirmCustom();
      expect(cubit.state.customGuidelines, ['Caminar 20 minutos']);
      expect(cubit.state.showCustomField, isFalse);
      expect(cubit.state.customDraft, '');

      cubit
        ..onAddCustomClick()
        ..onCustomDraftChange('Caminar 20 minutos')
        ..onConfirmCustom();
      expect(cubit.state.customGuidelines, ['Caminar 20 minutos']);

      for (var i = 0; i < 4; i++) {
        cubit
          ..onAddCustomClick()
          ..onCustomDraftChange('Indicación $i')
          ..onConfirmCustom();
      }
      expect(cubit.state.customGuidelines, hasLength(5));
      cubit
        ..onAddCustomClick()
        ..onCustomDraftChange('Una más')
        ..onConfirmCustom();
      expect(cubit.state.customError, isTrue);
      expect(cubit.state.customGuidelines, hasLength(5));

      cubit.onRemoveCustom('Caminar 20 minutos');
      expect(cubit.state.customGuidelines, hasLength(4));
      await cubit.close();
    });

    test('the message has at most 500 characters and flags it past that', () async {
      final cubit = await build();

      cubit.onPatientMessageChange('x' * 500);
      expect(cubit.state.messageTooLong, isFalse);
      cubit.onPatientMessageChange('${'x' * 500} ');
      expect(cubit.state.messageTooLong, isFalse);
      cubit.onPatientMessageChange('x' * 501);
      expect(cubit.state.messageTooLong, isTrue);
      await cubit.close();
    });
  });

  group('leaving with "‹"', () {
    test('saves the draft if it changed, in the background, and goes back', () async {
      final cubit = await build();
      cubit
        ..onRestrictionToggle(PlanRestrictionCode.halal)
        ..onPatientMessageChange(' Hola ');

      cubit.onBack();
      await pumpEventQueue();

      final draft = consultations.drafts.single;
      expect(draft.restrictions, {PlanRestrictionCode.halal});
      expect(draft.patientMessage?.text, 'Hola');
      expect((await delivered()).single, isA<StepBack>());

      // Leaving again without changes does not save it again.
      cubit.onBack();
      await pumpEventQueue();
      expect(consultations.drafts, hasLength(1));
      await cubit.close();
    });

    test('a message that is too long is not saved as a draft', () async {
      final cubit = await build();
      cubit.onPatientMessageChange('x' * 501);

      cubit.onBack();
      await pumpEventQueue();

      expect(consultations.drafts, isEmpty);
      expect((await delivered()).single, isA<StepBack>());
      await cubit.close();
    });
  });

  group('publish', () {
    test('saves the draft, publishes with the idempotency key and tells the flow', () async {
      final cubit = await build();
      cubit.onRestrictionToggle(PlanRestrictionCode.halal);

      await cubit.onPublish();

      expect(consultations.drafts, hasLength(1));
      final (publication, key) = consultations.published.single;
      expect(publication.restrictions, {PlanRestrictionCode.halal});
      expect(publication.guidelines, {PlanGuidelineCode.prioritizeVegetables, PlanGuidelineCode.reduceSalt});
      expect(key, keys.keyFor(ConsultationId(9)));
      expect(cubit.state.isPublishing, isFalse);
      expect((await delivered()).single, isA<StepPublished>());
      await cubit.close();
    });

    test('a draft that was already saved is not saved again', () async {
      consultations.inProgressResult = Result.success(
        consultationAtPublication(
          draft: const PublicationDraft(
            restrictions: {PlanRestrictionCode.halal},
            guidelines: {PlanGuidelineCode.reduceSalt},
            customGuidelines: [],
          ),
        ),
      );
      final cubit = await build();

      await cubit.onPublish();

      expect(consultations.drafts, isEmpty);
      expect(consultations.published, hasLength(1));
      await cubit.close();
    });

    test('a failure keeps everything written, and "Try again" resends the same idempotency key', () async {
      consultations.publishResults.addAll([const Result.failure(Network()), Result.success(consultation())]);
      final cubit = await build();
      cubit
        ..onRestrictionToggle(PlanRestrictionCode.vegan)
        ..onPatientMessageChange('Hola');

      await cubit.onPublish();

      expect(cubit.state.publishFailed, isTrue);
      expect(cubit.state.isPublishing, isFalse);
      expect(cubit.state.restrictions, {PlanRestrictionCode.vegan});
      expect(cubit.state.patientMessage, 'Hola');
      expect(await delivered(), isEmpty);

      await cubit.onRetryPublish();

      expect(cubit.state.publishFailed, isFalse);
      expect(consultations.published, hasLength(2));
      expect(consultations.published[0].$2, consultations.published[1].$2);
      expect((await delivered()).single, isA<StepPublished>());
      await cubit.close();
    });

    test('the key is the same after leaving and coming back to the step', () async {
      consultations.publishResults.add(const Result.failure(Network()));
      var cubit = await build();
      await cubit.onPublish();
      await cubit.close();

      cubit = await build();
      await cubit.onPublish();

      expect(consultations.published[0].$2, consultations.published[1].$2);
      await cubit.close();
    });

    test('dismissing the error goes back to the form with everything written', () async {
      consultations.publishResult = const Result.failure(Unexpected('HTTP_500'));
      final cubit = await build();
      cubit.onPatientMessageChange('Hola');
      await cubit.onPublish();
      expect(cubit.state.publishFailed, isTrue);

      cubit.onPublishFailureDismissed();

      expect(cubit.state.publishFailed, isFalse);
      expect(cubit.state.patientMessage, 'Hola');
      await cubit.close();
    });

    test('a message that is too long cannot be published', () async {
      final cubit = await build();
      cubit.onPatientMessageChange('x' * 501);

      await cubit.onPublish();

      expect(consultations.published, isEmpty);
      expect(cubit.state.isPublishing, isFalse);
      await cubit.close();
    });

    test('409 ConsultationNotInProgress closes the consultation instead of showing the error', () async {
      consultations.publishResult = const Result.failure(Conflict('ConsultationNotInProgress'));
      final cubit = await build();

      await cubit.onPublish();

      expect(cubit.state.publishFailed, isFalse);
      expect((await delivered()).single, isA<StepConsultationClosed>());
      await cubit.close();
    });

    test('a double tap publishes once', () async {
      final cubit = await build();

      await Future.wait([cubit.onPublish(), cubit.onPublish()]);

      expect(consultations.published, hasLength(1));
      await cubit.close();
    });
  });

  group('loading', () {
    test('without prescribed targets the step goes back to them', () async {
      consultations.inProgressResult = Result.success(consultationAtTargets());

      final cubit = await build();

      expect((await delivered()).single, isA<StepBack>());
      expect(consultations.suggestGuidelinesCalls, 0);
      await cubit.close();
    });

    test('a failed load is an error with retry; offline is flagged, and the connection coming back retries', () async {
      consultations.inProgressResult = const Result.failure(Network());
      final cubit = await build();
      expect(cubit.state.load.loadFailed, isTrue);
      expect(cubit.state.load.isOffline, isTrue);

      consultations.inProgressResult = Result.success(consultationAtPublication());
      connectivity.set(true);
      await pumpEventQueue();

      expect(cubit.state.load.loadFailed, isFalse);
      expect(cubit.state.isOffline, isFalse);
      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      await cubit.close();
    });

    test('no consultation in progress anymore closes the step', () async {
      consultations.inProgressResult = const Result.success(null);

      final cubit = await build();

      expect((await delivered()).single, isA<StepConsultationClosed>());
      await cubit.close();
    });
  });
}

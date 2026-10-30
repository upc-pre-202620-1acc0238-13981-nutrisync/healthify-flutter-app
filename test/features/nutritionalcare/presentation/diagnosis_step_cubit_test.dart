import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation_commands.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/diagnosis_step_cubit.dart';
import 'package:healthify/features/nutritionalcare/presentation/state/consultation_step_states.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakeConsultationRepository consultations;
  late FakeConnectivity connectivity;
  late List<ConsultationStepEvent> events;

  setUp(() {
    consultations = FakeConsultationRepository()..inProgressResult = Result.success(consultationAtDiagnosis());
    connectivity = FakeConnectivity();
  });

  Future<DiagnosisStepCubit> build() async {
    final cubit = DiagnosisStepCubit(
      GetConsultationInProgressUseCase(consultations),
      SuggestDiagnosisUseCase(consultations),
      IssueConsultationDiagnosisUseCase(consultations),
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

  group('the suggestion', () {
    test('arrives with the AI mark and starts unchosen', () async {
      final cubit = await build();

      expect(cubit.state.load.isLoading, isFalse);
      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      expect(cubit.state.suggestion?.isFromAi, isTrue);
      expect(cubit.state.selected, isNull);
      expect(cubit.state.usesSuggestion, isFalse);
      await cubit.close();
    });

    test('a slow AI shows the long loading state while the list is already usable', () async {
      consultations.suggestDiagnosisGate = Completer<void>();
      final cubit = await build();

      expect(cubit.state.load.isLoading, isFalse);
      expect(cubit.state.suggestionStatus, AiRequestStatus.loading);
      cubit.onSelect(DiagnosisCode.normalWeight);
      expect(cubit.state.selected, DiagnosisCode.normalWeight);

      consultations.suggestDiagnosisGate!.complete();
      await pumpEventQueue();
      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      // What was chosen meanwhile is not touched by the suggestion arriving.
      expect(cubit.state.selected, DiagnosisCode.normalWeight);
      await cubit.close();
    });

    test('an AI that fails or times out is an error with retry, keeping what was chosen', () async {
      consultations.suggestDiagnosisResult = const Result.failure(Network());
      final cubit = await build();
      cubit.onSelect(DiagnosisCode.obesityGradeI);

      expect(cubit.state.suggestionStatus, AiRequestStatus.failed);
      expect(cubit.state.suggestion, isNull);
      expect(cubit.state.selected, DiagnosisCode.obesityGradeI);
      expect(cubit.state.load.loadFailed, isFalse);

      consultations.suggestDiagnosisResult = Result.success(diagnosisSuggestion());
      await cubit.onRetrySuggestion();

      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      expect(cubit.state.suggestion?.code, DiagnosisCode.overweightGradeI);
      expect(cubit.state.selected, DiagnosisCode.obesityGradeI);
      expect(consultations.suggestDiagnosisCalls, 2);
      await cubit.close();
    });

    test('a server error from the AI endpoint is the same error with retry', () async {
      consultations.suggestDiagnosisResult = const Result.failure(Unexpected('HTTP_503'));

      final cubit = await build();

      expect(cubit.state.suggestionStatus, AiRequestStatus.failed);
      await cubit.close();
    });

    test('retry while it is still loading asks only once', () async {
      consultations.suggestDiagnosisGate = Completer<void>();
      final cubit = await build();

      await cubit.onRetrySuggestion();
      await cubit.onRetrySuggestion();

      expect(consultations.suggestDiagnosisCalls, 1);
      consultations.suggestDiagnosisGate!.complete();
      await cubit.close();
    });

    test('coming back online retries a failed suggestion by itself', () async {
      consultations.suggestDiagnosisResult = const Result.failure(Network());
      final cubit = await build();
      expect(cubit.state.suggestionStatus, AiRequestStatus.failed);

      consultations.suggestDiagnosisResult = Result.success(diagnosisSuggestion());
      connectivity.set(true);
      await pumpEventQueue();

      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      await cubit.close();
    });
  });

  group('choosing', () {
    test('"Use suggestion" selects its code and "Choose another" lets go of it', () async {
      final cubit = await build();

      cubit.onUseSuggestion();
      expect(cubit.state.selected, DiagnosisCode.overweightGradeI);
      expect(cubit.state.usesSuggestion, isTrue);

      cubit.onChooseOther();
      expect(cubit.state.selected, isNull);
      expect(cubit.state.usesSuggestion, isFalse);
      await cubit.close();
    });

    test('tapping a chip is the practitioner\'s own choice', () async {
      final cubit = await build();
      cubit.onUseSuggestion();

      cubit.onSelect(DiagnosisCode.normalWeight);

      expect(cubit.state.selected, DiagnosisCode.normalWeight);
      expect(cubit.state.usesSuggestion, isFalse);
      await cubit.close();
    });
  });

  group('continue', () {
    test('without a choice it asks for one and sends nothing', () async {
      final cubit = await build();

      await cubit.onContinue();

      expect(cubit.state.showRequired, isTrue);
      expect(consultations.diagnoses, isEmpty);
      expect(await delivered(), isEmpty);
      await cubit.close();
    });

    test('an accepted AI suggestion is stored with its generation', () async {
      final cubit = await build();
      cubit.onUseSuggestion();

      await cubit.onContinue();

      final sent = consultations.diagnoses.single as AcceptAiSuggestion;
      expect(sent.aiGenerationId, 77);
      expect(sent.source, DiagnosisSource.aiSuggestionAccepted);
      expect((await delivered()).single, isA<StepContinue>());
      await cubit.close();
    });

    test('the rule suggestion, accepted, counts as a choice of the practitioner', () async {
      consultations.suggestDiagnosisResult = Result.success(diagnosisSuggestion(fromAi: false));
      final cubit = await build();
      cubit.onUseSuggestion();

      await cubit.onContinue();

      final sent = consultations.diagnoses.single;
      expect(sent, isA<SelectedDiagnosis>());
      expect(sent.source, DiagnosisSource.practitionerSelected);
      await cubit.close();
    });

    test('another diagnosis than the suggested one is a plain choice, even after "Use suggestion"', () async {
      final cubit = await build();
      cubit
        ..onUseSuggestion()
        ..onSelect(DiagnosisCode.obesityGradeII);

      await cubit.onContinue();

      final sent = consultations.diagnoses.single as SelectedDiagnosis;
      expect(sent.code, DiagnosisCode.obesityGradeII);
      expect(sent.rationale, isNull);
      await cubit.close();
    });

    test('the same diagnosis that is already saved is not sent again', () async {
      consultations.inProgressResult = Result.success(
        consultationAtDiagnosis(diagnosis: savedDiagnosis(code: DiagnosisCode.normalWeight)),
      );
      final cubit = await build();
      expect(cubit.state.selected, DiagnosisCode.normalWeight);

      await cubit.onContinue();

      expect(consultations.diagnoses, isEmpty);
      expect((await delivered()).single, isA<StepContinue>());
      await cubit.close();
    });

    test('coming back, an accepted suggestion shows as used again', () async {
      consultations.inProgressResult = Result.success(
        consultationAtDiagnosis(
          diagnosis: savedDiagnosis(source: DiagnosisSource.aiSuggestionAccepted),
        ),
      );

      final cubit = await build();

      expect(cubit.state.selected, DiagnosisCode.overweightGradeI);
      expect(cubit.state.usesSuggestion, isTrue);
      await cubit.close();
    });

    test('a lost connection is a notice with retry that keeps the choice', () async {
      consultations.issueDiagnosisResult = const Result.failure(Network());
      final cubit = await build();
      cubit.onSelect(DiagnosisCode.normalWeight);

      await cubit.onContinue();

      expect(cubit.state.saveFailure, const SaveFailure(isNetwork: true));
      expect(cubit.state.selected, DiagnosisCode.normalWeight);
      expect(await delivered(), isEmpty);

      consultations.issueDiagnosisResult = Result.success(consultationAtTargets());
      cubit.onSaveFailureDismissed();
      await cubit.onContinue();
      expect((await delivered()).single, isA<StepContinue>());
      await cubit.close();
    });

    test('422 ConsultationStepOutOfOrder sends the practitioner back a step', () async {
      consultations.issueDiagnosisResult = const Result.failure(Validation('ConsultationStepOutOfOrder'));
      final cubit = await build();
      cubit.onSelect(DiagnosisCode.normalWeight);

      await cubit.onContinue();

      expect((await delivered()).single, isA<StepBack>());
      await cubit.close();
    });

    test('404 ConsultationNotFound closes the consultation', () async {
      consultations.issueDiagnosisResult = const Result.failure(NotFound('ConsultationNotFound'));
      final cubit = await build();
      cubit.onSelect(DiagnosisCode.normalWeight);

      await cubit.onContinue();

      expect((await delivered()).single, isA<StepConsultationClosed>());
      await cubit.close();
    });
  });

  group('loading', () {
    test('without the measurement the step goes back to it', () async {
      consultations.inProgressResult = Result.success(freshConsultation());

      final cubit = await build();

      expect((await delivered()).single, isA<StepBack>());
      expect(consultations.suggestDiagnosisCalls, 0);
      await cubit.close();
    });

    test('no consultation in progress anymore closes the step', () async {
      consultations.inProgressResult = const Result.success(null);

      final cubit = await build();

      expect((await delivered()).single, isA<StepConsultationClosed>());
      await cubit.close();
    });

    test('a failed load is an error with retry, and no AI call is made before the consultation is known', () async {
      consultations.inProgressResult = const Result.failure(Unexpected('HTTP_500'));
      final cubit = await build();
      expect(cubit.state.load.loadFailed, isTrue);
      expect(consultations.suggestDiagnosisCalls, 0);

      consultations.inProgressResult = Result.success(consultationAtDiagnosis());
      cubit.onRetry();
      await pumpEventQueue();

      expect(cubit.state.load.loadFailed, isFalse);
      expect(cubit.state.suggestionStatus, AiRequestStatus.ready);
      await cubit.close();
    });

    test('offline is flagged and the load retries when the connection is back', () async {
      consultations.inProgressResult = const Result.failure(Network());
      final cubit = await build();
      expect(cubit.state.load.isOffline, isTrue);
      expect(cubit.state.load.loadFailed, isTrue);

      consultations.inProgressResult = Result.success(consultationAtDiagnosis());
      connectivity.set(true);
      await pumpEventQueue();

      expect(cubit.state.load.loadFailed, isFalse);
      expect(cubit.state.load.isOffline, isFalse);
      await cubit.close();
    });
  });
}

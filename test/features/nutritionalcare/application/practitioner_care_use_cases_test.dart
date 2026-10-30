import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/practitioner_care_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_baseline.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';

import '../fakes.dart';

void main() {
  final newBaseline = NewBaseline(
    birthDate: BirthDate(DateTime(1995, 2, 15), DateTime(2026, 10, 30)),
    sex: BiologicalSex.female,
    height: HeightCm(168),
    conditions: const {},
  );

  group('SavePatientBaselineUseCase', () {
    late FakePatientBaselineRepository repository;

    setUp(() => repository = FakePatientBaselineRepository());

    test('records the first time', () async {
      final result = await SavePatientBaselineUseCase(repository)(7, newBaseline, alreadyRecorded: false);

      expect(result.isSuccess, isTrue);
      expect(repository.calls, ['record']);
    });

    test('edits once it is recorded', () async {
      await SavePatientBaselineUseCase(repository)(7, newBaseline, alreadyRecorded: true);

      expect(repository.calls, ['update']);
    });

    test('a 409 BaselineAlreadyRecorded (another phone got there first) is saved as an edit', () async {
      repository.recordResult = const Result.failure(Conflict('BaselineAlreadyRecorded'));

      final result = await SavePatientBaselineUseCase(repository)(7, newBaseline, alreadyRecorded: false);

      expect(result.isSuccess, isTrue);
      expect(repository.calls, ['record', 'update']);
    });

    test('any other failure is returned as is', () async {
      repository.recordResult = const Result.failure(Network());

      final result = await SavePatientBaselineUseCase(repository)(7, newBaseline, alreadyRecorded: false);

      expect(result.errorOrNull, isA<Network>());
      expect(repository.calls, ['record']);
    });
  });

  group('StartOrResumeConsultationUseCase', () {
    late FakeConsultationRepository repository;

    setUp(() => repository = FakeConsultationRepository());

    test('starts a consultation, linked to the appointment when there is one', () async {
      final result = await StartOrResumeConsultationUseCase(repository)(7, scheduledFollowUpId: 4);

      expect(result.valueOrNull!.id, ConsultationId(9));
      expect(repository.startedWith, [4]);
      expect(repository.inProgressCalls, 0);
    });

    test('a 409 ConsultationAlreadyInProgress resumes the open one', () async {
      repository
        ..startResult = const Result.failure(Conflict('ConsultationAlreadyInProgress'))
        ..inProgressResult = Result.success(consultation(step: ConsultationStep.targets, id: 12));

      final result = await StartOrResumeConsultationUseCase(repository)(7);

      expect(result.valueOrNull!.currentStep, ConsultationStep.targets);
      expect(result.valueOrNull!.id, ConsultationId(12));
    });

    test('if the open one vanished in between, it is not found', () async {
      repository.startResult = const Result.failure(Conflict('ConsultationAlreadyInProgress'));

      final result = await StartOrResumeConsultationUseCase(repository)(7);

      expect(result.errorOrNull, const NotFound('ConsultationNotFound'));
    });

    test('a 422 BaselineRequired is returned for the caller to open the baseline', () async {
      repository.startResult = const Result.failure(Validation('BaselineRequired'));

      final result = await StartOrResumeConsultationUseCase(repository)(7);

      expect(result.errorOrNull, const Validation('BaselineRequired'));
      expect(repository.inProgressCalls, 0);
    });

    test('a conflict with another code is not treated as "already open"', () async {
      repository.startResult = const Result.failure(Conflict('SomethingElse'));

      expect((await StartOrResumeConsultationUseCase(repository)(7)).errorOrNull, const Conflict('SomethingElse'));
    });
  });

}

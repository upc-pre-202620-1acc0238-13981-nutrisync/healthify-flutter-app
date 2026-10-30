import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/core/network/api_config.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation_commands.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_history.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/mapper/practitioner_care_mappers.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/remote/dto/consultation_dtos.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/remote/practitioner_care_services.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/repository/practitioner_care_repositories_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response _json(int status, Object? body) =>
    http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json; charset=utf-8'});

http.Response _problem(int status, String code) => http.Response(
  jsonEncode({'title': 'x', 'status': status, 'code': code}),
  status,
  headers: {'content-type': 'application/problem+json'},
);

/// What `ConsultationResource` returns (the `ConsultationInfrastructureTest` sample of the Android app).
Map<String, Object?> _consultationJson() => {
  'consultationId': 9,
  'patientId': 7,
  'practitionerId': 3,
  'state': 'InProgress',
  'currentStep': 'Publication',
  'stepNumber': 4,
  'startedAt': '2026-10-07T09:00:00-05:00',
  'lastSavedAt': '2026-10-07T09:40:00.1234567-05:00',
  'measurement': {
    'assessmentId': 21,
    'weightKg': 74.2,
    'heightCm': 168.0,
    'waistCm': 88,
    'bodyFatPercentage': null,
    'bmi': 26.3,
    'bmiCategory': 'OverweightGradeI',
    'protocolChecks': ['Fasting', 'NoShoes', 'Mystery'],
    'activityLevel': 'Moderate',
    'habits': {'mealsPerDay': 4, 'waterLitersPerDay': null, 'mealsOutPerWeek': null},
    'biochemistry': null,
    'ageYears': 31,
    'biologicalSex': 'Female',
  },
  'diagnosis': {
    'diagnosisId': 5,
    'code': 'OverweightGradeI',
    'source': 'AiSuggestionAccepted',
    'rationale': 'IMC 26.3',
    'bmiAtIssue': 26.3,
    'aiGenerationId': 77,
    'issuedAt': '2026-10-07T09:20:00-05:00',
    'isPending': true,
  },
  'targets': {
    'planId': 40,
    'version': 4,
    'calculationBasis': {
      'equation': 'MifflinStJeor',
      'referenceWeightKind': 'Actual',
      'referenceWeightKg': 74.2,
      'activityFactor': 1.55,
      'deficitKind': 'FixedKcal',
      'deficitValue': 500,
      'computedBmr': 1450,
      'computedTdee': 2247,
    },
    'proposal': {'energyKcal': 1796, 'proteinG': 119, 'carbG': 195, 'fatG': 60},
    'prescribed': {'energyKcal': 1700, 'proteinG': 120, 'carbG': 180, 'fatG': 55},
    'prescriptionOutcome': 'Overridden',
    'overrideReason': 'Su ritmo',
    'isPublished': false,
    'activePlanLegacyRestrictions': <Object?>[],
  },
  'publicationDraft': {
    'restrictions': ['ShellfishFree', 'Unknown'],
    'guidelines': ['ReduceSalt'],
    'customGuidelines': ['Caminar 20 minutos'],
    'patientMessage': ' ',
  },
  'patientCheckIn': {
    'followUpId': 31,
    'feeling': 'Fair',
    'difficulties': ['Dinners'],
    'questions': [
      {'text': '¿Puedo comer fuera?', 'origin': 'Patient'},
    ],
    'submittedAt': '2026-09-15T10:00:00-05:00',
    'editedAt': null,
    'isLocked': false,
  },
  'completedAt': null,
  'publishedPlanVersion': null,
  'isFirstConsultation': false,
  'scheduledFollowUpId': null,
};

/// The JSON as the backend receives it: the same text Android's kotlinx serializer writes.
String _wire(Map<String, dynamic> json) => jsonEncode(json);

void main() {
  group('requests carry the backend codes and omit what was not filled in', () {
    test('measurement', () {
      final minimal = NewMeasurement(
        weightKg: 74.2,
        protocolChecks: const {ProtocolCheck.noShoes, ProtocolCheck.fasting},
        activityLevel: ActivityLevel.light,
      );

      expect(_wire(minimal.toDto().toJson()), '{"weightKg":74.2,"protocolChecks":["Fasting","NoShoes"],"activityLevel":"Light"}');
    });

    test('measurement with every optional block', () {
      final full = NewMeasurement(
        weightKg: 74.2,
        waistCm: 88,
        bodyFatPercentage: 24,
        protocolChecks: const {ProtocolCheck.fasting},
        activityLevel: ActivityLevel.moderate,
        habits: EatingHabits(mealsPerDay: 4, waterLitersPerDay: 1.5),
        biochemistry: BiochemistryPanel(glucoseMgDl: 92, totalCholesterolMgDl: 180, triglyceridesMgDl: 120),
      );

      expect(
        _wire(full.toDto().toJson()),
        '{"weightKg":74.2,"waistCm":88.0,"bodyFatPercentage":24.0,"protocolChecks":["Fasting"],'
        '"activityLevel":"Moderate","habits":{"mealsPerDay":4,"waterLitersPerDay":1.5},'
        '"biochemistry":{"fastingGlucoseMgDl":92.0,"totalCholesterolMgDl":180.0,"triglyceridesMgDl":120.0}}',
      );
    });

    test('start, with and without an appointment', () {
      expect(_wire(const StartConsultationRequestDto().toJson()), '{}');
      expect(_wire(const StartConsultationRequestDto(scheduledFollowUpId: 4).toJson()), '{"scheduledFollowUpId":4}');
    });

    test('diagnosis, accepted from the AI or chosen', () {
      expect(
        _wire(const AcceptAiSuggestion(DiagnosisCode.overweightGradeI, 77, 'IMC').toDto().toJson()),
        '{"code":"OverweightGradeI","source":"AiSuggestionAccepted","aiGenerationId":77,"rationale":"IMC"}',
      );
      expect(
        _wire(const SelectedDiagnosis(DiagnosisCode.obesityGradeI).toDto().toJson()),
        '{"code":"ObesityGradeI","source":"PractitionerSelected"}',
      );
      // A rule suggestion is a choice that carries its rationale; a blank one is not sent.
      expect(
        _wire(const SelectedDiagnosis(DiagnosisCode.normalWeight, 'IMC 22').toDto().toJson()),
        '{"code":"NormalWeight","source":"PractitionerSelected","rationale":"IMC 22"}',
      );
      expect(
        _wire(const AcceptAiSuggestion(DiagnosisCode.normalWeight, 1, '  ').toDto().toJson()),
        '{"code":"NormalWeight","source":"AiSuggestionAccepted","aiGenerationId":1}',
      );
    });

    test('target proposal: defaults are an empty object, parameters go inside "parameters"', () {
      expect(_wire(const TargetProposalRequestDto().toJson()), '{}');

      final parameters = TargetParameters(
        equation: EnergyEquation.katchMcArdle,
        deficitKind: DeficitKind.percentOfTdee,
        deficitValue: 20,
        proteinGramsPerKg: 1.6,
        fatPercentOfEnergy: 30,
      );
      expect(
        _wire(TargetProposalRequestDto(parameters: parameters.toDto()).toJson()),
        '{"parameters":{"equation":"KatchMcArdle","deficitKind":"PercentOfTdee","deficitValue":20.0,'
        '"proteinGramsPerKg":1.6,"fatPercentOfEnergy":30.0}}',
      );
    });

    test('targets: accepted as proposed or overridden with the trimmed reason', () {
      expect(_wire(const AcceptedAsProposed().toDto().toJson()), '{"outcome":"AcceptedAsProposed"}');
      expect(
        _wire(
          OverriddenTargets(
            Targets(energyKcal: 1700, proteinG: 120, carbG: 180, fatG: 55),
            OverrideReason(' Su ritmo '),
          ).toDto().toJson(),
        ),
        '{"outcome":"Overridden","energyKcal":1700.0,"proteinG":120.0,"carbG":180.0,"fatG":55.0,"overrideReason":"Su ritmo"}',
      );
    });

    test('publication keeps the catalog order and trims what the practitioner wrote', () {
      final publication = Publication(
        restrictions: const {PlanRestrictionCode.halal, PlanRestrictionCode.lactoseFree},
        guidelines: const {PlanGuidelineCode.reduceSalt},
        customGuidelines: [CustomGuidelineText(' Caminar 20 minutos ')],
        patientMessage: PatientMessage('¡Vamos bien!'),
      );

      expect(
        _wire(publication.toDto().toJson()),
        '{"restrictions":["LactoseFree","Halal"],"guidelines":["ReduceSalt"],'
        '"customGuidelines":["Caminar 20 minutos"],"patientMessage":"¡Vamos bien!"}',
      );
      expect(
        _wire(Publication(restrictions: const {}, guidelines: const {}, customGuidelines: const []).toDto().toJson()),
        '{"restrictions":[],"guidelines":[],"customGuidelines":[]}',
      );
    });
  });

  group('the consultation resource', () {
    test('re-hydrates every saved step and drops unknown codes', () {
      final consultation = ConsultationDto.fromJson(_consultationJson()).toDomain();

      expect(consultation.id, ConsultationId(9));
      expect(consultation.isInProgress, isTrue);
      expect(consultation.currentStep, ConsultationStep.publication);
      expect(consultation.lastSavedAt, DateTime.utc(2026, 10, 7, 14, 40, 0, 123, 456));

      final measurement = consultation.measurement!;
      expect(measurement.protocolChecks, {ProtocolCheck.fasting, ProtocolCheck.noShoes});
      expect(measurement.activityLevel, ActivityLevel.moderate);
      expect(measurement.waistCm, 88);
      expect(measurement.habits?.mealsPerDay, 4);
      expect(measurement.biochemistry, isNull);
      expect(measurement.sex, BiologicalSex.female);

      // During an ongoing consultation the step 2 diagnosis stays pending until it is published.
      expect(consultation.diagnosis?.source, DiagnosisSource.aiSuggestionAccepted);
      expect(consultation.diagnosis!.isPending, isTrue);

      final targets = consultation.targets!;
      expect(targets.isOverridden, isTrue);
      expect(targets.prescribed, Targets(energyKcal: 1700, proteinG: 120, carbG: 180, fatG: 55));
      expect(targets.basis.deficitKind, DeficitKind.fixedKcal);
      expect(targets.overrideReason, 'Su ritmo');

      expect(consultation.publicationDraft?.restrictions, {PlanRestrictionCode.shellfishFree});
      expect(consultation.publicationDraft?.customGuidelines, ['Caminar 20 minutos']);
      expect(consultation.publicationDraft?.patientMessage, isNull);
      expect(consultation.patientCheckIn?.questions, ['¿Puedo comer fuera?']);
      expect(consultation.patientCheckIn?.submittedAt, DateTime.utc(2026, 9, 15, 15));
    });

    test('a consultation with only step 1 saved has nothing else', () {
      final json = _consultationJson()
        ..remove('diagnosis')
        ..remove('targets')
        ..remove('publicationDraft')
        ..remove('patientCheckIn');

      final consultation = ConsultationDto.fromJson(json).toDomain();

      expect(consultation.measurement, isNotNull);
      expect(consultation.diagnosis, isNull);
      expect(consultation.targets, isNull);
      expect(consultation.publicationDraft, isNull);
      expect(consultation.patientCheckIn, isNull);
    });

    test('the AI resources: the rule fallback is never labelled AI', () {
      final ai = DiagnosisSuggestionDto.fromJson({
        'aiGenerationId': 77,
        'code': 'OverweightGradeI',
        'rationale': 'IMC',
        'source': 'Ai',
        'disclaimer': 'Revisa',
      }).toDomain();
      final rule = DiagnosisSuggestionDto.fromJson({'code': 'NormalWeight', 'source': 'Rule'}).toDomain();
      // "Ai" without a generation to trace is not accepted as AI either.
      final untraceable = DiagnosisSuggestionDto.fromJson({'code': 'NormalWeight', 'source': 'Ai'}).toDomain();

      expect(ai.isFromAi, isTrue);
      expect(ai.aiGenerationId, 77);
      expect(rule.isFromAi, isFalse);
      expect(untraceable.isFromAi, isFalse);
      expect(
        () => DiagnosisSuggestionDto.fromJson({'code': 'Mystery'}).toDomain(),
        throwsFormatException,
      );

      final guidelines = GuidelineSuggestionsDto.fromJson({
        'suggested': ['ReduceSalt', 'Unknown', 'ReduceSalt', 'Drink2LWater'],
        'source': 'Ai',
      }).toDomain();
      expect(guidelines.codes, [PlanGuidelineCode.reduceSalt, PlanGuidelineCode.drink2lWater]);
      expect(guidelines.isFromAi, isTrue);
      expect(GuidelineSuggestionsDto.fromJson({'suggested': <String>[]}).toDomain().isFromAi, isFalse);
    });

    test('the target proposal keeps what it was calculated with', () {
      final proposal = TargetProposalDto.fromJson({
        'calculationBasis': {
          'equation': 'MifflinStJeor',
          'referenceWeightKg': 74.2,
          'activityFactor': 1.55,
          'deficitKind': 'PercentOfTdee',
          'deficitValue': 20,
        },
        'proposal': {'energyKcal': 1796, 'proteinG': 119, 'carbG': 195, 'fatG': 60},
        'inputsSummary': {'sex': 'Female', 'ageYears': 31, 'heightCm': 168, 'weightKg': 74.2, 'activityLevel': 'Moderate'},
      }).toDomain();

      expect(proposal.basis.deficitKind, DeficitKind.percentOfTdee);
      expect(proposal.proposal.energyKcal, 1796);
      expect(proposal.inputs.sex, BiologicalSex.female);
      expect(proposal.inputs.activityLevel, ActivityLevel.moderate);
    });
  });

  group('repository', () {
    late List<http.Request> requests;
    late ConsultationRepositoryImpl repository;

    void respondWith(FutureOr<http.Response> Function(http.Request request) handler, {Duration? timeout}) {
      requests = [];
      final api = ApiClient(
        MockClient((request) async {
          requests.add(request);
          return handler(request);
        }),
        baseUrl: Uri.parse('https://test.local/api/v1/'),
        readTimeout: timeout ?? defaultReadTimeout,
      );
      repository = ConsultationRepositoryImpl(ConsultationService(api));
    }

    final id = ConsultationId(9);
    final publication = Publication(restrictions: const {}, guidelines: const {}, customGuidelines: const []);

    test('each step goes to its endpoint with its verb', () async {
      respondWith((request) {
        if (request.url.path.endsWith('diagnosis-suggestion')) {
          return _json(200, {'aiGenerationId': 77, 'code': 'OverweightGradeI', 'source': 'Ai'});
        }
        if (request.url.path.endsWith('target-proposal')) {
          return _json(200, {
            'calculationBasis': {'equation': 'MifflinStJeor'},
            'proposal': {'energyKcal': 1796, 'proteinG': 119, 'carbG': 195, 'fatG': 60},
            'inputsSummary': {'ageYears': 31},
          });
        }
        if (request.url.path.endsWith('guideline-suggestions')) {
          return _json(200, {'suggested': ['ReduceSalt'], 'source': 'Rule'});
        }
        return _json(200, _consultationJson());
      });

      await repository.recordMeasurement(
        id,
        NewMeasurement(
          weightKg: 74.2,
          protocolChecks: const {ProtocolCheck.fasting},
          activityLevel: ActivityLevel.moderate,
        ),
      );
      await repository.suggestDiagnosis(id);
      await repository.issueDiagnosis(id, const SelectedDiagnosis(DiagnosisCode.normalWeight));
      await repository.proposeTargets(id, null);
      await repository.prescribeTargets(id, const AcceptedAsProposed());
      await repository.suggestGuidelines(id);
      await repository.saveDraft(id, publication);

      expect([for (final r in requests) '${r.method} ${r.url.path}'], [
        'PUT /api/v1/consultations/9/measurement',
        'POST /api/v1/consultations/9/diagnosis-suggestion',
        'PUT /api/v1/consultations/9/diagnosis',
        'POST /api/v1/consultations/9/target-proposal',
        'PUT /api/v1/consultations/9/targets',
        'POST /api/v1/consultations/9/guideline-suggestions',
        'PUT /api/v1/consultations/9/publication-draft',
      ]);
      expect(requests[1].body, isEmpty);
      expect(requests[3].body, '{}');
    });

    test('publishing sends the same idempotency key on every try', () async {
      respondWith((_) => _json(200, _consultationJson()));
      final key = IdempotencyKey('abc-123');

      await repository.publish(id, publication, key);
      await repository.publish(id, publication, key);

      expect([for (final r in requests) r.headers['Idempotency-Key']], ['abc-123', 'abc-123']);
      expect(requests.first.method, 'POST');
      expect(requests.first.url.path, '/api/v1/consultations/9/publication');
      expect(requests.first.headers['Content-Type'], contains('application/json'));
      expect(requests.first.body, '{"restrictions":[],"guidelines":[],"customGuidelines":[]}');
    });

    test('no consultation in progress is null, not an error', () async {
      respondWith((_) => _problem(404, 'ConsultationNotFound'));

      final result = await repository.getInProgress(PatientId(7));

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isNull);
    });

    test('discard deletes the consultation and a closed one keeps its backend code', () async {
      respondWith((_) => http.Response('', 204));
      expect((await repository.discard(id)).isSuccess, isTrue);
      expect(requests.single.method, 'DELETE');
      expect(requests.single.url.path, '/api/v1/consultations/9');

      respondWith((_) => _problem(409, 'ConsultationNotInProgress'));
      expect((await repository.discard(id)).errorOrNull, const Conflict('ConsultationNotInProgress'));
    });

    test('backend codes reach the screens as they are', () async {
      respondWith((_) => _problem(400, 'OverrideReasonRequired'));
      expect(
        (await repository.prescribeTargets(id, const AcceptedAsProposed())).errorOrNull,
        const Validation('OverrideReasonRequired'),
      );

      respondWith((_) => _problem(422, 'ConsultationStepOutOfOrder'));
      expect(
        (await repository.proposeTargets(id, null)).errorOrNull,
        const Validation('ConsultationStepOutOfOrder'),
      );

      respondWith((_) => _problem(400, 'ImplausibleMeasurement'));
      expect(
        (await repository.recordMeasurement(
          id,
          NewMeasurement(weightKg: 74, protocolChecks: const {ProtocolCheck.fasting}, activityLevel: ActivityLevel.light),
        )).errorOrNull,
        const Validation('ImplausibleMeasurement'),
      );

      respondWith((_) => _problem(422, 'BaselineRequired'));
      expect((await repository.start(PatientId(7), null)).errorOrNull, const Validation('BaselineRequired'));
    });

    test('an AI call that does not answer in time is a network failure, not a hang', () async {
      respondWith((_) => Completer<http.Response>().future, timeout: const Duration(milliseconds: 20));

      expect((await repository.suggestDiagnosis(id)).errorOrNull, isA<Network>());
      expect((await repository.suggestGuidelines(id)).errorOrNull, isA<Network>());
    });

    test('a resource that breaks a domain rule is read as malformed instead of crashing', () async {
      final broken = _consultationJson();
      ((broken['targets'] as Map)['proposal'] as Map)['energyKcal'] = 0;
      respondWith((_) => _json(200, broken));

      final result = await repository.getInProgress(PatientId(7));

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('a body with the wrong shape is malformed too', () async {
      respondWith((_) => _json(200, {'consultationId': 'nine'}));

      expect((await repository.recordMeasurement(
        id,
        NewMeasurement(weightKg: 74, protocolChecks: const {ProtocolCheck.fasting}, activityLevel: ActivityLevel.light),
      )).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });
  });
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
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

const _recordJson = {
  'patientId': 7,
  'intervention': {'planVersion': 3, 'validFrom': '2026-09-04T10:00:00-05:00', 'energyKcal': 1796.0},
  'followUp': {
    'referrals': [
      {
        'referralId': 1,
        'specialty': 'Endocrinología',
        'issuedAt': '2026-09-08T10:00:00-05:00',
        'status': 'Open',
        'reason': '  Descartar hipotiroidismo.  ',
      },
      {
        'referralId': 2,
        'specialty': 'Cardiología',
        'issuedAt': '2026-08-01T10:00:00-05:00',
        'status': 'Closed',
        'closedAt': '2026-08-20T10:00:00-05:00',
      },
    ],
  },
  'activeDiagnosis': {'code': 'OverweightGradeI', 'statement': '', 'issuedAt': '2026-03-03T10:00:00-05:00'},
  'evaluations': [
    {'assessmentId': 1, 'takenAt': '2026-03-03T10:00:00-05:00', 'weightKg': 76.0, 'bmi': 26.9, 'isFirst': true},
    {'assessmentId': 2, 'takenAt': '2026-09-03T10:00:00-05:00', 'weightKg': 74.2, 'bmi': 26.3, 'waistCm': 88.0},
  ],
  'clinicalWeight': {
    'latestKg': 74.2,
    'latestDate': '2026-09-03T10:00:00-05:00',
    'deltaKgSinceFirst': -1.8,
    'firstDate': '2026-03-03T10:00:00-05:00',
  },
  'bmi': {'value': 26.3, 'category': 'OverweightGradeI'},
  'compliance': {'from': '2026-09-30', 'to': '2026-10-06', 'met': 5, 'total': 7},
};

const _assessmentJson = {
  'assessmentId': 2,
  'ageYears': 31,
  'biologicalSex': 'Female',
  'anthropometry': [
    {'weightKg': 76.0, 'heightCm': 168.0, 'takenAt': '2026-03-03T10:00:00-05:00', 'bmi': 26.9},
    {
      'weightKg': 74.2,
      'heightCm': 168.0,
      'waistCircumferenceCm': 88.0,
      'bodyFatPercentage': 27.0,
      'takenAt': '2026-09-03T10:00:00-05:00',
      'bmi': 26.3,
      'bmiCategory': 'OverweightGradeI',
      'protocolChecks': ['Fasting', 'Unknown'],
    },
  ],
  'activityLevel': 'Light',
  'eatingHabits': {'mealsPerDay': 4, 'waterLitersPerDay': 1.5},
  'biochemistryPanel': {'fastingGlucoseMgDl': 92.0},
};

void main() {
  late List<http.Request> requests;
  late PractitionerRecordRepositoryImpl repository;

  void respondWith(FutureOr<http.Response> Function(http.Request request) handler) {
    requests = [];
    final api = ApiClient(
      MockClient((request) async {
        requests.add(request);
        return handler(request);
      }),
      baseUrl: Uri.parse('https://test.local/api/v1/'),
    );
    repository = PractitionerRecordRepositoryImpl(PractitionerPatientService(api));
  }

  group('record', () {
    test('GET patients/{id}/record?days=30 maps every section', () async {
      respondWith((_) => _json(200, _recordJson));

      final result = await repository.getRecord(PatientId(7));

      expect(requests.single.method, 'GET');
      expect(requests.single.url.path, '/api/v1/patients/7/record');
      expect(requests.single.url.queryParameters, {'days': '30'});
      final record = result.valueOrNull!;
      expect(record.clinicalWeight!.latestKg, 74.2);
      expect(record.clinicalWeight!.deltaKgSinceFirst, -1.8);
      expect(record.bmi!.category, DiagnosisCode.overweightGradeI);
      expect(record.activeTargets!.planVersion, 3);
      expect(record.activeTargets!.energyKcal, 1796);
      expect(record.compliance!.ratio.met, 5);
      expect(record.compliance!.ratio.total, 7);
      expect(record.activeDiagnosis!.code, DiagnosisCode.overweightGradeI);
      expect(record.referrals.map((r) => r.id), [1, 2]);
      expect(record.referrals.first.isOpen, isTrue);
      expect(record.referrals.first.reason, 'Descartar hipotiroidismo.');
      expect(record.referrals.last.isOpen, isFalse);
      expect(record.referrals.last.closedAt, isNotNull);
    });

    test('the assessments come newest first', () async {
      respondWith((_) => _json(200, _recordJson));

      final record = (await repository.getRecord(PatientId(7))).valueOrNull!;

      expect(record.evaluations.map((e) => e.assessmentId), [2, 1]);
      expect(record.evaluations.first.waistCm, 88);
      expect(record.evaluations.last.isFirst, isTrue);
    });

    test('a record with no sections is still a record', () async {
      respondWith((_) => _json(200, {'patientId': 7}));

      final record = (await repository.getRecord(PatientId(7))).valueOrNull!;

      expect(record.clinicalWeight, isNull);
      expect(record.bmi, isNull);
      expect(record.activeTargets, isNull);
      expect(record.compliance, isNull);
      expect(record.activeDiagnosis, isNull);
      expect(record.referrals, isEmpty);
      expect(record.evaluations, isEmpty);
    });

    test('a section that cannot be read is dropped, not the whole record', () async {
      respondWith(
        (_) => _json(200, {
          ..._recordJson,
          'clinicalWeight': {'latestKg': 74.2, 'latestDate': 'nope', 'deltaKgSinceFirst': 0, 'firstDate': 'nope'},
          'compliance': {'from': '2026-09-30', 'to': '2026-10-06', 'met': 9, 'total': 7},
        }),
      );

      final record = (await repository.getRecord(PatientId(7))).valueOrNull!;

      expect(record.clinicalWeight, isNull);
      expect(record.compliance, isNull);
      expect(record.bmi, isNotNull);
    });

    test('an unknown diagnosis code keeps its statement', () async {
      respondWith(
        (_) => _json(200, {
          'patientId': 7,
          'activeDiagnosis': {'code': 'SomethingNew', 'statement': 'Sobrepeso', 'issuedAt': '2026-03-03T10:00:00-05:00'},
        }),
      );

      final diagnosis = (await repository.getRecord(PatientId(7))).valueOrNull!.activeDiagnosis!;

      expect(diagnosis.code, isNull);
      expect(diagnosis.statement, 'Sobrepeso');
    });

    test('a body with the wrong shape reads as an unreadable response', () async {
      respondWith((_) => _json(200, {'patientId': 'seven'}));

      final result = await repository.getRecord(PatientId(7));

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('403 without an active link', () async {
      respondWith((_) => _problem(403, 'ActiveCareLinkRequired'));

      final result = await repository.getRecord(PatientId(7));

      expect(result.errorOrNull, isA<Forbidden>());
    });
  });

  group('assessment detail', () {
    test('GET nutritional-assessments/{id} shows the latest measurement', () async {
      respondWith((_) => _json(200, _assessmentJson));

      final detail = (await repository.getEvaluation(2)).valueOrNull!;

      expect(requests.single.url.path, '/api/v1/nutritional-assessments/2');
      final measurement = detail.measurement;
      expect(measurement.weightKg, 74.2);
      expect(measurement.waistCm, 88);
      expect(measurement.bodyFatPercentage, 27);
      expect(measurement.ageYears, 31);
      expect(measurement.sex, BiologicalSex.female);
      expect(measurement.activityLevel, ActivityLevel.light);
      expect(measurement.protocolChecks, {ProtocolCheck.fasting});
      expect(measurement.habits!.mealsPerDay, 4);
      expect(measurement.habits!.mealsOutPerWeek, isNull);
      expect(measurement.biochemistry!.glucoseMgDl, 92);
      expect(detail.bmiCategory, DiagnosisCode.overweightGradeI);
      expect(detail.takenAt.toUtc(), DateTime.utc(2026, 9, 3, 15));
    });

    test('without a measurement it cannot be shown', () async {
      respondWith((_) => _json(200, {'assessmentId': 2, 'anthropometry': <Object>[]}));

      final result = await repository.getEvaluation(2);

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('403 when it was recorded by someone else and 404 when it is missing', () async {
      respondWith((_) => _problem(403, 'AssessmentForbidden'));
      expect((await repository.getEvaluation(2)).errorOrNull, isA<Forbidden>());

      respondWith((_) => _problem(404, 'AssessmentNotFound'));
      expect((await repository.getEvaluation(2)).errorOrNull, isA<NotFound>());
    });
  });
}

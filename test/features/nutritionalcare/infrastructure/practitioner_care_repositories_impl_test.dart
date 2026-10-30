import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_baseline.dart';
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

const _baselineJson = {
  'patientId': 7,
  'birthDate': '1995-02-15',
  'ageYears': 31,
  'biologicalSex': 'Female',
  'heightCm': 168.0,
  'conditions': ['Hypothyroidism'],
};

const _consultationJson = {
  'consultationId': 9,
  'patientId': 7,
  'state': 'InProgress',
  'currentStep': 'Measurement',
  'stepNumber': 1,
  'lastSavedAt': '2026-10-30T09:00:00-05:00',
};

final _newBaseline = NewBaseline(
  birthDate: BirthDate(DateTime(1995, 2, 15), DateTime(2026, 10, 30)),
  sex: BiologicalSex.female,
  height: HeightCm(168),
  conditions: const {MedicalCondition.hypothyroidism},
);

void main() {
  late List<http.Request> requests;
  late ApiClient api;

  void respondWith(FutureOr<http.Response> Function(http.Request request) handler) {
    requests = [];
    api = ApiClient(
      MockClient((request) async {
        requests.add(request);
        return handler(request);
      }),
      baseUrl: Uri.parse('https://test.local/api/v1/'),
    );
  }

  group('baseline', () {
    PatientBaselineRepositoryImpl repository() => PatientBaselineRepositoryImpl(PatientBaselineService(api));

    test('GET reads the baseline', () async {
      respondWith((_) => _json(200, _baselineJson));

      final result = await repository().get(PatientId(7));

      expect(requests.single.method, 'GET');
      expect(requests.single.url.toString(), 'https://test.local/api/v1/patients/7/baseline');
      expect(result.valueOrNull!.sex, BiologicalSex.female);
    });

    test('404 BaselineNotFound is "no baseline yet", not an error', () async {
      respondWith((_) => _problem(404, 'BaselineNotFound'));

      final result = await repository().get(PatientId(7));

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isNull);
    });

    test('any other 404 is still an error', () async {
      respondWith((_) => _problem(404, 'PatientNotFound'));

      expect((await repository().get(PatientId(7))).errorOrNull, const NotFound('PatientNotFound'));
    });

    test('403 and a lost connection are errors', () async {
      respondWith((_) => http.Response('', 403));
      expect((await repository().get(PatientId(7))).errorOrNull, isA<Forbidden>());

      respondWith((_) => throw const SocketException('down'));
      expect((await repository().get(PatientId(7))).errorOrNull, isA<Network>());
    });

    test('POST records the baseline with the wire format', () async {
      respondWith((_) => _json(201, _baselineJson));

      final result = await repository().record(PatientId(7), _newBaseline);

      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/api/v1/patients/7/baseline');
      expect(jsonDecode(requests.single.body), {
        'birthDate': '1995-02-15',
        'biologicalSex': 'Female',
        'heightCm': 168.0,
        'conditions': ['Hypothyroidism'],
      });
      expect(result.isSuccess, isTrue);
    });

    test('POST 409 BaselineAlreadyRecorded comes back as a conflict', () async {
      respondWith((_) => _problem(409, 'BaselineAlreadyRecorded'));

      expect((await repository().record(PatientId(7), _newBaseline)).errorOrNull, const Conflict('BaselineAlreadyRecorded'));
    });

    test('PUT edits it, and 400 InvalidHeight is a validation error', () async {
      respondWith((_) => _json(200, _baselineJson));
      expect((await repository().update(PatientId(7), _newBaseline)).isSuccess, isTrue);
      expect(requests.single.method, 'PUT');

      respondWith((_) => _problem(400, 'InvalidHeight'));
      expect((await repository().update(PatientId(7), _newBaseline)).errorOrNull, const Validation('InvalidHeight'));
    });

    test('a baseline with an unknown sex is a malformed response, not a throw', () async {
      respondWith((_) => _json(200, {..._baselineJson, 'biologicalSex': 'Other'}));

      expect((await repository().get(PatientId(7))).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });
  });

  group('summary and plans', () {
    test('GET summary', () async {
      respondWith(
        (_) => _json(200, {
          'patientId': 7,
          'fullName': 'Ana Flores',
          'linkStatus': 'Active',
          'sinceLastConsultation': {'fromDate': '2026-09-30', 'trendWeeks': 4},
        }),
      );

      final result = await PatientSummaryRepositoryImpl(PractitionerPatientService(api)).getSummary(PatientId(7));

      expect(requests.single.url.path, '/api/v1/patients/7/summary');
      expect(result.valueOrNull!.fullName, 'Ana Flores');
      expect(result.valueOrNull!.isLinkActive, isTrue);
    });

    test('a summary missing a required field is malformed', () async {
      respondWith((_) => _json(200, {'patientId': 7}));

      final result = await PatientSummaryRepositoryImpl(PractitionerPatientService(api)).getSummary(PatientId(7));

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('GET nutrition-plans builds the history, newest first', () async {
      respondWith(
        (_) => _json(200, [
          for (final version in [1, 2])
            {
              'planId': version,
              'version': version,
              'proposal': {'energyKcal': 1800, 'proteinG': 120, 'carbG': 190, 'fatG': 60},
              'isActive': version == 2,
              'publishedAt': '2026-09-04T10:00:00-05:00',
            },
        ]),
      );

      final result = await NutritionPlanRepositoryImpl(PractitionerPatientService(api)).getHistory(PatientId(7));

      expect(requests.single.url.path, '/api/v1/patients/7/nutrition-plans');
      expect(result.valueOrNull!.versions.map((v) => v.version), [2, 1]);
      expect(result.valueOrNull!.active!.version, 2);
    });

    test('403 without an active link is forbidden', () async {
      respondWith((_) => _problem(403, 'AccessNotAllowed'));

      final result = await NutritionPlanRepositoryImpl(PractitionerPatientService(api)).getHistory(PatientId(7));

      expect(result.errorOrNull, const Forbidden('AccessNotAllowed'));
    });
  });

  group('consultation', () {
    ConsultationRepositoryImpl repository() => ConsultationRepositoryImpl(ConsultationService(api));

    test('GET in-progress reads the open consultation', () async {
      respondWith((_) => _json(200, _consultationJson));

      final result = await repository().getInProgress(PatientId(7));

      expect(requests.single.url.path, '/api/v1/patients/7/consultations/in-progress');
      expect(result.valueOrNull!.currentStep, ConsultationStep.measurement);
    });

    test('404 ConsultationNotFound means there is none', () async {
      respondWith((_) => _problem(404, 'ConsultationNotFound'));

      final result = await repository().getInProgress(PatientId(7));

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isNull);
    });

    test('POST start sends the appointment, or an empty object', () async {
      respondWith((_) => _json(201, _consultationJson));

      await repository().start(PatientId(7), 4);
      await repository().start(PatientId(7), null);

      expect(requests.map((r) => r.method), ['POST', 'POST']);
      expect(requests.first.url.path, '/api/v1/patients/7/consultations');
      expect(jsonDecode(requests[0].body), {'scheduledFollowUpId': 4});
      expect(jsonDecode(requests[1].body), isEmpty);
    });

    test('POST start reads a 201 with only the required fields, like ConsultationDtos.kt', () async {
      respondWith(
        (_) => _json(201, {
          'consultationId': 9,
          'patientId': 7,
          'state': 'InProgress',
          'currentStep': 'Measurement',
          'lastSavedAt': '2026-10-30T09:00:00-05:00',
        }),
      );

      final consultation = (await repository().start(PatientId(7), null)).valueOrNull!;

      expect(consultation.currentStep, ConsultationStep.measurement);
      expect(consultation.isInProgress, isTrue);
      expect(consultation.measurement, isNull);
      expect(consultation.patientCheckIn, isNull);
    });

    test('POST start surfaces 409 and 422 by their codes', () async {
      respondWith((_) => _problem(409, 'ConsultationAlreadyInProgress'));
      expect((await repository().start(PatientId(7), null)).errorOrNull, const Conflict('ConsultationAlreadyInProgress'));

      respondWith((_) => _problem(422, 'BaselineRequired'));
      expect((await repository().start(PatientId(7), null)).errorOrNull, const Validation('BaselineRequired'));
    });
  });
}

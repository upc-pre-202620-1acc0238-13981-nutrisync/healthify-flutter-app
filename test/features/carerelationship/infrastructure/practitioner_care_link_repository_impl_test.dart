import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/care_link_id.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/clinical_reason.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/roster_attention.dart';
import 'package:healthify/features/carerelationship/infrastructure/remote/practitioner_care_link_service.dart';
import 'package:healthify/features/carerelationship/infrastructure/repository/practitioner_care_link_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../fakes.dart';

http.Response _json(int status, Object? body) =>
    http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json; charset=utf-8'});

const _anaJson = {
  'patientId': 1,
  'careLinkId': 11,
  'fullName': 'Ana Flores',
  'initial': 'A',
  'linkedSince': '2026-03-12T10:00:00-05:00',
  'linkStatus': 'Active',
  'hasBaseline': true,
  'activePlanVersion': 3,
  'isNew': false,
  'nextFollowUpAt': null,
  'hasConsultationInProgress': false,
  'hasOpenReviewItem': false,
};

void main() {
  late List<http.Request> requests;

  PractitionerCareLinkRepositoryImpl repository(FutureOr<http.Response> Function(http.Request request) handler) {
    requests = [];
    final api = ApiClient(
      MockClient((request) async {
        requests.add(request);
        return handler(request);
      }),
      baseUrl: Uri.parse('https://test.local/api/v1/'),
    );
    return PractitionerCareLinkRepositoryImpl(PractitionerCareLinkService(api));
  }

  group('getRoster', () {
    test('GETs the practitioner roster and maps it', () async {
      final repo = repository((_) => _json(200, [_anaJson]));

      final result = await repo.getRoster(3);

      expect(requests.single.method, 'GET');
      expect(requests.single.url.toString(), 'https://test.local/api/v1/practitioners/3/patient-roster');
      final patient = result.valueOrNull!.patients.single;
      expect(patient.fullName, 'Ana Flores');
      expect(patient.careLinkId, 11);
      expect(patient.isLinkActive, isTrue);
      expect(patient.activePlanVersion, 3);
      expect(patient.linkedSince, DateTime.utc(2026, 3, 12, 15));
    });

    test('skips unreadable patients and keeps the rest', () async {
      final repo = repository(
        (_) => _json(200, [
          _anaJson,
          {'patientId': 2, 'careLinkId': 12, 'fullName': '', 'linkedSince': '2026-03-12T10:00:00-05:00'},
          {'patientId': 3, 'careLinkId': 13, 'fullName': 'Luz Ramírez', 'linkedSince': 'ayer', 'isNew': true},
        ]),
      );

      final roster = (await repo.getRoster(3)).valueOrNull!;

      expect(roster.patients.map((p) => p.fullName), ['Ana Flores']);
    });

    test('reads the next consultation and the open review signal', () async {
      final repo = repository(
        (_) => _json(200, [
          {
            ..._anaJson,
            'nextFollowUpAt': '2026-10-09T10:00:00-05:00',
            'hasOpenReviewItem': true,
          },
        ]),
      );

      final patient = (await repo.getRoster(3)).valueOrNull!.patients.single;

      expect(patient.nextFollowUpAt, DateTime.utc(2026, 10, 9, 15));
      expect(patient.hasOpenReviewItem, isTrue);
      expect(patient.attention, RosterAttention.openReview);
    });

    test('an empty roster is a success with no patients', () async {
      final repo = repository((_) => _json(200, <Object>[]));

      expect((await repo.getRoster(3)).valueOrNull!.isEmpty, isTrue);
    });

    test('a roster that is not a list is a malformed response, not an exception', () async {
      final repo = repository((_) => _json(200, {'unexpected': true}));

      expect((await repo.getRoster(3)).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('an item missing a required field is a malformed response', () async {
      final repo = repository((_) => _json(200, [{'fullName': 'Ana Flores'}]));

      expect((await repo.getRoster(3)).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('someone else\'s roster is Forbidden with the backend code', () async {
      final repo = repository((_) => _json(403, {'status': 403, 'code': 'AccessNotAllowed'}));

      expect((await repo.getRoster(4)).errorOrNull, const Forbidden('AccessNotAllowed'));
    });

    test('no connection is Network', () async {
      final repo = repository((_) => throw const SocketException('offline'));

      expect((await repo.getRoster(3)).errorOrNull, const Network());
    });
  });

  group('issueInvitation', () {
    test('POSTs the expiration in UTC seconds and returns the token', () async {
      final repo = repository(
        (_) => _json(201, {
          'invitationId': 5,
          'token': validToken,
          'expiresAt': '2026-10-31T07:00:00-05:00',
        }),
      );

      final result = await repo.issueInvitation(DateTime.utc(2026, 10, 31, 12, 0, 0, 456));

      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/api/v1/invitations');
      expect(jsonDecode(requests.single.body), {'expiresAt': '2026-10-31T12:00:00Z'});
      final issued = result.valueOrNull!;
      expect(issued.invitationId, 5);
      expect(issued.token.value, validToken);
      expect(issued.expiresAt, DateTime.utc(2026, 10, 31, 12));
    });

    test('a response without a usable token is malformed', () async {
      for (final token in <String?>[null, 'short', 'has spaces and is long enough to be a token']) {
        final repo = repository(
          (_) => _json(201, {'invitationId': 5, 'token': token, 'expiresAt': '2026-10-31T07:00:00-05:00'}),
        );

        final result = await repo.issueInvitation(DateTime.utc(2026, 10, 31, 12));

        expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'), reason: '$token');
      }
    });

    test('a response with an unreadable expiration is malformed', () async {
      final repo = repository((_) => _json(201, {'invitationId': 5, 'token': validToken, 'expiresAt': 'mañana'}));

      final result = await repo.issueInvitation(DateTime.utc(2026, 10, 31, 12));

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('ExpirationDateRequired is a validation error', () async {
      final repo = repository((_) => _json(400, {'status': 400, 'code': 'ExpirationDateRequired'}));

      final result = await repo.issueInvitation(DateTime.utc(2020));

      expect(result.errorOrNull, const Validation('ExpirationDateRequired'));
    });
  });

  group('discharge', () {
    final reason = ClinicalReason.of('Objetivos alcanzados')!;

    test('POSTs the clinical reason to the care link', () async {
      final repo = repository((_) => _json(200, {'careLinkId': 8, 'status': 'Discharged'}));

      final result = await repo.discharge(CareLinkId(8), reason);

      expect(result.isSuccess, isTrue);
      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/api/v1/care-links/8/discharge');
      expect(jsonDecode(requests.single.body), {'clinicalReason': 'Objetivos alcanzados'});
    });

    test('succeeds even if the closed link comes back empty or in another shape', () async {
      expect((await repository((_) => http.Response('', 204)).discharge(CareLinkId(8), reason)).isSuccess, isTrue);
      expect((await repository((_) => _json(200, ['x'])).discharge(CareLinkId(8), reason)).isSuccess, isTrue);
    });

    test('maps the backend errors', () async {
      Future<DomainError?> errorFor(int status, String code) async =>
          (await repository((_) => _json(status, {'status': status, 'code': code})).discharge(CareLinkId(8), reason))
              .errorOrNull;

      expect(await errorFor(409, 'DischargedLinkCannotBeReactivated'), const Conflict('DischargedLinkCannotBeReactivated'));
      expect(await errorFor(403, 'PractitionerOnly'), const Forbidden('PractitionerOnly'));
      expect(await errorFor(404, 'CareLinkNotFound'), const NotFound('CareLinkNotFound'));
      expect(await errorFor(400, 'ClinicalReasonRequired'), const Validation('ClinicalReasonRequired'));
    });
  });
}

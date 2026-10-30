import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/features/monitoring/application/usecase/practitioner_agenda_use_cases.dart';
import 'package:healthify/features/monitoring/domain/entity/practitioner_agenda.dart';
import 'package:healthify/features/monitoring/domain/entity/referral.dart';
import 'package:healthify/features/monitoring/domain/valueobject/monitoring_values.dart';
import 'package:healthify/features/monitoring/infrastructure/remote/dto/practitioner_agenda_dtos.dart';
import 'package:healthify/features/monitoring/infrastructure/remote/practitioner_agenda_service.dart';
import 'package:healthify/features/monitoring/infrastructure/repository/practitioner_agenda_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response _json(int status, Object? body) =>
    http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json; charset=utf-8'});

Map<String, dynamic> _visitJson({
  int id = 1,
  String state = 'Scheduled',
  String scheduledFor = '2026-11-18T10:00:00-05:00',
  Object? preparation = const ['Fasting', 'BringBloodTests'],
  String? modality = 'InPerson',
}) => {
  'followUpId': id,
  'patientId': 11,
  'practitionerId': 3,
  'scheduledFor': scheduledFor,
  'state': state,
  'patientFullName': ' Ana Flores ',
  'preparation': preparation,
  'modality': modality,
};

void main() {
  late List<http.Request> requests;
  var agendaChanges = 0;

  setUp(() => agendaChanges = 0);

  PractitionerAgendaRepositoryImpl repository(FutureOr<http.Response> Function(http.Request request) handler) {
    requests = [];
    final api = ApiClient(
      MockClient((request) async {
        requests.add(request);
        return handler(request);
      }),
      baseUrl: Uri.parse('https://test.local/api/v1/'),
    );
    return PractitionerAgendaRepositoryImpl(PractitionerAgendaService(api), onAgendaChanged: () => agendaChanges++);
  }

  group('the agenda', () {
    test('GET practitioners/{id}/scheduled-follow-ups sends the state and the start in UTC', () async {
      final repo = repository((_) => _json(200, [_visitJson()]));

      final result = await repo.getAgenda(3, FollowUpState.scheduled, DateTime.utc(2026, 10, 30, 12, 0, 5, 700));

      expect(requests.single.method, 'GET');
      expect(requests.single.url.path, '/api/v1/practitioners/3/scheduled-follow-ups');
      expect(requests.single.url.queryParameters, {'state': 'Scheduled', 'from': '2026-10-30T12:00:05Z'});
      final visit = result.valueOrNull!.single;
      expect(visit.id, 1);
      expect(visit.patientId.value, 11);
      expect(visit.patientFullName, 'Ana Flores');
      expect(visit.scheduledFor, DateTime.utc(2026, 11, 18, 15));
      expect(visit.state, FollowUpState.scheduled);
      expect(visit.canBeChanged, isTrue);
      expect(visit.modality, ConsultationModality.inPerson);
    });

    test('without a state or a start the query is empty', () async {
      final repo = repository((_) => _json(200, <Object?>[]));

      final result = await repo.getAgenda(3, null, null);

      expect(requests.single.url.query, isEmpty);
      expect(result.valueOrNull, isEmpty);
    });

    test('the preparation maps catalog codes and keeps an unknown one as text', () async {
      final repo = repository(
        (_) => _json(200, [
          _visitJson(preparation: ['EmptyBladder', 'Ayuno de 8 horas', ' ', 'LightClothing']),
        ]),
      );

      final visit = (await repo.getAgenda(3, null, null)).valueOrNull!.single;

      expect(visit.preparation, hasLength(3));
      expect((visit.preparation[0] as CatalogPreparation).code, PreparationCode.emptyBladder);
      expect((visit.preparation[1] as CustomPreparation).text, 'Ayuno de 8 horas');
      expect((visit.preparation[2] as CatalogPreparation).code, PreparationCode.lightClothing);
    });

    test('a missing preparation or modality uses the defaults', () async {
      final repo = repository((_) => _json(200, [_visitJson(preparation: null, modality: null)]));

      final visit = (await repo.getAgenda(3, null, null)).valueOrNull!.single;

      expect(visit.preparation, isEmpty);
      expect(visit.modality, ConsultationModality.inPerson);
    });

    test('a visit with a state this version does not know, or an unreadable date, is not listed', () async {
      final repo = repository(
        (_) => _json(200, [
          _visitJson(id: 1, state: 'SomethingNew'),
          _visitJson(id: 2, scheduledFor: 'tomorrow'),
          _visitJson(id: 3),
        ]),
      );

      final visits = (await repo.getAgenda(3, null, null)).valueOrNull!;

      expect(visits.map((visit) => visit.id), [3]);
    });

    test('a missing required field is a malformed response', () async {
      final repo = repository((_) => _json(200, [{'followUpId': 1}]));

      expect((await repo.getAgenda(3, null, null)).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('offline and the backend codes map to domain errors', () async {
      var repo = repository((_) => throw const SocketException('offline'));
      expect((await repo.getAgenda(3, null, null)).errorOrNull, isA<Network>());

      repo = repository((_) => _json(403, {'title': 'x', 'code': 'AccessNotAllowed'}));
      expect((await repo.getAgenda(3, null, null)).errorOrNull, isA<Forbidden>());
    });

    test('the use case lists the upcoming visits from now on, nearest first', () async {
      final repo = repository(
        (_) => _json(200, [
          _visitJson(id: 2, scheduledFor: '2026-12-01T10:00:00-05:00'),
          _visitJson(id: 1, scheduledFor: '2026-11-18T10:00:00-05:00'),
        ]),
      );
      final now = DateTime.utc(2026, 10, 30, 12);

      final visits = (await GetUpcomingFollowUpsUseCase(repo, () => now)(3)).valueOrNull!;

      expect(requests.single.url.queryParameters, {'state': 'Scheduled', 'from': '2026-10-30T12:00:00Z'});
      expect(visits.map((visit) => visit.id), [1, 2]);
    });
  });

  group('scheduling', () {
    NewFollowUp followUp() => NewFollowUp(
      patientId: PatientId(11),
      scheduledFor: DateTime.utc(2026, 11, 18, 15, 0, 0, 123),
      preparation: const FollowUpPreparation({PreparationCode.emptyBladder, PreparationCode.fasting}),
    );

    test('POST scheduled-follow-ups sends the moment in UTC, the preparation in catalog order and the modality', () async {
      final repo = repository((_) => _json(201, _visitJson()));

      final result = await repo.schedule(followUp());

      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/api/v1/scheduled-follow-ups');
      expect(jsonDecode(requests.single.body), {
        'patientId': 11,
        'scheduledFor': '2026-11-18T15:00:00Z',
        'preparation': ['Fasting', 'EmptyBladder'],
        'modality': 'InPerson',
      });
      expect(result.valueOrNull!.id, 1);
    });

    test('an unreadable answer is a malformed response, not an exception', () async {
      final repo = repository((_) => _json(201, _visitJson(state: 'SomethingNew')));

      expect((await repo.schedule(followUp())).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('the scheduling codes arrive as domain errors', () async {
      for (final (status, code, matcher) in <(int, String, Matcher)>[
        (400, 'ScheduledForMustBeInFuture', isA<Validation>()),
        (403, 'ActiveCareLinkRequired', isA<Forbidden>()),
        (409, 'PatientAlreadyHasActiveScheduledFollowUp', isA<Conflict>()),
      ]) {
        final repo = repository((_) => _json(status, {'title': 'x', 'code': code}));
        final error = (await repo.schedule(followUp())).errorOrNull;
        expect(error, matcher, reason: code);
        expect(error!.code, code);
      }
    });

    test('the use case rejects a moment that is not in the future before sending', () async {
      final repo = repository((_) => _json(201, _visitJson()));
      final now = DateTime.utc(2026, 11, 18, 15);

      final result = await ScheduleFollowUpUseCase(repo, () => now)(followUp().copyForTest(DateTime.utc(2026, 11, 18, 15)));

      expect(result.errorOrNull, const Validation('ScheduledForMustBeInFuture'));
      expect(requests, isEmpty);
    });

    test('the use case sends a moment that is in the future', () async {
      final repo = repository((_) => _json(201, _visitJson()));

      final result = await ScheduleFollowUpUseCase(repo, () => DateTime.utc(2026, 10, 30))(followUp());

      expect(result.isSuccess, isTrue);
      expect(requests, hasLength(1));
    });
  });

  group('rescheduling', () {
    test('POST scheduled-follow-ups/{id}/rescheduling replaces the moment and the preparation', () async {
      final repo = repository((_) => _json(200, _visitJson(id: 5)));

      final result = await repo.reschedule(
        5,
        DateTime.utc(2026, 11, 20, 21, 45),
        const FollowUpPreparation({PreparationCode.bringBloodTests}),
      );

      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/api/v1/scheduled-follow-ups/5/rescheduling');
      expect(jsonDecode(requests.single.body), {
        'scheduledFor': '2026-11-20T21:45:00Z',
        'preparation': ['BringBloodTests'],
      });
      expect(result.valueOrNull!.id, 5);
    });

    test('an empty preparation is sent as an empty list, so it clears the old one', () async {
      final repo = repository((_) => _json(200, _visitJson(id: 5)));

      await repo.reschedule(5, DateTime.utc(2026, 11, 20, 21), const FollowUpPreparation({}));

      expect((jsonDecode(requests.single.body) as Map)['preparation'], isEmpty);
    });

    test('the use case rejects a moment that is not in the future before sending', () async {
      final repo = repository((_) => _json(200, _visitJson()));

      final result = await RescheduleFollowUpUseCase(repo, () => DateTime.utc(2026, 11, 21))(
        5,
        DateTime.utc(2026, 11, 20),
        const FollowUpPreparation({}),
      );

      expect(result.errorOrNull, const Validation('ScheduledForMustBeInFuture'));
      expect(requests, isEmpty);
    });
  });

  group('cancelling', () {
    test('POST scheduled-follow-ups/{id}/cancellation answers 204 and sends `{}` without a reason', () async {
      final repo = repository((_) => http.Response('', 204));

      final result = await repo.cancel(5, null);

      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/api/v1/scheduled-follow-ups/5/cancellation');
      expect(jsonDecode(requests.single.body), isEmpty);
      expect(result.isSuccess, isTrue);
    });

    test('a reason is trimmed and cut at 30 characters', () async {
      final repo = repository((_) => http.Response('', 204));

      await repo.cancel(5, CancellationReason.ofOptional('  ${'a' * 40}  '));

      expect(jsonDecode(requests.single.body), {'reason': 'a' * 30});
      expect(CancellationReason.ofOptional('   '), isNull);
    });

    test('a visit that is no longer scheduled is a conflict or a not-found', () async {
      var repo = repository((_) => _json(409, {'title': 'x', 'code': 'FollowUpNotCancellable'}));
      expect((await repo.cancel(5, null)).errorOrNull, isA<Conflict>());

      repo = repository((_) => _json(404, {'title': 'x', 'code': 'ScheduledFollowUpNotFound'}));
      expect((await repo.cancel(5, null)).errorOrNull, isA<NotFound>());
    });
  });

  group('referrals', () {
    test('POST referrals sends the patient, the specialty and the reason as written', () async {
      final repo = repository((_) => _json(201, {'referralId': 1}));
      final referral = NewReferral(PatientId(11), ReferralSpecialty('Endocrinología'), ReferralReason('Hipotiroidismo\ncon TSH alta'));

      final result = await repo.recordReferral(referral);

      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/api/v1/referrals');
      expect(jsonDecode(requests.single.body), {
        'patientId': 11,
        'specialty': 'Endocrinología',
        'reason': 'Hipotiroidismo\ncon TSH alta',
      });
      expect(result.isSuccess, isTrue);
    });

    test('the referral codes arrive as domain errors', () async {
      final referral = NewReferral(PatientId(11), ReferralSpecialty('x'), ReferralReason('y'));
      var repo = repository((_) => _json(400, {'title': 'x', 'code': 'SpecialtyAndReasonRequired'}));
      expect((await repo.recordReferral(referral)).errorOrNull, isA<Validation>());

      repo = repository((_) => _json(403, {'title': 'x', 'code': 'ActiveCareLinkRequired'}));
      expect((await repo.recordReferral(referral)).errorOrNull, isA<Forbidden>());

      repo = repository((_) => throw const SocketException('offline'));
      expect((await repo.recordReferral(referral)).errorOrNull, isA<Network>());
    });

    test('the referral rules: a specialty up to 120 characters and a reason up to 1000', () {
      final patient = PatientId(11);

      expect((ReferralValidation.of(patient, ' ', 'Soplo') as InvalidReferral).missing, {ReferralField.specialty});
      expect((ReferralValidation.of(patient, 'Cardiología', '') as InvalidReferral).missing, {ReferralField.reason});
      expect(ReferralValidation.of(patient, 'Cardiología', 'Soplo'), isA<ValidReferral>());
      expect(() => ReferralSpecialty('a' * 121), throwsArgumentError);
      expect(() => ReferralReason('a' * 1001), throwsArgumentError);
      expect(ReferralSpecialty('a' * 120).text, hasLength(120));
    });
  });

  group('the moment of a visit', () {
    final now = DateTime.utc(2026, 10, 30, 12);

    test('a date and time in the future are valid and become an instant', () {
      final moment = FollowUpMoment.of(DateTime(2026, 11, 18), (hour: 10, minute: 30), now);

      expect((moment as ValidMoment).instant, DateTime(2026, 11, 18, 10, 30).toUtc());
    });

    test('a missing date or time is incomplete', () {
      expect(FollowUpMoment.of(null, (hour: 10, minute: 0), now), isA<IncompleteMoment>());
      expect(FollowUpMoment.of(DateTime(2026, 11, 18), null, now), isA<IncompleteMoment>());
    });

    test('the past and right now are not in the future', () {
      final local = now.toLocal();
      expect(
        FollowUpMoment.of(DateTime(local.year, local.month, local.day), (hour: local.hour, minute: local.minute), now),
        isA<MomentNotInFuture>(),
      );
      expect(FollowUpMoment.of(DateTime(2026, 1, 1), (hour: 8, minute: 0), now), isA<MomentNotInFuture>());
    });
  });

  test('the cancel request without a reason keeps the JSON empty', () {
    expect(const CancelFollowUpRequestDto().toJson(), isEmpty);
  });

  group('changes to the agenda reschedule the reminders', () {
    final followUp = NewFollowUp(
      patientId: PatientId(11),
      scheduledFor: DateTime.utc(2026, 11, 18, 15),
      preparation: const FollowUpPreparation({PreparationCode.fasting}),
    );
    const preparation = FollowUpPreparation({PreparationCode.fasting});

    test('after scheduling, rescheduling or cancelling', () async {
      await repository((_) => _json(201, _visitJson())).schedule(followUp);
      await repository((_) => _json(200, _visitJson())).reschedule(1, DateTime.utc(2026, 11, 19, 15), preparation);
      await repository((_) => http.Response('', 204)).cancel(1, null);

      expect(agendaChanges, 3);
    });

    test('not when the change fails, nor on reading the agenda or recording a referral', () async {
      final failing = repository((_) => _json(409, {'code': 'PatientAlreadyHasActiveScheduledFollowUp'}));
      await failing.schedule(followUp);
      await failing.reschedule(1, DateTime.utc(2026, 11, 19, 15), preparation);
      await failing.cancel(1, null);
      await repository((_) => _json(200, [_visitJson()])).getAgenda(3, FollowUpState.scheduled, null);
      await repository(
        (_) => http.Response('', 201),
      ).recordReferral(NewReferral(PatientId(11), ReferralSpecialty('Endocrinología'), ReferralReason('Control')));

      expect(agendaChanges, 0);
    });
  });
}

extension on NewFollowUp {
  NewFollowUp copyForTest(DateTime scheduledFor) =>
      NewFollowUp(patientId: patientId, scheduledFor: scheduledFor, preparation: preparation, modality: modality);
}

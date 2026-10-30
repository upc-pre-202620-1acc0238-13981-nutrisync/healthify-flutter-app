import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/review_inbox_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_history.dart' show Targets;
import 'package:healthify/features/nutritionalcare/domain/entity/plan_proposal.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/review_item.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/review_values.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/remote/dto/review_item_dtos.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/remote/review_item_service.dart';
import 'package:healthify/features/nutritionalcare/infrastructure/repository/review_inbox_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response _json(int status, Object? body, {Map<String, String> headers = const {}}) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8', ...headers},
);

Map<String, dynamic> _itemJson({
  int id = 1,
  String signalType = 'SustainedDeviation',
  String state = 'Open',
  Map<String, dynamic>? evidenceData,
  Map<String, dynamic> extra = const {},
}) => {
  'reviewItemId': id,
  'patientId': 11,
  'practitionerId': 3,
  'signalType': signalType,
  'evidence': 'Logged 40% below.',
  'state': state,
  'patientFullName': 'Ana Flores',
  'hasPlanProposal': true,
  'createdAt': '2026-09-08T10:00:00-05:00',
  'evidenceData':
      evidenceData ??
      {
        'averagePercentFromTarget': -40.0,
        'deviatedDays': 5,
        'loggedDaysConsidered': 9,
        'direction': 'Below',
        'averageEnergyKcalFromTarget': -718.0,
      },
  ...extra,
};

const _proposalJson = {
  'proposalId': 5,
  'reviewItemId': 1,
  'title': ' Ajustar la energía ',
  'currentEnergyKcal': 1796.0,
  'proposedEnergyKcal': 1650.0,
  'proposedProteinG': 119.0,
  'proposedCarbG': 170.0,
  'proposedFatG': 55.0,
  'addedGuidelines': ['ProteinAndVegetablesAtDinner', 'SomethingNew'],
  'removedGuidelines': ['ReduceSalt'],
  'patientMessage': 'Notamos tus cenas.',
  'recheckAfterDays': 7,
  'rationale': 'Menos energía en la cena.',
  'generatedAt': '2026-09-08T11:00:00-05:00',
  'status': 'Proposed',
};

void main() {
  late List<http.Request> requests;

  ReviewInboxRepositoryImpl repository(FutureOr<http.Response> Function(http.Request request) handler) {
    requests = [];
    final api = ApiClient(
      MockClient((request) async {
        requests.add(request);
        return handler(request);
      }),
      baseUrl: Uri.parse('https://test.local/api/v1/'),
    );
    return ReviewInboxRepositoryImpl(ReviewItemService(api));
  }

  group('the inbox', () {
    test('GET review-items?state=Open maps the items', () async {
      final repo = repository((_) => _json(200, [_itemJson(), _itemJson(id: 2, signalType: 'ConsistencyEscalation', evidenceData: {'consistencyKgPerWeek': 0.46, 'weeksInAlert': 4, 'alertSinceOn': '2026-08-20'})]));

      final result = await repo.getItems(ReviewItemStatus.open);

      expect(requests.single.method, 'GET');
      expect(requests.single.url.path, '/api/v1/review-items');
      expect(requests.single.url.queryParameters, {'state': 'Open'});
      final items = result.valueOrNull!;
      expect(items.map((item) => item.id.value), [1, 2]);
      expect(items.first.patientFullName, 'Ana Flores');
      expect(items.first.signalType, isA<SustainedDeviation>());
      expect(items.first.isOpen, isTrue);
      expect(items.first.offersPlanProposal, isTrue);
      expect(items.first.createdAt, DateTime.utc(2026, 9, 8, 15));
      expect(items.last.signalType, isA<ConsistencyEscalation>());
    });

    test('the deviation evidence comes unsigned, with the direction from `direction`', () async {
      final repo = repository((_) => _json(200, [_itemJson()]));

      final item = (await repo.getItems(ReviewItemStatus.open)).valueOrNull!.single;

      final evidence = item.evidence as SustainedDeviationEvidence;
      expect(evidence.averagePercentFromTarget, 40);
      expect(evidence.averageEnergyKcalFromTarget, 718);
      expect(evidence.direction, DeviationDirection.below);
      expect(evidence.deviatedDays, 5);
      expect(evidence.loggedDaysConsidered, 9);
    });

    test('without `direction` the sign of the percentage gives it', () async {
      final repo = repository(
        (_) => _json(200, [
          _itemJson(evidenceData: {'averagePercentFromTarget': 12.5, 'deviatedDays': 3, 'loggedDaysConsidered': 6}),
        ]),
      );

      final evidence = (await repo.getItems(ReviewItemStatus.open)).valueOrNull!.single.evidence;

      expect((evidence as SustainedDeviationEvidence).direction, DeviationDirection.above);
    });

    test('incomplete or impossible evidence falls back to the legacy sentence', () async {
      final repo = repository(
        (_) => _json(200, [
          _itemJson(id: 1, evidenceData: {'deviatedDays': 3}),
          // More deviated days than logged ones.
          _itemJson(
            id: 2,
            evidenceData: {'averagePercentFromTarget': 10, 'deviatedDays': 9, 'loggedDaysConsidered': 5, 'direction': 'Above'},
          ),
          _itemJson(id: 3, signalType: 'SomethingNew', evidenceData: {'deviatedDays': 3}),
        ]),
      );

      final items = (await repo.getItems(ReviewItemStatus.open)).valueOrNull!;

      expect(items.map((item) => item.evidence), [null, null, null]);
      expect(items.first.legacyEvidence, 'Logged 40% below.');
      expect((items.last.signalType as CustomSignal).text, 'SomethingNew');
    });

    test('a scheduled review keeps its counts only when both come', () async {
      final repo = repository(
        (_) => _json(200, [
          _itemJson(
            id: 1,
            signalType: 'ScheduledRecheck',
            evidenceData: {'adjustedOn': '2026-09-08', 'adjustedPlanVersion': 3, 'deviatedDays': 2, 'loggedDaysConsidered': 6},
          ),
          _itemJson(
            id: 2,
            signalType: 'ScheduledRecheck',
            evidenceData: {'adjustedOn': '2026-09-08', 'adjustedPlanVersion': 3, 'deviatedDays': 2},
          ),
        ]),
      );

      final items = (await repo.getItems(ReviewItemStatus.open)).valueOrNull!;

      final withCounts = items.first.evidence as ScheduledRecheckEvidence;
      expect(withCounts.hasCounts, isTrue);
      expect(withCounts.adjustedOn, DateTime(2026, 9, 8));
      expect((items.last.evidence as ScheduledRecheckEvidence).hasCounts, isFalse);
    });

    test('a resolved item carries its note: translated codes, or the text as is', () async {
      final repo = repository(
        (_) => _json(200, [
          _itemJson(
            id: 1,
            state: 'Resolved',
            extra: {'resolutionNoteCode': 'PlanAssignedWithEdits', 'resolutionNoteData': {'planVersion': 4}},
          ),
          _itemJson(id: 2, state: 'Resolved', extra: {'resolutionNoteCode': 'ProposalDiscarded'}),
          _itemJson(id: 3, state: 'Resolved', extra: {'resolutionNoteCode': 'Custom', 'resolutionNote': ' se habló '}),
          _itemJson(id: 4, state: 'Resolved', extra: {'resolutionNoteCode': 'PlanAssignedAsIs'}),
        ]),
      );

      final items = (await repo.getItems(ReviewItemStatus.resolved)).valueOrNull!;

      expect(items.every((item) => !item.isOpen), isTrue);
      expect((items[0].resolutionNote as PlanAssignedWithEdits).planVersion, 4);
      expect(items[1].resolutionNote, isA<ProposalDiscarded>());
      expect((items[2].resolutionNote as CustomResolutionNote).text, 'se habló');
      expect(items[3].resolutionNote, isNull);
    });

    test('a body with the wrong shape is a malformed response, not an exception', () async {
      final repo = repository((_) => _json(200, [{'reviewItemId': 'one'}]));

      final result = await repo.getItems(ReviewItemStatus.open);

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('no connection and the backend errors map to domain errors', () async {
      var repo = repository((_) => throw const SocketException('offline'));
      expect((await repo.getItems(ReviewItemStatus.open)).errorOrNull, isA<Network>());

      repo = repository((_) => _json(503, {'title': 'Down'}));
      expect((await repo.getItems(ReviewItemStatus.open)).errorOrNull, isA<Unexpected>());
    });
  });

  group('resolving', () {
    test('POST review-items/{id}/resolution sends the answer and the note', () async {
      final repo = repository((_) => _json(200, _itemJson(state: 'Resolved')));

      final result = await repo.resolve(ReviewItemId(1), ReviewResolution.of(true, ' nota ')!);

      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/api/v1/review-items/1/resolution');
      expect(jsonDecode(requests.single.body), {'resolvedWithAdjustment': true, 'resolutionNote': 'nota'});
      expect(result.valueOrNull!.isOpen, isFalse);
    });

    test('without a note the field is omitted', () async {
      final repo = repository((_) => _json(200, _itemJson(state: 'Resolved')));

      await repo.resolve(ReviewItemId(1), ReviewResolution.of(false, '  ')!);

      expect(jsonDecode(requests.single.body), {'resolvedWithAdjustment': false});
    });

    test('the backend codes arrive as domain errors', () async {
      var repo = repository((_) => _json(400, {'title': 'x', 'code': 'ResolutionOutcomeRequired'}));
      var error = (await repo.resolve(ReviewItemId(1), ReviewResolution.of(true, null)!)).errorOrNull;
      expect(error, isA<Validation>().having((e) => e.code, 'code', 'ResolutionOutcomeRequired'));

      repo = repository((_) => _json(404, {'title': 'x', 'code': 'ReviewItemNotFound'}));
      error = (await repo.resolve(ReviewItemId(1), ReviewResolution.of(true, null)!)).errorOrNull;
      expect(error, isA<NotFound>().having((e) => e.code, 'code', 'ReviewItemNotFound'));
    });
  });

  group('the AI proposal', () {
    test('200 maps the proposal, dropping a guideline this version does not know', () async {
      final repo = repository((_) => _json(200, _proposalJson));

      final lookup = (await repo.getPlanProposal(ReviewItemId(1))).valueOrNull;

      expect(requests.single.method, 'GET');
      expect(requests.single.url.path, '/api/v1/review-items/1/plan-proposal');
      final proposal = (lookup as ProposalReady).proposal;
      expect(proposal.title, 'Ajustar la energía');
      expect(proposal.currentEnergyKcal, 1796);
      expect(proposal.proposed.energyKcal, 1650);
      expect(proposal.addedGuidelines, [PlanGuidelineCode.proteinAndVegetablesAtDinner]);
      expect(proposal.removedGuidelines, [PlanGuidelineCode.reduceSalt]);
      expect(proposal.recheckAfterDays, 7);
      expect(proposal.status, PlanProposalStatus.proposed);
      expect(proposal.canBeAccepted, isTrue);
      expect(proposal.generatedAt, DateTime.utc(2026, 9, 8, 16));
    });

    test('an unknown status reads as decided', () async {
      final repo = repository((_) => _json(200, {..._proposalJson, 'status': 'Whatever'}));

      final proposal = ((await repo.getPlanProposal(ReviewItemId(1))).valueOrNull as ProposalReady).proposal;

      expect(proposal.status, PlanProposalStatus.dismissed);
      expect(proposal.canBeAccepted, isFalse);
    });

    test('202 + Retry-After is "generating", and the body is not read', () async {
      final repo = repository(
        (_) => http.Response('not json at all', 202, headers: {'Retry-After': ' 3 ', 'content-type': 'text/plain'}),
      );

      final lookup = (await repo.getPlanProposal(ReviewItemId(1))).valueOrNull;

      expect((lookup as ProposalGenerating).retryAfterSeconds, 3);
    });

    test('202 without a usable Retry-After waits the default', () async {
      var repo = repository((_) => _json(202, {'title': 'Generating'}));
      expect(((await repo.getPlanProposal(ReviewItemId(1))).valueOrNull as ProposalGenerating).retryAfterSeconds, 5);

      repo = repository((_) => _json(202, {}, headers: {'Retry-After': '0'}));
      expect(((await repo.getPlanProposal(ReviewItemId(1))).valueOrNull as ProposalGenerating).retryAfterSeconds, 5);

      repo = repository((_) => _json(202, {}, headers: {'Retry-After': 'Wed, 21 Oct 2026 07:28:00 GMT'}));
      expect(((await repo.getPlanProposal(ReviewItemId(1))).valueOrNull as ProposalGenerating).retryAfterSeconds, 5);
    });

    test('404 PlanProposalNotFound is "no proposal"; another 404 is an error', () async {
      var repo = repository((_) => _json(404, {'title': 'x', 'code': 'PlanProposalNotFound'}));
      expect((await repo.getPlanProposal(ReviewItemId(1))).valueOrNull, isA<NoProposal>());

      repo = repository((_) => _json(404, {'title': 'x', 'code': 'ReviewItemNotFound'}));
      expect((await repo.getPlanProposal(ReviewItemId(1))).errorOrNull, isA<NotFound>());
    });

    test('a 200 with an empty or broken body is malformed', () async {
      var repo = repository((_) => http.Response('', 200));
      expect((await repo.getPlanProposal(ReviewItemId(1))).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));

      repo = repository((_) => _json(200, {..._proposalJson, 'generatedAt': 'yesterday'}));
      expect((await repo.getPlanProposal(ReviewItemId(1))).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));

      repo = repository((_) => _json(200, {..._proposalJson, 'recheckAfterDays': 0}));
      expect((await repo.getPlanProposal(ReviewItemId(1))).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('accepting as is sends only `asIs`', () async {
      final repo = repository((_) => _json(200, {'reviewItem': _itemJson(state: 'Resolved'), 'planVersion': {'version': 4}}));

      final accepted = (await repo.acceptPlanProposal(ReviewItemId(1), const AcceptAsIs())).valueOrNull!;

      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/api/v1/review-items/1/plan-proposal/acceptance');
      expect(jsonDecode(requests.single.body), {'asIs': true});
      expect(accepted.planVersion, 4);
      expect(accepted.reviewItem.isOpen, isFalse);
    });

    test('accepting with edits sends the complete edits, guidelines in catalog order', () async {
      final repo = repository((_) => _json(200, {'reviewItem': _itemJson(state: 'Resolved'), 'planVersion': {'version': 5}}));
      final edits = ProposalEdits(
        targets: Targets(energyKcal: 1600, proteinG: 120.5, carbG: 170, fatG: 55),
        guidelines: {PlanGuidelineCode.proteinAndVegetablesAtDinner, PlanGuidelineCode.prioritizeVegetables},
        patientMessage: PatientMessage(' Probemos '),
      );

      await repo.acceptPlanProposal(ReviewItemId(1), AcceptWithEdits(edits));

      expect(jsonDecode(requests.single.body), {
        'asIs': false,
        'energyKcal': 1600.0,
        'proteinG': 120.5,
        'carbG': 170.0,
        'fatG': 55.0,
        'guidelines': ['PrioritizeVegetables', 'ProteinAndVegetablesAtDinner'],
        'patientMessage': 'Probemos',
      });
    });

    test('without a message the field is omitted', () async {
      final repo = repository((_) => _json(200, {'reviewItem': _itemJson(state: 'Resolved'), 'planVersion': {'version': 5}}));
      final edits = ProposalEdits(
        targets: Targets(energyKcal: 1600, proteinG: 120, carbG: 170, fatG: 55),
        guidelines: const {},
        patientMessage: null,
      );

      await repo.acceptPlanProposal(ReviewItemId(1), AcceptWithEdits(edits));

      final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
      expect(body.containsKey('patientMessage'), isFalse);
      expect(body['guidelines'], isEmpty);
    });

    test('the acceptance codes arrive as domain errors', () async {
      for (final (status, code, matcher) in <(int, String, Matcher)>[
        (422, 'PlanProposalOutOfSafetyBounds', isA<Validation>()),
        (409, 'PlanVersionAlreadySuperseded', isA<Conflict>()),
        (403, 'ActiveCareLinkRequired', isA<Forbidden>()),
      ]) {
        final repo = repository((_) => _json(status, {'title': 'x', 'code': code}));
        final error = (await repo.acceptPlanProposal(ReviewItemId(1), const AcceptAsIs())).errorOrNull;
        expect(error, matcher, reason: code);
        expect(error!.code, code);
      }
    });
  });

  group('waiting for the proposal', () {
    test('reads again after each Retry-After and ends with the proposal', () async {
      var calls = 0;
      final waits = <Duration>[];
      final repo = repository((_) {
        calls++;
        return calls < 3 ? _json(202, {}, headers: {'Retry-After': '2'}) : _json(200, _proposalJson);
      });

      final results = await AwaitPlanProposalUseCase(repo, wait: (d) async => waits.add(d))(1).toList();

      expect(results.map((r) => r.valueOrNull.runtimeType.toString()), ['ProposalGenerating', 'ProposalGenerating', 'ProposalReady']);
      expect(waits, [const Duration(seconds: 2), const Duration(seconds: 2)]);
    });

    test('a failure ends the wait with the failure', () async {
      final repo = repository((_) => throw const SocketException('offline'));

      final results = await AwaitPlanProposalUseCase(repo, wait: (_) async {})(1).toList();

      expect(results.single.errorOrNull, isA<Network>());
    });

    test('running out of attempts gives up without AI', () async {
      final repo = repository((_) => _json(202, {}, headers: {'Retry-After': '1'}));
      final waits = <Duration>[];

      final results = await AwaitPlanProposalUseCase(repo, wait: (d) async => waits.add(d))(1, maxAttempts: 3).toList();

      expect(requests, hasLength(3));
      expect(waits, hasLength(2));
      expect(results.last.valueOrNull, isA<NoProposal>());
    });

    test('at least one attempt is required', () {
      final repo = repository((_) => _json(200, _proposalJson));

      expect(() => AwaitPlanProposalUseCase(repo)(1, maxAttempts: 0).toList(), throwsArgumentError);
    });
  });

  group('domain rules', () {
    test('an item is found by id in the open inbox, or is null', () async {
      final repo = repository((_) => _json(200, [_itemJson(id: 1), _itemJson(id: 2)]));
      final lookup = GetOpenReviewItemUseCase(repo);

      expect((await lookup(2)).valueOrNull!.id.value, 2);
      expect((await lookup(9)).valueOrNull, isNull);
      expect((await lookup(9)).isSuccess, isTrue);
    });

    test('Yes or No is required to resolve', () {
      expect(ReviewResolution.of(null, 'nota'), isNull);
      expect(ReviewResolution.of(true, null)!.note, isNull);
    });

    test('edits need positive numbers with a comma or a dot, and a message of at most 500 characters', () {
      ProposalEditValidation validate({
        String energy = '1 650',
        String protein = '62,5',
        String carb = '170.5',
        String fat = '55',
        String message = '',
      }) => ProposalEditValidation.of(
        energyText: energy,
        proteinText: protein,
        carbText: carb,
        fatText: fat,
        guidelines: const {},
        message: message,
      );

      final valid = validate() as ValidProposalEdits;
      expect(valid.edits.targets.energyKcal, 1650);
      expect(valid.edits.targets.proteinG, 62.5);
      expect(valid.edits.targets.carbG, 170.5);
      expect(valid.edits.patientMessage, isNull);

      expect((validate(energy: '0') as InvalidProposalEdits).fields, {ProposalEditField.energy});
      expect((validate(protein: '-3', fat: '') as InvalidProposalEdits).fields, {
        ProposalEditField.protein,
        ProposalEditField.fat,
      });
      expect((validate(carb: 'abc') as InvalidProposalEdits).fields, {ProposalEditField.carb});
      expect((validate(message: 'a' * 501) as InvalidProposalEdits).fields, {ProposalEditField.message});
      expect(validate(message: 'a' * 500), isA<ValidProposalEdits>());
    });

    test('a proposal removes and adds catalog guidelines over the current ones', () {
      final proposal = PlanAdjustmentProposal(
        reviewItemId: ReviewItemId(1),
        title: 'x',
        currentEnergyKcal: null,
        proposed: Targets(energyKcal: 1500, proteinG: 100, carbG: 150, fatG: 50),
        addedGuidelines: const [PlanGuidelineCode.drink2lWater],
        removedGuidelines: const [PlanGuidelineCode.reduceSalt],
        patientMessage: '',
        recheckAfterDays: 7,
        rationale: '',
        generatedAt: DateTime.utc(2026),
        status: PlanProposalStatus.proposed,
      );

      expect(proposal.resultingGuidelines(const [PlanGuidelineCode.reduceSalt, PlanGuidelineCode.avoidSugaryDrinks]), {
        PlanGuidelineCode.avoidSugaryDrinks,
        PlanGuidelineCode.drink2lWater,
      });
    });
  });

  test('the DTO of a request keeps a null note out of the JSON', () {
    expect(const ResolveReviewItemRequestDto(resolvedWithAdjustment: true, resolutionNote: null).toJson(), {
      'resolvedWithAdjustment': true,
    });
  });
}

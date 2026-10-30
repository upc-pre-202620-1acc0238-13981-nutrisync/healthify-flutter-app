import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/features/monitoring/domain/entity/patient_monitoring_panel.dart';
import 'package:healthify/features/monitoring/domain/valueobject/monitoring_values.dart';
import 'package:healthify/features/monitoring/infrastructure/mapper/monitoring_mappers.dart';
import 'package:healthify/features/monitoring/infrastructure/remote/dto/monitoring_dtos.dart';
import 'package:healthify/features/monitoring/infrastructure/remote/monitoring_services.dart';
import 'package:healthify/features/monitoring/infrastructure/repository/monitoring_repositories_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response _json(int status, Object? body) =>
    http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json; charset=utf-8'});

final _panelJson = {
  'date': '2026-10-07',
  'week': {
    'days': [
      {'date': '2026-10-02', 'outcome': 'Short'},
      {'date': '2026-10-01', 'outcome': 'Met'},
      {'date': '2026-10-03', 'outcome': 'Mystery'},
      {'date': 'ayer', 'outcome': 'Met'},
    ],
    'metDays': 1,
    'totalDays': 7,
  },
  'loggedDays': {'logged': 6, 'totalDays': 7},
  'weightTrendSummary': {'weeks': 4, 'slopeKgPerWeek': -0.3},
  'diary': [
    {
      'diaryEntryId': 2,
      'localTimestamp': '2026-10-07T19:10:00-05:00',
      'provenance': 'Photo',
      'proposedFoodName': 'Ceviche',
      'proposedPortionGrams': 280,
    },
    {
      'diaryEntryId': 1,
      'localTimestamp': '2026-10-07T13:15:00-05:00',
      'provenance': 'Photo',
      'proposedFoodName': 'Lomo',
      'confirmedFoodName': 'Lomo saltado',
      'confirmedPortionGrams': 300,
      'confirmedAt': '2026-10-07T13:20:00-05:00',
    },
    {'diaryEntryId': 3, 'localTimestamp': 'hoy', 'provenance': 'Manual'},
  ],
  'lastClinicalMeasurement': {
    'takenAt': '2026-09-03T10:00:00-05:00',
    'weightKg': 74.2,
    'protocolChecks': ['Fasting', 'NoShoes', 'Unknown'],
  },
};

void main() {
  group('monitoring panel mapper', () {
    test('maps the week, the logged days, the trend and the clinical measurement', () {
      final panel = PatientMonitoringPanelDto.fromJson(_panelJson).toDomain();

      expect(panel.date, DateTime(2026, 10, 7));
      expect(panel.loggedDays!.count, 6);
      expect(panel.weightTrend!.slopeKgPerWeek, -0.3);
      expect(panel.lastClinicalMeasurement!.takenAt, DateTime.utc(2026, 9, 3, 15));
      expect(panel.lastClinicalMeasurement!.protocolChecks, [PanelProtocolCheck.fasting, PanelProtocolCheck.noShoes]);
    });

    test('week days are sorted, an unreadable day is dropped and an unknown outcome reads as "no log"', () {
      final week = PatientMonitoringPanelDto.fromJson(_panelJson).toDomain().week!;

      expect(week.days.map((d) => d.date.day), [1, 2, 3]);
      expect(week.days.map((d) => d.outcome), [ComplianceOutcome.met, ComplianceOutcome.short, ComplianceOutcome.unlogged]);
      expect(week.metDays, 1);
    });

    test('the diary is sorted by time; an unconfirmed photo awaits confirmation and a confirmed one shows its name', () {
      final diary = PatientMonitoringPanelDto.fromJson(_panelJson).toDomain().diary;

      expect(diary.map((e) => e.id), [1, 2]);
      expect(diary[0].foodName, 'Lomo saltado');
      expect(diary[0].grams, 300);
      expect(diary[0].isAwaitingConfirmation, isFalse);
      expect(diary[1].foodName, 'Ceviche');
      expect(diary[1].grams, 280);
      expect(diary[1].isAwaitingConfirmation, isTrue);
    });

    test('an unreadable section stays empty and the rest of the panel is shown', () {
      final panel = PatientMonitoringPanelDto.fromJson({
        ..._panelJson,
        'week': {'metDays': 9, 'totalDays': 7},
        'loggedDays': {'logged': 9, 'totalDays': 7},
        'lastClinicalMeasurement': {'takenAt': 'ayer', 'weightKg': 70},
      }).toDomain();

      expect(panel.week, isNull);
      expect(panel.loggedDays, isNull);
      expect(panel.lastClinicalMeasurement, isNull);
      expect(panel.weightTrend, isNotNull);
      expect(panel.diary, hasLength(2));
    });

    test('a panel without a readable date is malformed', () {
      expect(() => PatientMonitoringPanelDto.fromJson({..._panelJson, 'date': 'hoy'}).toDomain(), throwsFormatException);
    });

    test('an empty panel (no logs yet) has no sections', () {
      final panel = PatientMonitoringPanelDto.fromJson({'date': '2026-10-07'}).toDomain();

      expect(panel.week, isNull);
      expect(panel.diary, isEmpty);
    });
  });

  group('repositories', () {
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

    test('GET monitoring-panel sends the date and the days, and maps the panel', () async {
      respondWith((_) => _json(200, _panelJson));

      final result = await PractitionerMonitoringRepositoryImpl(PractitionerMonitoringService(api)).getPanel(
        PatientId(7),
        DateTime(2026, 10, 7),
        7,
      );

      expect(requests.single.url.path, '/api/v1/patients/7/monitoring-panel');
      expect(requests.single.url.queryParameters, {'date': '2026-10-07', 'days': '7'});
      expect(result.valueOrNull!.diary, hasLength(2));
    });

    test('403 AccessNotAllowed is forbidden, a lost connection is network', () async {
      respondWith((_) => http.Response(jsonEncode({'code': 'AccessNotAllowed'}), 403));
      final repository = PractitionerMonitoringRepositoryImpl(PractitionerMonitoringService(api));
      expect((await repository.getPanel(PatientId(7), DateTime(2026, 10, 7), 7)).errorOrNull, const Forbidden('AccessNotAllowed'));

      respondWith((_) => throw http.ClientException('down'));
      final offline = PractitionerMonitoringRepositoryImpl(PractitionerMonitoringService(api));
      expect((await offline.getPanel(PatientId(7), DateTime(2026, 10, 7), 7)).errorOrNull, isA<Network>());
    });

    test('a panel with a broken shape is malformed, not a throw', () async {
      respondWith((_) => _json(200, {'date': '2026-10-07', 'diary': 'nada'}));

      final result = await PractitionerMonitoringRepositoryImpl(PractitionerMonitoringService(api)).getPanel(
        PatientId(7),
        DateTime(2026, 10, 7),
        7,
      );

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });

    test('GET monitoring-summary reads the text, or none', () async {
      respondWith((_) => _json(200, {'text': '  Resumen  '}));
      final repository = PractitionerMonitoringRepositoryImpl(PractitionerMonitoringService(api));
      expect((await repository.getSummary(PatientId(7))).valueOrNull!.text, 'Resumen');
      expect(requests.single.url.path, '/api/v1/patients/7/monitoring-summary');

      respondWith((_) => _json(200, {'text': null}));
      final empty = PractitionerMonitoringRepositoryImpl(PractitionerMonitoringService(api));
      expect((await empty.getSummary(PatientId(7))).valueOrNull!.hasText, isFalse);
    });
  });
}

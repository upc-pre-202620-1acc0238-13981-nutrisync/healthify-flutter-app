import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/features/foodcatalog/domain/entity/new_local_food.dart';
import 'package:healthify/features/foodcatalog/domain/valueobject/food_search_term.dart';
import 'package:healthify/features/foodcatalog/infrastructure/remote/reference_food_service.dart';
import 'package:healthify/features/foodcatalog/infrastructure/repository/reference_food_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response _json(int status, Object? body) =>
    http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json; charset=utf-8'});

Map<String, Object?> _food(int id, String name, {bool override = false}) => {
  'referenceFoodId': id,
  'localName': name,
  'energyKcalPer100g': 120,
  'proteinGPer100g': 4.0,
  'carbGPer100g': 20.0,
  'fatGPer100g': 2.0,
  'isLocalOverride': override,
};

NewLocalFood _newFood(String name) =>
    (LocalFoodValidation.of(name: name, energy: '180', protein: '12', carb: '20', fat: '6') as ValidLocalFood).food;

void main() {
  late List<http.Request> requests;

  ReferenceFoodRepositoryImpl repository(FutureOr<http.Response> Function(http.Request request) handler) {
    requests = [];
    final api = ApiClient(
      MockClient((request) async {
        requests.add(request);
        return handler(request);
      }),
      baseUrl: Uri.parse('https://test.local/api/v1/'),
    );
    return ReferenceFoodRepositoryImpl(ReferenceFoodService(api));
  }

  group('browseCatalog', () {
    test('without text it asks the server catalog with an empty query and max 25', () async {
      final repo = repository(
        (_) => _json(200, [_food(1, 'Papa amarilla'), _food(2, 'Cuy al horno', override: true)]),
      );

      final foods = (await repo.browseCatalog(null)).valueOrNull!;

      expect(requests.single.method, 'GET');
      expect(requests.single.url.path, '/api/v1/reference-foods');
      expect(requests.single.url.queryParameters, {'query': '', 'max': '25'});
      expect(foods.map((f) => f.name), ['Papa amarilla', 'Cuy al horno']);
      expect(foods.map((f) => f.isLocalOverride), [false, true]);
      expect(foods.first.energyKcalPer100g, 120);
    });

    test('sends the search term and drops broken foods', () async {
      final repo = repository(
        (_) => _json(200, [_food(1, ' Cuy chactado '), _food(0, 'Sin id'), _food(3, '  ')]),
      );

      final foods = (await repo.browseCatalog(FoodSearchTerm.of('cuy'))).valueOrNull!;

      expect(requests.single.url.queryParameters['query'], 'cuy');
      expect(foods.single.name, 'Cuy chactado');
    });

    test('offline it fails with Network and a malformed body with MALFORMED_RESPONSE', () async {
      expect(
        (await repository((_) => throw const SocketException('offline')).browseCatalog(null)).errorOrNull,
        const Network(),
      );
      expect(
        (await repository((_) => _json(200, {'unexpected': true})).browseCatalog(null)).errorOrNull,
        const Unexpected('MALFORMED_RESPONSE'),
      );
    });
  });

  group('createLocalFood', () {
    test('POSTs the local override and returns the created food', () async {
      final repo = repository((_) => _json(201, _food(77, 'Chaufa de cuy', override: true)));

      final created = (await repo.createLocalFood(_newFood('Chaufa de cuy'))).valueOrNull!;

      expect(requests.single.method, 'POST');
      expect(requests.single.url.toString(), 'https://test.local/api/v1/reference-foods/local-overrides');
      expect(jsonDecode(requests.single.body), {
        'localName': 'Chaufa de cuy',
        'energyKcalPer100g': 180.0,
        'proteinGPer100g': 12.0,
        'carbGPer100g': 20.0,
        'fatGPer100g': 6.0,
      });
      expect(created.isLocalOverride, isTrue);
      expect(created.id.value, 77);
    });

    test('a duplicated name is a Conflict with its code', () async {
      final repo = repository(
        (_) => _json(409, {'status': 409, 'code': 'DuplicatedLocalOverride', 'title': 'Conflict'}),
      );

      final result = await repo.createLocalFood(_newFood('Cuy al horno'));

      expect(result.errorOrNull, isA<Conflict>());
    });

    test('a created food that breaks an invariant is MALFORMED_RESPONSE', () async {
      final repo = repository((_) => _json(201, _food(0, 'Chaufa de cuy', override: true)));

      expect((await repo.createLocalFood(_newFood('Chaufa de cuy'))).errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    });
  });
}

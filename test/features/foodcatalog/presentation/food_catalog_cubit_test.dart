import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/foodcatalog/application/usecase/food_catalog_use_cases.dart';
import 'package:healthify/features/foodcatalog/presentation/cubit/food_catalog_cubit.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

const _debounce = Duration(milliseconds: 20);

void main() {
  late FakeReferenceFoodRepository foods;
  late FakeConnectivity connectivity;

  setUp(() {
    foods = FakeReferenceFoodRepository();
    connectivity = FakeConnectivity();
  });

  FoodCatalogCubit build() =>
      FoodCatalogCubit(BrowseFoodCatalogUseCase(foods), connectivity, searchDebounce: _debounce);

  Future<void> settle() => pumpEventQueue();

  test('PR15 lists the catalog without text, local foods marked', () async {
    foods.remote = Result.success([referenceFood(1, 'Papa amarilla'), referenceFood(2, 'Cuy al horno', override: true)]);
    final cubit = build();
    await settle();

    expect(foods.browsedTerms, [null]);
    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.results!.map((row) => row.isLocal), [false, true]);
    await cubit.close();
  });

  test('PR15 searches once after a short pause while typing', () async {
    final cubit = build();
    await settle();

    cubit
      ..onQueryChange('c')
      ..onQueryChange('cu')
      ..onQueryChange('cuy');
    expect(cubit.state.query, 'cuy');
    expect(foods.browsedTerms, [null]);

    await Future<void>.delayed(_debounce * 3);
    await settle();
    expect(foods.browsedTerms, [null, 'cuy']);
    await cubit.close();
  });

  test('PR15 offline without results needs a connection, and reconnecting reloads', () async {
    connectivity.set(false);
    foods.remote = const Result.failure(Network());
    final cubit = build();
    await settle();

    expect(cubit.state.needsConnection, isTrue);

    foods.remote = Result.success([referenceFood(1, 'Papa amarilla')]);
    connectivity.set(true);
    await settle();

    expect(cubit.state.needsConnection, isFalse);
    expect(cubit.state.results!.single.name, 'Papa amarilla');
    await cubit.close();
  });

  test('a network failure without a connectivity change still reads as offline', () async {
    foods.remote = const Result.failure(Network());
    final cubit = build();
    await settle();

    expect(cubit.state.isOffline, isTrue);
    expect(cubit.state.needsConnection, isTrue);
    await cubit.close();
  });

  test('a server failure shows the error and a failed refresh keeps the last results', () async {
    foods.remote = const Result.failure(Unexpected('HTTP_500'));
    final cubit = build();
    await settle();
    expect(cubit.state.loadFailed, isTrue);
    expect(cubit.state.results, isNull);
    expect(cubit.state.needsConnection, isFalse);

    foods.remote = Result.success([referenceFood(1, 'Papa amarilla')]);
    cubit.onRetry();
    await settle();
    expect(cubit.state.results, hasLength(1));

    foods.remote = const Result.failure(Unexpected('HTTP_500'));
    cubit.onRetry();
    await settle();
    expect(cubit.state.loadFailed, isTrue);
    expect(cubit.state.results, hasLength(1));
    await cubit.close();
  });

  test('an empty answer is the empty state', () async {
    final cubit = build();
    await settle();

    expect(cubit.state.isEmpty, isTrue);
    await cubit.close();
  });

  test('returning with a new food searches for it right away', () async {
    final cubit = build();
    await settle();

    cubit.onFoodAdded('Chaufa de cuy');
    await settle();

    expect(cubit.state.query, 'Chaufa de cuy');
    expect(foods.browsedTerms, [null, 'Chaufa de cuy']);
    await cubit.close();
  });
}

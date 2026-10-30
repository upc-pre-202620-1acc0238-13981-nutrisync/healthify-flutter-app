import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/application/usecase/review_inbox_use_cases.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/review_values.dart';
import 'package:healthify/features/nutritionalcare/presentation/cubit/review_inbox_cubit.dart';

import '../../carerelationship/fakes.dart';
import '../review_fakes.dart';

void main() {
  late FakeReviewInboxRepository repository;
  late FakeConnectivity connectivity;

  setUp(() {
    repository = FakeReviewInboxRepository();
    connectivity = FakeConnectivity();
  });

  ReviewInboxCubit build() => ReviewInboxCubit(GetOpenReviewItemsUseCase(repository), connectivity);

  Future<void> settle() => pumpEventQueue();

  test('it starts loading, with nothing read yet', () async {
    final cubit = build();

    expect(cubit.state.isLoading, isTrue);
    expect(cubit.state.items, isNull);
    await cubit.close();
  });

  test('lists the open items, newest first as the backend sends them', () async {
    repository.itemsResult = Result.success([
      reviewItem(id: 2, name: 'Carlos Quispe', signal: const ConsistencyEscalation()),
      reviewItem(id: 1),
    ]);

    final cubit = build();
    await settle();

    expect(repository.states, [ReviewItemStatus.open]);
    expect(cubit.state.items!.map((row) => row.id), [2, 1]);
    expect(cubit.state.items!.first.patientName, 'Carlos Quispe');
    expect(cubit.state.items!.first.signal, isA<ConsistencyEscalation>());
    expect(cubit.state.isLoading, isFalse);
    await cubit.close();
  });

  test('an empty inbox is the all-caught-up state', () async {
    repository.itemsResult = const Result.success([]);

    final cubit = build();
    await settle();

    expect(cubit.state.isEmpty, isTrue);
    expect(cubit.state.loadFailed, isFalse);
    await cubit.close();
  });

  test('offline with nothing read shows the offline state, and retrying recovers', () async {
    repository.itemsResult = const Result.failure(Network());
    final cubit = build();
    await settle();

    expect(cubit.state.needsConnection, isTrue);
    expect(cubit.state.isOffline, isTrue);

    repository.itemsResult = Result.success([reviewItem()]);
    cubit.onRetry();
    await settle();

    expect(cubit.state.items, hasLength(1));
    expect(cubit.state.needsConnection, isFalse);
    await cubit.close();
  });

  test('a server error with nothing read is the error state, not the offline one', () async {
    repository.itemsResult = const Result.failure(Unexpected('HTTP_503'));

    final cubit = build();
    await settle();

    expect(cubit.state.loadFailed, isTrue);
    expect(cubit.state.needsConnection, isFalse);
    await cubit.close();
  });

  test('the connection coming back reloads', () async {
    connectivity.set(false);
    final cubit = build();
    await settle();
    expect(repository.itemsCalls, 1);

    connectivity.set(true);
    await settle();

    expect(repository.itemsCalls, 2);
    expect(cubit.state.isOffline, isFalse);
    await cubit.close();
  });

  test('returning to the tab rereads, so a resolved item disappears', () async {
    final cubit = build();
    await settle();
    expect(cubit.state.items, hasLength(1));

    repository.itemsResult = const Result.success([]);
    cubit.onResume();
    await settle();

    expect(repository.itemsCalls, 2);
    expect(cubit.state.isEmpty, isTrue);
    await cubit.close();
  });

  test('returning before the first read does not read twice', () async {
    final gate = repository.itemsGate = Completer();
    final cubit = build();

    cubit.onResume();
    expect(repository.itemsCalls, 1);

    gate.complete(Result.success([reviewItem()]));
    await settle();
    await cubit.close();
  });

  test('a refresh that fails keeps the list on screen', () async {
    final cubit = build();
    await settle();

    repository.itemsResult = const Result.failure(Network());
    cubit.onResume();
    await settle();

    expect(cubit.state.items, hasLength(1));
    expect(cubit.state.loadFailed, isFalse);
    expect(cubit.state.isOffline, isTrue);
    await cubit.close();
  });

  test('an old answer never overwrites a newer one', () async {
    final slow = repository.itemsGate = Completer();
    final cubit = build();
    await settle();

    repository.itemsResult = Result.success([reviewItem(id: 7)]);
    cubit.onRetry();
    await settle();
    expect(cubit.state.items!.single.id, 7);

    slow.complete(Result.success([reviewItem(id: 1)]));
    await settle();

    expect(cubit.state.items!.single.id, 7);
    await cubit.close();
  });
}

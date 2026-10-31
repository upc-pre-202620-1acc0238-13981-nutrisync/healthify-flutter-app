import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/food_catalog_use_cases.dart';
import '../state/food_catalog_states.dart';

/// The nutritionist's food catalog (from the main menu). Without text it lists the server catalog (local foods first);
/// while typing it searches after a short pause. It reloads on returning from the add screen with a new food and when
/// the connection comes back.
class FoodCatalogCubit extends Cubit<FoodCatalogState> {
  FoodCatalogCubit(
    this._browseFoodCatalog,
    ConnectivityObserver connectivityObserver, {
    this.searchDebounce = const Duration(milliseconds: 300),
  }) : super(const FoodCatalogState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (isClosed) return;
      final wasOffline = state.isOffline;
      emit(state.copyWith(isOffline: !online));
      if (online && wasOffline) _search();
    });
    _search();
  }

  final BrowseFoodCatalogUseCase _browseFoodCatalog;
  final Duration searchDebounce;

  late final StreamSubscription<bool> _connectivity;
  Timer? _debounce;
  int _searchId = 0;

  void onQueryChange(String query) {
    emit(state.copyWith(query: query));
    _debounce?.cancel();
    _debounce = Timer(searchDebounce, _search);
  }

  void onRetry() => _search();

  /// On returning from the add screen: shows the newly created food.
  void onFoodAdded(String name) {
    emit(state.copyWith(query: name));
    _search();
  }

  Future<void> _search() async {
    _debounce?.cancel();
    final searchId = ++_searchId;
    emit(state.copyWith(isLoading: true, loadFailed: false));
    final result = await _browseFoodCatalog(state.query);
    // A newer search took over (more typing, retry, reconnection): its answer is the one that counts.
    if (isClosed || searchId != _searchId) return;
    result.fold(
      (foods) => emit(state.copyWith(isLoading: false, results: foods.map(FoodRow.of).toList())),
      (error) =>
          emit(state.copyWith(isLoading: false, loadFailed: true, isOffline: state.isOffline || error is Network)),
    );
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _connectivity.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/review_inbox_use_cases.dart';
import '../state/review_states.dart';

/// Review inbox. Lists the open items (`?state=Open`); reread on returning to the tab (a resolved item no longer
/// appears) and when the connection returns. Reviewing an item adjusts nothing by itself.
class ReviewInboxCubit extends Cubit<ReviewInboxState> {
  ReviewInboxCubit(this._getOpenReviewItems, ConnectivityObserver connectivityObserver) : super(const ReviewInboxState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (isClosed) return;
      final wasOffline = state.isOffline;
      emit(state.copyWith(isOffline: !online));
      if (online && wasOffline) _load();
    });
    _load();
  }

  final GetOpenReviewItemsUseCase _getOpenReviewItems;

  late final StreamSubscription<bool> _connectivity;
  int _loadId = 0;

  void onRetry() => _load();

  /// The tab is visible again: refresh what is already on screen. Before the first read there is nothing to refresh.
  void onResume() {
    if (state.items != null) _load();
  }

  Future<void> _load() async {
    final loadId = ++_loadId;
    emit(state.copyWith(isLoading: state.items == null, loadFailed: false));
    final result = await _getOpenReviewItems();
    // A newer load took over (retry, resume, reconnection): its answer is the one that counts.
    if (isClosed || loadId != _loadId) return;
    result.fold(
      (items) => emit(state.copyWith(isLoading: false, items: items.map(InboxRow.of).toList())),
      (error) => emit(
        state.copyWith(
          isLoading: false,
          // A refresh that fails keeps the last list.
          loadFailed: state.items == null,
          isOffline: state.isOffline || error is Network,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    return super.close();
  }
}

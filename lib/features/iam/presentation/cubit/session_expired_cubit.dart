import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/connectivity/connectivity_observer.dart';
import '../state/session_expired_state.dart';

/// Final state until the person taps "Sign in" (goes to sign-in). Only observes the connection.
class SessionExpiredCubit extends Cubit<SessionExpiredState> {
  SessionExpiredCubit(ConnectivityObserver connectivityObserver) : super(const SessionExpiredState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (!isClosed) emit(SessionExpiredState(isOffline: !online));
    });
  }

  late final StreamSubscription<bool> _connectivity;

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    return super.close();
  }
}

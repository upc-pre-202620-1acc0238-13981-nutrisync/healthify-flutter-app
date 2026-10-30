import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../state/welcome_state.dart';

/// The two buttons lead to sign-up and sign-in, which need a network; offline the banner shows and nothing navigates.
class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(ConnectivityObserver connectivityObserver) : super(const WelcomeState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      _isOnline = online;
      if (online && !isClosed) emit(state.copyWith(showOfflineBanner: false));
    });
  }

  final _events = OneShotEvents<WelcomeEvent>();
  late final StreamSubscription<bool> _connectivity;
  bool _isOnline = true;

  Stream<WelcomeEvent> get events => _events.stream;

  void onCreateAccount() => _continueTo(const WelcomeNavigateToSignUp());

  void onHaveAccount() => _continueTo(const WelcomeNavigateToSignIn());

  void _continueTo(WelcomeEvent event) {
    if (!_isOnline) {
      emit(state.copyWith(showOfflineBanner: true));
      return;
    }
    _events.emit(event);
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

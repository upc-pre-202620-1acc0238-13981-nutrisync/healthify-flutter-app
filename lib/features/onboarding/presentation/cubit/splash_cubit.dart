import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/one_shot_events.dart';
import '../../../iam/application/usecase/session_use_cases.dart';
import '../state/splash_state.dart';

/// Decides the destination only from the session saved on the device (no network). No session -> welcome; session ->
/// shell loading; saved user whose session expired -> session expired.
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._observeCurrentUser, this._observeIsLoggedIn) : super(const SplashState()) {
    _resolve();
  }

  final ObserveCurrentUserUseCase _observeCurrentUser;
  final ObserveIsLoggedInUseCase _observeIsLoggedIn;
  final _events = OneShotEvents<SplashEvent>();

  Stream<SplashEvent> get events => _events.stream;

  Future<void> _resolve() async {
    final destination = await _resolveDestination();
    if (isClosed) return;
    emit(state.copyWith(destination: destination));
    _events.emit(SplashNavigate(destination));
  }

  Future<SplashDestination> _resolveDestination() async {
    try {
      final user = await _observeCurrentUser().first;
      if (user == null) return SplashDestination.welcome;
      if (await _observeIsLoggedIn().first) return SplashDestination.shellLoading;
      // The session expired while the app was closed (the user is kept, the tokens are not).
      return SplashDestination.sessionExpired;
    } on Exception {
      // If the local read fails, go to welcome by default (secure storage or preferences).
      return SplashDestination.welcome;
    }
  }

  @override
  Future<void> close() async {
    _events.close();
    return super.close();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/one_shot_events.dart';
import '../../application/usecase/resolve_navigation_shell_use_case.dart';
import '../../application/usecase/session_use_cases.dart';
import '../../domain/entity/session_user.dart';
import '../state/shell_loading_state.dart';

/// Loading. Resolves the session shell and sends the person to it. If shell selection does not respond, it retries
/// silently once; if it persists, it shows the error state with "Retry".
class ShellLoadingCubit extends Cubit<ShellLoadingState> {
  ShellLoadingCubit(this._observeCurrentUser, this._resolveNavigationShell, {Duration? silentRetryDelay})
    : _silentRetryDelay = silentRetryDelay ?? const Duration(seconds: 1),
      super(const ShellLoadingState()) {
    _load();
  }

  final ObserveCurrentUserUseCase _observeCurrentUser;
  final ResolveNavigationShellUseCase _resolveNavigationShell;
  final Duration _silentRetryDelay;
  final _events = OneShotEvents<ShellLoadingEvent>();

  Stream<ShellLoadingEvent> get events => _events.stream;

  void onRetry() {
    if (state.isRetrying) return;
    emit(state.copyWith(isRetrying: true));
    _load();
  }

  Future<void> _load() async {
    final user = await _observeCurrentUser().first;
    if (isClosed) return;
    if (user == null) {
      _events.emit(const ShellLoadingNavigateToWelcome());
      return;
    }
    var destination = await _resolveDestination(user);
    if (destination == null) {
      await Future<void>.delayed(_silentRetryDelay);
      if (isClosed) return;
      destination = await _resolveDestination(user);
    }
    if (isClosed) return;
    if (destination == null) {
      emit(const ShellLoadingState(isError: true));
    } else {
      _events.emit(ShellLoadingNavigate(destination));
    }
  }

  /// `null` if something failed (it is retried or the error is shown).
  Future<ShellDestination?> _resolveDestination(SessionUser user) async {
    final shell = (await _resolveNavigationShell(user)).valueOrNull;
    return shell == null ? null : selectShellDestination(shell);
  }

  @override
  Future<void> close() async {
    _events.close();
    return super.close();
  }
}

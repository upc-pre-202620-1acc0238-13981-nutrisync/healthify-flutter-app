import '../../domain/entity/session_user.dart';
import '../../domain/repository/session_repository.dart';

class LogoutLocallyUseCase {
  const LogoutLocallyUseCase(this._sessionRepository);

  final SessionRepository _sessionRepository;

  Future<void> call() => _sessionRepository.logoutLocally();
}

class ObserveCurrentUserUseCase {
  const ObserveCurrentUserUseCase(this._sessionRepository);

  final SessionRepository _sessionRepository;

  Stream<SessionUser?> call() => _sessionRepository.currentUser;
}

class ObserveIsLoggedInUseCase {
  const ObserveIsLoggedInUseCase(this._sessionRepository);

  final SessionRepository _sessionRepository;

  Stream<bool> call() => _sessionRepository.isLoggedIn;
}

/// "Session expired" events that lead to the session expired screen. Must have a single listener (the root router).
class ObserveSessionExpiredUseCase {
  const ObserveSessionExpiredUseCase(this._sessionRepository);

  final SessionRepository _sessionRepository;

  Stream<void> call() => _sessionRepository.sessionExpired;
}

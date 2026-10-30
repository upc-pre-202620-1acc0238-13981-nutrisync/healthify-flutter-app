import '../../../../core/network/auth/session_expiry_notifier.dart';
import '../../domain/entity/session_user.dart';
import '../../domain/repository/session_repository.dart';
import '../local/session_local_data_source.dart';

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl(this._localDataSource, this._sessionExpiryNotifier);

  final SessionLocalDataSource _localDataSource;
  final SessionExpiryNotifier _sessionExpiryNotifier;

  @override
  Stream<SessionUser?> get currentUser => _localDataSource.user;

  @override
  Stream<bool> get isLoggedIn => _localDataSource.isLoggedIn;

  @override
  Stream<void> get sessionExpired => _sessionExpiryNotifier.events;

  @override
  Future<void> logoutLocally() => _localDataSource.clear();
}

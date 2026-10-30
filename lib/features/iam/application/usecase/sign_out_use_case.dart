import '../../domain/repository/authentication_repository.dart';
import '../../domain/repository/session_repository.dart';

/// Sign out: notifies the backend (`POST /authentication/sign-out`) and then clears the session from the device.
///
/// The local session is cleared even if the backend does not answer (offline, 404, 409). Signing out never leaves the
/// person stuck; the forgotten refresh token can no longer be used from this device.
class SignOutUseCase {
  const SignOutUseCase(this._authenticationRepository, this._sessionRepository);

  final AuthenticationRepository _authenticationRepository;
  final SessionRepository _sessionRepository;

  Future<void> call() async {
    await _authenticationRepository.signOutRemotely();
    await _sessionRepository.logoutLocally();
  }
}

import '../../../../core/common/error/result.dart';
import '../../domain/entity/credentials.dart';
import '../../domain/entity/session_user.dart';
import '../../domain/repository/authentication_repository.dart';

/// Single sign-in: `POST /authentication/sign-in`. The session is stored on the device.
class SignInUseCase {
  const SignInUseCase(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;

  Future<Result<SessionUser>> call(Credentials credentials) => _authenticationRepository.signIn(credentials);
}

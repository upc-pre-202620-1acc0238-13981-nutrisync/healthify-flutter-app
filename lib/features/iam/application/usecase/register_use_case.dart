import '../../../../core/common/error/domain_error.dart';
import '../../domain/entity/credentials.dart';
import '../../domain/entity/new_account.dart';
import '../../domain/entity/session_user.dart';
import '../../domain/repository/authentication_repository.dart';

/// Result of creating the account: creating and then signing in are two calls that fail separately.
sealed class RegisterResult {
  const RegisterResult();
}

/// Account created and signed in: shell loading comes next.
final class SignedIn extends RegisterResult {
  const SignedIn(this.user);

  final SessionUser user;
}

/// The account exists but the automatic sign-in failed: the person signs in from the sign-in screen.
final class CreatedWithoutSession extends RegisterResult {
  const CreatedWithoutSession(this.error);

  final DomainError error;
}

/// The account was not created.
final class RegisterFailed extends RegisterResult {
  const RegisterFailed(this.error);

  final DomainError error;
}

/// `POST /authentication/sign-up` and, if it returns `201`, `POST /authentication/sign-in`.
class RegisterUseCase {
  const RegisterUseCase(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;

  Future<RegisterResult> call(NewAccount account) async {
    final signUp = await _authenticationRepository.signUp(account);
    final signUpError = signUp.errorOrNull;
    if (signUpError != null) return RegisterFailed(signUpError);

    final credentials = Credentials.parse(account.email.value, account.password.value);
    if (credentials == null) return const CreatedWithoutSession(Unexpected());
    final signIn = await _authenticationRepository.signIn(credentials);
    return signIn.fold<RegisterResult>(SignedIn.new, CreatedWithoutSession.new);
  }
}

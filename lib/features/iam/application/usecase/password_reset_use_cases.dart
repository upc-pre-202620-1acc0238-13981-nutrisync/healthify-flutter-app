import '../../../../core/common/error/result.dart';
import '../../domain/entity/password_reset.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/valueobject/email_address.dart';
import '../../domain/valueobject/password_reset_code.dart';
import '../../domain/valueobject/password_reset_token.dart';

/// "Forgot your password?": asks for a code to be sent to the email.
class RequestPasswordResetUseCase {
  const RequestPasswordResetUseCase(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;

  Future<Result<void>> call(EmailAddress email) => _authenticationRepository.requestPasswordReset(email);
}

/// Verifies the received code; if it is correct, returns the token that sets the password.
class VerifyPasswordResetCodeUseCase {
  const VerifyPasswordResetCodeUseCase(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;

  Future<Result<PasswordResetToken>> call(EmailAddress email, PasswordResetCode code) =>
      _authenticationRepository.verifyPasswordResetCode(email, code);
}

/// Sets the new password with the token. Does not sign in: the person signs in afterwards.
class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;

  Future<Result<void>> call(PasswordReset reset) => _authenticationRepository.resetPassword(reset);
}

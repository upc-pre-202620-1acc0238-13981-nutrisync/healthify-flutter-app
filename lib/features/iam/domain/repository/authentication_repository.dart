import '../../../../core/common/error/result.dart';
import '../entity/credentials.dart';
import '../entity/new_account.dart';
import '../entity/password_reset.dart';
import '../entity/session_user.dart';
import '../valueobject/email_address.dart';
import '../valueobject/navigation_shell.dart';
import '../valueobject/password_reset_code.dart';
import '../valueobject/password_reset_token.dart';
import '../valueobject/session_id.dart';

/// Accounts and sessions against the backend. Errors arrive as `DomainError` with the backend error `code`.
abstract interface class AuthenticationRepository {
  /// `POST /authentication/sign-up`. Does not sign in.
  Future<Result<void>> signUp(NewAccount account);

  /// `POST /authentication/sign-in`. On success, the session is stored on the device.
  Future<Result<SessionUser>> signIn(Credentials credentials);

  /// `POST /authentication/password-reset-requests`. Always `202`, whether or not the account exists: success does
  /// not tell whether an email was sent.
  Future<Result<void>> requestPasswordReset(EmailAddress email);

  /// `POST /authentication/password-reset-verifications`. A correct code is exchanged for the token that sets the
  /// password; a wrong one returns `PasswordResetCodeInvalid` and uses up an attempt.
  Future<Result<PasswordResetToken>> verifyPasswordResetCode(EmailAddress email, PasswordResetCode code);

  /// `POST /authentication/password-resets`, with the verification token. On success, every session of the account
  /// has ended; it does not sign in.
  Future<Result<void>> resetPassword(PasswordReset reset);

  /// `POST /authentication/sign-out`: ends the session on the backend and deletes its refresh token.
  Future<Result<void>> signOutRemotely();

  /// `GET /sessions/{sessionId}/navigation-shell`. `null` if the session has no shell (the shell policy failed) or
  /// has already ended.
  Future<Result<NavigationShell?>> getNavigationShell(SessionId sessionId);
}

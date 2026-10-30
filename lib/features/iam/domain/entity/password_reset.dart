import '../valueobject/password.dart';
import '../valueobject/password_reset_token.dart';

/// Data to set a new password with the token returned by the code verification. The password follows the sign-up
/// rules ([Password]): the backend answers `WeakPassword` with the same rules, and `PasswordReuseNotAllowed` if it is
/// the current one.
final class PasswordReset {
  const PasswordReset({required this.token, required this.newPassword});

  final PasswordResetToken token;
  final Password newPassword;
}

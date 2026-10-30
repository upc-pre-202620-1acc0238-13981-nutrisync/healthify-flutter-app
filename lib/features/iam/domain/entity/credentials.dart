import '../valueobject/email_address.dart';

/// Single sign-in data. The password is not checked against the sign-up rules: the backend answers
/// `InvalidCredentials` whether or not the account exists (minimal disclosure).
final class Credentials {
  const Credentials._(this.email, this.password);

  final EmailAddress email;
  final String password;

  /// The credentials, or `null` if the email is not shaped like an email or the password is missing. A malformed
  /// email is treated as wrong credentials, the same as the backend does.
  static Credentials? parse(String email, String password) {
    final address = EmailAddress.parse(email);
    if (address == null || password.isEmpty) return null;
    return Credentials._(address, password);
  }

  @override
  String toString() => 'Credentials(email=${email.value}, password=****)';
}

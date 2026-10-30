/// Single-use invitation token: 32 random bytes in url-safe base64, 22-64 characters. It is a secret: never logged
/// or shown as text (`toString` hides it).
///
/// The invitation QR code holds only the token.
final class InvitationToken {
  /// Throws [ArgumentError] if [value] does not have the shape of a token.
  factory InvitationToken(String value) {
    final token = parse(value);
    if (token == null || token.value != value) {
      throw ArgumentError('InvitationToken must be $minLength-$maxLength base64url chars');
    }
    return token;
  }

  const InvitationToken._(this.value);

  static const minLength = 22;
  static const maxLength = 64;

  static final _base64Url = RegExp(r'^[A-Za-z0-9_-]+$');

  final String value;

  /// The token read from [raw], or `null` if it does not look like an invitation.
  static InvitationToken? parse(String raw) {
    final candidate = raw.trim();
    final valid = candidate.length >= minLength && candidate.length <= maxLength && _base64Url.hasMatch(candidate);
    return valid ? InvitationToken._(candidate) : null;
  }

  @override
  bool operator ==(Object other) => other is InvitationToken && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'InvitationToken(***)';
}

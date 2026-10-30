/// Password for a new account, with the rules of the backend `Password` VO (`WeakPassword`): 8 to 128 characters,
/// with at least one uppercase letter, one lowercase letter, one digit and one character that is not a letter or digit.
///
/// Only used at sign-up and password reset: sign-in sends whatever the person typed (see `Credentials`).
final class Password {
  Password._(this.value);

  static const minLength = 8;
  static const maxLength = 128;

  final String value;

  /// Throws [ArgumentError] if [raw] does not meet the rules.
  factory Password(String raw) => parse(raw) ?? (throw ArgumentError('Weak password'));

  /// The password, or `null` if [raw] does not meet the rules.
  static Password? parse(String raw) => isStrong(raw) ? Password._(raw) : null;

  static bool isStrong(String raw) {
    if (raw.trim().isEmpty || raw.length < minLength || raw.length > maxLength) return false;
    final chars = raw.runes.map(String.fromCharCode).toList();
    final hasUpper = chars.any((c) => c != c.toLowerCase());
    final hasLower = chars.any((c) => c != c.toUpperCase());
    final hasDigit = chars.any((c) => c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39);
    final hasSymbol = chars.any((c) => !_isLetterOrDigit(c));
    return hasUpper && hasLower && hasDigit && hasSymbol;
  }

  static final _letterOrDigit = RegExp(r'^[\p{L}\p{Nd}]$', unicode: true);

  static bool _isLetterOrDigit(String c) => _letterOrDigit.hasMatch(c);

  @override
  bool operator ==(Object other) => other is Password && other.value == value;

  @override
  int get hashCode => value.hashCode;

  /// Never expose the password in logs or in UI state.
  @override
  String toString() => 'Password(****)';
}

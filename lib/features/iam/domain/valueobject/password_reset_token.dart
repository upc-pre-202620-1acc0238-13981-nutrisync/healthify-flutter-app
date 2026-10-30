/// Token the backend returns when the code is verified: sets the new password once and expires within a few minutes.
/// Lives in memory only; never stored or logged.
final class PasswordResetToken {
  /// Throws [ArgumentError] if [value] is blank.
  PasswordResetToken(this.value) {
    if (value.trim().isEmpty) throw ArgumentError.value(value, 'value', 'Reset token is required');
  }

  final String value;

  @override
  bool operator ==(Object other) => other is PasswordResetToken && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'PasswordResetToken(****)';
}

/// Recovery code that arrives by email: exactly six digits. The backend decides whether it is correct; here we only
/// avoid sending something that cannot be.
final class PasswordResetCode {
  PasswordResetCode._(this.value);

  static const length = 6;

  static final _whitespace = RegExp(r'\s');
  static final _digits = RegExp(r'^[0-9]+$');

  final String value;

  /// The code, or `null` if [raw] (without spaces) is not six digits.
  static PasswordResetCode? parse(String raw) {
    final digits = raw.replaceAll(_whitespace, '');
    return digits.length == length && _digits.hasMatch(digits) ? PasswordResetCode._(digits) : null;
  }

  @override
  bool operator ==(Object other) => other is PasswordResetCode && other.value == value;

  @override
  int get hashCode => value.hashCode;

  /// Never expose the code in logs or in UI state.
  @override
  String toString() => 'PasswordResetCode(******)';
}

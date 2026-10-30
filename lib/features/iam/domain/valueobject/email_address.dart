/// Account email, normalized and validated like the backend `Email` VO: no spaces, lowercase, up to 255 characters
/// and shaped like `^[^@\s]+@[^@\s]+\.[^@\s]+$`.
final class EmailAddress {
  EmailAddress._(this.value);

  static const maxLength = 255;

  static final _pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final String value;

  /// Throws [ArgumentError] if [raw] is not a valid email.
  factory EmailAddress(String raw) =>
      parse(raw) ?? (throw ArgumentError.value(raw, 'raw', 'Invalid email'));

  /// The email, or `null` if [raw] is not valid (form validation without exceptions).
  static EmailAddress? parse(String raw) {
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty || normalized.length > maxLength || !_pattern.hasMatch(normalized)) return null;
    return EmailAddress._(normalized);
  }

  @override
  bool operator ==(Object other) => other is EmailAddress && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'EmailAddress($value)';
}

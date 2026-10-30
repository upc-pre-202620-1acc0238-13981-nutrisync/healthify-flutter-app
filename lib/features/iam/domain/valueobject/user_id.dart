/// Account id on the backend (`users.id`, also the token's `sub`).
extension type const UserId._(int value) {
  /// Throws [ArgumentError] if [value] is not positive.
  factory UserId(int value) {
    if (value <= 0) throw ArgumentError.value(value, 'value', 'UserId must be positive');
    return UserId._(value);
  }
}

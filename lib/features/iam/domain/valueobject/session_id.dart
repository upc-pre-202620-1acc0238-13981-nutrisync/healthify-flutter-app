/// Id of the backend `UserSession` (`sessionId` claim); used to request the navigation shell.
extension type const SessionId._(int value) {
  /// Throws [ArgumentError] if [value] is not positive.
  factory SessionId(int value) {
    if (value <= 0) throw ArgumentError.value(value, 'value', 'SessionId must be positive');
    return SessionId._(value);
  }
}

/// Id of a care link (`CareLinkResource.careLinkId`).
extension type const CareLinkId._(int value) {
  /// Throws [ArgumentError] if [value] is not positive.
  factory CareLinkId(int value) {
    if (value <= 0) throw ArgumentError.value(value, 'value', 'CareLinkId must be positive');
    return CareLinkId._(value);
  }
}

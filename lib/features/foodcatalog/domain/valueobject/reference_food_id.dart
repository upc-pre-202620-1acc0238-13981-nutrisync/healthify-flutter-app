/// Id of a reference catalog food (`ReferenceFoodResource.referenceFoodId`).
extension type const ReferenceFoodId._(int value) {
  /// Throws [ArgumentError] if [value] is not positive.
  factory ReferenceFoodId(int value) {
    if (value <= 0) throw ArgumentError.value(value, 'value', 'ReferenceFoodId must be positive');
    return ReferenceFoodId._(value);
  }
}

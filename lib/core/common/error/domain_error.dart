/// Shared error kernel: domain, application and presentation of every context use it.
///
/// `code` is the name of the backend error enum value (`InvalidCredentials`, `ConsentAlreadyGranted`...)
/// when the backend sends it; the UI picks the mockup text from that code.
sealed class DomainError {
  const DomainError();

  /// Backend error code, or `HTTP_<status>` when the response carried none. `null` if there is nothing to report.
  String? get code;

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType && other is DomainError && other.code == code;

  @override
  int get hashCode => Object.hash(runtimeType, code);

  @override
  String toString() => '$runtimeType(code: $code)';
}

final class Network extends DomainError {
  const Network();

  @override
  String? get code => null;
}

final class Unauthorized extends DomainError {
  const Unauthorized([this.code]);

  @override
  final String? code;
}

final class Forbidden extends DomainError {
  const Forbidden([this.code]);

  @override
  final String? code;
}

final class NotFound extends DomainError {
  const NotFound([this.code]);

  @override
  final String? code;
}

final class Conflict extends DomainError {
  const Conflict([this.code]);

  @override
  final String? code;
}

final class Validation extends DomainError {
  const Validation(this.code);

  @override
  final String code;
}

/// 5xx, 429 or a response that could not be parsed. `code` carries the status if there is no other (`HTTP_503`).
final class Unexpected extends DomainError {
  const Unexpected([this.code]);

  @override
  final String? code;
}

/// Id of a review inbox item (`reviewItemId`).
extension type const ReviewItemId._(int value) {
  /// Throws [ArgumentError] if [value] is not positive.
  factory ReviewItemId(int value) {
    if (value <= 0) throw ArgumentError.value(value, 'value', 'ReviewItemId must be positive');
    return ReviewItemId._(value);
  }
}

/// Filter for `GET /review-items?state=`: the inbox asks for the open ones.
enum ReviewItemStatus {
  open('Open'),
  resolved('Resolved');

  const ReviewItemStatus(this.code);

  final String code;

  static ReviewItemStatus? fromCode(String? code) {
    final normalized = code?.trim().toLowerCase();
    for (final state in values) {
      if (state.code.toLowerCase() == normalized) return state;
    }
    return null;
  }
}

/// Which signal opened the item (`signalType`). Only a sustained deviation can carry an AI-proposed plan.
/// A type this version does not know is shown as is.
sealed class SignalType {
  const SignalType();

  factory SignalType.of(String code) => switch (code.trim()) {
    'SustainedDeviation' => const SustainedDeviation(),
    'ScheduledRecheck' => const ScheduledRecheck(),
    'ConsistencyEscalation' => const ConsistencyEscalation(),
    final other => CustomSignal(other),
  };
}

final class SustainedDeviation extends SignalType {
  const SustainedDeviation();
}

final class ScheduledRecheck extends SignalType {
  const ScheduledRecheck();
}

final class ConsistencyEscalation extends SignalType {
  const ConsistencyEscalation();
}

final class CustomSignal extends SignalType {
  /// Throws [ArgumentError] if [text] is blank.
  CustomSignal(this.text) {
    if (text.trim().isEmpty) throw ArgumentError.value(text, 'text', 'A custom signal type needs text');
  }

  final String text;
}

/// Which way the logged energy deviated from the target (`direction`).
enum DeviationDirection {
  above('Above'),
  below('Below');

  const DeviationDirection(this.code);

  final String code;

  static DeviationDirection? fromCode(String? code) {
    final normalized = code?.trim().toLowerCase();
    for (final direction in values) {
      if (direction.code.toLowerCase() == normalized) return direction;
    }
    return null;
  }
}

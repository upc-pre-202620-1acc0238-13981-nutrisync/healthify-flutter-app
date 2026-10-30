import 'domain_error.dart';

/// Outcome of an operation that can fail with a [DomainError]. Repositories return it and never throw to the UI.
sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(DomainError error) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    Failure<T>() => null,
  };

  DomainError? get errorOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(:final error) => error,
  };

  R fold<R>(R Function(T value) onSuccess, R Function(DomainError error) onFailure) => switch (this) {
    Success<T>(:final value) => onSuccess(value),
    Failure<T>(:final error) => onFailure(error),
  };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Success<T>(:final value) => Success(transform(value)),
    Failure<T>(:final error) => Failure(error),
  };

  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
    Success<T>(:final value) => transform(value),
    Failure<T>(:final error) => Failure(error),
  };

  /// Runs [action] on success and returns `this`, to chain side effects.
  Result<T> onSuccess(void Function(T value) action) {
    if (this case Success<T>(:final value)) action(value);
    return this;
  }

  /// Runs [action] on failure and returns `this`, to chain side effects.
  Result<T> onFailure(void Function(DomainError error) action) {
    if (this case Failure<T>(:final error)) action(error);
    return this;
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Success<T> && other.value == value;

  @override
  int get hashCode => Object.hash(Success, value);

  @override
  String toString() => 'Success($value)';
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final DomainError error;

  @override
  bool operator ==(Object other) => other is Failure<T> && other.error == error;

  @override
  int get hashCode => Object.hash(Failure, error);

  @override
  String toString() => 'Failure($error)';
}

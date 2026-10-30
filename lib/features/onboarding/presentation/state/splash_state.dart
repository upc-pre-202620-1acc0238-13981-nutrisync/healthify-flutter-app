import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

/// Where the app goes after the splash.
enum SplashDestination { welcome, shellLoading, sessionExpired }

/// The splash has a single visual; [destination] stays `null` while the local session is read.
@freezed
abstract class SplashState with _$SplashState {
  const factory SplashState({SplashDestination? destination}) = _SplashState;
}

sealed class SplashEvent {
  const SplashEvent();
}

final class SplashNavigate extends SplashEvent {
  const SplashNavigate(this.destination);

  final SplashDestination destination;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_expired_state.freezed.dart';

/// Session expired. The visual changes with the connection: dark (online) or light with a banner and the "sign in
/// again once you are online" text (offline).
@freezed
abstract class SessionExpiredState with _$SessionExpiredState {
  const factory SessionExpiredState({@Default(false) bool isOffline}) = _SessionExpiredState;
}

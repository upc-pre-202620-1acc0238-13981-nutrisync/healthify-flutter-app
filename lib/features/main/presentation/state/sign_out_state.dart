import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_out_state.freezed.dart';

/// The shells' "Sign out": the state says whether it is in progress; when done, the router clears the stack.
@freezed
abstract class SignOutState with _$SignOutState {
  const factory SignOutState({@Default(false) bool isSigningOut}) = _SignOutState;
}

sealed class SignOutEvent {
  const SignOutEvent();
}

final class SignedOut extends SignOutEvent {
  const SignedOut();
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'practitioner_only_state.freezed.dart';

/// "This app is for nutritionists": a patient account landed here and can only sign out.
@freezed
abstract class PractitionerOnlyState with _$PractitionerOnlyState {
  const factory PractitionerOnlyState({@Default(false) bool isSigningOut}) = _PractitionerOnlyState;
}

sealed class PractitionerOnlyEvent {
  const PractitionerOnlyEvent();
}

/// Signed out -> sign-in.
final class PractitionerOnlySignedOut extends PractitionerOnlyEvent {
  const PractitionerOnlySignedOut();
}

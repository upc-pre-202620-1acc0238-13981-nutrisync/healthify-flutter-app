import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/valueobject/invitation_token.dart';
import '../../domain/valueobject/invitation_validity.dart';

part 'invite_patient_state.freezed.dart';

/// Why the invitation code could not be generated (texts from the design notes).
enum InviteError { offline, expirationRequired, generic }

/// Generate invitation (plus its loading state). The token lives only in memory while the screen is open: it is never
/// saved or requested again.
@freezed
abstract class InvitePatientState with _$InvitePatientState {
  const InvitePatientState._();

  const factory InvitePatientState({
    @Default(InvitationValidity.defaultValidity) InvitationValidity validity,
    @Default(true) bool isGenerating,
    InvitationToken? token,
    Duration? remaining,
    @Default(false) bool isExpired,
    @Default(false) bool isOffline,
    InviteError? error,
  }) = _InvitePatientState;

  // Keeps the secret token out of logs.
  @override
  String toString() => 'InvitePatientState(validity: $validity, isGenerating: $isGenerating, error: $error)';
}

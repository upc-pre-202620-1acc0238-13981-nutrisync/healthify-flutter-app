import '../valueobject/invitation_token.dart';

/// The newly issued invitation. The token arrives **only once**, in this response: it is not stored on the phone or
/// requested again (ethical rule of the invite screen: never promise "you can see it later").
final class IssuedInvitation {
  /// Throws [ArgumentError] if [invitationId] is not positive.
  IssuedInvitation({required this.invitationId, required this.token, required this.expiresAt}) {
    if (invitationId <= 0) throw ArgumentError.value(invitationId, 'invitationId', 'InvitationId must be positive');
  }

  final int invitationId;
  final InvitationToken token;
  final DateTime expiresAt;

  /// Remaining validity at [now] (never negative).
  Duration remaining(DateTime now) {
    final left = expiresAt.difference(now);
    return left.isNegative ? Duration.zero : left;
  }

  bool isExpired(DateTime now) => !now.isBefore(expiresAt);
}

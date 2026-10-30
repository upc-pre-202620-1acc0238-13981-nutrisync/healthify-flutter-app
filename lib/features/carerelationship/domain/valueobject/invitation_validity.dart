/// "Expires in" on the invite screen. The backend asks for a future expiration date (`ExpirationDateRequired`); the app
/// offers fixed durations: 1 hour, 24 hours (the design's value, the default) and 7 days.
enum InvitationValidity {
  oneHour(Duration(hours: 1)),
  oneDay(Duration(hours: 24)),
  sevenDays(Duration(days: 7));

  const InvitationValidity(this.duration);

  static const defaultValidity = InvitationValidity.oneDay;

  final Duration duration;

  DateTime expiresAt(DateTime now) => now.add(duration);
}

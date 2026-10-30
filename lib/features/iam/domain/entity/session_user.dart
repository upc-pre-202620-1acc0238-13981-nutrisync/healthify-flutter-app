import '../valueobject/email_address.dart';
import '../valueobject/person_name.dart';
import '../valueobject/preferred_language.dart';
import '../valueobject/session_id.dart';
import '../valueobject/user_id.dart';
import '../valueobject/user_role.dart';

/// The person signed in on this device. Tokens are never part of the domain.
final class SessionUser {
  const SessionUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.preferredLanguage,
    required this.sessionId,
  });

  final UserId id;
  final EmailAddress email;
  final PersonName name;
  final UserRole role;
  final PreferredLanguage preferredLanguage;
  final SessionId sessionId;

  bool get isPatient => role == UserRole.patient;
  bool get isPractitioner => role == UserRole.practitioner;

  SessionUser copyWith({PreferredLanguage? preferredLanguage}) => SessionUser(
    id: id,
    email: email,
    name: name,
    role: role,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    sessionId: sessionId,
  );

  @override
  bool operator ==(Object other) =>
      other is SessionUser &&
      other.id == id &&
      other.email == email &&
      other.name == name &&
      other.role == role &&
      other.preferredLanguage == preferredLanguage &&
      other.sessionId == sessionId;

  @override
  int get hashCode => Object.hash(id, email, name, role, preferredLanguage, sessionId);

  @override
  String toString() => 'SessionUser(id=$id, role=$role)';
}

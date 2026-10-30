import '../../domain/entity/session_user.dart';
import '../../domain/valueobject/email_address.dart';
import '../../domain/valueobject/person_name.dart';
import '../../domain/valueobject/preferred_language.dart';
import '../../domain/valueobject/session_id.dart';
import '../../domain/valueobject/user_id.dart';
import '../../domain/valueobject/user_role.dart';
import '../local/session_user_record.dart';
import '../remote/dto/authentication_dtos.dart';

const _rolePatient = 'Patient';
const _rolePractitioner = 'Practitioner';

/// Backend role (`Patient`/`Practitioner`). An unknown role is a broken contract: fail fast with [ArgumentError].
UserRole userRoleFromCode(String code) {
  if (code.toLowerCase() == _rolePatient.toLowerCase()) return UserRole.patient;
  if (code.toLowerCase() == _rolePractitioner.toLowerCase()) return UserRole.practitioner;
  throw ArgumentError.value(code, 'code', 'Unknown role');
}

String userRoleToCode(UserRole role) => switch (role) {
  UserRole.patient => _rolePatient,
  UserRole.practitioner => _rolePractitioner,
};

extension SignInResponseMapper on SignInResponseDto {
  /// Throws [ArgumentError] if the response does not form a valid user.
  SessionUser toDomain() {
    final address = EmailAddress(email);
    // An account without names (created before names were required) uses the email local part, like the backend.
    final given = (givenNames?.trim().isNotEmpty ?? false) ? givenNames! : address.value.split('@').first;
    return SessionUser(
      id: UserId(userId),
      email: address,
      name: PersonName.of(given, familyNames ?? ''),
      role: userRoleFromCode(role),
      preferredLanguage: PreferredLanguage.fromCode(preferredLanguage),
      sessionId: SessionId(sessionId),
    );
  }
}

extension SessionUserRecordMapper on SessionUserRecord {
  /// Throws [ArgumentError] if the stored record no longer forms a valid user.
  SessionUser toDomain() => SessionUser(
    id: UserId(userId),
    email: EmailAddress(email),
    name: PersonName(givenNames, familyNames),
    role: userRoleFromCode(role),
    preferredLanguage: PreferredLanguage.fromCode(preferredLanguage),
    sessionId: SessionId(sessionId),
  );
}

extension SessionUserMapper on SessionUser {
  SessionUserRecord toRecord({String? createdAt}) => SessionUserRecord(
    userId: id.value,
    email: email.value,
    givenNames: name.givenNames,
    familyNames: name.familyNames,
    role: userRoleToCode(role),
    preferredLanguage: preferredLanguage.code,
    sessionId: sessionId.value,
    createdAt: createdAt,
  );
}

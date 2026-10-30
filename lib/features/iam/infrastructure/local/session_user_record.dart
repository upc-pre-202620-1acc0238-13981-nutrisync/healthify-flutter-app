import 'package:json_annotation/json_annotation.dart';

part 'session_user_record.g.dart';

/// The user signed in on the device, as stored in `shared_preferences` (the equivalent of Android's Room row). There
/// is at most one session, so there is a single record.
@JsonSerializable()
class SessionUserRecord {
  const SessionUserRecord({
    required this.userId,
    required this.email,
    required this.givenNames,
    required this.familyNames,
    required this.role,
    required this.preferredLanguage,
    required this.sessionId,
    this.createdAt,
  });

  factory SessionUserRecord.fromJson(Map<String, dynamic> json) => _$SessionUserRecordFromJson(json);

  final int userId;
  final String email;
  final String givenNames;
  final String familyNames;

  /// `Patient` or `Practitioner`, as on the backend.
  final String role;
  final String preferredLanguage;
  final int sessionId;

  /// `UserResource.createdAt` (ISO-8601), read once with `GET /users/{id}`; `null` until then.
  final String? createdAt;

  SessionUserRecord copyWith({String? preferredLanguage, String? createdAt}) => SessionUserRecord(
    userId: userId,
    email: email,
    givenNames: givenNames,
    familyNames: familyNames,
    role: role,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    sessionId: sessionId,
    createdAt: createdAt ?? this.createdAt,
  );

  Map<String, dynamic> toJson() => _$SessionUserRecordToJson(this);
}

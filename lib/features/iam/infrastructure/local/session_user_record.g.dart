// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_user_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionUserRecord _$SessionUserRecordFromJson(Map<String, dynamic> json) =>
    SessionUserRecord(
      userId: (json['userId'] as num).toInt(),
      email: json['email'] as String,
      givenNames: json['givenNames'] as String,
      familyNames: json['familyNames'] as String,
      role: json['role'] as String,
      preferredLanguage: json['preferredLanguage'] as String,
      sessionId: (json['sessionId'] as num).toInt(),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$SessionUserRecordToJson(SessionUserRecord instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'givenNames': instance.givenNames,
      'familyNames': instance.familyNames,
      'role': instance.role,
      'preferredLanguage': instance.preferredLanguage,
      'sessionId': instance.sessionId,
      'createdAt': instance.createdAt,
    };

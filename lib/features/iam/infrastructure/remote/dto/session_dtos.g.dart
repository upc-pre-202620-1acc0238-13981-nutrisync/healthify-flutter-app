// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigationShellDto _$NavigationShellDtoFromJson(Map<String, dynamic> json) =>
    NavigationShellDto(
      sessionId: (json['sessionId'] as num).toInt(),
      roleClaim: json['roleClaim'] as String?,
      navigationShell: json['navigationShell'] as String?,
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$ChangePreferredLanguageRequestDtoToJson(
  ChangePreferredLanguageRequestDto instance,
) => <String, dynamic>{'language': instance.language};

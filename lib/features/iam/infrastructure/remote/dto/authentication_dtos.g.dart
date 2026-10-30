// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$SignInRequestDtoToJson(SignInRequestDto instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

SignInResponseDto _$SignInResponseDtoFromJson(Map<String, dynamic> json) =>
    SignInResponseDto(
      userId: (json['userId'] as num).toInt(),
      email: json['email'] as String,
      role: json['role'] as String,
      sessionId: (json['sessionId'] as num).toInt(),
      token: json['token'] as String,
      givenNames: json['givenNames'] as String?,
      familyNames: json['familyNames'] as String?,
      preferredLanguage: json['preferredLanguage'] as String?,
      refreshToken: json['refreshToken'] as String,
      expiresAt: json['expiresAt'] as String?,
    );

Map<String, dynamic> _$TokenRefreshRequestDtoToJson(
  TokenRefreshRequestDto instance,
) => <String, dynamic>{'refreshToken': instance.refreshToken};

TokenRefreshResponseDto _$TokenRefreshResponseDtoFromJson(
  Map<String, dynamic> json,
) => TokenRefreshResponseDto(
  token: json['token'] as String,
  refreshToken: json['refreshToken'] as String,
  expiresAt: json['expiresAt'] as String?,
);

Map<String, dynamic> _$PasswordResetRequestDtoToJson(
  PasswordResetRequestDto instance,
) => <String, dynamic>{'email': instance.email};

Map<String, dynamic> _$PasswordResetVerificationRequestDtoToJson(
  PasswordResetVerificationRequestDto instance,
) => <String, dynamic>{'email': instance.email, 'code': instance.code};

PasswordResetVerificationResponseDto
_$PasswordResetVerificationResponseDtoFromJson(Map<String, dynamic> json) =>
    PasswordResetVerificationResponseDto(
      resetToken: json['resetToken'] as String,
      expiresAt: json['expiresAt'] as String?,
    );

Map<String, dynamic> _$PasswordResetDtoToJson(PasswordResetDto instance) =>
    <String, dynamic>{
      'resetToken': instance.resetToken,
      'newPassword': instance.newPassword,
    };

Map<String, dynamic> _$SignUpRequestDtoToJson(SignUpRequestDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
      'givenNames': instance.givenNames,
      'familyNames': instance.familyNames,
    };

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  userId: (json['userId'] as num).toInt(),
  email: json['email'] as String,
  role: json['role'] as String,
  createdAt: json['createdAt'] as String?,
  givenNames: json['givenNames'] as String?,
  familyNames: json['familyNames'] as String?,
  fullName: json['fullName'] as String?,
  preferredLanguage: json['preferredLanguage'] as String?,
);

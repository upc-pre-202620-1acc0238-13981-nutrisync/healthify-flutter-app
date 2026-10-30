import 'package:json_annotation/json_annotation.dart';

part 'authentication_dtos.g.dart';

/// `SignInResource(Email, Password)`, without `role` (single sign-in).
@JsonSerializable(createFactory: false)
class SignInRequestDto {
  const SignInRequestDto({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$SignInRequestDtoToJson(this);
}

/// `SignInResponseResource(UserId, Email, Role, SessionId, Token, GivenNames, FamilyNames, PreferredLanguage,
/// RefreshToken, ExpiresAt)`.
@JsonSerializable(createToJson: false)
class SignInResponseDto {
  const SignInResponseDto({
    required this.userId,
    required this.email,
    required this.role,
    required this.sessionId,
    required this.token,
    this.givenNames,
    this.familyNames,
    this.preferredLanguage,
    required this.refreshToken,
    this.expiresAt,
  });

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) => _$SignInResponseDtoFromJson(json);

  final int userId;
  final String email;
  final String role;
  final int sessionId;
  final String token;
  final String? givenNames;
  final String? familyNames;
  final String? preferredLanguage;
  final String refreshToken;
  final String? expiresAt;
}

/// Body of `POST /authentication/token-refreshes`.
@JsonSerializable(createFactory: false)
class TokenRefreshRequestDto {
  const TokenRefreshRequestDto({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => _$TokenRefreshRequestDtoToJson(this);
}

/// `200` from `POST /authentication/token-refreshes`: `{ token, refreshToken, expiresAt }`.
@JsonSerializable(createToJson: false)
class TokenRefreshResponseDto {
  const TokenRefreshResponseDto({required this.token, required this.refreshToken, this.expiresAt});

  factory TokenRefreshResponseDto.fromJson(Map<String, dynamic> json) => _$TokenRefreshResponseDtoFromJson(json);

  final String token;
  final String refreshToken;
  final String? expiresAt;
}

/// `PasswordResetRequestResource(Email)`.
@JsonSerializable(createFactory: false)
class PasswordResetRequestDto {
  const PasswordResetRequestDto({required this.email});

  final String email;

  Map<String, dynamic> toJson() => _$PasswordResetRequestDtoToJson(this);
}

/// `PasswordResetVerificationResource(Email, Code)`.
@JsonSerializable(createFactory: false)
class PasswordResetVerificationRequestDto {
  const PasswordResetVerificationRequestDto({required this.email, required this.code});

  final String email;
  final String code;

  Map<String, dynamic> toJson() => _$PasswordResetVerificationRequestDtoToJson(this);
}

/// `200` from `POST /authentication/password-reset-verifications`: `{ resetToken, expiresAt }`.
@JsonSerializable(createToJson: false)
class PasswordResetVerificationResponseDto {
  const PasswordResetVerificationResponseDto({required this.resetToken, this.expiresAt});

  factory PasswordResetVerificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetVerificationResponseDtoFromJson(json);

  final String resetToken;
  final String? expiresAt;
}

/// `PasswordResetResource(ResetToken, NewPassword)`.
@JsonSerializable(createFactory: false)
class PasswordResetDto {
  const PasswordResetDto({required this.resetToken, required this.newPassword});

  final String resetToken;
  final String newPassword;

  Map<String, dynamic> toJson() => _$PasswordResetDtoToJson(this);
}

/// `SignUpResource(Email, Password, Role, GivenNames, FamilyNames)`.
@JsonSerializable(createFactory: false)
class SignUpRequestDto {
  const SignUpRequestDto({
    required this.email,
    required this.password,
    required this.role,
    required this.givenNames,
    required this.familyNames,
  });

  final String email;
  final String password;
  final String role;
  final String givenNames;
  final String familyNames;

  Map<String, dynamic> toJson() => _$SignUpRequestDtoToJson(this);
}

/// `UserResource(UserId, Email, Role, CreatedAt, GivenNames, FamilyNames, FullName, PreferredLanguage)`.
@JsonSerializable(createToJson: false)
class UserDto {
  const UserDto({
    required this.userId,
    required this.email,
    required this.role,
    this.createdAt,
    this.givenNames,
    this.familyNames,
    this.fullName,
    this.preferredLanguage,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  final int userId;
  final String email;
  final String role;
  final String? createdAt;
  final String? givenNames;
  final String? familyNames;
  final String? fullName;
  final String? preferredLanguage;
}

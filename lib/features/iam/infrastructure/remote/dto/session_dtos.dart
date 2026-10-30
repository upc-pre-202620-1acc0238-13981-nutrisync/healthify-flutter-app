import 'package:json_annotation/json_annotation.dart';

part 'session_dtos.g.dart';

/// `NavigationShellResource(SessionId, RoleClaim, NavigationShell, IsActive)`. `navigationShell` is `PatientShell`,
/// `PractitionerShell` or `null` while none has been chosen.
@JsonSerializable(createToJson: false)
class NavigationShellDto {
  const NavigationShellDto({required this.sessionId, this.roleClaim, this.navigationShell, this.isActive = false});

  factory NavigationShellDto.fromJson(Map<String, dynamic> json) => _$NavigationShellDtoFromJson(json);

  final int sessionId;
  final String? roleClaim;
  final String? navigationShell;
  final bool isActive;
}

/// `ChangePreferredLanguageResource(Language)`: `es` or `en`.
@JsonSerializable(createFactory: false)
class ChangePreferredLanguageRequestDto {
  const ChangePreferredLanguageRequestDto({required this.language});

  final String language;

  Map<String, dynamic> toJson() => _$ChangePreferredLanguageRequestDtoToJson(this);
}

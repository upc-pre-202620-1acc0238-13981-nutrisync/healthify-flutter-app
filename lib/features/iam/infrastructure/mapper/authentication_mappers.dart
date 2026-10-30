import '../../domain/entity/credentials.dart';
import '../../domain/entity/new_account.dart';
import '../../domain/entity/password_reset.dart';
import '../../domain/valueobject/navigation_shell.dart';
import '../../domain/valueobject/password_reset_token.dart';
import '../remote/dto/authentication_dtos.dart';
import '../remote/dto/session_dtos.dart';
import 'session_mappers.dart';

const _shellPatient = 'PatientShell';
const _shellPractitioner = 'PractitionerShell';

extension NewAccountMapper on NewAccount {
  SignUpRequestDto toDto() => SignUpRequestDto(
    email: email.value,
    password: password.value,
    role: userRoleToCode(role),
    givenNames: name.givenNames,
    familyNames: name.familyNames,
  );
}

extension CredentialsMapper on Credentials {
  SignInRequestDto toDto() => SignInRequestDto(email: email.value, password: password);
}

extension PasswordResetMapper on PasswordReset {
  PasswordResetDto toDto() => PasswordResetDto(resetToken: token.value, newPassword: newPassword.value);
}

extension PasswordResetVerificationMapper on PasswordResetVerificationResponseDto {
  /// Throws [ArgumentError] if the backend returned an empty token (broken contract).
  PasswordResetToken toDomain() => PasswordResetToken(resetToken);
}

extension NavigationShellMapper on NavigationShellDto {
  /// `null` if the session already ended or has no shell; an unknown value is also read as "no shell".
  NavigationShell? toDomain() {
    if (!isActive) return null;
    final shell = navigationShell?.toLowerCase();
    if (shell == _shellPatient.toLowerCase()) return NavigationShell.patient;
    if (shell == _shellPractitioner.toLowerCase()) return NavigationShell.practitioner;
    return null;
  }
}

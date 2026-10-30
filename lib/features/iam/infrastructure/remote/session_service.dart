import '../../../../core/network/api_client.dart';
import 'dto/authentication_dtos.dart';
import 'dto/session_dtos.dart';

/// Authenticated Iam endpoints: they go through the [ApiClient] with bearer and token pair refresh.
class SessionService {
  const SessionService(this._api);

  final ApiClient _api;

  /// The `sessionId` comes from the token, not the body. `204`.
  Future<void> signOut() => _api.post('authentication/sign-out');

  Future<NavigationShellDto> getNavigationShell(int sessionId) async => NavigationShellDto.fromJson(
    await _api.get('sessions/$sessionId/navigation-shell') as Map<String, dynamic>,
  );

  /// The caller's own account (`403` if it is not the token's).
  Future<UserDto> getUser(int userId) async =>
      UserDto.fromJson(await _api.get('users/$userId') as Map<String, dynamic>);

  /// `204`.
  Future<void> changePreferredLanguage(int userId, ChangePreferredLanguageRequestDto body) =>
      _api.put('users/$userId/preferred-language', body: body.toJson());
}

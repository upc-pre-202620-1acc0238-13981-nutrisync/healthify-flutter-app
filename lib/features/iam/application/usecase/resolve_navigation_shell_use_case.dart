import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/error/result.dart';
import '../../domain/entity/session_user.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/valueobject/navigation_shell.dart';

/// The shell the app mounts for the session (`GET /sessions/{sessionId}/navigation-shell`).
///
/// If the session has no shell (the sign-in shell policy failed: `navigation-shell` would return a null shell) or
/// there is no connection, the shell for the account's role is used (`NavigationShell.forRole`, the same backend
/// rule).
class ResolveNavigationShellUseCase {
  const ResolveNavigationShellUseCase(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;

  Future<Result<NavigationShell>> call(SessionUser user) async {
    final byRole = NavigationShell.forRole(user.role);
    final result = await _authenticationRepository.getNavigationShell(user.sessionId);
    return switch (result.errorOrNull) {
      Network() || NotFound() => Result.success(byRole),
      _ => result.map((shell) => shell ?? byRole),
    };
  }
}

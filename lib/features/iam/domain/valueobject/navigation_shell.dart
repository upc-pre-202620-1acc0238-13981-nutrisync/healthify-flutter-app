import 'user_role.dart';

/// Shell the app mounts for a session (App Shell read model, `NavigationShellResource`).
enum NavigationShell {
  patient,
  practitioner;

  /// The shell for a role (the backend's `NavigationShell.ForRole`).
  static NavigationShell forRole(UserRole role) => switch (role) {
    UserRole.patient => NavigationShell.patient,
    UserRole.practitioner => NavigationShell.practitioner,
  };
}

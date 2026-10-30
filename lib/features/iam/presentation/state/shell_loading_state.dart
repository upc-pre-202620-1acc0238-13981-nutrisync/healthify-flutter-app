import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/valueobject/navigation_shell.dart';

part 'shell_loading_state.freezed.dart';

/// Where the person goes after loading. The patient shell is not part of this app: it only gets the "this app is for
/// nutritionists" screen.
enum ShellDestination {
  /// Practitioner (practitioner shell).
  practitionerHome,

  /// Patient: this app does not serve that role.
  patientNotSupported,
}

/// Loading rule: the shell decides.
ShellDestination selectShellDestination(NavigationShell shell) => switch (shell) {
  NavigationShell.practitioner => ShellDestination.practitionerHome,
  NavigationShell.patient => ShellDestination.patientNotSupported,
};

/// Loading (Normal / Error).
@freezed
abstract class ShellLoadingState with _$ShellLoadingState {
  const factory ShellLoadingState({@Default(false) bool isError, @Default(false) bool isRetrying}) =
      _ShellLoadingState;
}

sealed class ShellLoadingEvent {
  const ShellLoadingEvent();
}

final class ShellLoadingNavigate extends ShellLoadingEvent {
  const ShellLoadingNavigate(this.destination);

  final ShellDestination destination;
}

/// No stored user (should not happen right after sign-up or sign-in): goes back to the start.
final class ShellLoadingNavigateToWelcome extends ShellLoadingEvent {
  const ShellLoadingNavigateToWelcome();
}

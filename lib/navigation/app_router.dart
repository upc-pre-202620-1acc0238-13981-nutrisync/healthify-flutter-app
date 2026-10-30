import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/designsystem/theme/healthify_theme.dart';
import '../core/di/service_locator.dart';
import '../core/l10n/app_localizations.dart';
import '../features/carerelationship/presentation/navigation/care_relationship_routes.dart';
import '../features/carerelationship/presentation/screen/discharge_patient_screen.dart';
import '../features/carerelationship/presentation/screen/invite_patient_screen.dart';
import '../features/carerelationship/presentation/screen/patient_roster_screen.dart';
import '../features/iam/presentation/screen/forgot_password_screen.dart';
import '../features/iam/presentation/screen/practitioner_only_screen.dart';
import '../features/iam/presentation/screen/session_expired_screen.dart';
import '../features/iam/presentation/screen/shell_loading_screen.dart';
import '../features/iam/presentation/screen/sign_in_screen.dart';
import '../features/iam/presentation/screen/sign_up_screen.dart';
import '../features/iam/presentation/state/shell_loading_state.dart';
import '../features/main/presentation/cubit/practitioner_shell_cubit.dart';
import '../features/main/presentation/navigation/shell_routes.dart';
import '../features/main/presentation/screen/practitioner_settings_screen.dart';
import '../features/main/presentation/screen/practitioner_shell_screen.dart';
import '../features/main/presentation/screen/sign_out_confirmation_screen.dart';
import '../features/main/presentation/state/practitioner_shell_state.dart';
import '../features/onboarding/presentation/screen/splash_screen.dart';
import '../features/onboarding/presentation/screen/welcome_screen.dart';
import '../features/onboarding/presentation/state/splash_state.dart';
import 'session_gate.dart';

const splashPath = '/';
const welcomePath = '/welcome';
const signUpPath = '/sign-up';
const signInPath = '/sign-in';
const forgotPasswordPath = '/forgot-password';
const shellLoadingPath = '/shell-loading';
const sessionExpiredPath = '/session-expired';

/// Patient accounts land here: this app only serves nutritionists.
const practitionerOnlyPath = '/practitioner-only';

/// Where a resolved practitioner shell lands: the first tab.
const practitionerHomePath = patientsPath;

/// Routes that need a session. Without one (signed out) the redirect sends the person to sign-in.
bool routeRequiresSession(String location) =>
    const {shellLoadingPath, practitionerOnlyPath}.contains(location) ||
    const [
      patientsPath,
      inboxPath,
      agendaPath,
      invitePatientPath,
      '/care-links',
      practitionerSettingsPath,
      signOutConfirmationPath,
    ].any((path) => location == path || location.startsWith('$path/'));

/// Root router. Entering a shell, signing out or the session expiring replaces the whole stack with `go`, so "back"
/// never returns to a screen of another session.
GoRouter createAppRouter(SessionGate gate) => GoRouter(
  refreshListenable: gate,
  redirect: (context, state) {
    final location = state.matchedLocation;
    // The session expired screen takes over from anywhere until the person goes on to sign-in.
    if (gate.hasExpired && location != sessionExpiredPath) return sessionExpiredPath;
    if (gate.isLoggedIn == false && routeRequiresSession(location)) return signInPath;
    return null;
  },
  routes: [
    GoRoute(
      path: splashPath,
      builder: (context, state) => SplashScreen(
        onNavigate: (destination) => context.go(switch (destination) {
          SplashDestination.welcome => welcomePath,
          SplashDestination.shellLoading => shellLoadingPath,
          SplashDestination.sessionExpired => sessionExpiredPath,
        }),
      ),
    ),
    GoRoute(
      path: welcomePath,
      builder: (context, state) => WelcomeScreen(
        onCreateAccount: () => context.push(signUpPath),
        onHaveAccount: () => context.push(signInPath),
      ),
    ),
    GoRoute(
      path: signUpPath,
      builder: (context, state) => SignUpScreen(
        onSignedIn: () => context.go(shellLoadingPath),
        // Sign-up and sign-in replace each other: "back" returns to welcome without stacking them.
        onSignIn: () => context.pushReplacement(signInPath),
      ),
    ),
    GoRoute(
      path: signInPath,
      builder: (context, state) => SignInScreen(
        onSignedIn: () => context.go(shellLoadingPath),
        onCreateAccount: () => context.pushReplacement(signUpPath),
        onForgotPassword: () => context.push(forgotPasswordPath),
      ),
    ),
    GoRoute(
      path: forgotPasswordPath,
      // Reset password -> sign-in: the recovery leaves the stack and sign-in (if it was below) is reused.
      builder: (context, state) => ForgotPasswordScreen(onGoToSignIn: () => context.go(signInPath)),
    ),
    GoRoute(
      path: shellLoadingPath,
      builder: (context, state) => ShellLoadingScreen(
        onNavigate: (destination) => context.go(switch (destination) {
          ShellDestination.practitionerHome => practitionerHomePath,
          ShellDestination.patientNotSupported => practitionerOnlyPath,
        }),
        onNoSession: () => context.go(welcomePath),
      ),
    ),
    GoRoute(
      path: sessionExpiredPath,
      builder: (context, state) => SessionExpiredScreen(
        onSignIn: () {
          gate.acknowledgeExpiry();
          context.go(signInPath);
        },
      ),
    ),
    GoRoute(
      path: practitionerOnlyPath,
      builder: (context, state) => PractitionerOnlyScreen(onSignedOut: () => context.go(signInPath)),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => PractitionerShellScreen(
        navigationShell: navigationShell,
        onOpenSettings: () => context.push(practitionerSettingsPath),
        onSignOut: () => context.push(signOutConfirmationPath),
      ),
      // One branch per `PractitionerTab`, in the same order.
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: patientsPath,
              // `Builder`: the menu button reads the shell's cubit, which lives below this builder's context.
              builder: (context, state) => Builder(
                builder: (context) => PatientRosterScreen(
                  onInvitePatient: () => context.push(invitePatientPath),
                  onOpenPatient: (patient) => context.push(
                    DischargePatientRoute(careLinkId: patient.careLinkId, patientName: patient.fullName).location,
                  ),
                  onOpenMenu: context.read<PractitionerShellCubit>().onOpenMenu,
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: inboxPath,
              builder: (context, state) => const _Placeholder(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: agendaPath,
              builder: (context, state) => const _Placeholder(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: invitePatientPath,
      builder: (context, state) => InvitePatientScreen(onBack: context.pop),
    ),
    GoRoute(
      path: DischargePatientRoute.pathPattern,
      redirect: (context, state) => DischargePatientRoute.tryParse(state) == null ? patientsPath : null,
      builder: (context, state) {
        final route = DischargePatientRoute.tryParse(state)!;
        return DischargePatientScreen(
          careLinkId: route.careLinkId,
          patientName: route.patientName,
          onBack: context.pop,
          onDischarged: (patientName) {
            // Back to the roster with the snackbar; the shell underneath picks the message up.
            getIt<PractitionerShellMessages>().post(PatientDischarged(patientName));
            context.go(patientsPath);
          },
        );
      },
    ),
    GoRoute(
      path: practitionerSettingsPath,
      builder: (context, state) => PractitionerSettingsScreen(
        onBack: context.pop,
        onSignOut: () => context.push(signOutConfirmationPath),
      ),
    ),
    GoRoute(
      path: signOutConfirmationPath,
      builder: (context, state) =>
          SignOutConfirmationScreen(onCancel: context.pop, onSignedOut: () => context.go(signInPath)),
    ),
  ],
);

/// Temporary destination until the tab's own screen lands.
class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: context.colors.surface, child: Center(child: Text(AppLocalizations.of(context).appName)));
}

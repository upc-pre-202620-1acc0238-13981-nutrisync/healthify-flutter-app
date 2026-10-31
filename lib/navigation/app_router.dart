import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/service_locator.dart';
import '../features/carerelationship/presentation/navigation/care_relationship_routes.dart';
import '../features/carerelationship/presentation/screen/discharge_patient_screen.dart';
import '../features/carerelationship/presentation/screen/invite_patient_screen.dart';
import '../features/carerelationship/presentation/screen/patient_roster_screen.dart';
import '../features/foodcatalog/presentation/navigation/food_catalog_routes.dart';
import '../features/foodcatalog/presentation/screen/add_local_food_screen.dart';
import '../features/foodcatalog/presentation/screen/food_catalog_screen.dart';
import '../features/iam/presentation/screen/forgot_password_screen.dart';
import '../features/iam/presentation/screen/practitioner_only_screen.dart';
import '../features/iam/presentation/screen/session_expired_screen.dart';
import '../features/iam/presentation/screen/shell_loading_screen.dart';
import '../features/iam/presentation/screen/sign_in_screen.dart';
import '../features/iam/presentation/screen/sign_up_screen.dart';
import '../features/iam/presentation/state/shell_loading_state.dart';
import '../features/main/presentation/cubit/practitioner_shell_cubit.dart';
import '../features/main/presentation/navigation/shell_routes.dart';
import '../features/main/presentation/navigation/patient_snackbar_request.dart';
import '../features/main/presentation/screen/practitioner_patient_screen.dart';
import '../features/main/presentation/screen/practitioner_settings_screen.dart';
import '../features/main/presentation/screen/practitioner_shell_screen.dart';
import '../features/main/presentation/screen/sign_out_confirmation_screen.dart';
import '../features/main/presentation/state/practitioner_shell_state.dart';
import '../features/monitoring/presentation/navigation/monitoring_routes.dart';
import '../features/monitoring/presentation/screen/practitioner_agenda_screen.dart';
import '../features/monitoring/presentation/screen/record_referral_screen.dart';
import '../features/monitoring/presentation/screen/schedule_follow_up_screen.dart';
import '../features/nutritionalcare/presentation/navigation/nutritional_care_routes.dart';
import '../features/nutritionalcare/presentation/screen/adjust_proposal_screen.dart';
import '../features/nutritionalcare/presentation/screen/baseline_screen.dart';
import '../features/nutritionalcare/presentation/screen/review_inbox_screen.dart';
import '../features/nutritionalcare/presentation/screen/review_item_screen.dart';
import '../features/onboarding/presentation/screen/splash_screen.dart';
import '../features/onboarding/presentation/screen/welcome_screen.dart';
import '../features/onboarding/presentation/state/splash_state.dart';
import 'consultation_routes.dart';
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
      '/review-items',
      ScheduleFollowUpRoute.pathPattern,
      foodCatalogPath,
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
                    PractitionerPatientRoute(
                      patientId: patient.patientId,
                      careLinkId: patient.careLinkId,
                      patientName: patient.fullName,
                    ).location,
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
              builder: (context, state) => Builder(
                builder: (context) => ReviewInboxScreen(
                  onOpenItem: (reviewItemId) => context.push(ReviewItemRoute(reviewItemId: reviewItemId).location),
                  onOpenMenu: context.read<PractitionerShellCubit>().onOpenMenu,
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: agendaPath,
              builder: (context, state) => Builder(
                builder: (context) => PractitionerAgendaScreen(
                  onSchedule: () => context.push(const ScheduleFollowUpRoute().location),
                  onReschedule: (row) => context.push(
                    ScheduleFollowUpRoute(
                      patientId: row.patientId,
                      patientName: row.patientName ?? '',
                      followUpId: row.followUpId,
                      scheduledFor: row.scheduledFor,
                      preparation: row.preparation,
                    ).location,
                  ),
                  onOpenPatient: (patientId, careLinkId, patientName) => context.push(
                    PractitionerPatientRoute(patientId: patientId, careLinkId: careLinkId, patientName: patientName).location,
                  ),
                  onOpenMenu: context.read<PractitionerShellCubit>().onOpenMenu,
                ),
              ),
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
      path: PractitionerPatientRoute.pathPattern,
      redirect: (context, state) => PractitionerPatientRoute.tryParse(state) == null ? patientsPath : null,
      builder: (context, state) {
        final route = PractitionerPatientRoute.tryParse(state)!;
        return PractitionerPatientScreen(
          route: route,
          onBack: context.pop,
          onOpenBaseline: (editing) => context.push<PatientSnackbarRequest>(
            BaselineRoute(patientId: route.patientId, patientName: route.patientName, editing: editing).location,
          ),
          onOpenConsultation: (step) => context.push<PatientSnackbarRequest>(
            ConsultationRoute(patientId: route.patientId, patientName: route.patientName, step: step).location,
          ),
          onSchedule: () => context.push<PatientSnackbarRequest>(
            ScheduleFollowUpRoute(patientId: route.patientId, patientName: route.patientName).location,
          ),
          onReferral: () => context.push<PatientSnackbarRequest>(
            RecordReferralRoute(patientId: route.patientId, patientName: route.patientName).location,
          ),
          onDischarge: () => context.push(
            DischargePatientRoute(careLinkId: route.careLinkId, patientName: route.patientName).location,
          ),
        );
      },
    ),
    GoRoute(
      path: BaselineRoute.pathPattern,
      redirect: (context, state) => BaselineRoute.tryParse(state) == null ? patientsPath : null,
      builder: (context, state) {
        final route = BaselineRoute.tryParse(state)!;
        return BaselineScreen(
          patientId: route.patientId,
          editing: route.editing,
          onBack: context.pop,
          onSaved: context.pop,
          // The baseline hands over to the consultation through the patient file, which opens it: the file stays the
          // screen that gets the result ("Plan published") when the consultation ends.
          onStartConsultation: (step) => context.pop(ContinueToConsultation(step)),
        );
      },
    ),
    GoRoute(
      path: ReviewItemRoute.pathPattern,
      redirect: (context, state) => ReviewItemRoute.tryParse(state) == null ? inboxPath : null,
      builder: (context, state) => ReviewItemScreen(
        reviewItemId: ReviewItemRoute.tryParse(state)!.reviewItemId,
        onBack: context.pop,
        onResolved: (patientName) => _returnToInbox(context, patientName: patientName, resolved: true),
        onClose: () => _returnToInbox(context),
        onOpenAdjust: (reviewItemId) => context.push(AdjustProposalRoute(reviewItemId: reviewItemId).location),
        onOpenPatient: (patientId, careLinkId, patientName) => context.push(
          PractitionerPatientRoute(patientId: patientId, careLinkId: careLinkId, patientName: patientName).location,
        ),
      ),
    ),
    GoRoute(
      path: AdjustProposalRoute.pathPattern,
      redirect: (context, state) => AdjustProposalRoute.tryParse(state) == null ? inboxPath : null,
      builder: (context, state) => AdjustProposalScreen(
        reviewItemId: AdjustProposalRoute.tryParse(state)!.reviewItemId,
        onBack: context.pop,
        onAssigned: (patientName) => _returnToInbox(context, patientName: patientName, resolved: true),
        onClose: () => _returnToInbox(context),
      ),
    ),
    GoRoute(
      path: ScheduleFollowUpRoute.pathPattern,
      builder: (context, state) {
        final route = ScheduleFollowUpRoute.parse(state);
        return ScheduleFollowUpScreen(
          args: (
            patientId: route.patientId,
            patientName: route.patientName,
            followUpId: route.followUpId,
            scheduledFor: route.scheduledFor,
            preparation: route.preparation,
          ),
          onBack: context.pop,
          onScheduled: (scheduledFor, rescheduled) {
            // From the patient file it returns to the file; from the Agenda, to the Agenda tab.
            final fromPatientFile = route.patientId > 0 && route.followUpId == 0;
            if (fromPatientFile) {
              context.pop<PatientSnackbarRequest>(FollowUpScheduled(scheduledFor));
            } else {
              getIt<PractitionerShellMessages>().post(
                AgendaVisitScheduled(scheduledFor: scheduledFor, rescheduled: rescheduled),
              );
              context.go(agendaPath);
            }
          },
        );
      },
    ),
    GoRoute(
      path: RecordReferralRoute.pathPattern,
      redirect: (context, state) => RecordReferralRoute.tryParse(state) == null ? patientsPath : null,
      builder: (context, state) => RecordReferralScreen(
        patientId: RecordReferralRoute.tryParse(state)!.patientId,
        onBack: context.pop,
        onRecorded: (specialty) => context.pop<PatientSnackbarRequest>(ReferralRegistered(specialty)),
      ),
    ),
    consultationRoutes(),
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
      path: foodCatalogPath,
      builder: (context, state) => FoodCatalogScreen(
        onBack: context.pop,
        onAddLocalFood: () => context.push<String>(addLocalFoodPath),
      ),
    ),
    GoRoute(
      path: addLocalFoodPath,
      builder: (context, state) => AddLocalFoodScreen(onBack: context.pop, onAdded: context.pop<String>),
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

/// Back to the Inbox tab, dropping what was opened over it. A resolved item leaves its "Signal resolved" snackbar for the
/// shell underneath; a vanished one just reloads the inbox.
void _returnToInbox(BuildContext context, {String? patientName, bool resolved = false}) {
  if (resolved) getIt<PractitionerShellMessages>().post(SignalResolved(patientName));
  context.go(inboxPath);
}

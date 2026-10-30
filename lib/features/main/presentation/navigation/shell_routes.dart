import 'package:go_router/go_router.dart';

import '../../../../core/designsystem/component/healthify_navigation_bar.dart';

// Practitioner shell tabs (each tab is a branch of the `StatefulShellRoute`).
const patientsPath = '/patients';
const inboxPath = '/inbox';
const agendaPath = '/agenda';

/// Practitioner settings: opened from the main menu (full screen over the shell).
const practitionerSettingsPath = '/settings';

/// Sign out (full screen over the shell).
const signOutConfirmationPath = '/sign-out';

String pathOf(PractitionerTab tab) => switch (tab) {
  PractitionerTab.patients => patientsPath,
  PractitionerTab.inbox => inboxPath,
  PractitionerTab.agenda => agendaPath,
};

/// A practitioner's patient file (Summary, Follow-up, Record and Plan tabs), full screen over the shell. The baseline,
/// plan versions and consultation screens hang from it (`/patients/:patientId/...`).
final class PractitionerPatientRoute {
  const PractitionerPatientRoute({required this.patientId, required this.careLinkId, required this.patientName});

  static const pathPattern = '/patients/:patientId';

  final int patientId;
  final int careLinkId;
  final String patientName;

  String get location => Uri(
    path: '$patientsPath/$patientId',
    queryParameters: {'careLinkId': '$careLinkId', 'patientName': patientName},
  ).toString();

  /// `null` if the URL does not carry valid ids (a hand-typed or stale link).
  static PractitionerPatientRoute? tryParse(GoRouterState state) {
    final patientId = int.tryParse(state.pathParameters['patientId'] ?? '');
    final careLinkId = int.tryParse(state.uri.queryParameters['careLinkId'] ?? '');
    if (patientId == null || patientId <= 0 || careLinkId == null || careLinkId <= 0) return null;
    return PractitionerPatientRoute(
      patientId: patientId,
      careLinkId: careLinkId,
      patientName: state.uri.queryParameters['patientName'] ?? '',
    );
  }
}

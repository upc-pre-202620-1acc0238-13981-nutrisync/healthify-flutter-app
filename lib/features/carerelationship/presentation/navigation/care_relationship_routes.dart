import 'package:go_router/go_router.dart';

/// Generate invitation (full screen over the nutritionist shell).
const invitePatientPath = '/invite-patient';

/// Clinical discharge (from "Discharge" in the patient file).
final class DischargePatientRoute {
  const DischargePatientRoute({required this.careLinkId, required this.patientName});

  static const pathPattern = '/care-links/:careLinkId/discharge';

  final int careLinkId;
  final String patientName;

  String get location => Uri(
    path: '/care-links/$careLinkId/discharge',
    queryParameters: {'patientName': patientName},
  ).toString();

  /// `null` if the URL does not carry a valid care link id.
  static DischargePatientRoute? tryParse(GoRouterState state) {
    final careLinkId = int.tryParse(state.pathParameters['careLinkId'] ?? '');
    if (careLinkId == null || careLinkId <= 0) return null;
    return DischargePatientRoute(
      careLinkId: careLinkId,
      patientName: state.uri.queryParameters['patientName'] ?? '',
    );
  }
}

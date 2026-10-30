import '../../../../core/common/error/result.dart';
import '../../../iam/application/usecase/session_use_cases.dart';
import '../../domain/entity/patient_roster.dart';
import 'practitioner_care_link_use_cases.dart';

/// The roster entry of [patientId] if the signed-in nutritionist has an active care link with them. This is how a screen
/// that only knows a patient id (an inbox item, an agenda visit) gets what the patient file needs (the care link id).
/// `null` = no signed-in user, the patient is not in the roster, or their link is not active.
class FindActiveRosterPatientUseCase {
  const FindActiveRosterPatientUseCase(this._observeCurrentUser, this._getPatientRoster);

  final ObserveCurrentUserUseCase _observeCurrentUser;
  final GetPatientRosterUseCase _getPatientRoster;

  Future<Result<RosterPatient?>> call(int patientId) async {
    final user = await _observeCurrentUser().first;
    if (user == null) return const Result.success(null);
    final roster = await _getPatientRoster(user.id.value);
    return roster.map((roster) {
      for (final patient in roster.patients) {
        if (patient.patientId == patientId && patient.isLinkActive) return patient;
      }
      return null;
    });
  }
}

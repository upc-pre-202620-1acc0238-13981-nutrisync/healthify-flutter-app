import '../../../../core/common/error/result.dart';
import '../entity/patient_monitoring_panel.dart';
import '../valueobject/monitoring_values.dart';

/// A patient's follow-up as seen by their nutritionist. Not stored on the phone.
abstract interface class PractitionerMonitoringRepository {
  /// `GET /patients/{pid}/monitoring-panel?date=&days=`. `403 AccessNotAllowed` without an active care link.
  Future<Result<PatientMonitoringPanel>> getPanel(PatientId patientId, DateTime date, int days);

  /// `GET /patients/{pid}/monitoring-summary`: `429`, `502` and `503` are AI failures.
  Future<Result<MonitoringSummary>> getSummary(PatientId patientId);
}

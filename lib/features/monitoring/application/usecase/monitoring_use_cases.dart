import '../../../../core/common/error/result.dart';
import '../../domain/entity/patient_monitoring_panel.dart';
import '../../domain/repository/monitoring_repositories.dart';
import '../../domain/valueobject/monitoring_values.dart';

const _panelDays = 7;

/// The panel for the last 7 days up to today (the phone's day).
class GetMonitoringPanelUseCase {
  const GetMonitoringPanelUseCase(this._repository, this._now);

  final PractitionerMonitoringRepository _repository;
  final DateTime Function() _now;

  Future<Result<PatientMonitoringPanel>> call(int patientId) {
    final now = _now();
    return _repository.getPanel(PatientId(patientId), DateTime(now.year, now.month, now.day), _panelDays);
  }
}

/// The AI summary (requested in parallel with the panel).
class GetMonitoringSummaryUseCase {
  const GetMonitoringSummaryUseCase(this._repository);

  final PractitionerMonitoringRepository _repository;

  Future<Result<MonitoringSummary>> call(int patientId) => _repository.getSummary(PatientId(patientId));
}

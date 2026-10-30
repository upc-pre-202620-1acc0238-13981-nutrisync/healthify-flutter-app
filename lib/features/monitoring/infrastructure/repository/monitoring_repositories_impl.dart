import '../../../../core/common/error/result.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entity/patient_monitoring_panel.dart';
import '../../domain/repository/monitoring_repositories.dart';
import '../../domain/valueobject/monitoring_values.dart';
import '../mapper/monitoring_mappers.dart';
import '../remote/monitoring_services.dart';

class PractitionerMonitoringRepositoryImpl implements PractitionerMonitoringRepository {
  const PractitionerMonitoringRepositoryImpl(this._service);

  final PractitionerMonitoringService _service;

  @override
  Future<Result<PatientMonitoringPanel>> getPanel(PatientId patientId, DateTime date, int days) =>
      apiCall(() async => (await _service.getPanel(patientId.value, date, days)).toDomain());

  @override
  Future<Result<MonitoringSummary>> getSummary(PatientId patientId) =>
      apiCall(() async => (await _service.getSummary(patientId.value)).toDomain());
}

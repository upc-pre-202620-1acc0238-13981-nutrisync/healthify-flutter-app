import '../../../../core/network/api_client.dart';
import '../../../../core/network/iso_dates.dart';
import 'dto/monitoring_dtos.dart';

/// A patient's follow-up for their nutritionist.
class PractitionerMonitoringService {
  const PractitionerMonitoringService(this._api);

  final ApiClient _api;

  Future<PatientMonitoringPanelDto> getPanel(int patientId, DateTime date, int days) async =>
      PatientMonitoringPanelDto.fromJson(
        await _api.get('patients/$patientId/monitoring-panel', query: {'date': toIsoDate(date), 'days': days})
            as Map<String, dynamic>,
      );

  /// No range: the 7 days up to yesterday.
  Future<MonitoringSummaryDto> getSummary(int patientId) async =>
      MonitoringSummaryDto.fromJson(await _api.get('patients/$patientId/monitoring-summary') as Map<String, dynamic>);
}

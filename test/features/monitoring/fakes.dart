import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/monitoring/domain/entity/patient_monitoring_panel.dart';
import 'package:healthify/features/monitoring/domain/repository/monitoring_repositories.dart';
import 'package:healthify/features/monitoring/domain/valueobject/monitoring_values.dart';

PatientMonitoringPanel panel({List<PanelDiaryEntry> diary = const []}) => PatientMonitoringPanel(
  date: DateTime(2026, 10, 7),
  week: PanelWeek(
    days: [
      for (var i = 0; i < 7; i++)
        PanelDay(
          DateTime(2026, 9, 28 + i),
          const [
            ComplianceOutcome.met,
            ComplianceOutcome.met,
            ComplianceOutcome.met,
            ComplianceOutcome.short,
            ComplianceOutcome.met,
            ComplianceOutcome.unlogged,
            ComplianceOutcome.exceeded,
          ][i],
        ),
    ],
    metDays: 4,
    totalDays: 7,
  ),
  loggedDays: DaysRatio(6, 7),
  weightTrend: const PanelWeightTrend(4, -0.3),
  diary: diary,
  lastClinicalMeasurement: PanelClinicalMeasurement(
    takenAt: DateTime.utc(2026, 9, 3, 15),
    weightKg: 74.2,
    protocolChecks: const [PanelProtocolCheck.fasting, PanelProtocolCheck.noShoes],
  ),
);

class FakePractitionerMonitoringRepository implements PractitionerMonitoringRepository {
  Result<PatientMonitoringPanel> panelResult = Result.success(panel());
  Result<MonitoringSummary> summaryResult = const Result.success(MonitoringSummary('Cumple casi todos los días.'));
  final panelRequests = <(int, DateTime, int)>[];
  int panelCalls = 0;

  @override
  Future<Result<PatientMonitoringPanel>> getPanel(PatientId patientId, DateTime date, int days) async {
    panelCalls++;
    panelRequests.add((patientId.value, date, days));
    return panelResult;
  }

  @override
  Future<Result<MonitoringSummary>> getSummary(PatientId patientId) async => summaryResult;
}

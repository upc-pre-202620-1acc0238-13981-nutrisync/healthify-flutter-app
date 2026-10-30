import '../../../../core/network/iso_dates.dart';
import '../../domain/entity/patient_monitoring_panel.dart';
import '../../domain/valueobject/monitoring_values.dart';
import '../remote/dto/monitoring_dtos.dart';

extension PatientMonitoringPanelMapper on PatientMonitoringPanelDto {
  /// Each section is read separately: an unreadable one stays empty and the rest of the panel is shown.
  PatientMonitoringPanel toDomain() => PatientMonitoringPanel(
    date: parseLocalDateOrNull(date) ?? (throw const FormatException('Unreadable panel date')),
    week: _week(week),
    loggedDays: loggedDays != null && loggedDays!.logged >= 0 && loggedDays!.logged <= loggedDays!.totalDays
        ? DaysRatio(loggedDays!.logged, loggedDays!.totalDays)
        : null,
    weightTrend: weightTrendSummary == null
        ? null
        : PanelWeightTrend(weightTrendSummary!.weeks, weightTrendSummary!.slopeKgPerWeek),
    diary: [for (final entry in diary) ?_entry(entry)]..sort((a, b) => a.localTimestamp.compareTo(b.localTimestamp)),
    lastClinicalMeasurement: _measurement(lastClinicalMeasurement),
  );

  static PanelWeek? _week(PanelWeekDto? dto) {
    if (dto == null) return null;
    final days = <PanelDay>[
      for (final day in dto.days)
        // An unknown outcome is never drawn as a failure: it reads as "No log".
        if (parseLocalDateOrNull(day.date) case final date?)
          PanelDay(date, ComplianceOutcome.fromCode(day.outcome) ?? ComplianceOutcome.unlogged),
    ]..sort((a, b) => a.date.compareTo(b.date));
    return dto.metDays >= 0 && dto.metDays <= dto.totalDays
        ? PanelWeek(days: days, metDays: dto.metDays, totalDays: dto.totalDays)
        : null;
  }

  static PanelDiaryEntry? _entry(PanelDiaryEntryDto dto) {
    final at = parseInstantOrNull(dto.localTimestamp);
    if (at == null) return null;
    final provenance = PanelEntryProvenance.fromCode(dto.provenance) ?? PanelEntryProvenance.manual;
    final name = dto.confirmedFoodName ?? dto.foodName ?? dto.proposedFoodName;
    return PanelDiaryEntry(
      id: dto.diaryEntryId,
      localTimestamp: at,
      foodName: name != null && name.trim().isNotEmpty ? name : null,
      grams: dto.confirmedPortionGrams ?? dto.proposedPortionGrams,
      provenance: provenance,
      isAwaitingConfirmation:
          provenance == PanelEntryProvenance.photo && dto.confirmedAt == null && dto.confirmedPortionGrams == null,
    );
  }

  static PanelClinicalMeasurement? _measurement(PanelClinicalMeasurementDto? dto) {
    final takenAt = dto == null ? null : parseInstantOrNull(dto.takenAt);
    if (dto == null || takenAt == null) return null;
    return PanelClinicalMeasurement(
      takenAt: takenAt,
      weightKg: dto.weightKg,
      protocolChecks: dto.protocolChecks.map(PanelProtocolCheck.fromCode).nonNulls.toList(),
    );
  }
}

extension MonitoringSummaryMapper on MonitoringSummaryDto {
  MonitoringSummary toDomain() => MonitoringSummary(text != null && text!.trim().isNotEmpty ? text!.trim() : null);
}

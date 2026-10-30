import '../valueobject/monitoring_values.dart';

/// `PatientMonitoringPanelResource`: the practitioner's Follow-up tab. **Read-only**: the practitioner never writes or
/// corrects the diary. It does not carry the consistency index (Patient First).
final class PatientMonitoringPanel {
  const PatientMonitoringPanel({
    required this.date,
    required this.diary,
    this.week,
    this.loggedDays,
    this.weightTrend,
    this.lastClinicalMeasurement,
  });

  final DateTime date;
  final PanelWeek? week;
  final DaysRatio? loggedDays;
  final PanelWeightTrend? weightTrend;
  final List<PanelDiaryEntry> diary;
  final PanelClinicalMeasurement? lastClinicalMeasurement;
}

/// "This week": one outcome per day. [ComplianceOutcome.unlogged] is shown separately ("No log"), never as "Below" or
/// as non-compliance.
final class PanelWeek {
  /// Throws [ArgumentError] if the met days are outside `0..totalDays`.
  PanelWeek({required this.days, required this.metDays, required this.totalDays}) {
    if (metDays < 0 || metDays > totalDays) throw ArgumentError('Met days cannot exceed the total');
  }

  final List<PanelDay> days;
  final int metDays;
  final int totalDays;
}

final class PanelDay {
  const PanelDay(this.date, this.outcome);

  final DateTime date;
  final ComplianceOutcome outcome;
}

/// "Logging · 6 of 7 days".
final class DaysRatio {
  /// Throws [ArgumentError] if the count is outside `0..total`.
  DaysRatio(this.count, this.total) {
    if (count < 0 || count > total) throw ArgumentError('Count cannot exceed the total');
  }

  final int count;
  final int total;
}

/// "Weight trend · −0.3 kg/wk · Self-weighing · 4 weeks". Never a single day's weight.
final class PanelWeightTrend {
  const PanelWeightTrend(this.weeks, this.slopeKgPerWeek);

  final int weeks;
  final double? slopeKgPerWeek;
}

/// Source of a diary entry.
enum PanelEntryProvenance {
  photo('Photo'),
  manual('Manual'),
  offPlan('OffPlan');

  const PanelEntryProvenance(this.code);

  final String code;

  static PanelEntryProvenance? fromCode(String? code) {
    for (final provenance in values) {
      if (provenance.code.toLowerCase() == code?.toLowerCase()) return provenance;
    }
    return null;
  }
}

/// An entry of "Today's diary" (read-only). [foodName] is the catalog name; it may be missing.
final class PanelDiaryEntry {
  const PanelDiaryEntry({
    required this.id,
    required this.localTimestamp,
    required this.provenance,
    required this.isAwaitingConfirmation,
    this.foodName,
    this.grams,
  });

  final int id;
  final DateTime localTimestamp;
  final String? foodName;
  final double? grams;
  final PanelEntryProvenance provenance;
  final bool isAwaitingConfirmation;
}

/// Checkboxes of the clinical measurement protocol.
enum PanelProtocolCheck {
  fasting('Fasting'),
  noShoes('NoShoes'),
  lightClothing('LightClothing'),
  emptyBladder('EmptyBladder'),
  sameScale('SameScale');

  const PanelProtocolCheck(this.code);

  final String code;

  static PanelProtocolCheck? fromCode(String? code) {
    for (final check in values) {
      if (check.code.toLowerCase() == code?.toLowerCase()) return check;
    }
    return null;
  }
}

/// "Last clinical measurement · Sep 3 · fasting, no shoes · 74.2 kg" (clinical series, apart from self-weighing).
final class PanelClinicalMeasurement {
  const PanelClinicalMeasurement({required this.takenAt, required this.weightKg, required this.protocolChecks});

  final DateTime takenAt;
  final double weightKg;
  final List<PanelProtocolCheck> protocolChecks;
}

/// "AI-generated summary · Review it before using it in a visit". Without the patient's AI consent or with the feature
/// off, the backend sends only the data: [text] is `null` and the card is hidden.
final class MonitoringSummary {
  const MonitoringSummary(this.text);

  final String? text;

  bool get hasText => text != null && text!.trim().isNotEmpty;
}

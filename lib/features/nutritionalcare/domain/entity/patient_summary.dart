import '../valueobject/clinical_codes.dart';
import '../valueobject/clinical_values.dart';

/// `PatientSummaryResource`: the Summary tab. `baseline == null` means there is no baseline yet; a non-null
/// [consultationInProgress] means a consultation is in progress.
final class PatientSummary {
  const PatientSummary({
    required this.patientId,
    required this.isLinkActive,
    required this.sinceLastConsultation,
    this.fullName,
    this.linkedSince,
    this.activePlanVersion,
    this.baseline,
    this.nextFollowUp,
    this.consultationInProgress,
  });

  final int patientId;
  final String? fullName;
  final DateTime? linkedSince;
  final bool isLinkActive;
  final int? activePlanVersion;
  final BaselineSummary? baseline;
  final SummaryFollowUp? nextFollowUp;
  final ConsultationInProgress? consultationInProgress;
  final SinceLastConsultation sinceLastConsultation;

  bool get hasBaseline => baseline != null;

  /// "New": no baseline or no published plan (same rule as the caseload).
  bool get isNew => baseline == null || activePlanVersion == null;
}

/// What the summary gets from the baseline ("Woman · 31 years · 168 cm · hypothyroidism").
final class BaselineSummary {
  const BaselineSummary({required this.sex, required this.ageYears, required this.heightCm, required this.conditions});

  final BiologicalSex? sex;
  final int ageYears;
  final double heightCm;
  final Set<MedicalCondition> conditions;
}

/// The summary's "Next consultation".
final class SummaryFollowUp {
  const SummaryFollowUp(this.followUpId, this.scheduledFor);

  final int followUpId;
  final DateTime scheduledFor;
}

/// "Consultation in progress · Step 1 of 4 · Today's measurement · saved today".
final class ConsultationInProgress {
  const ConsultationInProgress({required this.id, required this.step, required this.lastSavedAt});

  final ConsultationId id;
  final ConsultationStep step;
  final DateTime lastSavedAt;
}

/// "SINCE THE LAST CONSULTATION": slope of the self-weigh-in trend (never a single day's weight, ethics rule 6) and
/// days within targets over calendar days (a day without logs is not a miss: it just does not add up).
final class SinceLastConsultation {
  const SinceLastConsultation({
    required this.fromDate,
    required this.trendWeeks,
    this.weightSlopeKgPerWeek,
    this.compliance,
  });

  final DateTime fromDate;
  final double? weightSlopeKgPerWeek;
  final int trendWeeks;
  final ComplianceRatio? compliance;
}

final class ComplianceRatio {
  /// Throws [ArgumentError] if the met days exceed the total.
  ComplianceRatio(this.met, this.total) {
    if (met < 0 || total < 0 || met > total) throw ArgumentError('Met days cannot exceed the total');
  }

  final int met;
  final int total;
}

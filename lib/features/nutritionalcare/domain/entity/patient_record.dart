import '../valueobject/clinical_codes.dart';
import 'consultation.dart';
import 'patient_summary.dart';

/// `PractitionerPatientRecordResource`: what the Record tab shows. It includes the **active diagnosis**, which is
/// practitioner-only. Any section can be missing if its context did not respond.
final class PractitionerPatientRecord {
  const PractitionerPatientRecord({
    this.clinicalWeight,
    this.bmi,
    this.activeTargets,
    this.compliance,
    this.activeDiagnosis,
    this.referrals = const [],
    this.evaluations = const [],
  });

  final ClinicalWeightSummary? clinicalWeight;
  final RecordBmi? bmi;
  final RecordActiveTargets? activeTargets;
  final RecordComplianceWindow? compliance;
  final RecordDiagnosis? activeDiagnosis;
  final List<ReferralSummary> referrals;

  /// Newest first.
  final List<RecordEvaluation> evaluations;
}

final class ClinicalWeightSummary {
  const ClinicalWeightSummary({
    required this.latestKg,
    required this.latestDate,
    required this.deltaKgSinceFirst,
    required this.firstDate,
  });

  final double latestKg;
  final DateTime latestDate;
  final double deltaKgSinceFirst;
  final DateTime firstDate;
}

final class RecordBmi {
  const RecordBmi(this.value, this.category);

  final double value;
  final DiagnosisCode? category;
}

final class RecordActiveTargets {
  const RecordActiveTargets({required this.planVersion, required this.validFrom, required this.energyKcal});

  final int planVersion;
  final DateTime validFrom;
  final double energyKcal;
}

final class RecordComplianceWindow {
  const RecordComplianceWindow({required this.from, required this.to, required this.ratio});

  final DateTime from;
  final DateTime to;
  final ComplianceRatio ratio;
}

/// "Overweight class I · Mar 3, 2026 · practitioner only". `code == null`: a diagnosis older than the closed list.
final class RecordDiagnosis {
  const RecordDiagnosis({required this.code, required this.statement, required this.issuedAt});

  final DiagnosisCode? code;
  final String statement;
  final DateTime issuedAt;
}

/// Specialty and reason are the practitioner's text; they are not translated.
final class ReferralSummary {
  const ReferralSummary({
    required this.id,
    required this.specialty,
    required this.issuedAt,
    required this.isOpen,
    this.reason = '',
    this.closedAt,
  });

  final int id;
  final String specialty;
  final DateTime issuedAt;
  final bool isOpen;
  final String reason;
  final DateTime? closedAt;
}

/// "Sep 3, 2026 · 74.2 kg · BMI 26.3 · waist 88 cm" / "… · first assessment".
final class RecordEvaluation {
  const RecordEvaluation({
    required this.assessmentId,
    required this.takenAt,
    required this.weightKg,
    required this.bmi,
    required this.isFirst,
    this.waistCm,
  });

  final int assessmentId;
  final DateTime takenAt;
  final double weightKg;
  final double bmi;
  final double? waistCm;
  final bool isFirst;
}

/// Detail of a record assessment (`GET nutritional-assessments/{id}`, only for the practitioner who recorded it): the
/// assessment's latest measurement, with the baseline at that time.
final class EvaluationDetail {
  const EvaluationDetail({
    required this.assessmentId,
    required this.takenAt,
    required this.measurement,
    required this.bmiCategory,
  });

  final int assessmentId;
  final DateTime takenAt;
  final ConsultationMeasurement measurement;
  final DiagnosisCode? bmiCategory;
}

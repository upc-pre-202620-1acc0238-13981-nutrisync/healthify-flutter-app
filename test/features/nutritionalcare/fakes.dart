import 'dart:async';

import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_baseline.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_record.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/patient_summary.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_history.dart';
import 'package:healthify/features/nutritionalcare/domain/repository/practitioner_care_repositories.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';

export 'consultation_fakes.dart';

PatientBaseline baseline({
  DateTime? birthDate,
  int ageYears = 31,
  BiologicalSex sex = BiologicalSex.female,
  double heightCm = 168,
  Set<MedicalCondition> conditions = const {MedicalCondition.hypothyroidism},
}) => PatientBaseline(
  birthDate: birthDate ?? DateTime(1995, 2, 15),
  ageYears: ageYears,
  sex: sex,
  heightCm: heightCm,
  conditions: conditions,
);

PatientSummary summary({
  String? fullName = 'Ana Flores',
  int? activePlanVersion = 3,
  bool withBaseline = true,
  ConsultationInProgress? inProgress,
  SummaryFollowUp? nextFollowUp,
}) => PatientSummary(
  patientId: 7,
  fullName: fullName,
  linkedSince: DateTime.utc(2026, 3, 12, 15),
  isLinkActive: true,
  activePlanVersion: activePlanVersion,
  baseline: withBaseline
      ? const BaselineSummary(
          sex: BiologicalSex.female,
          ageYears: 31,
          heightCm: 168,
          conditions: {MedicalCondition.hypothyroidism},
        )
      : null,
  nextFollowUp: nextFollowUp,
  consultationInProgress: inProgress,
  sinceLastConsultation: SinceLastConsultation(
    fromDate: DateTime(2026, 9, 30),
    weightSlopeKgPerWeek: -0.3,
    trendWeeks: 4,
    compliance: ComplianceRatio(5, 7),
  ),
);

PlanHistory planHistory({bool withActive = true}) => PlanHistory.of([
  NutritionPlanVersion(
    version: 3,
    isActive: withActive,
    publishedAt: DateTime.utc(2026, 9, 4, 15),
    targets: Targets(energyKcal: 1796, proteinG: 119, carbG: 195, fatG: 60),
    guidelines: const [CatalogGuideline(PlanGuidelineCode.prioritizeVegetables), CustomGuideline('Caminar 20 minutos')],
    restrictions: const [CatalogRestriction(PlanRestrictionCode.shellfishFree)],
    patientMessage: 'Vamos muy bien.',
  ),
  NutritionPlanVersion(
    version: 2,
    isActive: false,
    publishedAt: DateTime.utc(2026, 6, 12, 15),
    targets: Targets(energyKcal: 1850, proteinG: 110, carbG: 210, fatG: 62),
  ),
]);

class FakePatientSummaryRepository implements PatientSummaryRepository {
  Result<PatientSummary> result = Result.success(summary());
  Completer<Result<PatientSummary>>? gate;
  int calls = 0;

  @override
  Future<Result<PatientSummary>> getSummary(PatientId patientId) async {
    calls++;
    final pending = gate;
    if (pending != null) {
      gate = null;
      return pending.future;
    }
    return result;
  }
}

class FakePatientBaselineRepository implements PatientBaselineRepository {
  Result<PatientBaseline?> getResult = const Result.success(null);
  Result<PatientBaseline> recordResult = Result.success(baseline());
  Result<PatientBaseline> updateResult = Result.success(baseline());
  final calls = <String>[];
  final sent = <NewBaseline>[];

  @override
  Future<Result<PatientBaseline?>> get(PatientId patientId) async {
    calls.add('get');
    return getResult;
  }

  @override
  Future<Result<PatientBaseline>> record(PatientId patientId, NewBaseline value) async {
    calls.add('record');
    sent.add(value);
    return recordResult;
  }

  @override
  Future<Result<PatientBaseline>> update(PatientId patientId, NewBaseline value) async {
    calls.add('update');
    sent.add(value);
    return updateResult;
  }
}

class FakeNutritionPlanRepository implements NutritionPlanRepository {
  Result<PlanHistory> result = Result.success(planHistory());
  int calls = 0;

  @override
  Future<Result<PlanHistory>> getHistory(PatientId patientId) async {
    calls++;
    return result;
  }
}

PractitionerPatientRecord practitionerRecord({
  bool withEvaluations = true,
  List<ReferralSummary> referrals = const [],
}) => PractitionerPatientRecord(
  clinicalWeight: ClinicalWeightSummary(
    latestKg: 74.2,
    latestDate: DateTime.utc(2026, 9, 3, 15),
    deltaKgSinceFirst: -1.8,
    firstDate: DateTime.utc(2026, 3, 3, 15),
  ),
  bmi: const RecordBmi(26.3, DiagnosisCode.overweightGradeI),
  activeTargets: RecordActiveTargets(planVersion: 3, validFrom: DateTime.utc(2026, 9, 4, 15), energyKcal: 1796),
  compliance: RecordComplianceWindow(
    from: DateTime(2026, 9, 30),
    to: DateTime(2026, 10, 6),
    ratio: ComplianceRatio(5, 7),
  ),
  activeDiagnosis: RecordDiagnosis(
    code: DiagnosisCode.overweightGradeI,
    statement: '',
    issuedAt: DateTime.utc(2026, 3, 3, 15),
  ),
  referrals: referrals,
  evaluations: withEvaluations
      ? [
          RecordEvaluation(
            assessmentId: 2,
            takenAt: DateTime.utc(2026, 9, 3, 15),
            weightKg: 74.2,
            bmi: 26.3,
            waistCm: 88,
            isFirst: false,
          ),
          RecordEvaluation(
            assessmentId: 1,
            takenAt: DateTime.utc(2026, 3, 3, 15),
            weightKg: 76,
            bmi: 26.9,
            waistCm: 90,
            isFirst: true,
          ),
        ]
      : const [],
);

EvaluationDetail evaluationDetail() => EvaluationDetail(
  assessmentId: 2,
  takenAt: DateTime.utc(2026, 9, 3, 15),
  bmiCategory: DiagnosisCode.overweightGradeI,
  measurement: ConsultationMeasurement(
    weightKg: 74.2,
    heightCm: 168,
    waistCm: 88,
    bodyFatPercentage: 27,
    bmi: 26.3,
    protocolChecks: const {ProtocolCheck.fasting},
    activityLevel: ActivityLevel.light,
    habits: EatingHabits(mealsPerDay: 4, waterLitersPerDay: 1.5, mealsOutPerWeek: 2),
    ageYears: 31,
    sex: BiologicalSex.female,
  ),
);

class FakePractitionerRecordRepository implements PractitionerRecordRepository {
  Result<PractitionerPatientRecord> recordResult = Result.success(practitionerRecord());
  Result<EvaluationDetail> evaluationResult = Result.success(evaluationDetail());
  Completer<Result<EvaluationDetail>>? evaluationGate;
  int recordCalls = 0;
  final evaluationsRequested = <int>[];

  @override
  Future<Result<PractitionerPatientRecord>> getRecord(PatientId patientId) async {
    recordCalls++;
    return recordResult;
  }

  @override
  Future<Result<EvaluationDetail>> getEvaluation(int assessmentId) {
    evaluationsRequested.add(assessmentId);
    return evaluationGate?.future ?? Future.value(evaluationResult);
  }
}

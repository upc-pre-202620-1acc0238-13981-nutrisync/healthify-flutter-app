import '../../../../core/common/error/result.dart';
import '../entity/consultation.dart';
import '../entity/consultation_commands.dart';
import '../entity/patient_baseline.dart';
import '../entity/patient_record.dart';
import '../entity/patient_summary.dart';
import '../entity/plan_history.dart';
import '../valueobject/clinical_values.dart';

// Nutritionist side of NutritionalCare. None of this is stored on the phone: the caseload and patient data are not
// available offline.

/// `/patients/{pid}/baseline`.
abstract interface class PatientBaselineRepository {
  /// `null` if the patient has no baseline yet (`404 BaselineNotFound`).
  Future<Result<PatientBaseline?>> get(PatientId patientId);

  /// `POST` (first time). `409 BaselineAlreadyRecorded` if it already existed.
  Future<Result<PatientBaseline>> record(PatientId patientId, NewBaseline baseline);

  /// `PUT` (edit).
  Future<Result<PatientBaseline>> update(PatientId patientId, NewBaseline baseline);
}

/// The practitioner's view of the patient record (`GET /patients/{pid}/record`) and one of its assessments.
abstract interface class PractitionerRecordRepository {
  Future<Result<PractitionerPatientRecord>> getRecord(PatientId patientId);

  /// `GET /nutritional-assessments/{id}`: `403` if it was recorded by someone else, `404` if missing.
  Future<Result<EvaluationDetail>> getEvaluation(int assessmentId);
}

/// `GET /patients/{pid}/summary`.
abstract interface class PatientSummaryRepository {
  Future<Result<PatientSummary>> getSummary(PatientId patientId);
}

/// `GET /patients/{pid}/nutrition-plans` (published versions only).
abstract interface class NutritionPlanRepository {
  Future<Result<PlanHistory>> getHistory(PatientId patientId);
}

/// The 4-step guided consultation. Each saved step returns the up-to-date consultation.
abstract interface class ConsultationRepository {
  /// `POST /patients/{pid}/consultations`. `409 ConsultationAlreadyInProgress` if one exists (it is resumed) and
  /// `422 BaselineRequired` without a baseline.
  Future<Result<Consultation>> start(PatientId patientId, int? scheduledFollowUpId);

  /// `GET /patients/{pid}/consultations/in-progress`; `null` if there is none (404).
  Future<Result<Consultation?>> getInProgress(PatientId patientId);

  /// Step 1 · `PUT /consultations/{id}/measurement`.
  Future<Result<Consultation>> recordMeasurement(ConsultationId id, NewMeasurement measurement);

  /// Step 2 · `POST /consultations/{id}/diagnosis-suggestion` (never empty: without AI, the BMI rule).
  Future<Result<DiagnosisSuggestion>> suggestDiagnosis(ConsultationId id);

  /// Step 2 · `PUT /consultations/{id}/diagnosis`.
  Future<Result<Consultation>> issueDiagnosis(ConsultationId id, DiagnosisChoice choice);

  /// Step 3 · `POST /consultations/{id}/target-proposal`: [parameters] `null` = the default parameters.
  Future<Result<TargetProposal>> proposeTargets(ConsultationId id, TargetParameters? parameters);

  /// Step 3 · `PUT /consultations/{id}/targets`.
  Future<Result<Consultation>> prescribeTargets(ConsultationId id, TargetPrescription prescription);

  /// Step 4 · `POST /consultations/{id}/guideline-suggestions` (AI, or the fixed table).
  Future<Result<GuidelineSuggestions>> suggestGuidelines(ConsultationId id);

  /// Step 4 · `PUT /consultations/{id}/publication-draft`.
  Future<Result<Consultation>> saveDraft(ConsultationId id, Publication publication);

  /// Step 4 · `POST /consultations/{id}/publication` with `Idempotency-Key`: repeating it with the same key after a
  /// timeout returns the same result and never publishes a second version ("Try again").
  Future<Result<Consultation>> publish(ConsultationId id, Publication publication, IdempotencyKey idempotencyKey);

  /// `DELETE /consultations/{id}`: discards the in-progress consultation. What was already saved (the measurement)
  /// stays as history; the current diagnosis and plan do not change.
  Future<Result<void>> discard(ConsultationId id);
}

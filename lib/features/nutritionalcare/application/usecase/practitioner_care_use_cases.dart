import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/error/result.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/entity/patient_baseline.dart';
import '../../domain/entity/patient_record.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/repository/practitioner_care_repositories.dart';
import '../../domain/valueobject/clinical_values.dart';

const _baselineAlreadyRecorded = 'BaselineAlreadyRecorded';
const _consultationAlreadyInProgress = 'ConsultationAlreadyInProgress';
const _consultationNotFound = 'ConsultationNotFound';

/// The patient summary.
class GetPatientSummaryUseCase {
  const GetPatientSummaryUseCase(this._repository);

  final PatientSummaryRepository _repository;

  Future<Result<PatientSummary>> call(int patientId) => _repository.getSummary(PatientId(patientId));
}

/// The patient record as the practitioner sees it, including the active diagnosis.
class GetPractitionerRecordUseCase {
  const GetPractitionerRecordUseCase(this._repository);

  final PractitionerRecordRepository _repository;

  Future<Result<PractitionerPatientRecord>> call(int patientId) => _repository.getRecord(PatientId(patientId));
}

/// One record assessment, when tapped.
class GetEvaluationDetailUseCase {
  const GetEvaluationDetailUseCase(this._repository);

  final PractitionerRecordRepository _repository;

  Future<Result<EvaluationDetail>> call(int assessmentId) => _repository.getEvaluation(assessmentId);
}

/// The plan history (published versions, newest first).
class GetPlanHistoryUseCase {
  const GetPlanHistoryUseCase(this._repository);

  final NutritionPlanRepository _repository;

  Future<Result<PlanHistory>> call(int patientId) => _repository.getHistory(PatientId(patientId));
}

/// The saved baseline (`null` = none yet).
class GetPatientBaselineUseCase {
  const GetPatientBaselineUseCase(this._repository);

  final PatientBaselineRepository _repository;

  Future<Result<PatientBaseline?>> call(int patientId) => _repository.get(PatientId(patientId));
}

/// "Save...": records the baseline the first time and edits it afterwards. If recording returns that it already
/// existed (`409 BaselineAlreadyRecorded`, e.g. from another phone), it is saved as an edit.
class SavePatientBaselineUseCase {
  const SavePatientBaselineUseCase(this._repository);

  final PatientBaselineRepository _repository;

  Future<Result<PatientBaseline>> call(int patientId, NewBaseline baseline, {required bool alreadyRecorded}) async {
    final id = PatientId(patientId);
    if (alreadyRecorded) return _repository.update(id, baseline);
    final recorded = await _repository.record(id, baseline);
    return recorded.errorOrNull == const Conflict(_baselineAlreadyRecorded)
        ? _repository.update(id, baseline)
        : recorded;
  }
}

/// "New consultation" / "Continue consultation": starts the consultation or, if one is already in progress
/// (`409 ConsultationAlreadyInProgress`), resumes it. A patient never has two open consultations.
class StartOrResumeConsultationUseCase {
  const StartOrResumeConsultationUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<Consultation>> call(int patientId, {int? scheduledFollowUpId}) async {
    final id = PatientId(patientId);
    final started = await _repository.start(id, scheduledFollowUpId);
    if (started.errorOrNull != const Conflict(_consultationAlreadyInProgress)) return started;
    final inProgress = await _repository.getInProgress(id);
    final error = inProgress.errorOrNull;
    if (error != null) return Result.failure(error);
    final consultation = inProgress.valueOrNull;
    return consultation == null ? const Result.failure(NotFound(_consultationNotFound)) : Result.success(consultation);
  }
}

/// The consultation in progress, to decide between "New consultation" and "Continue consultation". `null` if none is
/// in progress anymore (it was published or discarded).
class GetConsultationInProgressUseCase {
  const GetConsultationInProgressUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<Consultation?>> call(int patientId) => _repository.getInProgress(PatientId(patientId));
}

/// "Continue to diagnosis".
class RecordConsultationMeasurementUseCase {
  const RecordConsultationMeasurementUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<Consultation>> call(ConsultationId consultationId, NewMeasurement measurement) =>
      _repository.recordMeasurement(consultationId, measurement);
}

/// The suggestion (AI, or the BMI rule).
class SuggestDiagnosisUseCase {
  const SuggestDiagnosisUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<DiagnosisSuggestion>> call(ConsultationId consultationId) => _repository.suggestDiagnosis(consultationId);
}

/// "Continue to targets".
class IssueConsultationDiagnosisUseCase {
  const IssueConsultationDiagnosisUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<Consultation>> call(ConsultationId consultationId, DiagnosisChoice choice) =>
      _repository.issueDiagnosis(consultationId, choice);
}

/// Calculates (or recalculates with "Change parameters") the target proposal.
class ProposeConsultationTargetsUseCase {
  const ProposeConsultationTargetsUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<TargetProposal>> call(ConsultationId consultationId, [TargetParameters? parameters]) =>
      _repository.proposeTargets(consultationId, parameters);
}

/// "Accept targets" / "Enter my own values" (reason required).
class PrescribeConsultationTargetsUseCase {
  const PrescribeConsultationTargetsUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<Consultation>> call(ConsultationId consultationId, TargetPrescription prescription) =>
      _repository.prescribeTargets(consultationId, prescription);
}

/// The suggested guidelines (AI, or the fixed table).
class SuggestGuidelinesUseCase {
  const SuggestGuidelinesUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<GuidelineSuggestions>> call(ConsultationId consultationId) => _repository.suggestGuidelines(consultationId);
}

/// Saves the draft so the choices survive even if the app is closed.
class SavePublicationDraftUseCase {
  const SavePublicationDraftUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<Consultation>> call(ConsultationId consultationId, Publication publication) =>
      _repository.saveDraft(consultationId, publication);
}

/// "Publish and close consultation". The caller keeps [idempotencyKey] and reuses it on "Try again": the backend
/// returns the same result and never publishes two versions.
class PublishConsultationUseCase {
  const PublishConsultationUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<Consultation>> call(
    ConsultationId consultationId,
    Publication publication,
    IdempotencyKey idempotencyKey,
  ) => _repository.publish(consultationId, publication, idempotencyKey);
}

/// "Delete consultation" (opened by mistake): discards the in-progress consultation.
class DiscardConsultationUseCase {
  const DiscardConsultationUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<void>> call(ConsultationId consultationId) => _repository.discard(consultationId);
}

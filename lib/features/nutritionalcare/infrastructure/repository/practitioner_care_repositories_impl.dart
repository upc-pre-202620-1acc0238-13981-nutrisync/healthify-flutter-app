import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/error/result.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/entity/patient_baseline.dart';
import '../../domain/entity/patient_record.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/repository/practitioner_care_repositories.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../mapper/practitioner_care_mappers.dart';
import '../remote/dto/consultation_dtos.dart';
import '../remote/practitioner_care_services.dart';

// Mappers run inside `apiCall`: a resource that breaks a domain invariant (e.g. targets at 0) reads as an unreadable
// response, same as broken JSON, instead of crashing the app.

extension on Result<Object?> {
  /// A 404 with [code] means "nothing yet" (`null`), not an error.
  Result<T?> notFoundAsNull<T extends Object>(String code) {
    if (errorOrNull == NotFound(code)) return const Result.success(null);
    return map((value) => value as T?);
  }
}

class PatientBaselineRepositoryImpl implements PatientBaselineRepository {
  const PatientBaselineRepositoryImpl(this._service);

  final PatientBaselineService _service;

  @override
  Future<Result<PatientBaseline?>> get(PatientId patientId) async =>
      (await apiCall<PatientBaseline?>(
        () async => (await _service.get(patientId.value)).toDomain(),
      )).notFoundAsNull<PatientBaseline>('BaselineNotFound');

  @override
  Future<Result<PatientBaseline>> record(PatientId patientId, NewBaseline baseline) =>
      apiCall(() async => (await _service.record(patientId.value, baseline.toDto())).toDomain());

  @override
  Future<Result<PatientBaseline>> update(PatientId patientId, NewBaseline baseline) =>
      apiCall(() async => (await _service.update(patientId.value, baseline.toDto())).toDomain());
}

class PatientSummaryRepositoryImpl implements PatientSummaryRepository {
  const PatientSummaryRepositoryImpl(this._service);

  final PractitionerPatientService _service;

  @override
  Future<Result<PatientSummary>> getSummary(PatientId patientId) =>
      apiCall(() async => (await _service.getSummary(patientId.value)).toDomain());
}

class NutritionPlanRepositoryImpl implements NutritionPlanRepository {
  const NutritionPlanRepositoryImpl(this._service);

  final PractitionerPatientService _service;

  @override
  Future<Result<PlanHistory>> getHistory(PatientId patientId) =>
      apiCall(() async => (await _service.getPlans(patientId.value)).toPlanHistory());
}

class ConsultationRepositoryImpl implements ConsultationRepository {
  const ConsultationRepositoryImpl(this._service);

  final ConsultationService _service;

  @override
  Future<Result<Consultation>> start(PatientId patientId, int? scheduledFollowUpId) => apiCall(() async {
    final dto = await _service.start(patientId.value, StartConsultationRequestDto(scheduledFollowUpId: scheduledFollowUpId));
    return dto.toDomain();
  });

  @override
  Future<Result<Consultation?>> getInProgress(PatientId patientId) async =>
      (await apiCall<Consultation?>(
        () async => (await _service.getInProgress(patientId.value)).toDomain(),
      )).notFoundAsNull<Consultation>('ConsultationNotFound');

  @override
  Future<Result<Consultation>> recordMeasurement(ConsultationId id, NewMeasurement measurement) =>
      apiCall(() async => (await _service.recordMeasurement(id.value, measurement.toDto())).toDomain());

  @override
  Future<Result<DiagnosisSuggestion>> suggestDiagnosis(ConsultationId id) =>
      apiCall(() async => (await _service.suggestDiagnosis(id.value)).toDomain());

  @override
  Future<Result<Consultation>> issueDiagnosis(ConsultationId id, DiagnosisChoice choice) =>
      apiCall(() async => (await _service.issueDiagnosis(id.value, choice.toDto())).toDomain());

  @override
  Future<Result<TargetProposal>> proposeTargets(ConsultationId id, TargetParameters? parameters) => apiCall(() async {
    final dto = await _service.proposeTargets(id.value, TargetProposalRequestDto(parameters: parameters?.toDto()));
    return dto.toDomain();
  });

  @override
  Future<Result<Consultation>> prescribeTargets(ConsultationId id, TargetPrescription prescription) =>
      apiCall(() async => (await _service.prescribeTargets(id.value, prescription.toDto())).toDomain());

  @override
  Future<Result<GuidelineSuggestions>> suggestGuidelines(ConsultationId id) =>
      apiCall(() async => (await _service.suggestGuidelines(id.value)).toDomain());

  @override
  Future<Result<Consultation>> saveDraft(ConsultationId id, Publication publication) =>
      apiCall(() async => (await _service.saveDraft(id.value, publication.toDto())).toDomain());

  @override
  Future<Result<Consultation>> publish(ConsultationId id, Publication publication, IdempotencyKey idempotencyKey) =>
      apiCall(() async => (await _service.publish(id.value, idempotencyKey.value, publication.toDto())).toDomain());

  @override
  Future<Result<void>> discard(ConsultationId id) => apiCall(() => _service.discard(id.value));
}

class PractitionerRecordRepositoryImpl implements PractitionerRecordRepository {
  const PractitionerRecordRepositoryImpl(this._service);

  final PractitionerPatientService _service;

  /// `PatientRecordComposer.DefaultDays`.
  static const recordDays = 30;

  @override
  Future<Result<PractitionerPatientRecord>> getRecord(PatientId patientId) =>
      apiCall(() async => (await _service.getRecord(patientId.value, days: recordDays)).toDomain());

  @override
  Future<Result<EvaluationDetail>> getEvaluation(int assessmentId) =>
      apiCall(() async => (await _service.getAssessment(assessmentId)).toDomain());
}

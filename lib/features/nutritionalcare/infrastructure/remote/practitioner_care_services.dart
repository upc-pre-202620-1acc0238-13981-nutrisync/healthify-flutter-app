import '../../../../core/network/api_client.dart';
import 'dto/consultation_dtos.dart';
import 'dto/patient_baseline_dtos.dart';
import 'dto/practitioner_patient_dtos.dart';

/// Baseline (`Practitioner` only; `403` without an active link).
class PatientBaselineService {
  const PatientBaselineService(this._api);

  final ApiClient _api;

  /// `404 BaselineNotFound` before it is recorded.
  Future<PatientBaselineDto> get(int patientId) async =>
      PatientBaselineDto.fromJson(await _api.get('patients/$patientId/baseline') as Map<String, dynamic>);

  /// `201` · `409 BaselineAlreadyRecorded` · `400 InvalidBirthDate`/`InvalidHeight`/`UnknownMedicalCondition`.
  Future<PatientBaselineDto> record(int patientId, PatientBaselineRequestDto body) async => PatientBaselineDto.fromJson(
    await _api.post('patients/$patientId/baseline', body: body.toJson()) as Map<String, dynamic>,
  );

  Future<PatientBaselineDto> update(int patientId, PatientBaselineRequestDto body) async => PatientBaselineDto.fromJson(
    await _api.put('patients/$patientId/baseline', body: body.toJson()) as Map<String, dynamic>,
  );
}

/// The guided consultation (`Practitioner` only).
class ConsultationService {
  const ConsultationService(this._api);

  final ApiClient _api;

  static ConsultationDto _consultation(dynamic json) => ConsultationDto.fromJson(json as Map<String, dynamic>);

  /// `201` · `409 ConsultationAlreadyInProgress` · `422 BaselineRequired`.
  Future<ConsultationDto> start(int patientId, StartConsultationRequestDto body) async =>
      _consultation(await _api.post('patients/$patientId/consultations', body: body.toJson()));

  /// `404 ConsultationNotFound` if none is in progress.
  Future<ConsultationDto> getInProgress(int patientId) async =>
      _consultation(await _api.get('patients/$patientId/consultations/in-progress'));

  Future<ConsultationDto> recordMeasurement(int consultationId, MeasurementRequestDto body) async =>
      _consultation(await _api.put('consultations/$consultationId/measurement', body: body.toJson()));

  /// AI: can take up to the 60 s read timeout.
  Future<DiagnosisSuggestionDto> suggestDiagnosis(int consultationId) async => DiagnosisSuggestionDto.fromJson(
    await _api.post('consultations/$consultationId/diagnosis-suggestion') as Map<String, dynamic>,
  );

  Future<ConsultationDto> issueDiagnosis(int consultationId, DiagnosisRequestDto body) async =>
      _consultation(await _api.put('consultations/$consultationId/diagnosis', body: body.toJson()));

  Future<TargetProposalDto> proposeTargets(int consultationId, TargetProposalRequestDto body) async =>
      TargetProposalDto.fromJson(
        await _api.post('consultations/$consultationId/target-proposal', body: body.toJson()) as Map<String, dynamic>,
      );

  /// `400 OverrideReasonRequired` if own values are entered without a reason.
  Future<ConsultationDto> prescribeTargets(int consultationId, PrescribeTargetsRequestDto body) async =>
      _consultation(await _api.put('consultations/$consultationId/targets', body: body.toJson()));

  /// AI: can take up to the 60 s read timeout.
  Future<GuidelineSuggestionsDto> suggestGuidelines(int consultationId) async => GuidelineSuggestionsDto.fromJson(
    await _api.post('consultations/$consultationId/guideline-suggestions') as Map<String, dynamic>,
  );

  Future<ConsultationDto> saveDraft(int consultationId, PublicationRequestDto body) async =>
      _consultation(await _api.put('consultations/$consultationId/publication-draft', body: body.toJson()));

  /// With the same `Idempotency-Key` the backend returns the same result: it never publishes two versions.
  Future<ConsultationDto> publish(int consultationId, String idempotencyKey, PublicationRequestDto body) async =>
      _consultation(
        await _api.post(
          'consultations/$consultationId/publication',
          body: body.toJson(),
          headers: {'Idempotency-Key': idempotencyKey},
        ),
      );

  /// `204` · `403` if the caller does not own it · `404` · `409` if it is no longer in progress.
  Future<void> discard(int consultationId) async {
    await _api.delete('consultations/$consultationId');
  }
}

/// Patient views for the practitioner. `403` without an active link.
class PractitionerPatientService {
  const PractitionerPatientService(this._api);

  final ApiClient _api;

  Future<PatientSummaryDto> getSummary(int patientId) async =>
      PatientSummaryDto.fromJson(await _api.get('patients/$patientId/summary') as Map<String, dynamic>);

  Future<List<NutritionPlanDto>> getPlans(int patientId) async {
    final json = await _api.get('patients/$patientId/nutrition-plans') as List<dynamic>;
    return [for (final item in json) NutritionPlanDto.fromJson(item as Map<String, dynamic>)];
  }

  /// [days] is the record's compliance window (`PatientRecordComposer.DefaultDays`).
  Future<PractitionerRecordDto> getRecord(int patientId, {required int days}) async => PractitionerRecordDto.fromJson(
    await _api.get('patients/$patientId/record', query: {'days': days}) as Map<String, dynamic>,
  );

  /// Only the practitioner who recorded the assessment · `403` if it is someone else's · `404` if missing.
  Future<NutritionalAssessmentDto> getAssessment(int assessmentId) async => NutritionalAssessmentDto.fromJson(
    await _api.get('nutritional-assessments/$assessmentId') as Map<String, dynamic>,
  );
}

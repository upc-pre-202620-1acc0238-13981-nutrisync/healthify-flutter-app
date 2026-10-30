import 'dart:async';

import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/consultation_commands.dart';
import 'package:healthify/features/nutritionalcare/domain/entity/plan_history.dart';
import 'package:healthify/features/nutritionalcare/domain/repository/practitioner_care_repositories.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_codes.dart';
import 'package:healthify/features/nutritionalcare/domain/valueobject/clinical_values.dart';

Consultation consultation({
  ConsultationStep step = ConsultationStep.measurement,
  int id = 9,
  ConsultationMeasurement? measurement,
  ConsultationDiagnosis? diagnosis,
  ConsultationTargets? targets,
  PublicationDraft? draft,
  PatientCheckIn? checkIn,
}) => Consultation(
  id: ConsultationId(id),
  patientId: PatientId(7),
  isInProgress: true,
  currentStep: step,
  lastSavedAt: DateTime.utc(2026, 10, 30, 12),
  measurement: measurement,
  diagnosis: diagnosis,
  targets: targets,
  publicationDraft: draft,
  patientCheckIn: checkIn,
);

ConsultationMeasurement savedMeasurement({double weightKg = 74.2}) => ConsultationMeasurement(
  weightKg: weightKg,
  heightCm: 168,
  waistCm: 88,
  bmi: 26.3,
  protocolChecks: const {ProtocolCheck.fasting, ProtocolCheck.noShoes},
  activityLevel: ActivityLevel.moderate,
  habits: EatingHabits(mealsPerDay: 4),
  ageYears: 31,
  sex: BiologicalSex.female,
);

ConsultationDiagnosis savedDiagnosis({
  DiagnosisCode code = DiagnosisCode.overweightGradeI,
  DiagnosisSource source = DiagnosisSource.practitionerSelected,
}) => ConsultationDiagnosis(code: code, source: source, rationale: 'IMC 26.3', isPending: true);

CalculationBasis calculationBasis() => const CalculationBasis(
  equation: EnergyEquation.mifflinStJeor,
  referenceWeightKg: 74.2,
  activityFactor: 1.55,
  deficitKind: DeficitKind.fixedKcal,
  deficitValue: 500,
);

Targets proposedTargets() => Targets(energyKcal: 1796, proteinG: 119, carbG: 195, fatG: 60);

ConsultationTargets savedTargets({bool prescribed = true, bool overridden = false}) => ConsultationTargets(
  basis: calculationBasis(),
  proposal: proposedTargets(),
  prescribed: prescribed ? proposedTargets() : null,
  isOverridden: overridden,
);

TargetProposal targetProposal() => TargetProposal(
  basis: calculationBasis(),
  proposal: proposedTargets(),
  inputs: const TargetInputs(
    sex: BiologicalSex.female,
    ageYears: 31,
    heightCm: 168,
    weightKg: 74.2,
    activityLevel: ActivityLevel.moderate,
  ),
);

DiagnosisSuggestion diagnosisSuggestion({bool fromAi = true}) => DiagnosisSuggestion(
  aiGenerationId: fromAi ? 77 : null,
  code: DiagnosisCode.overweightGradeI,
  rationale: 'IMC 26.3 kg/m2 (rango 25 a 29.9).',
  isFromAi: fromAi,
  disclaimer: 'Revisa antes de usar.',
);

GuidelineSuggestions guidelineSuggestions({bool fromAi = true}) => GuidelineSuggestions(
  codes: const [PlanGuidelineCode.prioritizeVegetables, PlanGuidelineCode.reduceSalt],
  isFromAi: fromAi,
);

/// A consultation in progress at step 1 with nothing saved yet.
Consultation freshConsultation() => consultation();

/// A consultation in progress with step 1 saved, ready for the diagnosis step.
Consultation consultationAtDiagnosis({ConsultationDiagnosis? diagnosis}) =>
    consultation(step: ConsultationStep.diagnosis, measurement: savedMeasurement(), diagnosis: diagnosis);

/// A consultation in progress with steps 1 and 2 saved, ready for the targets step.
Consultation consultationAtTargets({ConsultationTargets? targets}) => consultation(
  step: ConsultationStep.targets,
  measurement: savedMeasurement(),
  diagnosis: savedDiagnosis(),
  targets: targets,
);

/// A consultation in progress with steps 1 to 3 saved, ready for the publication step.
Consultation consultationAtPublication({PublicationDraft? draft}) => consultation(
  step: ConsultationStep.publication,
  measurement: savedMeasurement(),
  diagnosis: savedDiagnosis(),
  targets: savedTargets(),
  draft: draft,
);

/// Holds an answer until the test lets it go, to look at the screen while the AI works. The answer is read after the
/// wait, so a test can change it while the call is pending.
Future<T> _after<T>(Completer<void>? gate, T Function() value) async {
  if (gate != null) await gate.future;
  return value();
}

class FakeConsultationRepository implements ConsultationRepository {
  Result<Consultation> startResult = Result.success(consultation());
  Result<Consultation?> inProgressResult = const Result.success(null);
  /// `null` answers like the backend: the consultation at step 2 with the measurement that was sent.
  Result<Consultation>? recordMeasurementResult;
  Result<DiagnosisSuggestion> suggestDiagnosisResult = Result.success(diagnosisSuggestion());
  Result<Consultation> issueDiagnosisResult = Result.success(consultation(step: ConsultationStep.targets));
  Result<TargetProposal> proposeTargetsResult = Result.success(targetProposal());
  Result<Consultation> prescribeTargetsResult = Result.success(consultation(step: ConsultationStep.publication));
  Result<GuidelineSuggestions> suggestGuidelinesResult = Result.success(guidelineSuggestions());
  Result<Consultation> saveDraftResult = Result.success(consultation(step: ConsultationStep.publication));
  Result<Consultation> publishResult = Result.success(consultation(step: ConsultationStep.publication));
  Result<void> discardResult = const Result.success(null);

  /// Results handed out in order before falling back to the fields above (a failure followed by a success...).
  final publishResults = <Result<Consultation>>[];
  final suggestDiagnosisResults = <Result<DiagnosisSuggestion>>[];
  final suggestGuidelinesResults = <Result<GuidelineSuggestions>>[];

  /// Hold the AI calls so a test can look at the screen while they run.
  Completer<void>? inProgressGate;
  Completer<void>? startGate;
  Completer<void>? suggestDiagnosisGate;
  Completer<void>? suggestGuidelinesGate;

  final startedWith = <int?>[];
  final measurements = <NewMeasurement>[];
  final diagnoses = <DiagnosisChoice>[];
  final parametersSent = <TargetParameters?>[];
  final prescriptions = <TargetPrescription>[];
  final drafts = <Publication>[];
  final published = <(Publication, IdempotencyKey)>[];
  final discarded = <ConsultationId>[];
  int inProgressCalls = 0;
  int suggestDiagnosisCalls = 0;
  int suggestGuidelinesCalls = 0;

  @override
  Future<Result<Consultation>> start(PatientId patientId, int? scheduledFollowUpId) async {
    await startGate?.future;
    startedWith.add(scheduledFollowUpId);
    return startResult;
  }

  @override
  Future<Result<Consultation?>> getInProgress(PatientId patientId) {
    inProgressCalls++;
    return _after(inProgressGate, () => inProgressResult);
  }

  @override
  Future<Result<Consultation>> recordMeasurement(ConsultationId id, NewMeasurement measurement) async {
    measurements.add(measurement);
    return recordMeasurementResult ??
        Result.success(
          consultation(
            step: ConsultationStep.diagnosis,
            measurement: ConsultationMeasurement(
              weightKg: measurement.weightKg,
              heightCm: 168,
              waistCm: measurement.waistCm,
              bodyFatPercentage: measurement.bodyFatPercentage,
              bmi: 26.3,
              protocolChecks: measurement.protocolChecks,
              activityLevel: measurement.activityLevel,
              habits: measurement.habits,
              biochemistry: measurement.biochemistry,
              ageYears: 31,
              sex: BiologicalSex.female,
            ),
          ),
        );
  }

  @override
  Future<Result<DiagnosisSuggestion>> suggestDiagnosis(ConsultationId id) {
    suggestDiagnosisCalls++;
    return _after(
      suggestDiagnosisGate,
      () => suggestDiagnosisResults.isEmpty ? suggestDiagnosisResult : suggestDiagnosisResults.removeAt(0),
    );
  }

  @override
  Future<Result<Consultation>> issueDiagnosis(ConsultationId id, DiagnosisChoice choice) async {
    diagnoses.add(choice);
    return issueDiagnosisResult;
  }

  @override
  Future<Result<TargetProposal>> proposeTargets(ConsultationId id, TargetParameters? parameters) async {
    parametersSent.add(parameters);
    return proposeTargetsResult;
  }

  @override
  Future<Result<Consultation>> prescribeTargets(ConsultationId id, TargetPrescription prescription) async {
    prescriptions.add(prescription);
    return prescribeTargetsResult;
  }

  @override
  Future<Result<GuidelineSuggestions>> suggestGuidelines(ConsultationId id) {
    suggestGuidelinesCalls++;
    return _after(
      suggestGuidelinesGate,
      () => suggestGuidelinesResults.isEmpty ? suggestGuidelinesResult : suggestGuidelinesResults.removeAt(0),
    );
  }

  @override
  Future<Result<Consultation>> saveDraft(ConsultationId id, Publication publication) async {
    drafts.add(publication);
    return saveDraftResult;
  }

  @override
  Future<Result<Consultation>> publish(ConsultationId id, Publication publication, IdempotencyKey idempotencyKey) async {
    published.add((publication, idempotencyKey));
    return publishResults.isEmpty ? publishResult : publishResults.removeAt(0);
  }

  @override
  Future<Result<void>> discard(ConsultationId id) async {
    discarded.add(id);
    return discardResult;
  }
}

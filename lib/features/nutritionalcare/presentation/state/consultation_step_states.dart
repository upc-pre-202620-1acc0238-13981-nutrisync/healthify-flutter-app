import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/consultation.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/entity/patient_summary.dart';
import '../../domain/valueobject/clinical_codes.dart';

part 'consultation_step_states.freezed.dart';

/// What the consultation steps share: loading the in-progress consultation (rehydrate) and its failures.
@freezed
abstract class StepLoadState with _$StepLoadState {
  const factory StepLoadState({
    @Default(true) bool isLoading,
    @Default(false) bool loadFailed,
    @Default(false) bool isOffline,
  }) = _StepLoadState;
}

/// A save that failed for a reason other than form data (network, 5xx...): notice with "Retry".
@freezed
abstract class SaveFailure with _$SaveFailure {
  const factory SaveFailure({required bool isNetwork}) = _SaveFailure;
}

/// State of a request to the AI (up to the 60 s read timeout): what the screen shows while it is slow or after it failed.
enum AiRequestStatus { idle, loading, ready, failed }

/// What the consultation steps ask of their screen.
sealed class ConsultationStepEvent {
  const ConsultationStepEvent();
}

/// Step saved: on to the next.
final class StepContinue extends ConsultationStepEvent {
  const StepContinue();
}

/// "Exit and continue later".
final class StepExit extends ConsultationStepEvent {
  const StepExit();
}

/// A previous step is missing (e.g. the measurement): go back to it.
final class StepBack extends ConsultationStepEvent {
  const StepBack();
}

/// No consultation in progress anymore (published or closed): back to the patient file.
final class StepConsultationClosed extends ConsultationStepEvent {
  const StepConsultationClosed();
}

/// Plan published: to the patient file with "Plan published".
final class StepPublished extends ConsultationStepEvent {
  const StepPublished();
}

/// Step 1, today's measurement.
@freezed
abstract class MeasurementState with _$MeasurementState {
  const factory MeasurementState({
    @Default(StepLoadState()) StepLoadState load,
    BaselineSummary? baseline,
    PatientCheckIn? checkIn,
    @Default(MeasurementForm()) MeasurementForm form,

    /// Live BMI from the typed weight and the baseline height.
    double? bmi,
    @Default(false) bool habitsExpanded,
    @Default(false) bool biochemistryExpanded,
    @Default({}) Map<MeasurementField, FieldProblem> problems,
    @Default(false) bool isSaving,
    SaveFailure? saveFailure,
    @Default(false) bool showExitDialog,

    /// "Delete consultation" (trash can): confirmation dialog, deletion in progress and failure with "Retry".
    @Default(false) bool showDiscardDialog,
    @Default(false) bool isDiscarding,
    SaveFailure? discardFailure,
  }) = _MeasurementState;
}

/// Step 2, diagnosis.
@freezed
abstract class DiagnosisState with _$DiagnosisState {
  const factory DiagnosisState({
    @Default(StepLoadState()) StepLoadState load,

    /// The AI suggestion: `loading` can last up to a minute; `failed` keeps the closed list usable and offers "Retry".
    @Default(AiRequestStatus.idle) AiRequestStatus suggestionStatus,
    DiagnosisSuggestion? suggestion,
    DiagnosisCode? selected,

    /// `true` if the choice is the suggestion ("Use suggestion"); "Choose another" or tapping a chip turns it off.
    @Default(false) bool usesSuggestion,
    @Default(false) bool showRequired,
    @Default(false) bool isSaving,
    SaveFailure? saveFailure,
  }) = _DiagnosisState;
}

/// "Change parameters".
@freezed
abstract class ParametersForm with _$ParametersForm {
  const factory ParametersForm({
    @Default(EnergyEquation.mifflinStJeor) EnergyEquation equation,
    @Default(DeficitKind.fixedKcal) DeficitKind deficitKind,
    @Default('') String deficit,
    @Default('') String proteinPerKg,
    @Default('') String fatPercent,
  }) = _ParametersForm;
}

/// "Enter my own values" with the required reason (`OverrideReasonRequired`).
@freezed
abstract class OverrideForm with _$OverrideForm {
  const factory OverrideForm({
    @Default('') String energy,
    @Default('') String protein,
    @Default('') String carb,
    @Default('') String fat,
    @Default('') String reason,
  }) = _OverrideForm;
}

/// Step 3, calculated targets.
@freezed
abstract class TargetsState with _$TargetsState {
  const factory TargetsState({
    @Default(StepLoadState()) StepLoadState load,
    @Default(false) bool isCalculating,
    TargetProposal? proposal,
    @Default(false) bool proposalFailed,
    @Default(false) bool showParameters,
    ParametersForm? parameters,
    @Default(false) bool parametersInvalid,
    @Default(false) bool showOverride,
    @Default(OverrideForm()) OverrideForm ownValues,
    @Default({}) Set<OverrideField> overrideProblems,
    @Default(false) bool isSaving,
    SaveFailure? saveFailure,
  }) = _TargetsState;
}

/// Step 4, guidelines and publication (including the publish error).
@freezed
abstract class PublicationState with _$PublicationState {
  const factory PublicationState({
    @Default(StepLoadState()) StepLoadState load,
    @Default({}) Set<PlanRestrictionCode> restrictions,
    @Default({}) Set<PlanGuidelineCode> guidelines,
    @Default([]) List<String> customGuidelines,
    @Default([]) List<PlanGuidelineCode> suggested,
    @Default(false) bool suggestedByAi,

    /// The guideline suggestions (AI) arrive after the form: `loading` can last up to a minute, `failed` offers "Retry".
    @Default(AiRequestStatus.idle) AiRequestStatus suggestionStatus,
    @Default('') String customDraft,
    @Default(false) bool showCustomField,
    @Default(false) bool customError,
    @Default('') String patientMessage,
    @Default(false) bool messageTooLong,
    @Default(false) bool isPublishing,

    /// "We could not publish the plan. What you wrote was not lost".
    @Default(false) bool publishFailed,
    @Default(false) bool isOffline,
  }) = _PublicationState;
}

import 'dart:async';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../state/consultation_step_states.dart';
import 'consultation_step_cubit.dart';

/// One `Idempotency-Key` per consultation, kept for as long as the app lives: "Try again" (even from a fresh visit to the
/// step) resends it and the backend never publishes two versions.
class IdempotencyKeyStore {
  final _keys = <int, IdempotencyKey>{};

  IdempotencyKey keyFor(ConsultationId id) => _keys.putIfAbsent(id.value, IdempotencyKey.random);
}

/// Step 4, guidelines and publication (including the publish error).
///
/// - Rehydrates the saved draft (`publication-draft`); without a draft, the suggested guidelines arrive selected (like
///   the frame, which shows them chosen) unless the practitioner already chose some.
/// - The suggestions (AI) are requested after the form is shown, so the form is usable while the AI works (up to a
///   minute) and a timeout leaves it as it was, with "Retry" on the suggestions only.
/// - The draft is saved when leaving the step with "‹" and before publishing, so what was written survives even if the
///   app is closed.
/// - "Publish and close consultation" uses **one** `Idempotency-Key` per consultation.
class PublicationStepCubit extends ConsultationStepCubit<PublicationState> {
  PublicationStepCubit(
    GetConsultationInProgressUseCase getInProgress,
    this._suggestGuidelines,
    this._saveDraft,
    this._publish,
    this._keys,
    ConnectivityObserver connectivity, {
    required super.patientId,
  }) : super(const PublicationState(), getInProgress, connectivity) {
    unawaited(_load());
  }

  final SuggestGuidelinesUseCase _suggestGuidelines;
  final SavePublicationDraftUseCase _saveDraft;
  final PublishConsultationUseCase _publish;
  final IdempotencyKeyStore _keys;

  /// The last state saved as a draft (not resent if unchanged).
  Publication? _lastSavedDraft;

  /// Whether the saved draft decided the guidelines, or the practitioner already toggled one: suggestions then arrive
  /// as chips only, never overriding the choice.
  bool _guidelinesDecided = false;

  @override
  void onConnectivityChanged(bool online) {
    emit(state.copyWith(isOffline: !online, load: state.load.copyWith(isOffline: !online)));
    if (!online) return;
    if (state.load.loadFailed) {
      unawaited(_load());
    } else if (state.suggestionStatus == AiRequestStatus.failed) {
      unawaited(onRetrySuggestions());
    }
  }

  void onRetry() => unawaited(_load());

  /// "Retry" on the failed AI suggestions; the form is left as it is.
  Future<void> onRetrySuggestions() async {
    final current = consultation;
    if (current == null || state.suggestionStatus == AiRequestStatus.loading) return;
    await _loadSuggestions();
  }

  void onRestrictionToggle(PlanRestrictionCode code) => emit(
    state.copyWith(
      restrictions: state.restrictions.contains(code) ? ({...state.restrictions}..remove(code)) : {...state.restrictions, code},
    ),
  );

  void onGuidelineToggle(PlanGuidelineCode code) {
    _guidelinesDecided = true;
    emit(
      state.copyWith(
        guidelines: state.guidelines.contains(code) ? ({...state.guidelines}..remove(code)) : {...state.guidelines, code},
      ),
    );
  }

  /// "Other guideline".
  void onAddCustomClick() => emit(state.copyWith(showCustomField: true, customError: false));

  void onCustomDraftChange(String text) => emit(state.copyWith(customDraft: text, customError: false));

  void onConfirmCustom() {
    final text = state.customDraft.trim();
    final valid = CustomGuidelineText.hasValidLength(text) && state.customGuidelines.length < CustomGuidelineText.maxPerVersion;
    if (!valid) {
      emit(state.copyWith(customError: true));
      return;
    }
    emit(
      state.copyWith(
        customGuidelines: {...state.customGuidelines, text}.toList(),
        customDraft: '',
        showCustomField: false,
      ),
    );
  }

  void onRemoveCustom(String text) =>
      emit(state.copyWith(customGuidelines: [...state.customGuidelines]..remove(text)));

  void onPatientMessageChange(String text) =>
      emit(state.copyWith(patientMessage: text, messageTooLong: text.trim().length > PatientMessage.maxLength));

  /// "‹": saves the draft (if changed) and goes back to step 3.
  void onBack() {
    final publication = _currentPublication();
    final current = consultation;
    if (current != null && publication != null && publication != _lastSavedDraft) {
      _lastSavedDraft = publication;
      // Saved in the background: leaving the step does not wait for the network.
      unawaited(_saveDraft(current.id, publication));
    }
    sendEvent(const StepBack());
  }

  Future<void> onPublish() async {
    final current = consultation;
    if (current == null || state.isPublishing) return;
    final publication = _currentPublication();
    if (publication == null) return;
    emit(state.copyWith(isPublishing: true, publishFailed: false));
    if (publication != _lastSavedDraft && (await _saveDraft(current.id, publication)).isSuccess) {
      _lastSavedDraft = publication;
    }
    final result = await _publish(current.id, publication, _keys.keyFor(current.id));
    if (isClosed) return;
    final error = result.errorOrNull;
    if (result.isSuccess) {
      emit(state.copyWith(isPublishing: false));
      sendEvent(const StepPublished());
    } else if (closesConsultation(error)) {
      emit(state.copyWith(isPublishing: false));
      sendEvent(const StepConsultationClosed());
    } else {
      // What was written stays on screen and in the draft.
      emit(state.copyWith(isPublishing: false, publishFailed: true));
    }
  }

  /// "Try again": same `Idempotency-Key`.
  Future<void> onRetryPublish() => onPublish();

  /// Closing the publish error goes back to the form with everything written.
  void onPublishFailureDismissed() => emit(state.copyWith(publishFailed: false));

  /// `null` if the message is too long (the field flags it).
  Publication? _currentPublication() {
    if (state.messageTooLong) return null;
    return Publication(
      restrictions: state.restrictions,
      guidelines: state.guidelines,
      customGuidelines: state.customGuidelines.map(CustomGuidelineText.new).toList(),
      patientMessage: PatientMessage.ofOptional(state.patientMessage),
    );
  }

  Future<void> _load() async {
    emit(state.copyWith(load: state.load.copyWith(isLoading: true, loadFailed: false)));
    final result = await readInProgress();
    if (isClosed) return;
    if (result.isFailure) {
      emit(
        state.copyWith(
          load: state.load.copyWith(
            isLoading: false,
            loadFailed: true,
            isOffline: state.isOffline || result.errorOrNull is Network,
          ),
        ),
      );
      return;
    }
    final inProgress = result.valueOrNull;
    if (inProgress == null) return;
    if (inProgress.targets?.prescribed == null) {
      sendEvent(const StepBack());
      return;
    }
    consultation = inProgress;
    final draft = inProgress.publicationDraft;
    final draftCustoms = draft?.customGuidelines
        .where(CustomGuidelineText.hasValidLength)
        .take(CustomGuidelineText.maxPerVersion)
        .toList();
    if (draft != null) _guidelinesDecided = true;
    emit(
      state.copyWith(
        load: state.load.copyWith(isLoading: false, loadFailed: false),
        restrictions: draft?.restrictions ?? state.restrictions,
        guidelines: draft?.guidelines ?? state.guidelines,
        customGuidelines: draftCustoms ?? state.customGuidelines,
        patientMessage: draft?.patientMessage ?? state.patientMessage,
        messageTooLong: (draft?.patientMessage ?? state.patientMessage).trim().length > PatientMessage.maxLength,
      ),
    );
    if (draft != null) {
      _lastSavedDraft = Publication(
        restrictions: draft.restrictions,
        guidelines: draft.guidelines,
        customGuidelines: (draftCustoms ?? const <String>[]).map(CustomGuidelineText.new).toList(),
        patientMessage: PatientMessage.ofOptional(draft.patientMessage),
      );
    }
    if (state.suggested.isEmpty) await _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final current = consultation;
    if (current == null) return;
    emit(state.copyWith(suggestionStatus: AiRequestStatus.loading));
    final result = await _suggestGuidelines(current.id);
    if (isClosed) return;
    final suggestions = result.valueOrNull;
    if (suggestions == null) {
      emit(state.copyWith(suggestionStatus: AiRequestStatus.failed));
      return;
    }
    emit(
      state.copyWith(
        suggestionStatus: AiRequestStatus.ready,
        suggested: suggestions.codes,
        suggestedByAi: suggestions.isFromAi,
        guidelines: _guidelinesDecided ? state.guidelines : suggestions.codes.toSet(),
      ),
    );
  }
}

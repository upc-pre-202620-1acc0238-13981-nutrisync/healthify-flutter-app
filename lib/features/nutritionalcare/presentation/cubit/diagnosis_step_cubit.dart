import 'dart:async';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../../domain/entity/consultation.dart';
import '../../domain/entity/consultation_commands.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../state/consultation_step_states.dart';
import 'consultation_step_cubit.dart';

/// Step 2, diagnosis (only for the professional record: the patient will not see it). Requests the suggestion (AI, or
/// the BMI rule when AI is unavailable) and offers the closed list. "Use suggestion" stores the AI generation; "Choose
/// another" or tapping another diagnosis is the practitioner's choice.
///
/// The AI can take up to a minute. While it does the list is already usable; if it times out or fails the card says so
/// with "Retry", and what was already chosen is kept.
class DiagnosisStepCubit extends ConsultationStepCubit<DiagnosisState> {
  DiagnosisStepCubit(
    GetConsultationInProgressUseCase getInProgress,
    this._suggestDiagnosis,
    this._issueDiagnosis,
    ConnectivityObserver connectivity, {
    required super.patientId,
  }) : super(const DiagnosisState(), getInProgress, connectivity) {
    unawaited(_load());
  }

  final SuggestDiagnosisUseCase _suggestDiagnosis;
  final IssueConsultationDiagnosisUseCase _issueDiagnosis;

  DiagnosisSuggestion? _suggestion;

  @override
  void onConnectivityChanged(bool online) {
    emit(state.copyWith(load: state.load.copyWith(isOffline: !online)));
    if (!online) return;
    if (state.load.loadFailed) {
      unawaited(_load());
    } else if (state.suggestionStatus == AiRequestStatus.failed) {
      unawaited(onRetrySuggestion());
    }
  }

  void onRetry() => unawaited(_load());

  /// "Retry" on the failed AI suggestion; nothing else on the screen is touched.
  Future<void> onRetrySuggestion() async {
    final current = consultation;
    if (current == null || state.suggestionStatus == AiRequestStatus.loading) return;
    await _loadSuggestion(current);
  }

  void onUseSuggestion() {
    final current = _suggestion;
    if (current == null) return;
    emit(state.copyWith(selected: current.code, usesSuggestion: true, showRequired: false));
  }

  /// "Choose another": drops the suggestion to pick from the list.
  void onChooseOther() => emit(state.copyWith(selected: null, usesSuggestion: false));

  void onSelect(DiagnosisCode code) => emit(state.copyWith(selected: code, usesSuggestion: false, showRequired: false));

  void onSaveFailureDismissed() => emit(state.copyWith(saveFailure: null));

  Future<void> onContinue() async {
    final current = consultation;
    if (current == null || state.isSaving) return;
    final code = state.selected;
    if (code == null) {
      emit(state.copyWith(showRequired: true));
      return;
    }
    final suggestion = _suggestion;
    final DiagnosisChoice choice = suggestion != null && state.usesSuggestion && suggestion.code == code
        ? DiagnosisChoice.accepting(suggestion)
        : SelectedDiagnosis(code);
    // This consultation's diagnosis stays pending until publishing; it is already saved. Repeating the step would
    // discard the pending one and issue an identical one.
    final saved = current.diagnosis;
    if (saved != null && saved.code == code && saved.source == choice.source) {
      sendEvent(const StepContinue());
      return;
    }
    emit(state.copyWith(isSaving: true));
    final result = await _issueDiagnosis(current.id, choice);
    if (isClosed) return;
    emit(state.copyWith(isSaving: false));
    final updated = result.valueOrNull;
    final error = result.errorOrNull;
    if (updated != null) {
      consultation = updated;
      sendEvent(const StepContinue());
    } else if (closesConsultation(error)) {
      sendEvent(const StepConsultationClosed());
    } else if (error == const Validation(stepOutOfOrder)) {
      sendEvent(const StepBack());
    } else {
      emit(state.copyWith(saveFailure: SaveFailure(isNetwork: error is Network)));
    }
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
            isOffline: state.load.isOffline || result.errorOrNull is Network,
          ),
        ),
      );
      return;
    }
    final inProgress = result.valueOrNull;
    if (inProgress == null) return;
    if (inProgress.measurement == null) {
      sendEvent(const StepBack());
      return;
    }
    consultation = inProgress;
    emit(
      state.copyWith(
        load: state.load.copyWith(isLoading: false, loadFailed: false),
        selected: inProgress.diagnosis?.code ?? state.selected,
      ),
    );
    if (_suggestion == null) await _loadSuggestion(inProgress);
  }

  Future<void> _loadSuggestion(Consultation inProgress) async {
    emit(state.copyWith(suggestionStatus: AiRequestStatus.loading));
    final result = await _suggestDiagnosis(inProgress.id);
    if (isClosed) return;
    final suggestion = result.valueOrNull;
    if (suggestion == null) {
      // The closed list stays usable; the card offers "Retry".
      emit(state.copyWith(suggestionStatus: AiRequestStatus.failed));
      return;
    }
    _suggestion = suggestion;
    final saved = inProgress.diagnosis;
    // On returning to the step: a previously accepted suggestion shows as used again.
    final accepted = DiagnosisChoice.accepting(suggestion);
    final acceptedBefore = saved != null && saved.code == accepted.code && saved.source == accepted.source;
    emit(
      state.copyWith(
        suggestionStatus: AiRequestStatus.ready,
        suggestion: suggestion,
        usesSuggestion: state.usesSuggestion || (acceptedBefore && state.selected == saved.code),
      ),
    );
  }
}

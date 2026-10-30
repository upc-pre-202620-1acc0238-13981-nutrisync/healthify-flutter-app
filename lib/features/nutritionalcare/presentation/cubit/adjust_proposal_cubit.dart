import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../../application/usecase/review_inbox_use_cases.dart';
import '../../domain/entity/plan_history.dart';
import '../../domain/entity/plan_proposal.dart';
import '../../domain/valueobject/clinical_codes.dart';
import '../../domain/valueobject/clinical_values.dart';
import '../state/review_states.dart';

const _planProposalOutOfSafetyBounds = 'PlanProposalOutOfSafetyBounds';
const _invalidPatientMessage = 'InvalidPatientMessage';
const _planVersionAlreadySuperseded = 'PlanVersionAlreadySuperseded';
const _activeCareLinkRequired = 'ActiveCareLinkRequired';

/// Adjust the AI-proposed plan. Everything comes prefilled from the proposal: targets, guidelines (the current ones with
/// what the AI adds and removes) and the message to the patient. "Assign adjusted plan" accepts it with the edits
/// (`asIs = false`); the backend only checks them against the calorie floor (`422`).
///
/// The 7 catalog guidelines are offered as chips (the practitioner's custom ones are always kept by the backend and are
/// not touched here). The message to the patient can be edited (at most 500 characters).
class AdjustProposalCubit extends Cubit<AdjustProposalState> {
  AdjustProposalCubit(
    this._getOpenReviewItem,
    this._awaitPlanProposal,
    this._getPlanHistory,
    this._acceptPlanProposal,
    ConnectivityObserver connectivityObserver, {
    required this.reviewItemId,
  }) : super(const AdjustProposalState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (!isClosed) emit(state.copyWith(isOffline: !online));
    });
    _load();
  }

  final GetOpenReviewItemUseCase _getOpenReviewItem;
  final AwaitPlanProposalUseCase _awaitPlanProposal;
  final GetPlanHistoryUseCase _getPlanHistory;
  final AcceptPlanProposalUseCase _acceptPlanProposal;
  final int reviewItemId;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<AdjustProposalEvent>();
  String? _patientName;

  Stream<AdjustProposalEvent> get events => _events.stream;

  void onRetryLoad() => _load();

  void onEnergyChange(String value) =>
      _updateField(ProposalEditField.energy, (s) => s.copyWith(energy: value, belowSafetyFloor: false));

  void onProteinChange(String value) => _updateField(ProposalEditField.protein, (s) => s.copyWith(protein: value));

  void onCarbChange(String value) => _updateField(ProposalEditField.carb, (s) => s.copyWith(carb: value));

  void onFatChange(String value) => _updateField(ProposalEditField.fat, (s) => s.copyWith(fat: value));

  void onMessageChange(String value) => _updateField(
    ProposalEditField.message,
    (s) => s.copyWith(message: value.length > PatientMessage.maxLength ? value.substring(0, PatientMessage.maxLength) : value),
  );

  void onGuidelineToggle(PlanGuidelineCode code, bool selected) => emit(
    state.copyWith(guidelines: selected ? {...state.guidelines, code} : ({...state.guidelines}..remove(code))),
  );

  /// "Assign adjusted plan".
  Future<void> onAssign() async {
    if (state.isAssigning || state.isLoading) return;
    final validation = ProposalEditValidation.of(
      energyText: state.energy,
      proteinText: state.protein,
      carbText: state.carb,
      fatText: state.fat,
      guidelines: state.guidelines,
      message: state.message,
    );
    final ProposalEdits edits;
    switch (validation) {
      case InvalidProposalEdits(:final fields):
        emit(state.copyWith(invalidFields: fields));
        return;
      case ValidProposalEdits(edits: final valid):
        edits = valid;
    }
    emit(state.copyWith(isAssigning: true, invalidFields: const {}, belowSafetyFloor: false));
    final result = await _acceptPlanProposal(reviewItemId, AcceptWithEdits(edits));
    if (isClosed) return;
    emit(state.copyWith(isAssigning: false));
    final error = result.errorOrNull;
    if (error == null) {
      _events.emit(ProposalAssigned(result.valueOrNull?.reviewItem.patientFullName ?? _patientName));
    } else {
      _onAssignFailed(error);
    }
  }

  void onDialogConfirmed() {
    final dialog = state.dialog;
    emit(state.copyWith(dialog: null));
    switch (dialog) {
      case ReviewDialog.notAvailable || ReviewDialog.alreadyResolved || ReviewDialog.planChanged:
        _events.emit(const CloseAdjustProposal());
      case ReviewDialog.serverError:
        onAssign();
      case ReviewDialog.noActiveLink || null:
        break;
    }
  }

  void onDialogDismissed() => emit(state.copyWith(dialog: null));

  Future<void> _load() async {
    emit(state.copyWith(isLoading: true, loadError: null));
    // The item and the proposal are independent reads.
    final itemRead = _getOpenReviewItem(reviewItemId);
    final proposalRead = _awaitPlanProposal(reviewItemId, maxAttempts: 1).last;
    final itemResult = await itemRead;
    final proposalResult = await proposalRead;
    if (isClosed) return;
    final item = itemResult.valueOrNull;
    final lookup = proposalResult.valueOrNull;
    final proposal = lookup is ProposalReady ? lookup.proposal : null;
    if (item == null || proposal == null || !proposal.canBeAccepted) {
      emit(state.copyWith(isLoading: false, loadError: _toLoadError(itemResult.errorOrNull ?? proposalResult.errorOrNull)));
      return;
    }
    // The current guidelines come from the plan history; the proposal only says what it adds and removes.
    final historyResult = await _getPlanHistory(item.patientId.value);
    if (isClosed) return;
    final history = historyResult.valueOrNull;
    if (history == null) {
      emit(state.copyWith(isLoading: false, loadError: _toLoadError(historyResult.errorOrNull)));
      return;
    }
    final current = [
      for (final guideline in history.active?.guidelines ?? const <PlanGuidelineItem>[])
        if (guideline is CatalogGuideline) guideline.code,
    ];
    _patientName = item.patientFullName;
    final firstName = item.patientFullName?.split(' ').first;
    emit(
      state.copyWith(
        isLoading: false,
        loadError: null,
        patientFirstName: firstName == null || firstName.trim().isEmpty ? null : firstName,
        previousEnergyKcal: proposal.currentEnergyKcal,
        energy: _formatNumber(proposal.proposed.energyKcal),
        protein: _formatNumber(proposal.proposed.proteinG),
        carb: _formatNumber(proposal.proposed.carbG),
        fat: _formatNumber(proposal.proposed.fatG),
        guidelines: proposal.resultingGuidelines(current),
        message: proposal.patientMessage.length > PatientMessage.maxLength
            ? proposal.patientMessage.substring(0, PatientMessage.maxLength)
            : proposal.patientMessage,
      ),
    );
  }

  void _onAssignFailed(DomainError error) {
    switch (error) {
      case Validation(:final code) when code == _planProposalOutOfSafetyBounds:
        emit(state.copyWith(belowSafetyFloor: true));
      case Validation(:final code) when code == _invalidPatientMessage:
        emit(state.copyWith(invalidFields: const {ProposalEditField.message}));
      case Conflict(:final code) when code == _planVersionAlreadySuperseded:
        _showDialog(ReviewDialog.planChanged);
      case Conflict():
        _showDialog(ReviewDialog.alreadyResolved);
      case NotFound():
        _showDialog(ReviewDialog.notAvailable);
      case Forbidden(:final code) when code == _activeCareLinkRequired:
        _showDialog(ReviewDialog.noActiveLink);
      case Forbidden():
        _showDialog(ReviewDialog.notAvailable);
      default:
        _showDialog(ReviewDialog.serverError);
    }
  }

  void _showDialog(ReviewDialog dialog) => emit(state.copyWith(dialog: dialog));

  void _updateField(ProposalEditField field, AdjustProposalState Function(AdjustProposalState) transform) {
    final next = transform(state);
    emit(next.copyWith(invalidFields: {...state.invalidFields}..remove(field)));
  }

  ReviewLoadError _toLoadError(DomainError? error) => switch (error) {
    null || NotFound() || Forbidden() => ReviewLoadError.notAvailable,
    Network() => ReviewLoadError.offline,
    _ => ReviewLoadError.generic,
  };

  /// Editable value: an integer without separator ("1650") or with one decimal ("62.5"); both read back the same way.
  static String _formatNumber(double value) =>
      value == value.roundToDouble() ? value.round().toString() : value.toStringAsFixed(1);

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

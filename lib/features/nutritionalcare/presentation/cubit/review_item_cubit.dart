import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../carerelationship/application/usecase/find_active_care_link_use_case.dart';
import '../../application/usecase/review_inbox_use_cases.dart';
import '../../domain/entity/plan_proposal.dart';
import '../../domain/entity/review_item.dart';
import '../state/review_states.dart';

const _resolutionOutcomeRequired = 'ResolutionOutcomeRequired';
const _planProposalNotFound = 'PlanProposalNotFound';
const _planVersionAlreadySuperseded = 'PlanVersionAlreadySuperseded';
const _reviewItemNotSustainedDeviation = 'ReviewItemNotSustainedDeviation';
const _activeCareLinkRequired = 'ActiveCareLinkRequired';

enum _Action { resolve, accept, openPatient }

/// Resolve item and the AI-proposed plan. Combines NutritionalCare (inbox and proposal) with CareRelationship (the
/// caseload, to open the patient file from "Adjust the plan now").
///
/// Besides "Adjust" and "Resolve" (assign as is), it offers "Resolve without assigning this plan", which shows the plain
/// resolution form: the backend allows it (`/resolution` discards the proposal), so the AI is never the only way to
/// close the signal. While the proposal is generating (`202`) the item can be resolved anyway. "Adjust the plan now" opens
/// the patient file; the item stays open and is resolved later with "Yes".
class ReviewItemCubit extends Cubit<ReviewItemState> {
  ReviewItemCubit(
    this._getOpenReviewItem,
    this._awaitPlanProposal,
    this._resolveReviewItem,
    this._acceptPlanProposal,
    this._findActiveRosterPatient,
    ConnectivityObserver connectivityObserver, {
    required this.reviewItemId,
  }) : super(const ReviewItemState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (!isClosed) emit(state.copyWith(isOffline: !online));
    });
    _load();
  }

  final GetOpenReviewItemUseCase _getOpenReviewItem;
  final AwaitPlanProposalUseCase _awaitPlanProposal;
  final ResolveReviewItemUseCase _resolveReviewItem;
  final AcceptPlanProposalUseCase _acceptPlanProposal;
  final FindActiveRosterPatientUseCase _findActiveRosterPatient;
  final int reviewItemId;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<ReviewItemEvent>();
  StreamSubscription<Object?>? _proposal;
  _Action? _failedAction;
  int _loadId = 0;

  Stream<ReviewItemEvent> get events => _events.stream;

  void onRetryLoad() => _load();

  void onAdjustedChange(bool adjusted) => emit(state.copyWith(adjusted: adjusted, showOutcomeError: false));

  void onNoteChange(String note) => emit(state.copyWith(note: note));

  /// "Resolve without assigning this plan" (or "Resolve without waiting" while generating).
  void onResolveWithoutProposal() => emit(state.copyWith(showManualResolution: true));

  /// "Resolve": saying whether the plan was adjusted is required.
  Future<void> onResolve() async {
    if (state.isBusy) return;
    final resolution = ReviewResolution.of(state.adjusted, state.note);
    if (resolution == null) {
      emit(state.copyWith(showOutcomeError: true));
      return;
    }
    emit(state.copyWith(isResolving: true));
    final result = await _resolveReviewItem(reviewItemId, resolution);
    if (isClosed) return;
    emit(state.copyWith(isResolving: false));
    switch (result.errorOrNull) {
      case null:
        _events.emit(ReviewResolved(result.valueOrNull?.patientFullName ?? state.item?.patientFullName));
      case Validation(:final code) when code == _resolutionOutcomeRequired:
        emit(state.copyWith(showOutcomeError: true));
      case NotFound() || Forbidden():
        _showDialog(ReviewDialog.notAvailable);
      default:
        _showServerError(_Action.resolve);
    }
  }

  /// "Resolve" on the proposal: assigns the proposed plan as is and publishes it (explicit practitioner action).
  Future<void> onAcceptAsIs() async {
    if (state.isBusy || state.proposal is! ProposalLoaded) return;
    emit(state.copyWith(isAccepting: true));
    final result = await _acceptPlanProposal(reviewItemId, const AcceptAsIs());
    if (isClosed) return;
    emit(state.copyWith(isAccepting: false));
    final error = result.errorOrNull;
    if (error == null) {
      _events.emit(ReviewResolved(result.valueOrNull?.reviewItem.patientFullName ?? state.item?.patientFullName));
    } else {
      _onAcceptFailed(error);
    }
  }

  /// "Adjust" -> the adjust screen with everything prefilled.
  void onAdjust() {
    if (state.isBusy) return;
    _events.emit(OpenAdjust(reviewItemId));
  }

  /// "Adjust the plan now": opens the patient file (the care link is looked up in the roster).
  Future<void> onAdjustPlanNow() async {
    final item = state.item;
    if (item == null || state.isBusy) return;
    emit(state.copyWith(isOpeningPatient: true));
    final result = await _findActiveRosterPatient(item.patientId.value);
    if (isClosed) return;
    emit(state.copyWith(isOpeningPatient: false));
    final error = result.errorOrNull;
    final patient = result.valueOrNull;
    if (error != null) {
      _showServerError(_Action.openPatient);
    } else if (patient == null) {
      _showDialog(ReviewDialog.noActiveLink);
    } else {
      _events.emit(
        OpenPatientFile(patientId: patient.patientId, careLinkId: patient.careLinkId.value, patientName: patient.fullName),
      );
    }
  }

  void onDialogConfirmed() {
    final dialog = state.dialog;
    emit(state.copyWith(dialog: null));
    switch (dialog) {
      case ReviewDialog.notAvailable || ReviewDialog.alreadyResolved:
        _events.emit(const CloseReviewItem());
      case ReviewDialog.planChanged:
        _load();
      case ReviewDialog.serverError:
        switch (_failedAction) {
          case _Action.resolve:
            onResolve();
          case _Action.accept:
            onAcceptAsIs();
          case _Action.openPatient:
            onAdjustPlanNow();
          case null:
            break;
        }
      case ReviewDialog.noActiveLink || null:
        break;
    }
  }

  void onDialogDismissed() => emit(state.copyWith(dialog: null));

  Future<void> _load() async {
    final loadId = ++_loadId;
    await _proposal?.cancel();
    emit(state.copyWith(isLoading: true, loadError: null));
    final result = await _getOpenReviewItem(reviewItemId);
    if (isClosed || loadId != _loadId) return;
    final found = result.valueOrNull;
    if (found == null) {
      emit(
        state.copyWith(
          isLoading: false,
          loadError: result.isSuccess
              ? ReviewLoadError.notAvailable
              : (result.errorOrNull is Network ? ReviewLoadError.offline : ReviewLoadError.generic),
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        isLoading: false,
        item: found,
        proposal: found.offersPlanProposal ? const ProposalPreparing() : const ProposalNotOffered(),
        showManualResolution: false,
      ),
    );
    if (found.offersPlanProposal) _watchProposal(loadId);
  }

  /// `202` -> "the AI is preparing..." and retries after `Retry-After`; `404` or a failure -> the plain review item.
  void _watchProposal(int loadId) {
    _proposal = _awaitPlanProposal(reviewItemId).listen((result) {
      if (isClosed || loadId != _loadId) return;
      final lookup = result.valueOrNull;
      final section = switch (lookup) {
        ProposalReady(:final proposal) => proposal.canBeAccepted ? ProposalLoaded(proposal) : const ProposalNotOffered(),
        ProposalGenerating() => const ProposalPreparing(),
        NoProposal() || null => const ProposalNotOffered(),
      };
      emit(state.copyWith(proposal: section));
    });
  }

  void _onAcceptFailed(DomainError error) {
    switch (error) {
      case Conflict(:final code) when code == _planVersionAlreadySuperseded:
        _showDialog(ReviewDialog.planChanged);
      case Conflict(:final code) when code == _reviewItemNotSustainedDeviation:
        emit(state.copyWith(proposal: const ProposalNotOffered()));
      case Conflict():
        _showDialog(ReviewDialog.alreadyResolved);
      // The proposal is gone (purged or discarded): the item opens without AI.
      case NotFound(:final code) when code == _planProposalNotFound:
        emit(state.copyWith(proposal: const ProposalNotOffered()));
      case NotFound():
        _showDialog(ReviewDialog.notAvailable);
      case Forbidden(:final code) when code == _activeCareLinkRequired:
        _showDialog(ReviewDialog.noActiveLink);
      case Forbidden():
        _showDialog(ReviewDialog.notAvailable);
      default:
        _showServerError(_Action.accept);
    }
  }

  void _showDialog(ReviewDialog dialog) => emit(state.copyWith(dialog: dialog));

  void _showServerError(_Action action) {
    _failedAction = action;
    _showDialog(ReviewDialog.serverError);
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    await _proposal?.cancel();
    _events.close();
    return super.close();
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_link_use_cases.dart';
import '../../domain/valueobject/clinical_reason.dart';
import '../state/discharge_patient_state.dart';

const _clinicalReasonRequired = 'ClinicalReasonRequired';

/// Clinical discharge (plus confirmation). The clinical reason is **required** (a deliberate asymmetry with withdrawing
/// consent) and a discharged care link is never reactivated, so it is confirmed before sending.
class DischargePatientCubit extends Cubit<DischargePatientState> {
  DischargePatientCubit(
    this._dischargePatient,
    ConnectivityObserver connectivityObserver, {
    required this.careLinkId,
    required this.patientName,
  }) : super(const DischargePatientState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (!isClosed) emit(state.copyWith(isOffline: !online));
    });
  }

  final DischargePatientUseCase _dischargePatient;
  final int careLinkId;
  final String patientName;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<DischargePatientEvent>();

  Stream<DischargePatientEvent> get events => _events.stream;

  void onReasonChange(String value) => emit(state.copyWith(reason: value, reasonMissing: false));

  /// "Discharge": without a reason the confirmation does not open ("Write the clinical reason for the discharge").
  void onDischargeRequested() {
    if (ClinicalReason.of(state.reason) == null) {
      emit(state.copyWith(reasonMissing: true));
      return;
    }
    emit(state.copyWith(dialog: DischargeDialog.confirm));
  }

  /// "Yes, discharge" on the confirmation (or "Retry" after a network/server failure).
  Future<void> onConfirmed() async {
    final reason = ClinicalReason.of(state.reason);
    if (reason == null) {
      emit(state.copyWith(dialog: null, reasonMissing: true));
      return;
    }
    if (state.isDischarging) return;
    emit(state.copyWith(isDischarging: true));
    final result = await _dischargePatient(careLinkId, reason);
    if (isClosed) return;
    emit(state.copyWith(isDischarging: false));
    final error = result.errorOrNull;
    switch (error) {
      case null:
        emit(state.copyWith(dialog: null));
        _events.emit(Discharged(patientName));
      case Validation(:final code) when code == _clinicalReasonRequired:
        emit(state.copyWith(dialog: null, reasonMissing: true));
      case Conflict():
        emit(state.copyWith(dialog: DischargeDialog.alreadyDischarged));
      case Forbidden() || NotFound():
        emit(state.copyWith(dialog: DischargeDialog.noActiveLink));
      default:
        emit(state.copyWith(dialog: DischargeDialog.serverError));
    }
  }

  /// "This patient had already been discharged." -> returns to the roster just like a discharge.
  void onAlreadyDischargedConfirmed() {
    emit(state.copyWith(dialog: null));
    _events.emit(Discharged(patientName));
  }

  void onDialogDismissed() => emit(state.copyWith(dialog: null));

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

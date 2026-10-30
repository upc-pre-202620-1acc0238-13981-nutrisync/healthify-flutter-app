import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_agenda_use_cases.dart';
import '../../domain/entity/referral.dart';
import '../../domain/valueobject/monitoring_values.dart';
import '../state/practitioner_agenda_states.dart';

const _specialtyAndReasonRequired = 'SpecialtyAndReasonRequired';

/// Record a referral (with required-field and error states). A referral records that something was decided on a date; it
/// has no workflow. On success it returns to the patient file with a snackbar.
class RecordReferralCubit extends Cubit<RecordReferralState> {
  RecordReferralCubit(this._recordReferral, ConnectivityObserver connectivityObserver, {required this.patientId})
    : super(const RecordReferralState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (!isClosed) emit(state.copyWith(isOffline: !online));
    });
  }

  final RecordReferralUseCase _recordReferral;
  final int patientId;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<String>();

  /// The recorded specialty, once the referral is saved.
  Stream<String> get recorded => _events.stream;

  void onSpecialtyChange(String value) => emit(
    state.copyWith(
      specialty: value.length > ReferralSpecialty.maxLength ? value.substring(0, ReferralSpecialty.maxLength) : value,
      missing: {...state.missing}..remove(ReferralField.specialty),
    ),
  );

  void onReasonChange(String value) => emit(
    state.copyWith(
      reason: value.length > ReferralReason.maxLength ? value.substring(0, ReferralReason.maxLength) : value,
      missing: {...state.missing}..remove(ReferralField.reason),
    ),
  );

  /// Error "Try again": returns to the form with what was written.
  void onBackToForm() => emit(state.copyWith(failed: false));

  void onNoActiveLinkDismissed() => emit(state.copyWith(noActiveLink: false));

  /// "Record".
  Future<void> onSubmit() async {
    if (state.isSaving) return;
    final ReferralValidation validation = ReferralValidation.of(PatientId(patientId), state.specialty, state.reason);
    final NewReferral referral;
    switch (validation) {
      case InvalidReferral(:final missing):
        emit(state.copyWith(missing: missing));
        return;
      case ValidReferral(referral: final valid):
        referral = valid;
    }
    emit(state.copyWith(isSaving: true));
    final result = await _recordReferral(referral);
    if (isClosed) return;
    emit(state.copyWith(isSaving: false));
    switch (result.errorOrNull) {
      case null:
        _events.emit(referral.specialty.text);
      case Validation(:final code) when code == _specialtyAndReasonRequired:
        emit(state.copyWith(missing: const {ReferralField.specialty, ReferralField.reason}));
      case Forbidden():
        emit(state.copyWith(noActiveLink: true));
      default:
        emit(state.copyWith(failed: true));
    }
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/error/result.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_use_cases.dart';
import '../../domain/entity/consultation.dart';
import '../state/consultation_step_states.dart';

const stepOutOfOrder = 'ConsultationStepOutOfOrder';

/// `409 ConsultationNotInProgress` or `404 ConsultationNotFound`: the consultation no longer accepts steps.
bool closesConsultation(DomainError? error) =>
    error == const Conflict('ConsultationNotInProgress') || error == const NotFound('ConsultationNotFound');

/// Saved number -> field text ("74.2", "88"), the way the practitioner would type it.
String formFormat(double value) => NumberFormat('0.##', 'en').format(value);

/// Whole number text for the energy and macro fields ("1796").
String wholeFormat(double value) => value.round().toString();

/// The part every consultation step shares: the in-progress consultation it rehydrates from, the connectivity flag and
/// the one-shot events (next step, exit, back, closed). Subclasses own their state and what they do on each.
abstract class ConsultationStepCubit<S> extends Cubit<S> {
  ConsultationStepCubit(super.initialState, this._getInProgress, ConnectivityObserver connectivity, {required this.patientId}) {
    _connectivity = connectivity.isOnline.listen((online) {
      if (isClosed) return;
      onConnectivityChanged(online);
    });
  }

  final GetConsultationInProgressUseCase _getInProgress;
  final int patientId;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<ConsultationStepEvent>();

  Stream<ConsultationStepEvent> get events => _events.stream;

  /// The consultation as the last read or save left it.
  Consultation? consultation;

  void sendEvent(ConsultationStepEvent event) => _events.emit(event);

  /// Called with the first connectivity reading and with every change afterwards.
  void onConnectivityChanged(bool online);

  /// Reads the in-progress consultation. A failure is returned for the subclass to put in its load state; `null` in the
  /// success means there is none anymore (it was published or discarded), and the step is already told to close.
  Future<Result<Consultation?>> readInProgress() async {
    final result = await _getInProgress(patientId);
    if (isClosed) return result;
    if (result.valueOrNull == null && result.isSuccess) sendEvent(const StepConsultationClosed());
    return result;
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

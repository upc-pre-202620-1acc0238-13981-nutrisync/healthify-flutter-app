import 'dart:async';

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../carerelationship/application/usecase/practitioner_care_link_use_cases.dart';
import '../../../iam/application/usecase/session_use_cases.dart';
import '../../application/usecase/practitioner_agenda_use_cases.dart';
import '../../domain/entity/practitioner_agenda.dart';
import '../../domain/valueobject/monitoring_values.dart';
import '../state/practitioner_agenda_states.dart';

const _scheduledFollowUpNotFound = 'ScheduledFollowUpNotFound';
const _patientAlreadyHasFollowUp = 'PatientAlreadyHasActiveScheduledFollowUp';

/// Schedule a visit (with its validation and error states) and reschedule from the Agenda. Date and time must be in the
/// future: checked on the phone with [FollowUpMoment] before sending and again by the backend
/// (`400 ScheduledForMustBeInFuture`; older backends answered `404 ScheduledFollowUpNotFound`, read the same way).
///
/// The frame has no modality field, so visits are scheduled in person (the backend default). Without a fixed patient, the
/// "Patient" field picks from the roster (active care links). Offline or on a server error -> the error state.
class ScheduleFollowUpCubit extends Cubit<ScheduleFollowUpState> {
  ScheduleFollowUpCubit(
    this._scheduleFollowUp,
    this._rescheduleFollowUp,
    this._getPatientRoster,
    this._observeCurrentUser,
    ConnectivityObserver connectivityObserver,
    this._now, {
    required ScheduleFollowUpArgs args,
  }) : super(_initialState(args)) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (!isClosed) emit(state.copyWith(isOffline: !online));
    });
    if (!state.patientFixed) _loadPatients();
  }

  final ScheduleFollowUpUseCase _scheduleFollowUp;
  final RescheduleFollowUpUseCase _rescheduleFollowUp;
  final GetPatientRosterUseCase _getPatientRoster;
  final ObserveCurrentUserUseCase _observeCurrentUser;
  final DateTime Function() _now;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<FollowUpSaved>();

  Stream<FollowUpSaved> get events => _events.stream;

  /// Today in the phone's time zone: the first selectable day.
  DateTime get today {
    final now = _now();
    return DateTime(now.year, now.month, now.day);
  }

  /// The "Patient" field was tapped: the roster is read again if the first read did not come through.
  void onPatientFieldClick() {
    if (state.patientFixed) return;
    if (state.patients == null && !state.isLoadingPatients) _loadPatients();
  }

  void onPatientSelected(PatientOption option) => emit(state.copyWith(patient: option, patientError: null));

  void onDateSelected(DateTime date) =>
      emit(state.copyWith(date: DateTime(date.year, date.month, date.day), momentError: null));

  void onTimeSelected(TimeOfDay time) => emit(state.copyWith(time: time, momentError: null));

  void onPreparationToggle(PreparationCode code, bool selected) =>
      emit(state.copyWith(preparation: selected ? {...state.preparation, code} : ({...state.preparation}..remove(code))));

  /// Error "Try again": returns to the form with what was written.
  void onBackToForm() => emit(state.copyWith(failed: false));

  /// "Schedule".
  Future<void> onSubmit() async {
    if (state.isSaving) return;
    final time = state.time;
    final moment = FollowUpMoment.of(state.date, time == null ? null : (hour: time.hour, minute: time.minute), _now());
    final patient = state.patient;
    if (moment is! ValidMoment || patient == null) {
      emit(
        state.copyWith(
          momentError: switch (moment) {
            IncompleteMoment() => ScheduleMomentError.missing,
            MomentNotInFuture() => ScheduleMomentError.notInFuture,
            ValidMoment() => null,
          },
          patientError: patient == null ? SchedulePatientError.missing : null,
        ),
      );
      return;
    }
    emit(state.copyWith(isSaving: true, momentError: null, patientError: null));
    final preparation = FollowUpPreparation(state.preparation);
    final rescheduleId = state.rescheduleId;
    final result = rescheduleId != null
        ? await _rescheduleFollowUp(rescheduleId, moment.instant, preparation)
        : await _scheduleFollowUp(
            NewFollowUp(patientId: PatientId(patient.patientId), scheduledFor: moment.instant, preparation: preparation),
          );
    if (isClosed) return;
    emit(state.copyWith(isSaving: false));
    final error = result.errorOrNull;
    if (error == null) {
      _events.emit(FollowUpSaved(scheduledFor: result.valueOrNull!.scheduledFor, rescheduled: rescheduleId != null));
    } else {
      _onFailed(error, rescheduling: rescheduleId != null);
    }
  }

  void _onFailed(DomainError error, {required bool rescheduling}) {
    switch (error) {
      case Validation(:final code) when code == scheduledForMustBeInFuture:
        emit(state.copyWith(momentError: ScheduleMomentError.notInFuture));
      // Older backends answered a past date with 404 ScheduledFollowUpNotFound (the 404 is never shown).
      case NotFound(:final code) when !rescheduling && code == _scheduledFollowUpNotFound:
        emit(state.copyWith(momentError: ScheduleMomentError.notInFuture));
      case Conflict(:final code) when code == _patientAlreadyHasFollowUp:
        emit(state.copyWith(patientError: SchedulePatientError.alreadyScheduled));
      case Forbidden():
        emit(state.copyWith(patientError: SchedulePatientError.noActiveLink));
      default:
        emit(state.copyWith(failed: true));
    }
  }

  Future<void> _loadPatients() async {
    emit(state.copyWith(isLoadingPatients: true));
    final user = await _observeCurrentUser().first;
    final roster = user == null ? null : (await _getPatientRoster(user.id.value)).valueOrNull;
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoadingPatients: false,
        patients: roster == null
            ? state.patients
            : [
                for (final patient in roster.patients)
                  if (patient.isLinkActive) PatientOption(patientId: patient.patientId, fullName: patient.fullName),
              ],
      ),
    );
  }

  static ScheduleFollowUpState _initialState(ScheduleFollowUpArgs args) {
    final fixed = args.patientId > 0;
    // When rescheduling, the previous date and time are the starting point (in the phone's time zone).
    final previous = args.followUpId > 0 ? args.scheduledFor?.toLocal() : null;
    return ScheduleFollowUpState(
      patient: fixed ? PatientOption(patientId: args.patientId, fullName: args.patientName) : null,
      patientFixed: fixed,
      date: previous == null ? null : DateTime(previous.year, previous.month, previous.day),
      time: previous == null ? null : TimeOfDay(hour: previous.hour, minute: previous.minute),
      preparation: args.preparation,
      rescheduleId: args.followUpId > 0 ? args.followUpId : null,
    );
  }

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

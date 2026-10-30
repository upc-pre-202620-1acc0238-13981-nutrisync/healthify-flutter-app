import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/practitioner_care_link_use_cases.dart';
import '../../domain/entity/issued_invitation.dart';
import '../../domain/valueobject/invitation_validity.dart';
import '../state/invite_patient_state.dart';

const _expirationDateRequired = 'ExpirationDateRequired';
const _countdownTick = Duration(seconds: 1);

/// Generate invitation. On entry it issues a code with the default validity (24 h, as in the design); the countdown is
/// recomputed every second with the phone's clock. "Generate another code" issues a new one: the previous one stays
/// valid until it expires.
///
/// Changing "Expires in" issues a new code with that validity (the one already shown cannot change).
class InvitePatientCubit extends Cubit<InvitePatientState> {
  InvitePatientCubit(
    this._issueInvitation,
    ConnectivityObserver connectivityObserver,
    this._now, {
    this._tick = _countdownTick,
  }) : super(const InvitePatientState()) {
    var first = true;
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (isClosed) return;
      emit(state.copyWith(isOffline: !online));
      if (!first) return;
      first = false;
      // Offline on entry, no attempt is made: the error from the design notes is shown.
      if (online) {
        onGenerateAnother();
      } else {
        emit(state.copyWith(isGenerating: false, error: InviteError.offline));
      }
    });
  }

  final IssueInvitationUseCase _issueInvitation;
  final DateTime Function() _now;
  final Duration _tick;

  late final StreamSubscription<bool> _connectivity;
  Timer? _countdown;
  bool _issuing = false;

  /// "Generate another code" and retry after an error.
  Future<void> onGenerateAnother() async {
    if (_issuing) return;
    _issuing = true;
    emit(state.copyWith(isGenerating: true, error: null));
    final result = await _issueInvitation(state.validity);
    _issuing = false;
    if (isClosed) return;
    result.fold((issued) {
      emit(state.copyWith(isGenerating: false, token: issued.token, isExpired: false, error: null));
      _startCountdown(issued);
    }, (error) => emit(state.copyWith(isGenerating: false, error: _inviteError(error))));
  }

  Future<void> onValidityChange(InvitationValidity validity) {
    if (validity == state.validity && state.token != null) return Future.value();
    emit(state.copyWith(validity: validity));
    return onGenerateAnother();
  }

  InviteError _inviteError(DomainError error) => switch (error) {
    Network() => InviteError.offline,
    Validation(:final code) when code == _expirationDateRequired => InviteError.expirationRequired,
    _ => InviteError.generic,
  };

  void _startCountdown(IssuedInvitation issued) {
    _countdown?.cancel();
    void tick() {
      final now = _now();
      final expired = issued.isExpired(now);
      emit(state.copyWith(remaining: issued.remaining(now), isExpired: expired));
      if (expired) _countdown?.cancel();
    }

    tick();
    if (!state.isExpired) _countdown = Timer.periodic(_tick, (_) => tick());
  }

  @override
  Future<void> close() async {
    _countdown?.cancel();
    await _connectivity.cancel();
    return super.close();
  }
}

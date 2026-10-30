import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/one_shot_events.dart';
import '../../application/usecase/sign_out_use_case.dart';
import '../state/practitioner_only_state.dart';

/// Patient accounts are not served by this app: the only action is signing out.
class PractitionerOnlyCubit extends Cubit<PractitionerOnlyState> {
  PractitionerOnlyCubit(this._signOut) : super(const PractitionerOnlyState());

  final SignOutUseCase _signOut;
  final _events = OneShotEvents<PractitionerOnlyEvent>();

  Stream<PractitionerOnlyEvent> get events => _events.stream;

  Future<void> onSignOut() async {
    if (state.isSigningOut) return;
    emit(state.copyWith(isSigningOut: true));
    await _signOut();
    if (isClosed) return;
    emit(state.copyWith(isSigningOut: false));
    _events.emit(const PractitionerOnlySignedOut());
  }

  @override
  Future<void> close() async {
    _events.close();
    return super.close();
  }
}

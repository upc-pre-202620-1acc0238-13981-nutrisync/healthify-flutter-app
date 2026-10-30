import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/one_shot_events.dart';
import '../../../iam/application/usecase/sign_out_use_case.dart';
import '../state/sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit(this._signOut) : super(const SignOutState());

  final SignOutUseCase _signOut;
  final _events = OneShotEvents<SignOutEvent>();

  Stream<SignOutEvent> get events => _events.stream;

  Future<void> onSignOut() async {
    if (state.isSigningOut) return;
    emit(state.copyWith(isSigningOut: true));
    await _signOut();
    if (isClosed) return;
    emit(state.copyWith(isSigningOut: false));
    _events.emit(const SignedOut());
  }

  @override
  Future<void> close() async {
    _events.close();
    return super.close();
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/one_shot_events.dart';
import '../../../iam/application/usecase/session_use_cases.dart';
import '../../../monitoring/application/usecase/consultation_reminder_use_cases.dart';
import '../state/practitioner_shell_state.dart';

/// Practitioner shell: the main menu (menu button on the tabs) with the session user's name, the same one Settings uses.
/// Messages other screens leave for the shell come out through [messages].
/// On entering, it asks for the notification permission and reschedules the consultation reminders (the agenda may
/// have changed from another phone).
class PractitionerShellCubit extends Cubit<PractitionerShellState> {
  PractitionerShellCubit(
    ObserveCurrentUserUseCase observeCurrentUser,
    PractitionerShellMessages bus,
    ConsultationRemindersSync reminders,
  ) : super(const PractitionerShellState()) {
    _user = observeCurrentUser().listen((user) {
      if (isClosed) return;
      emit(
        state.copyWith(
          fullName: user?.name.fullName ?? '',
          avatarInitial: user?.name.initial ?? '',
        ),
      );
    });
    _bus = bus.stream.listen(_messages.emit);
    unawaited(reminders.onShellEntered());
  }

  late final StreamSubscription<Object?> _user;
  late final StreamSubscription<PractitionerShellMessage> _bus;
  final _messages = OneShotEvents<PractitionerShellMessage>();

  Stream<PractitionerShellMessage> get messages => _messages.stream;

  void onOpenMenu() => emit(state.copyWith(isMenuOpen: true));

  void onCloseMenu() => emit(state.copyWith(isMenuOpen: false));

  @override
  Future<void> close() async {
    await _user.cancel();
    await _bus.cancel();
    _messages.close();
    return super.close();
  }
}

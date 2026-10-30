import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../iam/application/usecase/account_use_cases.dart';
import '../../../iam/application/usecase/session_use_cases.dart';
import '../../../iam/domain/valueobject/preferred_language.dart';
import '../state/practitioner_settings_state.dart';

/// Practitioner settings: My account, Language and Sign out. The language is applied on tap and then saved to the
/// account; if that fails (offline, 5xx) it is retried when the connection comes back while Settings is still open.
/// Only the UI changes: clinical data and notes are not translated.
class PractitionerSettingsCubit extends Cubit<PractitionerSettingsState> {
  PractitionerSettingsCubit(
    ObserveCurrentUserUseCase observeCurrentUser,
    this._getAppLanguage,
    this._applyAppLanguage,
    this._changePreferredLanguage,
    ConnectivityObserver connectivityObserver,
  ) : super(PractitionerSettingsState(language: _getAppLanguage())) {
    _user = observeCurrentUser().listen((user) {
      if (isClosed || user == null) return;
      emit(state.copyWith(fullName: user.name.fullName, email: user.email.value));
    });
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (isClosed) return;
      final wasOffline = state.isOffline;
      emit(state.copyWith(isOffline: !online));
      final pending = _pendingAccountLanguage;
      if (online && wasOffline && pending != null) unawaited(_saveAccountLanguage(pending));
    });
  }

  final GetAppLanguageUseCase _getAppLanguage;
  final ApplyAppLanguageUseCase _applyAppLanguage;
  final ChangePreferredLanguageUseCase _changePreferredLanguage;

  late final StreamSubscription<Object?> _user;
  late final StreamSubscription<bool> _connectivity;

  /// Chosen language the account has not saved yet.
  PreferredLanguage? _pendingAccountLanguage;

  /// The language may have changed from another screen while this one was underneath.
  void onResume() => emit(state.copyWith(language: _getAppLanguage()));

  /// Applied right away; the sheet closes itself.
  Future<void> onLanguageSelected(PreferredLanguage language) async {
    emit(state.copyWith(language: language));
    await _applyAppLanguage(language);
    if (isClosed) return;
    await _saveAccountLanguage(language);
  }

  Future<void> _saveAccountLanguage(PreferredLanguage language) async {
    final saved = (await _changePreferredLanguage(language)).isSuccess;
    _pendingAccountLanguage = saved ? null : language;
  }

  @override
  Future<void> close() async {
    await _user.cancel();
    await _connectivity.cancel();
    return super.close();
  }
}

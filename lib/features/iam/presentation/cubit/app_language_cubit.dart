import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/usecase/account_use_cases.dart';
import '../../application/usecase/session_use_cases.dart';
import '../../domain/valueobject/preferred_language.dart';

/// In-app language switch. Applying the language is local and immediate (it updates the root `Locale` and the
/// `Accept-Language` header, also offline); saving it to the account is best effort and only when someone is signed in.
class AppLanguageCubit extends Cubit<PreferredLanguage> {
  AppLanguageCubit(
    GetAppLanguageUseCase getAppLanguage,
    this._applyAppLanguage,
    this._changePreferredLanguage,
    this._observeIsLoggedIn,
  ) : super(getAppLanguage());

  final ApplyAppLanguageUseCase _applyAppLanguage;
  final ChangePreferredLanguageUseCase _changePreferredLanguage;
  final ObserveIsLoggedInUseCase _observeIsLoggedIn;

  Future<void> onSelect(PreferredLanguage language) async {
    if (language == state) return;
    await _applyAppLanguage(language);
    if (isClosed) return;
    emit(language);
    if (await _observeIsLoggedIn().first) await _changePreferredLanguage(language);
  }
}

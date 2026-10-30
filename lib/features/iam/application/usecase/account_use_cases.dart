import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/error/result.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/repository/app_language_repository.dart';
import '../../domain/repository/session_repository.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/valueobject/preferred_language.dart';
import '../../domain/valueobject/user_id.dart';

/// Saves the language to the signed-in user's account.
class ChangePreferredLanguageUseCase {
  const ChangePreferredLanguageUseCase(this._sessionRepository, this._userRepository);

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  Future<Result<void>> call(PreferredLanguage language) async {
    final user = await _sessionRepository.currentUser.first;
    if (user == null) return const Result.failure(Unauthorized());
    if (user.preferredLanguage == language) return const Result.success(null);
    return _userRepository.changePreferredLanguage(user.id, language);
  }
}

/// Day the account was created: nothing before that day belongs to this person (the date pickers' lower bound).
class GetAccountCreatedOnUseCase {
  const GetAccountCreatedOnUseCase(this._accountRepository);

  final AccountRepository _accountRepository;

  Future<Result<DateTime>> call(UserId userId) => _accountRepository.getCreatedOn(userId);
}

/// The language the app is shown in right now.
class GetAppLanguageUseCase {
  const GetAppLanguageUseCase(this._appLanguage);

  final AppLanguageRepository _appLanguage;

  PreferredLanguage call() => _appLanguage.current();
}

/// Applies the language on the phone right away (UI only; clinical data is never translated).
/// Saving it to the account is separate ([ChangePreferredLanguageUseCase]): the app still switches language offline.
class ApplyAppLanguageUseCase {
  const ApplyAppLanguageUseCase(this._appLanguage);

  final AppLanguageRepository _appLanguage;

  /// `false` if that language was already active (nothing to apply).
  Future<bool> call(PreferredLanguage language) async {
    if (_appLanguage.current() == language) return false;
    await _appLanguage.apply(language);
    return true;
  }
}

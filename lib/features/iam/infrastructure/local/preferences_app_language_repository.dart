import '../../../../core/network/app_language_provider.dart';
import '../../domain/repository/app_language_repository.dart';
import '../../domain/valueobject/preferred_language.dart';

/// The app's language, the same one sent in `Accept-Language`: changing it updates the root `Locale`.
class PreferencesAppLanguageRepository implements AppLanguageRepository {
  const PreferencesAppLanguageRepository(this._provider);

  final PreferencesAppLanguageProvider _provider;

  @override
  PreferredLanguage current() => PreferredLanguage.fromCode(_provider.currentLanguage());

  @override
  Future<void> apply(PreferredLanguage language) => _provider.setLanguage(language.code);
}

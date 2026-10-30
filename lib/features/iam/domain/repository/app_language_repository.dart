import '../valueobject/preferred_language.dart';

/// UI language on this phone. Clinical data is never translated: only the UI.
abstract interface class AppLanguageRepository {
  PreferredLanguage current();

  /// Applies the language in the app right away (the phone stores it).
  Future<void> apply(PreferredLanguage language);
}

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language the app shows its texts in, as the backend understands it: `es` or `en`.
abstract interface class AppLanguageProvider {
  String currentLanguage();
}

const defaultLanguage = 'es';

/// Resources exist only in Spanish (base) and English, so any other language reads as Spanish.
String toSupportedLanguage(String? languageCode) => languageCode == 'en' ? 'en' : defaultLanguage;

/// Per-app language: the stored choice and, if there is none, the system's. Only a language code is stored.
class PreferencesAppLanguageProvider implements AppLanguageProvider {
  PreferencesAppLanguageProvider(this._preferences, {required String Function() systemLanguage})
    : _systemLanguage = systemLanguage,
      _language = ValueNotifier(toSupportedLanguage(_preferences.getString(_key) ?? systemLanguage()));

  static const _key = 'app_language';

  final SharedPreferences _preferences;
  final String Function() _systemLanguage;
  final ValueNotifier<String> _language;

  /// Lets the root widget rebuild with the new locale when the user changes it.
  ValueListenable<String> get language => _language;

  @override
  String currentLanguage() => _language.value;

  Future<void> setLanguage(String languageCode) async {
    final code = toSupportedLanguage(languageCode);
    await _preferences.setString(_key, code);
    _language.value = code;
  }

  /// Forgets the choice and goes back to the system language.
  Future<void> useSystemLanguage() async {
    await _preferences.remove(_key);
    _language.value = toSupportedLanguage(_systemLanguage());
  }
}

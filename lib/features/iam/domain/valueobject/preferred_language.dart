/// Preferred account language. The backend only accepts `es` and `en`; `es` is the default.
enum PreferredLanguage {
  spanish('es'),
  english('en');

  const PreferredLanguage(this.code);

  static const defaultLanguage = PreferredLanguage.spanish;

  final String code;

  static PreferredLanguage fromCode(String? code) {
    final normalized = code?.trim().toLowerCase();
    for (final language in values) {
      if (language.code == normalized) return language;
    }
    return defaultLanguage;
  }
}

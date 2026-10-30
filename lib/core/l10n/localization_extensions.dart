import 'dart:ui' show Locale;

import 'app_localizations.dart';

/// Separator between the parts of a supporting line ("Plan version 3 · in your roster since…").
const textSeparator = ' · ';

/// Placeholder for a value that is not there yet.
const valueMissing = '—';

extension AppLocalizationsLocale on AppLocalizations {
  /// The language the texts are in, for the date and number formatters.
  Locale get locale => Locale(localeName);
}

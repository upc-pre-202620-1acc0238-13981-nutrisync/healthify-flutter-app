import 'dart:ui' show Locale;

import 'package:intl/intl.dart';

// Dates and times in the app language and the phone's time zone (intl + the given Locale, no concatenation).
// Formatting only: no business rules. The locale's date symbols must be initialized (the Material localizations
// delegate does it in the app; tests call `initializeDateFormatting`).

/// «4 sept 2026» / «Sep 4, 2026».
String mediumDateText(DateTime instant, Locale locale) =>
    DateFormat.yMMMd(locale.toLanguageTag()).format(instant.toLocal());

/// «4 sept» / «Sep 4»: the day and month, for dates inside a sentence.
String dayMonthText(DateTime date, Locale locale) => DateFormat.MMMd(locale.toLanguageTag()).format(date.toLocal());

/// «8:10 a. m.» / «8:10 AM».
String shortTimeText(DateTime instant, Locale locale) =>
    DateFormat.jm(locale.toLanguageTag()).format(instant.toLocal());

/// «Jue 18 sept.» / «Thu, Sep 18»: abbreviated weekday, capitalized.
String weekdayDayMonthText(DateTime instant, Locale locale) {
  final tag = locale.toLanguageTag();
  final pattern = locale.languageCode == 'en' ? 'EEE, MMM d' : 'EEE d MMM';
  final text = DateFormat(pattern, tag).format(instant.toLocal());
  return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

/// Whether [instant] falls on today in the phone's time zone.
bool isToday(DateTime instant, {DateTime? now}) {
  final local = instant.toLocal();
  final today = (now ?? DateTime.now()).toLocal();
  return local.year == today.year && local.month == today.month && local.day == today.day;
}

/// «Jueves» / «Thursday»: the full weekday, capitalized.
String weekdayText(DateTime instant, Locale locale) {
  final text = DateFormat.EEEE(locale.toLanguageTag()).format(instant.toLocal());
  return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

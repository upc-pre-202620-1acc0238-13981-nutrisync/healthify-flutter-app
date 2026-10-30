import 'dart:ui' show Locale;

import 'package:intl/intl.dart';

// Numbers in the app language ("74,2" in Spanish, "74.2" in English). Formatting only: no business rules.

/// Always [decimals] decimals ("168,0").
String decimalText(double value, Locale locale, {int decimals = 1}) =>
    NumberFormat.decimalPatternDigits(locale: locale.toLanguageTag(), decimalDigits: decimals).format(value);

/// Up to [maxDecimals] decimals, without trailing zeros ("168", not "168,0"; "74,25" stays).
String compactText(double value, Locale locale, {int maxDecimals = 1}) {
  final format = NumberFormat.decimalPattern(locale.toLanguageTag())
    ..minimumFractionDigits = 0
    ..maximumFractionDigits = maxDecimals;
  return format.format(value);
}

/// "−0,3" / "+0,3" / "0,0": one decimal with the typographic sign.
String signedDecimalText(double value, Locale locale) {
  final sign = value < 0 ? '−' : (value > 0 ? '+' : '');
  return '$sign${decimalText(value.abs(), locale)}';
}

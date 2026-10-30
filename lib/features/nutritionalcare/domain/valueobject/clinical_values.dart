import 'dart:math';

import 'clinical_codes.dart';

/// Parses a number typed by the practitioner: decimal comma or point ("74,2" or "74.2"). `null` if not a number.
abstract final class DecimalText {
  static double? parse(String text) {
    final normalized = text.trim().replaceAll(',', '.');
    if (normalized.isEmpty || '.'.allMatches(normalized).length > 1) return null;
    if (!RegExp(r'^[0-9.]+$').hasMatch(normalized)) return null;
    return double.tryParse(normalized);
  }

  /// Rounds half up on the number as it is written ("1.005" -> 1.01), not on its binary expansion.
  static double round(double value, int decimals) {
    final written = value.toString();
    if (written.contains('e') || written.contains('E')) return value;
    return double.parse('${written}e$decimals').roundToDouble() / double.parse('1e$decimals');
  }
}

/// Result of reading a numeric field with a backend range.
sealed class NumberInput {
  const NumberInput();
}

final class ValidNumber extends NumberInput {
  const ValidNumber(this.value);

  final double value;
}

final class EmptyNumber extends NumberInput {
  const EmptyNumber();
}

final class OutOfRangeNumber extends NumberInput {
  const OutOfRangeNumber();
}

/// Backend plausibility ranges: height (`HeightCm`), measurement (`ImplausibleMeasurement`), habits (`EatingHabits`) and
/// biochemistry (`BiochemistryPanel`). The phone applies them before sending (fail fast).
enum ClinicalRange {
  heightCm(50, 250, 1),
  weightKg(20, 350, 2),
  waistCm(40, 200, 1),
  bodyFatPercent(3, 70, 1),
  mealsPerDay(1, 10, 0),
  waterLitersPerDay(0, 10, 2),
  mealsOutPerWeek(0, 21, 0),
  glucoseMgDl(20, 600, 1),
  totalCholesterolMgDl(50, 500, 1),
  triglyceridesMgDl(20, 2000, 1);

  const ClinicalRange(this.minimum, this.maximum, this.decimals);

  final double minimum;
  final double maximum;
  final int decimals;

  bool contains(double value) => value >= minimum && value <= maximum;

  /// Empty text is [EmptyNumber]; text that is not a number or is out of range is [OutOfRangeNumber].
  NumberInput parse(String text) {
    if (text.trim().isEmpty) return const EmptyNumber();
    final value = DecimalText.parse(text);
    if (value == null) return const OutOfRangeNumber();
    if (decimals == 0 && value != value.floorToDouble()) return const OutOfRangeNumber();
    return contains(value) ? ValidNumber(DecimalText.round(value, decimals)) : const OutOfRangeNumber();
  }
}

/// Fixed baseline height: 50-250 cm with 1 decimal. It is not asked again at each consultation.
extension type const HeightCm._(double value) {
  /// Throws [ArgumentError] if [value] is outside 50-250 cm.
  factory HeightCm(double value) {
    if (!ClinicalRange.heightCm.contains(value)) {
      throw ArgumentError.value(value, 'value', 'Height must be between 50 and 250 cm');
    }
    return HeightCm._(value);
  }
}

/// Baseline birth date: between 1 and 120 years before [today]. Age is calculated on the fly (exact birthday), never
/// stored. Both are calendar dates (midnight, no time of day).
final class BirthDate {
  /// Throws [ArgumentError] if the date is not plausible.
  BirthDate(this.value, this.today) {
    if (!isPlausible(value, today)) {
      throw ArgumentError.value(value, 'value', 'Birth date must be between 1 and 120 years ago');
    }
  }

  final DateTime value;
  final DateTime today;

  int get ageYears => ageOn(value, today);

  static bool isPlausible(DateTime date, DateTime today) =>
      !date.isAfter(_yearsBefore(today, 1)) && !date.isBefore(_yearsBefore(today, 120));

  /// Whole years completed on [today] (the birthday counts on its day).
  static int ageOn(DateTime date, DateTime today) {
    var years = today.year - date.year;
    if (today.month < date.month || (today.month == date.month && today.day < date.day)) years--;
    return years;
  }

  // Like `LocalDate.minusYears`: Feb 29 minus a non-leap number of years lands on Feb 28.
  static DateTime _yearsBefore(DateTime date, int years) {
    final year = date.year - years;
    final lastDay = DateTime(year, date.month + 1, 0).day;
    return DateTime(year, date.month, date.day > lastDay ? lastDay : date.day);
  }

  @override
  bool operator ==(Object other) => other is BirthDate && other.value == value && other.today == today;

  @override
  int get hashCode => Object.hash(value, today);
}

/// Id of a guided consultation (`ConsultationResource.consultationId`).
extension type const ConsultationId._(int value) {
  /// Throws [ArgumentError] if [value] is not positive.
  factory ConsultationId(int value) {
    if (value <= 0) throw ArgumentError.value(value, 'value', 'ConsultationId must be positive');
    return ConsultationId._(value);
  }
}

/// Patient id in NutritionalCare: the `userId` of their account (the backend compares it with the token).
extension type const PatientId._(int value) {
  /// Throws [ArgumentError] if [value] is not positive.
  factory PatientId(int value) {
    if (value <= 0) throw ArgumentError.value(value, 'value', 'PatientId must be positive');
    return PatientId._(value);
  }
}

/// BMI calculated live on the measurement step: weight / height^2, 1 decimal (rounded away from zero like the backend).
final class BodyMassIndex {
  /// Throws [ArgumentError] if [value] is not positive.
  BodyMassIndex(this.value) {
    if (value <= 0) throw ArgumentError.value(value, 'value', 'BMI must be positive');
  }

  /// Throws [ArgumentError] if weight or height is not positive.
  factory BodyMassIndex.of(double weightKg, double heightCm) {
    if (weightKg <= 0 || heightCm <= 0) throw ArgumentError('Weight and height must be positive');
    final meters = heightCm / 100;
    return BodyMassIndex(DecimalText.round(weightKg / (meters * meters), 1));
  }

  final double value;

  DiagnosisCode get category => DiagnosisCode.forBmi(value);
}

/// Required reason when entering own values on the targets step (`OverrideReasonRequired`): 1-500 characters.
final class OverrideReason {
  static const maxLength = 500;

  /// Throws [ArgumentError] if [value] is blank or longer than [maxLength] once trimmed.
  OverrideReason(this.value) {
    if (value.trim().isEmpty) throw ArgumentError.value(value, 'value', 'An override reason is required');
    if (value.trim().length > maxLength) {
      throw ArgumentError.value(value, 'value', 'An override reason has at most $maxLength characters');
    }
  }

  final String value;

  @override
  bool operator ==(Object other) => other is OverrideReason && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// "Other guideline": practitioner text of 3 to 140 characters; shown as is, never translated.
final class CustomGuidelineText {
  static const minLength = 3;
  static const maxLength = 140;

  /// Maximum custom guidelines per plan version.
  static const maxPerVersion = 5;

  /// Throws [ArgumentError] unless the trimmed [text] has 3 to 140 characters.
  CustomGuidelineText(this.text) {
    if (!hasValidLength(text)) throw ArgumentError.value(text, 'text', 'A custom guideline has 3 to 140 characters');
  }

  final String text;

  static bool hasValidLength(String text) {
    final length = text.trim().length;
    return length >= minLength && length <= maxLength;
  }

  @override
  bool operator ==(Object other) => other is CustomGuidelineText && other.text == text;

  @override
  int get hashCode => text.hashCode;
}

/// The version's message to the patient: up to 500 characters; empty = no message.
final class PatientMessage {
  static const maxLength = 500;

  /// Throws [ArgumentError] if [text] is blank or longer than [maxLength] once trimmed.
  PatientMessage(this.text) {
    if (text.trim().isEmpty) throw ArgumentError.value(text, 'text', 'A message cannot be empty');
    if (text.trim().length > maxLength) {
      throw ArgumentError.value(text, 'text', 'A message has at most $maxLength characters');
    }
  }

  final String text;

  static PatientMessage? ofOptional(String? text) {
    final trimmed = text?.trim();
    return trimmed == null || trimmed.isEmpty ? null : PatientMessage(trimmed);
  }

  @override
  bool operator ==(Object other) => other is PatientMessage && other.text == text;

  @override
  int get hashCode => text.hashCode;
}

/// Publication `Idempotency-Key`: visible ASCII, 1-64 characters. Generated once per consultation and reused on every
/// retry, so a timeout followed by "Try again" never publishes two versions.
final class IdempotencyKey {
  static const maxLength = 64;

  /// Throws [ArgumentError] if [value] is empty, too long or not visible ASCII.
  IdempotencyKey(this.value) {
    if (value.isEmpty || value.length > maxLength) {
      throw ArgumentError.value(value, 'value', 'An idempotency key has 1 to $maxLength characters');
    }
    if (!value.codeUnits.every((unit) => unit >= 0x21 && unit <= 0x7e)) {
      throw ArgumentError.value(value, 'value', 'An idempotency key holds visible ASCII only');
    }
  }

  /// A random version-4 UUID.
  factory IdempotencyKey.random([Random? random]) {
    final source = random ?? Random.secure();
    final bytes = List<int>.generate(16, (_) => source.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    String hex(int from, int to) => bytes.sublist(from, to).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return IdempotencyKey('${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}');
  }

  final String value;

  @override
  bool operator ==(Object other) => other is IdempotencyKey && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Backend dates in the `infrastructure` mappers: `DateTimeOffset` arrives as ISO-8601 with offset
/// (`2026-09-04T10:00:00-05:00`, up to 7 decimals).
final _isoWithOffset = RegExp(
  r'^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(?::\d{2})?)(?:\.(\d+))?(Z|[+-]\d{2}:\d{2})$',
  caseSensitive: false,
);

/// The instant in UTC, or `null` if the text is not an ISO-8601 date with an offset. A date without an offset is
/// rejected rather than read as local time.
DateTime? parseInstantOrNull(String? value) {
  final match = value == null ? null : _isoWithOffset.firstMatch(value.trim());
  if (match == null) return null;
  // `DateTime` keeps microseconds; the backend sends up to 7 decimals.
  final fraction = match.group(2);
  final trimmedFraction = fraction == null ? '' : '.${fraction.length > 6 ? fraction.substring(0, 6) : fraction}';
  return DateTime.tryParse('${match.group(1)}$trimmedFraction${match.group(3)}')?.toUtc();
}

/// `2026-09-04T15:00:00Z`: UTC, truncated to seconds, as the backend expects it in requests.
String toIsoSecondsUtc(DateTime instant) {
  final utc = DateTime.fromMillisecondsSinceEpoch(
    instant.millisecondsSinceEpoch ~/ 1000 * 1000,
    isUtc: true,
  );
  return utc.toIso8601String().replaceFirst(RegExp(r'\.\d+Z$'), 'Z');
}

final _isoDate = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

/// A calendar date (`2026-09-04`) as midnight in the phone's time zone, or `null` if the text is not a real date.
/// Dates without a time (birth dates, report days) are not instants: they must not shift with the offset.
DateTime? parseLocalDateOrNull(String? value) {
  final match = value == null ? null : _isoDate.firstMatch(value.trim());
  if (match == null) return null;
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final date = DateTime(year, month, day);
  // `DateTime` rolls `2026-02-31` over to March; a date that changed was never valid.
  return date.year == year && date.month == month && date.day == day ? date : null;
}

/// `2026-09-04`: the calendar date as the backend expects it in requests and query strings.
String toIsoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

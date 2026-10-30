import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/network/iso_dates.dart';

void main() {
  group('parseInstantOrNull', () {
    test('reads offsets and returns UTC', () {
      expect(parseInstantOrNull('2026-10-09T10:00:00-05:00'), DateTime.utc(2026, 10, 9, 15));
      expect(parseInstantOrNull('2026-10-09T10:00:00+02:00'), DateTime.utc(2026, 10, 9, 8));
      expect(parseInstantOrNull('2026-10-09T15:00:00Z'), DateTime.utc(2026, 10, 9, 15));
      expect(parseInstantOrNull('2026-10-09T15:00:00Z')!.isUtc, isTrue);
    });

    test('accepts up to 7 decimals', () {
      expect(parseInstantOrNull('2026-10-09T10:00:00.1234567-05:00'), DateTime.utc(2026, 10, 9, 15, 0, 0, 123, 456));
      expect(parseInstantOrNull('2026-10-09T10:00:00.5Z'), DateTime.utc(2026, 10, 9, 10, 0, 0, 500));
    });

    test('rejects text without an offset, or that is not a date', () {
      expect(parseInstantOrNull('2026-10-09T10:00:00'), isNull);
      expect(parseInstantOrNull('2026-10-09'), isNull);
      expect(parseInstantOrNull('ayer'), isNull);
      expect(parseInstantOrNull(''), isNull);
      expect(parseInstantOrNull(null), isNull);
    });
  });

  test('toIsoSecondsUtc truncates to seconds and writes Z', () {
    expect(toIsoSecondsUtc(DateTime.utc(2026, 10, 9, 15, 0, 0, 999)), '2026-10-09T15:00:00Z');
    expect(toIsoSecondsUtc(DateTime.parse('2026-10-09T10:00:00-05:00')), '2026-10-09T15:00:00Z');
  });

  group('parseLocalDateOrNull', () {
    test('reads a calendar date as local midnight, without shifting with an offset', () {
      expect(parseLocalDateOrNull('1995-02-15'), DateTime(1995, 2, 15));
      expect(parseLocalDateOrNull(' 2026-12-31 '), DateTime(2026, 12, 31));
      expect(parseLocalDateOrNull('2024-02-29'), DateTime(2024, 2, 29));
    });

    test('rejects impossible dates, other formats and null', () {
      for (final value in ['2026-02-31', '2025-02-29', '2026-13-01', '15/02/1995', '2026-10-09T10:00:00Z', '', 'ayer']) {
        expect(parseLocalDateOrNull(value), isNull, reason: value);
      }
      expect(parseLocalDateOrNull(null), isNull);
    });
  });

  test('toIsoDate pads and round-trips', () {
    expect(toIsoDate(DateTime(2026, 2, 3)), '2026-02-03');
    expect(parseLocalDateOrNull(toIsoDate(DateTime(1995, 11, 30))), DateTime(1995, 11, 30));
  });
}

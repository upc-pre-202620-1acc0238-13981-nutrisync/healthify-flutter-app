import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/component/date_time_texts.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
    await initializeDateFormatting('en');
  });

  const es = Locale('es');
  const en = Locale('en');
  final instant = DateTime(2026, 9, 18, 8, 10);

  test('mediumDateText follows the locale', () {
    expect(mediumDateText(instant, en), 'Sep 18, 2026');
    expect(mediumDateText(instant, es), contains('2026'));
    expect(mediumDateText(instant, es), isNot(contains('Sep')));
  });

  test('shortTimeText uses the locale time format', () {
    expect(shortTimeText(instant, en), contains('8:10'));
    expect(shortTimeText(instant, en), contains('AM'));
  });

  test('weekdayDayMonthText is capitalized and ordered per language', () {
    expect(weekdayDayMonthText(instant, en), 'Fri, Sep 18');
    expect(weekdayDayMonthText(instant, es), startsWith('Vie 18'));
  });

  test('isToday compares calendar days', () {
    final now = DateTime(2026, 9, 18, 23, 59);

    expect(isToday(DateTime(2026, 9, 18, 0, 1), now: now), isTrue);
    expect(isToday(DateTime(2026, 9, 17, 23, 59), now: now), isFalse);
  });
}

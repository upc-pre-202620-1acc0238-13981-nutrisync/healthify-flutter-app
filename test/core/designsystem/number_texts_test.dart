import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/component/number_texts.dart';

void main() {
  const es = Locale('es');
  const en = Locale('en');

  test('decimalText always shows the decimals, with the language separator', () {
    expect(decimalText(74.2, es), '74,2');
    expect(decimalText(74.2, en), '74.2');
    expect(decimalText(168, es), '168,0');
    expect(decimalText(74.25, es, decimals: 2), '74,25');
  });

  test('compactText drops trailing zeros and keeps up to the maximum', () {
    expect(compactText(168, es), '168');
    expect(compactText(168.5, es), '168,5');
    expect(compactText(74.26, en), '74.3');
    expect(compactText(74.25, es, maxDecimals: 2), '74,25');
    expect(compactText(1796, en, maxDecimals: 0), '1,796');
  });

  test('signedDecimalText uses the typographic minus', () {
    expect(signedDecimalText(-0.3, es), '−0,3');
    expect(signedDecimalText(0.3, en), '+0.3');
    expect(signedDecimalText(0, en), '0.0');
  });
}

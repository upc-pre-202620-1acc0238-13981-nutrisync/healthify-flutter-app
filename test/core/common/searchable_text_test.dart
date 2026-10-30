import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/searchable_text.dart';

void main() {
  test('ignores case and accents', () {
    expect('Ramírez'.searchable, 'ramirez');
    expect('  PEÑA Núñez '.searchable, 'pena nunez');
    expect('Ñandú'.searchable, 'nandu');
    expect('Müller Åkesson'.searchable, 'muller akesson');
  });

  test('keeps what it does not know how to fold', () {
    expect('Ana 2'.searchable, 'ana 2');
    expect('李'.searchable, '李');
  });

  test('a typed accent still matches the plain name and the other way around', () {
    expect('Luz Ramírez'.searchable.contains('ramírez'.searchable), isTrue);
    expect('Luz Ramirez'.searchable.contains('RAMÍREZ'.searchable), isTrue);
  });
}

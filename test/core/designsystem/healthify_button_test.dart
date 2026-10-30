import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/component/healthify_button.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';

import 'test_app.dart';

void main() {
  testWidgets('calls onPressed when tapped', (tester) async {
    var taps = 0;
    await pumpThemed(tester, HealthifyButton(text: 'Guardar', onPressed: () => taps++));

    await tester.tap(find.text('Guardar'));

    expect(taps, 1);
  });

  testWidgets('ignores taps while disabled', (tester) async {
    var taps = 0;
    await pumpThemed(tester, HealthifyButton(text: 'Guardar', onPressed: () => taps++, enabled: false));

    await tester.tap(find.text('Guardar'));

    expect(taps, 0);
  });

  testWidgets('shows progress and ignores taps while loading', (tester) async {
    var taps = 0;
    await pumpThemed(tester, HealthifyButton(text: 'Guardando…', onPressed: () => taps++, loading: true));

    await tester.tap(find.text('Guardando…'));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(taps, 0);
  });

  testWidgets('is 56 tall, and 48 for the text style', (tester) async {
    await pumpThemed(
      tester,
      Column(
        children: [
          HealthifyButton(key: const Key('filled'), text: 'A', onPressed: () {}),
          HealthifyButton(key: const Key('text'), text: 'B', onPressed: () {}, style: HealthifyButtonStyle.text),
        ],
      ),
    );

    expect(tester.getSize(find.byKey(const Key('filled'))).height, 56);
    expect(tester.getSize(find.byKey(const Key('text'))).height, 48);
  });

  testWidgets('paints the Figma container colors per state', (tester) async {
    await pumpThemed(
      tester,
      Column(
        children: [
          HealthifyButton(key: const Key('idle'), text: 'A', onPressed: () {}),
          HealthifyButton(key: const Key('pressed'), text: 'B', onPressed: () {}, forcePressed: true),
          HealthifyButton(key: const Key('disabled'), text: 'C', onPressed: null, enabled: false),
        ],
      ),
    );
    final context = tester.element(find.byKey(const Key('idle')));

    Color? container(String key) => tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byKey(Key(key)), matching: find.byType(DecoratedBox)))
        .map((box) => (box.decoration as BoxDecoration).color)
        .firstWhere((color) => color != null);

    expect(container('idle'), context.colors.secondary);
    expect(container('pressed'), context.extendedColors.secondaryPressed);
    expect(container('disabled'), context.extendedColors.disabledContainer);
  });

  testWidgets('stretches to the parent width when fullWidth', (tester) async {
    await pumpThemed(
      tester,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [HealthifyButton(key: const Key('wide'), text: 'A', onPressed: () {}, fullWidth: true)],
      ),
    );

    expect(tester.getSize(find.byKey(const Key('wide'))).width, 360 - 32);
  });
}

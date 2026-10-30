import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/component/segmented_selector.dart';
import 'package:healthify/core/designsystem/component/yes_no_selector.dart';

import 'test_app.dart';

void main() {
  group('SegmentedSelector', () {
    testWidgets('reports the tapped option', (tester) async {
      String? picked;
      await pumpThemed(
        tester,
        SegmentedSelector<String>(
          options: const ['Paciente', 'Nutricionista'],
          selected: null,
          onSelect: (value) => picked = value,
          optionLabel: (value) => value,
        ),
      );

      await tester.tap(find.text('Nutricionista'));

      expect(picked, 'Nutricionista');
    });

    testWidgets('lays options side by side when they fit', (tester) async {
      await pumpThemed(
        tester,
        SegmentedSelector<String>(
          options: const ['Sí', 'No'],
          selected: 'Sí',
          onSelect: (_) {},
          optionLabel: (value) => value,
        ),
      );

      expect(tester.getTopLeft(find.text('Sí')).dy, tester.getTopLeft(find.text('No')).dy);
    });

    testWidgets('stacks options at full width when a label does not fit its share', (tester) async {
      await pumpThemed(
        tester,
        SegmentedSelector<String>(
          options: const ['Actividad física moderada', 'Actividad física intensa'],
          selected: null,
          onSelect: (_) {},
          optionLabel: (value) => value,
        ),
      );

      expect(
        tester.getTopLeft(find.text('Actividad física intensa')).dy,
        greaterThan(tester.getTopLeft(find.text('Actividad física moderada')).dy),
      );
    });
  });

  group('YesNoSelector', () {
    testWidgets('answers true for Sí and false for No', (tester) async {
      final answers = <bool>[];
      await pumpThemed(
        tester,
        YesNoSelector(question: '¿Ayunas?', answer: null, onAnswer: answers.add),
      );

      await tester.tap(find.text('Sí'));
      await tester.tap(find.text('No'));

      expect(answers, [true, false]);
    });

    testWidgets('shows the required message only when unanswered and flagged', (tester) async {
      await pumpThemed(
        tester,
        YesNoSelector(question: '¿Ayunas?', answer: null, onAnswer: (_) {}, isError: true),
      );
      expect(find.text('Responde Sí o No'), findsOneWidget);

      await pumpThemed(
        tester,
        YesNoSelector(question: '¿Ayunas?', answer: true, onAnswer: (_) {}, isError: true),
      );
      expect(find.text('Responde Sí o No'), findsNothing);
    });

    testWidgets('uses the English labels in English', (tester) async {
      await pumpThemed(
        tester,
        YesNoSelector(question: 'Fasting?', answer: null, onAnswer: (_) {}, isError: true),
        locale: const Locale('en'),
      );

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('Answer Yes or No'), findsOneWidget);
    });
  });
}

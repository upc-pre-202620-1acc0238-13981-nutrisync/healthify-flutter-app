import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/main/presentation/screen/practitioner_patient_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../core/designsystem/test_fonts.dart';

/// The patient file's tab row: the four tabs are all there and evenly spaced, so a short label like «Plan» is not left far
/// from the others (it used to sit in a quarter of the width of its own).
void main() {
  setUpAll(loadAppFonts);

  Future<TabController> pump(
    WidgetTester tester, {
    String language = 'es',
    Size size = const Size(360, 640),
    double textScale = 1,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    late TabController controller;
    await tester.pumpWidget(
      MaterialApp(
        theme: HealthifyTheme.light(),
        locale: Locale(language),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) =>
            MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)), child: child!),
        home: DefaultTabController(
          length: PatientDetailTab.values.length,
          initialIndex: 1,
          child: Builder(
            builder: (context) {
              controller = DefaultTabController.of(context);
              return Scaffold(body: PatientTabBar(controller: controller));
            },
          ),
        ),
      ),
    );
    return controller;
  }

  List<String> labels(String language) => language == 'es'
      ? ['Resumen', 'Seguimiento', 'Historia', 'Plan']
      : ['Summary', 'Follow-up', 'History', 'Plan'];

  for (final language in ['es', 'en']) {
    group('tab bar ($language)', () {
      testWidgets('shows the four tabs inside a 360 wide screen', (tester) async {
        await pump(tester, language: language);

        expect(tester.takeException(), isNull);
        for (final label in labels(language)) {
          final right = tester.getTopRight(find.text(label)).dx;
          expect(find.text(label), findsOneWidget, reason: label);
          expect(right, lessThanOrEqualTo(360), reason: '$label is cut off');
        }
      });

      testWidgets('the gaps between neighbouring labels are even', (tester) async {
        await pump(tester, language: language);
        final names = labels(language);

        final gaps = <double>[
          for (var i = 0; i < names.length - 1; i++)
            tester.getTopLeft(find.text(names[i + 1])).dx - tester.getTopRight(find.text(names[i])).dx,
        ];

        final spread = gaps.reduce((a, b) => a > b ? a : b) - gaps.reduce((a, b) => a < b ? a : b);
        expect(spread, lessThanOrEqualTo(2), reason: 'Uneven gaps: $gaps');
        expect(gaps.reduce((a, b) => a < b ? a : b), greaterThanOrEqualTo(8), reason: 'Labels too close: $gaps');
      });
    });
  }

  testWidgets('tapping a tab selects it', (tester) async {
    final controller = await pump(tester);

    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();

    expect(controller.index, PatientDetailTab.plan.index);
  });

  testWidgets('with very large text the labels scroll instead of overflowing', (tester) async {
    await pump(tester, textScale: 2);

    expect(tester.takeException(), isNull);
    expect(find.text('Seguimiento'), findsOneWidget);
  });

  testWidgets('on a wide screen the tabs stay evenly spread and inside the screen', (tester) async {
    await pump(tester, size: const Size(600, 800));

    expect(tester.takeException(), isNull);
    expect(tester.getTopRight(find.text('Plan')).dx, lessThanOrEqualTo(600));
    final gap1 = tester.getTopLeft(find.text('Seguimiento')).dx - tester.getTopRight(find.text('Resumen')).dx;
    final gap3 = tester.getTopLeft(find.text('Plan')).dx - tester.getTopRight(find.text('Historia')).dx;
    expect((gap1 - gap3).abs(), lessThanOrEqualTo(2));
  });
}

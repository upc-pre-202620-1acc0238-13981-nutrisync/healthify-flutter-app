import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/component/healthify_navigation_bar.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/iam/domain/valueobject/preferred_language.dart';
import 'package:healthify/features/main/presentation/components/language_sheet.dart';
import 'package:healthify/features/main/presentation/screen/patient_history_tab.dart';
import 'package:healthify/features/main/presentation/screen/practitioner_settings_screen.dart';
import 'package:healthify/features/main/presentation/screen/practitioner_shell_screen.dart';
import 'package:healthify/features/main/presentation/state/patient_history_state.dart';
import 'package:healthify/features/main/presentation/state/practitioner_settings_state.dart';
import 'package:healthify/features/main/presentation/state/practitioner_shell_state.dart';

import '../core/designsystem/test_fonts.dart';
import '../features/nutritionalcare/fakes.dart';

/// Layout adapts to the window (rail on tablets) and the screens survive the largest system font.
void main() {
  setUpAll(loadAppFonts);

  Future<void> pump(
    WidgetTester tester,
    Widget screen, {
    Size size = const Size(360, 640),
    double textScale = 1,
    String language = 'es',
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
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
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: screen,
      ),
    );
    await tester.pumpAndSettle();
  }

  Widget shell({PractitionerTab selected = PractitionerTab.patients, ValueChanged<PractitionerTab>? onSelect}) =>
      PractitionerShellContent(
        state: const PractitionerShellState(),
        selected: selected,
        onSelect: onSelect ?? (_) {},
        onCloseMenu: () {},
        onFoodCatalog: () {},
        onSettings: () {},
        onSignOut: () {},
        child: const Center(child: Text('contenido')),
      );

  group('shell navigation', () {
    testWidgets('a phone gets the bottom bar', (tester) async {
      await pump(tester, shell(), size: const Size(390, 800));

      expect(find.byType(PractitionerNavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('exactly 600 dp is still a phone, anything wider gets the rail', (tester) async {
      await pump(tester, shell(), size: const Size(600, 900));
      expect(find.byType(NavigationRail), findsNothing);

      await pump(tester, shell(), size: const Size(601, 900));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(PractitionerNavigationBar), findsNothing);
    });

    testWidgets('on a tablet the rail has the three tabs, marks the current one and selects', (tester) async {
      PractitionerTab? tapped;
      await pump(
        tester,
        shell(selected: PractitionerTab.inbox, onSelect: (tab) => tapped = tab),
        size: const Size(1024, 768),
      );

      expect(find.text('Pacientes'), findsOneWidget);
      expect(find.text('Bandeja'), findsOneWidget);
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('contenido'), findsOneWidget);
      expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex, PractitionerTab.inbox.index);

      await tester.tap(find.text('Agenda'));
      expect(tapped, PractitionerTab.agenda);
      expect(tester.takeException(), isNull);
    });
  });

  group('largest system font (2x) on a small phone', () {
    for (final language in ['es', 'en']) {
      testWidgets('shell: $language', (tester) async {
        await pump(tester, shell(), textScale: 2, language: language);
        expect(tester.takeException(), isNull);
      });

      testWidgets('settings: $language', (tester) async {
        await pump(
          tester,
          PractitionerSettingsContent(
            state: const PractitionerSettingsState(
              fullName: 'Lucía Paredes de la Fuente',
              email: 'lucia.paredes.de.la.fuente@correo.com',
              isOffline: true,
            ),
            onBack: () {},
            onSignOut: () {},
            onOpenLanguage: () {},
          ),
          textScale: 2,
          language: language,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('language sheet: $language', (tester) async {
        await pump(
          tester,
          Scaffold(
            body: SingleChildScrollView(
              child: LanguageSheetContent(selected: PreferredLanguage.english, onSelect: (_) {}, onClose: () {}),
            ),
          ),
          textScale: 2,
          language: language,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('record tab: $language', (tester) async {
        await pump(
          tester,
          PatientHistoryContent(
            state: PatientHistoryState(
              isLoading: false,
              data: HistoryData(baseline: baseline(), record: practitionerRecord()),
            ),
            onEditBaseline: () {},
            onRetry: () {},
          ),
          textScale: 2,
          language: language,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('accessibility', () {
    testWidgets('settings: tap targets and labels', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        PractitionerSettingsContent(
          state: const PractitionerSettingsState(fullName: 'Lucía Paredes', email: 'lucia@correo.com'),
          onBack: () {},
          onSignOut: () {},
          onOpenLanguage: () {},
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('language sheet: the title is a header and the chosen language is selected', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        Scaffold(
          body: LanguageSheetContent(selected: PreferredLanguage.english, onSelect: (_) {}, onClose: () {}),
        ),
      );

      expect(tester.getSemantics(find.text('IDIOMA')), matchesSemantics(label: 'IDIOMA', isHeader: true));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });
  });
}

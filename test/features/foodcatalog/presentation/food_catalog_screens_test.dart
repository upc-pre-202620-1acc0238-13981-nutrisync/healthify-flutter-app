import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/designsystem/component/healthify_dialog.dart';
import 'package:healthify/core/designsystem/theme/healthify_theme.dart';
import 'package:healthify/core/l10n/app_localizations.dart';
import 'package:healthify/features/foodcatalog/domain/entity/new_local_food.dart';
import 'package:healthify/features/foodcatalog/presentation/screen/add_local_food_screen.dart';
import 'package:healthify/features/foodcatalog/presentation/screen/food_catalog_screen.dart';
import 'package:healthify/features/foodcatalog/presentation/state/food_catalog_states.dart';

const _rows = [
  FoodRow(id: 1, name: 'Papa amarilla', energyKcalPer100g: 97, isLocal: false),
  FoodRow(id: 2, name: 'Cuy al horno', energyKcalPer100g: 176.5, isLocal: true),
];

void noop() {}

void _ignore(String _) {}

/// The screens must lay out without overflow on a small phone, in both languages.
void main() {
  Future<void> pump(WidgetTester tester, Widget screen, {String language = 'es'}) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
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
        home: screen,
      ),
    );
  }

  group('catalog', () {
    Widget catalog(FoodCatalogState state, {VoidCallback onAddLocalFood = noop, VoidCallback onRetry = noop}) =>
        FoodCatalogContent(
          state: state,
          onBack: noop,
          onQueryChange: _ignore,
          onAddLocalFood: onAddLocalFood,
          onRetry: onRetry,
        );

    for (final language in ['es', 'en']) {
      testWidgets('lists the foods, local ones marked ($language)', (tester) async {
        await pump(tester, catalog(const FoodCatalogState(isLoading: false, results: _rows)), language: language);

        expect(tester.takeException(), isNull);
        expect(find.text('Papa amarilla'), findsOneWidget);
        expect(find.text('Cuy al horno (local)'), findsOneWidget);
        expect(find.text(language == 'es' ? '176,5 kcal / 100 g' : '176.5 kcal / 100 g'), findsOneWidget);
      });
    }

    testWidgets('"Add local food" opens the add screen', (tester) async {
      var opened = 0;
      await pump(
        tester,
        catalog(const FoodCatalogState(isLoading: false, results: _rows), onAddLocalFood: () => opened++),
      );

      await tester.tap(find.text('Agregar alimento local'));

      expect(opened, 1);
    });

    testWidgets('with no results the empty state offers to add the food', (tester) async {
      var opened = 0;
      await pump(
        tester,
        catalog(const FoodCatalogState(query: 'chaufa de cuy', isLoading: false, results: []), onAddLocalFood: () => opened++),
      );

      expect(find.text('Sin resultados'), findsOneWidget);
      await tester.tap(find.text('Agregar alimento local'));
      expect(opened, 1);
    });

    testWidgets('offline without a read it asks for a connection', (tester) async {
      var retried = 0;
      await pump(
        tester,
        catalog(const FoodCatalogState(isLoading: false, isOffline: true, loadFailed: true), onRetry: () => retried++),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Necesitas conexión'), findsOneWidget);
      await tester.tap(find.text('Reintentar'));
      expect(retried, 1);
    });

    testWidgets('loading and error states lay out', (tester) async {
      await pump(tester, catalog(const FoodCatalogState()));
      expect(tester.takeException(), isNull);

      await pump(tester, catalog(const FoodCatalogState(isLoading: false, loadFailed: true)));
      expect(tester.takeException(), isNull);
    });
  });

  group('add local food', () {
    Widget form(AddLocalFoodState state, {VoidCallback onSave = noop}) => AddLocalFoodContent(
      state: state,
      onBack: noop,
      onNameChange: _ignore,
      onEnergyChange: _ignore,
      onProteinChange: _ignore,
      onCarbChange: _ignore,
      onFatChange: _ignore,
      onSave: onSave,
      onServerErrorDismissed: noop,
    );

    for (final language in ['es', 'en']) {
      testWidgets('lays out the form ($language)', (tester) async {
        await pump(tester, form(const AddLocalFoodState()), language: language);

        expect(tester.takeException(), isNull);
        expect(find.text(language == 'es' ? 'ALIMENTO LOCAL' : 'LOCAL FOOD'), findsOneWidget);
      });
    }

    testWidgets('missing values and a duplicated name show their messages', (tester) async {
      await pump(
        tester,
        form(const AddLocalFoodState(name: 'Chaufa', invalidFields: {LocalFoodField.energy, LocalFoodField.fat})),
      );
      expect(find.text('Completa el nombre y los valores nutricionales'), findsOneWidget);

      await pump(tester, form(const AddLocalFoodState(name: 'Cuy al horno', duplicatedName: true)));
      expect(find.text('Ya existe un alimento local con este nombre'), findsOneWidget);
    });

    testWidgets('the server error dialog retries the save', (tester) async {
      var saved = 0;
      await pump(tester, form(const AddLocalFoodState(showServerError: true), onSave: () => saved++));

      expect(find.byType(HealthifyDialog), findsOneWidget);
      await tester.tap(find.text('Reintentar'));
      expect(saved, 1);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/features/foodcatalog/domain/entity/new_local_food.dart';
import 'package:healthify/features/foodcatalog/domain/valueobject/food_search_term.dart';
import 'package:healthify/features/foodcatalog/domain/valueobject/reference_food_id.dart';

void main() {
  test('search terms need 2 characters, collapse spaces and are cut at 80', () {
    expect(FoodSearchTerm.of(' q '), isNull);
    expect(FoodSearchTerm.of('  arroz   con pollo ')!.value, 'arroz con pollo');
    expect(FoodSearchTerm.of('a' * 100)!.value.length, FoodSearchTerm.maxLength);
  });

  test('a reference food id is positive', () {
    expect(() => ReferenceFoodId(0), throwsArgumentError);
    expect(ReferenceFoodId(5).value, 5);
  });

  group('LocalFoodValidation', () {
    test('a local food needs a name with letters and nutrients within the backend ranges', () {
      final invalid =
          LocalFoodValidation.of(name: '123', energy: '', protein: '120', carb: '20', fat: '-1') as InvalidLocalFood;
      expect(invalid.fields, {LocalFoodField.name, LocalFoodField.energy, LocalFoodField.protein, LocalFoodField.fat});

      expect(
        LocalFoodValidation.of(name: 'Cuy', energy: '951', protein: '1', carb: '1', fat: '1'),
        isA<InvalidLocalFood>(),
      );
      expect(
        LocalFoodValidation.of(name: 'Cuy', energy: 'NaN', protein: 'Infinity', carb: '1', fat: '1'),
        isA<InvalidLocalFood>().having((v) => v.fields, 'fields', {LocalFoodField.energy, LocalFoodField.protein}),
      );
    });

    test('trims the name and reads a comma or a dot as the decimal separator', () {
      final valid =
          LocalFoodValidation.of(name: ' Chaufa de cuy ', energy: '180', protein: '12,5', carb: '20.0', fat: '6')
              as ValidLocalFood;

      expect(valid.food.name, 'Chaufa de cuy');
      expect(valid.food.energyKcalPer100g, 180);
      expect(valid.food.proteinGPer100g, 12.5);
      expect(valid.food.carbGPer100g, 20);
      expect(valid.food.fatGPer100g, 6);
    });

    test('accented letters count as letters and the limits are inclusive', () {
      expect(
        LocalFoodValidation.of(name: 'Ñoqui', energy: '950', protein: '100', carb: '0', fat: '0'),
        isA<ValidLocalFood>(),
      );
      expect(
        LocalFoodValidation.of(name: 'a' * 201, energy: '1', protein: '1', carb: '1', fat: '1'),
        isA<InvalidLocalFood>().having((v) => v.fields, 'fields', {LocalFoodField.name}),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/features/foodcatalog/application/usecase/food_catalog_use_cases.dart';
import 'package:healthify/features/foodcatalog/domain/entity/new_local_food.dart';
import 'package:healthify/features/foodcatalog/presentation/cubit/add_local_food_cubit.dart';

import '../../carerelationship/fakes.dart';
import '../fakes.dart';

void main() {
  late FakeReferenceFoodRepository foods;
  late FakeConnectivity connectivity;
  late List<String> added;

  setUp(() {
    foods = FakeReferenceFoodRepository();
    connectivity = FakeConnectivity();
    added = [];
  });

  AddLocalFoodCubit build() {
    final cubit = AddLocalFoodCubit(CreateLocalFoodUseCase(foods), connectivity);
    cubit.added.listen(added.add);
    return cubit;
  }

  void fill(AddLocalFoodCubit cubit, String name) => cubit
    ..onNameChange(name)
    ..onEnergyChange('176')
    ..onProteinChange('19')
    ..onCarbChange('0')
    ..onFatChange('11');

  Future<void> settle() => pumpEventQueue();

  test('PR15_1 an empty form marks every field and sends nothing; typing clears each mark', () async {
    final cubit = build();

    await cubit.onSave();

    expect(cubit.state.invalidFields, LocalFoodField.values.toSet());
    expect(foods.created, isEmpty);
    cubit.onEnergyChange('180');
    expect(cubit.state.invalidFields.contains(LocalFoodField.energy), isFalse);
    await cubit.close();
  });

  test('PR15_1 a duplicated name is shown on the name field until the name changes', () async {
    foods.createResult = const Result.failure(Conflict('DuplicatedLocalOverride'));
    final cubit = build();
    fill(cubit, 'Cuy al horno');

    await cubit.onSave();
    expect(cubit.state.duplicatedName, isTrue);
    expect(cubit.state.isSaving, isFalse);

    cubit.onNameChange('Cuy chactado');
    expect(cubit.state.duplicatedName, isFalse);
    await cubit.close();
  });

  test('PR15_1 a valid food is created and its name is reported', () async {
    final cubit = build();
    fill(cubit, ' Cuy chactado ');

    await cubit.onSave();
    await settle();

    expect(foods.created.single.name, 'Cuy chactado');
    expect(foods.created.single.energyKcalPer100g, 176);
    expect(added, ['Cuy chactado']);
    await cubit.close();
  });

  test('the backend asking for name and nutrients marks every field', () async {
    foods.createResult = const Result.failure(Validation('LocalNameAndNutrientsRequired'));
    final cubit = build();
    fill(cubit, 'Cuy');

    await cubit.onSave();

    expect(cubit.state.invalidFields, LocalFoodField.values.toSet());
    await cubit.close();
  });

  test('a server or network failure shows the error dialog, and retrying hides it', () async {
    foods.createResult = const Result.failure(Network());
    final cubit = build();
    fill(cubit, 'Cuy');

    await cubit.onSave();
    expect(cubit.state.showServerError, isTrue);

    foods.createResult = null;
    await cubit.onSave();
    await settle();
    expect(cubit.state.showServerError, isFalse);
    expect(added, ['Cuy']);
    await cubit.close();
  });

  test('the name is cut at 200 characters and the offline state follows the connection', () async {
    final cubit = build();
    await settle();

    cubit.onNameChange('a' * 250);
    connectivity.set(false);
    await settle();

    expect(cubit.state.name.length, NewLocalFood.maxNameLength);
    expect(cubit.state.isOffline, isTrue);
    await cubit.close();
  });
}

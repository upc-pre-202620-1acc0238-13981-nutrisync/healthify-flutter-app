import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/error/domain_error.dart';
import '../../../../core/common/one_shot_events.dart';
import '../../../../core/connectivity/connectivity_observer.dart';
import '../../application/usecase/food_catalog_use_cases.dart';
import '../../domain/entity/new_local_food.dart';
import '../state/food_catalog_states.dart';

const _localNameAndNutrientsRequired = 'LocalNameAndNutrientsRequired';

/// Add local food (Peruvian dishes the external catalog lacks). An import never overwrites a local food. It is technical
/// support for patient logging, not clinical data.
class AddLocalFoodCubit extends Cubit<AddLocalFoodState> {
  AddLocalFoodCubit(this._createLocalFood, ConnectivityObserver connectivityObserver)
    : super(const AddLocalFoodState()) {
    _connectivity = connectivityObserver.isOnline.listen((online) {
      if (!isClosed) emit(state.copyWith(isOffline: !online));
    });
  }

  final CreateLocalFoodUseCase _createLocalFood;

  late final StreamSubscription<bool> _connectivity;
  final _events = OneShotEvents<String>();

  /// The created food's name, once it is saved.
  Stream<String> get added => _events.stream;

  void onNameChange(String value) => emit(
    state.copyWith(
      name: value.length > NewLocalFood.maxNameLength ? value.substring(0, NewLocalFood.maxNameLength) : value,
      invalidFields: {...state.invalidFields}..remove(LocalFoodField.name),
      duplicatedName: false,
    ),
  );

  void onEnergyChange(String value) => _updateNumber(LocalFoodField.energy, state.copyWith(energy: value));

  void onProteinChange(String value) => _updateNumber(LocalFoodField.protein, state.copyWith(protein: value));

  void onCarbChange(String value) => _updateNumber(LocalFoodField.carb, state.copyWith(carb: value));

  void onFatChange(String value) => _updateNumber(LocalFoodField.fat, state.copyWith(fat: value));

  void onServerErrorDismissed() => emit(state.copyWith(showServerError: false));

  /// "Save food" (or "Retry").
  Future<void> onSave() async {
    if (state.isSaving) return;
    final NewLocalFood food;
    switch (LocalFoodValidation.of(
      name: state.name,
      energy: state.energy,
      protein: state.protein,
      carb: state.carb,
      fat: state.fat,
    )) {
      case InvalidLocalFood(:final fields):
        emit(state.copyWith(invalidFields: fields));
        return;
      case ValidLocalFood(food: final valid):
        food = valid;
    }
    emit(state.copyWith(isSaving: true, showServerError: false, invalidFields: const {}));
    final result = await _createLocalFood(food);
    if (isClosed) return;
    emit(state.copyWith(isSaving: false));
    switch (result.errorOrNull) {
      case null:
        _events.emit(result.valueOrNull!.name);
      case Conflict():
        emit(state.copyWith(duplicatedName: true));
      case Validation(:final code) when code == _localNameAndNutrientsRequired:
        emit(state.copyWith(invalidFields: LocalFoodField.values.toSet()));
      default:
        emit(state.copyWith(showServerError: true));
    }
  }

  void _updateNumber(LocalFoodField field, AddLocalFoodState updated) =>
      emit(updated.copyWith(invalidFields: {...state.invalidFields}..remove(field)));

  @override
  Future<void> close() async {
    await _connectivity.cancel();
    _events.close();
    return super.close();
  }
}

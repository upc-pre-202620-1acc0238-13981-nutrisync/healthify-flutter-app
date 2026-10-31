import '../../../../core/connectivity/connectivity_observer.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/api_client.dart';
import '../../application/usecase/food_catalog_use_cases.dart';
import '../../domain/repository/reference_food_repository.dart';
import '../../presentation/cubit/add_local_food_cubit.dart';
import '../../presentation/cubit/food_catalog_cubit.dart';
import '../remote/reference_food_service.dart';
import '../repository/reference_food_repository_impl.dart';

/// Registers the `foodcatalog` graph (the nutritionist's catalog management only). Called from `main` after `setupCore`.
void registerFoodCatalog() {
  getIt
    ..registerLazySingleton<ReferenceFoodService>(() => ReferenceFoodService(getIt<ApiClient>()))
    ..registerLazySingleton<ReferenceFoodRepository>(() => ReferenceFoodRepositoryImpl(getIt<ReferenceFoodService>()))
    // Use cases.
    ..registerFactory(() => BrowseFoodCatalogUseCase(getIt<ReferenceFoodRepository>()))
    ..registerFactory(() => CreateLocalFoodUseCase(getIt<ReferenceFoodRepository>()))
    // Cubits: one per screen instance.
    ..registerFactory(() => FoodCatalogCubit(getIt(), getIt<ConnectivityObserver>()))
    ..registerFactory(() => AddLocalFoodCubit(getIt(), getIt<ConnectivityObserver>()));
}

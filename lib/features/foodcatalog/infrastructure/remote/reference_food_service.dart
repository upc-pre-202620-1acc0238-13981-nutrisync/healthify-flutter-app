import '../../../../core/network/api_client.dart';
import 'dto/reference_food_dtos.dart';

/// FoodCatalog. Search is anonymous on the backend (the bearer the client adds changes nothing); creating a local food
/// needs the nutritionist's session.
class ReferenceFoodService {
  const ReferenceFoodService(this._api);

  final ApiClient _api;

  /// Local-first on the server; `200` with an empty list if there are no results.
  Future<List<ReferenceFoodDto>> search(String query, int max) async {
    final json = await _api.get('reference-foods', query: {'query': query, 'max': max}) as List<dynamic>;
    return [for (final item in json) ReferenceFoodDto.fromJson(item as Map<String, dynamic>)];
  }

  /// `201` with the created food (marked as local for good).
  Future<ReferenceFoodDto> createLocalOverride(CreateLocalOverrideRequestDto body) async => ReferenceFoodDto.fromJson(
    await _api.post('reference-foods/local-overrides', body: body.toJson()) as Map<String, dynamic>,
  );
}

/// A non-2xx response. Thrown by `ApiClient` and translated by `apiCall` through `ProblemDetailsMapper`
/// (the equivalent of Retrofit's `HttpException`).
class ApiException implements Exception {
  const ApiException(this.statusCode, this.body);

  final int statusCode;
  final String? body;

  @override
  String toString() => 'ApiException($statusCode)';
}

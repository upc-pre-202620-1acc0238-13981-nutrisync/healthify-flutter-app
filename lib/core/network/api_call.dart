import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import '../common/error/domain_error.dart';
import '../common/error/result.dart';
import 'api_exception.dart';
import 'problem_details_mapper.dart';

/// Runs a network call and turns it into a [Result]. Use it in the `*RepositoryImpl` (infrastructure)
/// together with the DTO -> domain mapper. Decode **inside** [block], so a body with an unexpected shape
/// becomes `MALFORMED_RESPONSE` instead of throwing to the UI (the equivalent of kotlinx `SerializationException`):
///
/// ```dart
/// Future<Result<User>> getUser(UserId id) => apiCall(() async {
///   final json = await api.get('users/${id.value}');
///   return UserDto.fromJson(json as Map<String, dynamic>).toDomain();
/// });
/// ```
Future<Result<T>> apiCall<T>(Future<T> Function() block) async {
  try {
    return Result.success(await block());
  } on ApiException catch (e) {
    return Result.failure(ProblemDetailsMapper.map(e.statusCode, e.body));
  } on http.ClientException {
    return const Result.failure(Network());
  } on SocketException {
    return const Result.failure(Network());
  } on TimeoutException {
    return const Result.failure(Network());
  } on FormatException {
    return const Result.failure(Unexpected('MALFORMED_RESPONSE'));
  } on CheckedFromJsonException {
    return const Result.failure(Unexpected('MALFORMED_RESPONSE'));
  } on TypeError {
    // A missing or mistyped field fails the `as` casts of `fromJson`; an unknown enum value fails `$enumDecode`
    // with an ArgumentError.
    return const Result.failure(Unexpected('MALFORMED_RESPONSE'));
  } on ArgumentError {
    return const Result.failure(Unexpected('MALFORMED_RESPONSE'));
  }
}

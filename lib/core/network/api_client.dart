import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

/// Thin JSON layer over an [http.Client]: builds the URI from the base URL, encodes the body and decodes the
/// response. Throws [ApiException] on non-2xx; wrap calls with `apiCall` to get a `Result`.
class ApiClient {
  ApiClient(this._client, {Uri? baseUrl, this.readTimeout = defaultReadTimeout})
    : _baseUrl = baseUrl ?? apiBaseUrl;

  final http.Client _client;
  final Uri _baseUrl;
  final Duration readTimeout;

  static const _jsonHeaders = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(_client.get(_uri(path, query), headers: _jsonHeaders));

  /// Like [get], but keeps the status and headers: for the few endpoints where a `2xx` other than `200` means something
  /// (`202` + `Retry-After`).
  Future<ApiResponse> getResponse(String path, {Map<String, dynamic>? query}) async {
    final response = await _read(_client.get(_uri(path, query), headers: _jsonHeaders));
    // A `202` carries a ProblemDetails body nobody reads: it must not fail the call if it is not JSON.
    final body = response.statusCode == 200 ? _decode(response.text) : _tryDecode(response.text);
    return ApiResponse(response.statusCode, response.headers, body);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? query, Object? body, Map<String, String>? headers}) =>
      _send(_client.post(_uri(path, query), headers: {..._jsonHeaders, ...?headers}, body: _encode(body)));

  Future<dynamic> put(String path, {Map<String, dynamic>? query, Object? body}) =>
      _send(_client.put(_uri(path, query), headers: _jsonHeaders, body: _encode(body)));

  Future<dynamic> delete(String path, {Map<String, dynamic>? query, Object? body}) =>
      _send(_client.delete(_uri(path, query), headers: _jsonHeaders, body: _encode(body)));

  Uri _uri(String path, Map<String, dynamic>? query) {
    final resolved = _baseUrl.resolve(path.startsWith('/') ? path.substring(1) : path);
    final params = <String, dynamic>{};
    query?.forEach((key, value) {
      if (value == null) return;
      params[key] = value is Iterable ? value.map((e) => '$e').toList() : '$value';
    });
    return params.isEmpty ? resolved : resolved.replace(queryParameters: params);
  }

  String? _encode(Object? body) => body == null ? null : jsonEncode(body);

  /// Decoded JSON, or `null` for an empty body (`204`). A `TimeoutException` after [readTimeout] reads as network.
  Future<dynamic> _send(Future<http.Response> request) async => _decode((await _read(request)).text);

  Future<({int statusCode, Map<String, String> headers, String text})> _read(Future<http.Response> request) async {
    final response = await request.timeout(readTimeout);
    // `response.body` falls back to latin1 without a charset; the backend always speaks UTF-8.
    final text = utf8.decode(response.bodyBytes);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, text);
    }
    return (statusCode: response.statusCode, headers: response.headers, text: text);
  }

  dynamic _decode(String text) => text.trim().isEmpty ? null : jsonDecode(text);

  dynamic _tryDecode(String text) {
    try {
      return _decode(text);
    } on FormatException {
      return null;
    }
  }
}

/// A successful response with its status and headers.
class ApiResponse {
  const ApiResponse(this.statusCode, this.headers, this.body);

  final int statusCode;
  final Map<String, String> headers;

  /// The value of the header [name], whatever its case (`package:http` lower-cases them on a real connection only).
  String? header(String name) {
    final wanted = name.toLowerCase();
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == wanted) return entry.value;
    }
    return null;
  }

  /// Decoded JSON, or `null` for an empty body.
  final dynamic body;
}

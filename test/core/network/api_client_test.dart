import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/network/api_call.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/api_client.dart';
import 'package:healthify/core/network/api_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final baseUrl = Uri.parse('https://host/api/v1/');

  test('builds the URI under the base path, with query and without nulls', () async {
    late http.Request captured;
    final api = ApiClient(
      MockClient((request) async {
        captured = request;
        return http.Response('{"ok":true}', 200);
      }),
      baseUrl: baseUrl,
    );

    final json = await api.get('/patients/7/targets', query: {'page': 2, 'from': null, 'tags': ['a', 'b']});

    expect(json, {'ok': true});
    expect(captured.url.toString(), 'https://host/api/v1/patients/7/targets?page=2&tags=a&tags=b');
    expect(captured.headers['Accept'], 'application/json');
  });

  test('encodes the body as JSON and decodes UTF-8 responses', () async {
    late http.Request captured;
    final api = ApiClient(
      MockClient((request) async {
        captured = request;
        return http.Response.bytes(utf8.encode('{"name":"Peña"}'), 200);
      }),
      baseUrl: baseUrl,
    );

    final json = await api.post('consultations', body: {'note': 'ñandú'});

    expect(captured.method, 'POST');
    expect(captured.headers['Content-Type'], startsWith('application/json'));
    expect(jsonDecode(captured.body), {'note': 'ñandú'});
    expect(json, {'name': 'Peña'});
  });

  test('an empty body decodes to null', () async {
    final api = ApiClient(MockClient((_) async => http.Response('', 204)), baseUrl: baseUrl);

    expect(await api.delete('consultations/1'), isNull);
  });

  test('non-2xx throws ApiException with status and body', () async {
    final api = ApiClient(MockClient((_) async => http.Response('{"code":"X"}', 409)), baseUrl: baseUrl);

    await expectLater(
      api.put('consultations/1'),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 409).having((e) => e.body, 'body', '{"code":"X"}')),
    );
  });

  test('a response slower than the read timeout reads as network through apiCall', () async {
    final api = ApiClient(
      MockClient((_) => Completer<http.Response>().future),
      baseUrl: baseUrl,
      readTimeout: const Duration(milliseconds: 20),
    );

    final result = await apiCall(() => api.get('slow'));

    expect(result.errorOrNull, const Network());
  });

  test('invalid JSON reads as a malformed response through apiCall', () async {
    final api = ApiClient(MockClient((_) async => http.Response('<html>', 200)), baseUrl: baseUrl);

    final result = await apiCall(() => api.get('broken'));

    expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
  });
}

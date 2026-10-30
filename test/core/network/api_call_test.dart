import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/common/error/result.dart';
import 'package:healthify/core/network/api_call.dart';
import 'package:healthify/core/network/api_exception.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

void main() {
  test('success is wrapped', () async {
    final result = await apiCall(() async => 42);

    expect(result, const Success(42));
  });

  test('http error becomes a domain error', () async {
    final result = await apiCall<int>(
      () async => throw const ApiException(409, '{"status":409,"title":"Conflicto"}'),
    );

    expect(result.errorOrNull, const Conflict());
  });

  test('http error keeps the backend code', () async {
    final result = await apiCall<int>(
      () async => throw const ApiException(401, '{"status":401,"code":"InvalidCredentials"}'),
    );

    expect(result.errorOrNull, const Unauthorized('InvalidCredentials'));
  });

  test('client, socket and timeout errors become network', () async {
    final errors = <Object>[
      http.ClientException('offline'),
      const SocketException('offline'),
      TimeoutException('slow'),
    ];

    for (final error in errors) {
      final result = await apiCall<int>(() async => throw error);

      expect(result.errorOrNull, const Network(), reason: '$error');
    }
  });

  test('format error becomes a malformed response', () async {
    final result = await apiCall<int>(() async => throw const FormatException('bad json'));

    expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
  });

  test('a body with an unexpected shape becomes a malformed response', () async {
    final errors = <Object Function()>[
      // A field with the wrong type in a hand-written or generated fromJson.
      () => <String, dynamic>{'id': 'not-an-int'}['id'] as int,
      // A missing required field.
      () => <String, dynamic>{}['name'] as String,
      // A field the generated fromJson (checked: true) could not read.
      () => throw CheckedFromJsonException({}, 'id', 'UserDto', 'bad'),
      // An unknown enum value in $enumDecode.
      () => throw ArgumentError.value('Unknown', 'status'),
    ];

    for (final error in errors) {
      final result = await apiCall<Object>(() async => error());

      expect(result.errorOrNull, const Unexpected('MALFORMED_RESPONSE'));
    }
  });

  test('unknown errors are not swallowed', () {
    expect(apiCall<int>(() async => throw StateError('bug')), throwsStateError);
  });
}

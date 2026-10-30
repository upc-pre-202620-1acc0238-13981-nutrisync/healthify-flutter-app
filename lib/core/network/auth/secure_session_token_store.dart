import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'session_token_store.dart';

/// Tokens in the platform secure storage (Keystore / Keychain). They are never logged.
class SecureSessionTokenStore implements SessionTokenStore {
  SecureSessionTokenStore(this._storage);

  final FlutterSecureStorage _storage;
  final _changes = StreamController<bool>.broadcast();

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  @override
  Stream<bool> get hasSession async* {
    yield (await refreshToken()) != null;
    yield* _changes.stream;
  }

  @override
  Future<String?> accessToken() => _read(_accessKey);

  @override
  Future<String?> refreshToken() => _read(_refreshKey);

  @override
  Future<void> save({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
    _changes.add(true);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
    _changes.add(false);
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      // Rotated keystore key or corrupt data (e.g. a reinstall): the session can no longer be recovered.
      await clear();
      return null;
    }
  }
}

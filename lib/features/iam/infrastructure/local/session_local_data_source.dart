import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/auth/session_token_store.dart';
import '../../domain/entity/session_user.dart';
import '../../domain/valueobject/preferred_language.dart';
import '../mapper/session_mappers.dart';
import 'session_user_record.dart';

/// Session persistence: tokens in the [SessionTokenStore] (secure storage) and the user in `shared_preferences`. Only
/// used by the `iam` infrastructure (the session repositories and, on sign-in and session expiry, the authentication
/// one).
class SessionLocalDataSource {
  SessionLocalDataSource(this._preferences, this._tokenStore) : _record = _readRecord(_preferences);

  static const _userKey = 'session_user';

  final SharedPreferences _preferences;
  final SessionTokenStore _tokenStore;
  final _changes = StreamController<void>.broadcast();

  // The preferences are loaded in memory, so the current record is always read synchronously.
  SessionUserRecord? _record;

  /// Current user, then every change. A record that no longer forms a valid user counts as having no session.
  Stream<SessionUser?> get user async* {
    yield _currentUser();
    yield* _changes.stream.map((_) => _currentUser());
  }

  /// There is a user and a refresh token. Emits the current value and then every change, without repeats.
  Stream<bool> get isLoggedIn {
    late StreamController<bool> controller;
    StreamSubscription<bool>? tokens;
    StreamSubscription<SessionUser?>? users;
    controller = StreamController<bool>(
      onListen: () {
        bool? hasTokens;
        bool? hasUser;
        bool? last;
        void emit() {
          if (hasTokens == null || hasUser == null) return;
          final value = hasTokens! && hasUser!;
          if (value == last) return;
          last = value;
          controller.add(value);
        }

        tokens = _tokenStore.hasSession.listen((value) {
          hasTokens = value;
          emit();
        });
        users = user.listen((value) {
          hasUser = value != null;
          emit();
        });
      },
      onCancel: () async {
        await tokens?.cancel();
        await users?.cancel();
      },
    );
    return controller.stream;
  }

  /// Stores a newly started session.
  Future<void> save(SessionUser user, {required String accessToken, required String refreshToken}) async {
    await _tokenStore.save(accessToken: accessToken, refreshToken: refreshToken);
    // The account creation date never changes: for the same user, the one already read is kept.
    final previous = _record;
    final createdAt = previous != null && previous.userId == user.id.value ? previous.createdAt : null;
    await _write(user.toRecord(createdAt: createdAt));
  }

  /// Stored `createdAt` of user [userId], or `null` if not read yet (or another user).
  String? accountCreatedAt(int userId) {
    final record = _record;
    return record != null && record.userId == userId ? record.createdAt : null;
  }

  /// Stores `createdAt` if [userId] is still the signed-in user.
  Future<void> saveAccountCreatedAt(int userId, String createdAt) async {
    final record = _record;
    if (record == null || record.userId != userId) return;
    await _write(record.copyWith(createdAt: createdAt));
  }

  /// The language already saved on the account. Does nothing without a stored user.
  Future<void> updatePreferredLanguage(PreferredLanguage language) async {
    final record = _record;
    if (record == null) return;
    await _write(record.copyWith(preferredLanguage: language.code));
  }

  Future<void> clear() async {
    await _tokenStore.clear();
    _record = null;
    await _preferences.remove(_userKey);
    _changes.add(null);
  }

  Future<void> _write(SessionUserRecord record) async {
    _record = record;
    await _preferences.setString(_userKey, jsonEncode(record.toJson()));
    _changes.add(null);
  }

  SessionUser? _currentUser() {
    final record = _record;
    if (record == null) return null;
    try {
      return record.toDomain();
    } on ArgumentError {
      return null;
    }
  }

  static SessionUserRecord? _readRecord(SharedPreferences preferences) {
    final raw = preferences.getString(_userKey);
    if (raw == null) return null;
    try {
      return SessionUserRecord.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}

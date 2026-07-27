import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

/// The single provider exposing [SecureStorage]. Overridden in `main()` with a
/// concrete instance; the auth layer reads it through here.
@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) => throw UnimplementedError(
  'secureStorageProvider must be overridden in main()',
);

/// A minimal secure key-value backend. Abstracts the storage plugin so the
/// wrapper — and tests — never touch `flutter_secure_storage` directly.
abstract interface class SecureKeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// The ONLY place `flutter_secure_storage` is imported (CLAUDE.md §7): a thin
/// [SecureKeyValueStore] adapter over the plugin.
class _FlutterSecureKeyValueStore implements SecureKeyValueStore {
  const _FlutterSecureKeyValueStore(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Stores the auth token pair and the per-account onboarding flag (§4.3-B
/// fallback) in secure storage. Never logs values.
class SecureStorage {
  SecureStorage(this._store);

  /// Builds a [SecureStorage] over the real platform backend. The plugin is
  /// constructed only here, so callers (e.g. `main`) never import it.
  SecureStorage.platform()
    : _store = const _FlutterSecureKeyValueStore(FlutterSecureStorage());

  final SecureKeyValueStore _store;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _onboardingPrefix = 'onboarding_completed:';

  Future<String?> readAccessToken() => _store.read(_accessTokenKey);
  Future<String?> readRefreshToken() => _store.read(_refreshTokenKey);

  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _store.write(_accessTokenKey, accessToken);
    await _store.write(_refreshTokenKey, refreshToken);
  }

  /// Persists the account identity fetched via `me` (spec §6.2). The userId is
  /// the key for the per-account onboarding flag (§4.3-B).
  Future<void> writeUser({
    required String userId,
    required String userEmail,
  }) async {
    await _store.write(_userIdKey, userId);
    await _store.write(_userEmailKey, userEmail);
  }

  Future<void> clearSession() async {
    await _store.delete(_accessTokenKey);
    await _store.delete(_refreshTokenKey);
    await _store.delete(_userIdKey);
    await _store.delete(_userEmailKey);
  }

  // --- Per-account onboarding flag (spec §4.3-B local fallback) ---
  // TODO(introspection): if `user.onboardingCompleted` exists on the real
  // schema, prefer that server field (§4.3-A) and drop these local keys.

  Future<bool> isOnboardingCompleted(String userId) async {
    final String? value = await _store.read('$_onboardingPrefix$userId');
    return value == 'true';
  }

  Future<void> setOnboardingCompleted(String userId) =>
      _store.write('$_onboardingPrefix$userId', 'true');
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final FlutterSecureStorage _storage =
  const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    try {
      return await _storage
          .read(key: _tokenKey)
          .timeout(timeout, onTimeout: () => null);
    } catch (_) {
      return null;
    }
  }

  static Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (_) {
      // ignore
    }
  }
}

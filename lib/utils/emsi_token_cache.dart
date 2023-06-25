import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class EmsiTokenCache {
  static const String _tokenKey = 'emsi_token';
  // Create a function that returns the AndroidOptions with the encryptedSharedPreferences option set to true

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static final FlutterSecureStorage _secureStorage =
      FlutterSecureStorage(aOptions: _getAndroidOptions());

  Future<void> cacheToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  Future<bool> isTokenExpired() async {
    final String? token = await getToken();
    if (token == null) {
      return true;
    }

    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    if (decodedToken.containsKey('exp')) {
      final int expiryTimestamp = decodedToken['exp'];
      final DateTime expiryDateTime =
          DateTime.fromMillisecondsSinceEpoch(expiryTimestamp * 1000);

      final DateTime currentDateTime = DateTime.now();
      return currentDateTime.isAfter(expiryDateTime);
    }

    // If 'exp' claim is not present, consider the token as expired
    return true;
  }
}

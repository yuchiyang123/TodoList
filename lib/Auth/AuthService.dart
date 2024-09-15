import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final String _tokenKey = 'auth_token';

  Future<void> storeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getStoredToken() async {
    final String? token = await _storage.read(key: _tokenKey);
    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final String? token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'Googleinfo.dart';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<bool> isLoggedInByAuth() async {
    final String? token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  Stream<bool> authStateChanges() {
    return _auth.authStateChanges().map((user) => user != null);
  }

  Future<bool> isLoggedInByGoogle() async {
    return _auth.currentUser != null;
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'isEmailVerified': user.emailVerified,
        'providerId': user.providerData.isNotEmpty
            ? user.providerData[0].providerId
            : null,
      };
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await deleteToken();
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'AuthService.dart';
import 'GoogleInfo.dart';

class FirebaseGoogleSignIn extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String?, String?>?> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ["profile", "email"]).signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // 获取 ID token
      final String? idToken = await userCredential.user?.getIdToken();

      return {
        'idToken': await userCredential.user?.getIdToken(),
        'accessToken': googleAuth.accessToken,
      };
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      child: ElevatedButton(
        onPressed: () async {
          Map<String?, String?>? Token = await _handleSignIn();

          if (Token != null) {
            print('Signed in. ID Token: $Token');
            AuthService auth = AuthService();
            auth.storeToken(Token['accessToken']!);
            // 在这里处理成功登录后的逻辑，包括传递 token
            Map<String, dynamic>? userInfo =
                await fetchGoogleUserInfo(Token['accessToken']!);
            if (userInfo != "") {
              print('User Info:');
              print('ID: ${userInfo?['id']}');
              print('Email: ${userInfo?['email']}');
              print('Name: ${userInfo?['name']}');
              print('Picture URL: ${userInfo?['picture']}');
            }
          } else {
            print('Sign in failed');
            // 在这里处理登录失败的逻辑
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.redAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            constraints: BoxConstraints(minHeight: 45),
            alignment: Alignment.center,
            child: Text(
              'Google 登入',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

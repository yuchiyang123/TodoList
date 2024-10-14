import 'package:flutter/material.dart';
import 'package:todo/main.dart';
import 'package:todo/screens/login.dart';
import 'package:todo/screens/register.dart';
import 'package:todo/Auth/AuthService.dart'; // 請確保路徑正確

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => LoginPage(),
        register: (context) => Register(),
      };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<bool>(
            future: AuthService().isLoggedInByGoogle(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              } else {
                final isLoggedIn = snapshot.data ?? false;
                if (isLoggedIn) {
                  return Homepage();
                } else {
                  // 如果未登錄，重定向到登錄頁面
                  return LoginPage();
                }
              }
            },
          ),
        );
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => Register());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('找不到路由：${settings.name}'),
            ),
          ),
        );
    }
  }
}

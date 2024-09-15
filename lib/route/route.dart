import 'package:flutter/material.dart';
// 導入你的頁面
import 'package:todo/main.dart';
import 'package:todo/screens/login.dart';
import 'package:todo/screens/register.dart';
// 如果你有更多面，繼續導入

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  // 定義更多路由常量

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => Homepage(),
        login: (context) => LoginPage(),
        register: (context) => Register(),
        // 添加更多路由
      };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => Homepage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => Register());
      // 可以在這裡處理帶參數的路由
      // case somePageWithParams:
      //   final args = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(builder: (_) => SomePage(param: args['param']));
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

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/AddPage.dart';
import 'widgets/List.dart';
import 'screens/login.dart';
import 'route/route.dart';
import 'Auth/AuthService.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'), // 简体中文
        const Locale('zh', 'TW'), // 繁体中文
      ],
      title: '代辦事項',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: FutureBuilder<bool>(
        future: AuthService().isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 当正在检查登录状态时，显示加载指示器
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // 登录状态检查完成后，根据结果决定初始路由
            final isLoggedIn = snapshot.data ?? false;
            return MaterialApp(
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('zh', 'CN'), // 简体中文
                const Locale('zh', 'TW'), // 繁体中文
              ],
              title: '代辦事項',
              theme: ThemeData(primarySwatch: Colors.amber),
              initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
              routes: AppRoutes.routes,
              onGenerateRoute: AppRoutes.generateRoute,
            );
          }
        },
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (Text('代辦事項')),
      ),
      body: SafeArea(
        child: TodoListMain(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPage(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

void _showAddPage(BuildContext context) {
  showModalBottomSheet(
    // showModalBottomSheet flutter提供的函數 讓畫面可以由下而上的效果
    context: context,
    isScrollControlled: true,
    // 允許超過表單畫面
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GestureDetector(
        // GestureDetector監聽背景點擊事件
        onTap: () => Navigator.of(context).pop(), // 點擊背景回到主畫面
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            // 防止點擊表單而取消畫面
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.65, // 65%
              minChildSize: 0.2,
              maxChildSize: 0.75,
              builder: (_, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(150.0),
                      topRight: Radius.circular(150.0),
                    ),
                  ),
                  child: Addpage(),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

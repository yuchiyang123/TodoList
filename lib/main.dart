import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/AddPage.dart';
import 'widgets/List.dart';
import 'screens/login.dart';
import 'route/route.dart';
import 'Auth/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:todo/screens/draw.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale('zh', 'TW'),
      ],
      title: '代辦事項1',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: StreamBuilder<bool>(
        stream: _authService.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? Homepage() : LoginPage();
          }
        },
      ),
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.generateRoute,
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
      drawer: DrawerC(),
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

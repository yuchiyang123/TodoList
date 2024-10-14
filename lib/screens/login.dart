import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/route/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/Auth/GoogleAuth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userfieldcontroller = TextEditingController();
  final TextEditingController _passwordfieldcontroller =
      TextEditingController();

  @override
  void dispose() {
    _userfieldcontroller.dispose();
    _passwordfieldcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Todolistlogo.png',
                width: 200,
                height: 150,
              ),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 350),
                  child: TextField(
                    controller: _userfieldcontroller,
                    decoration: InputDecoration(
                      labelText: '用戶名',
                      hintText: '請輸入您的用戶名',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 350),
                  child: TextField(
                    controller: _userfieldcontroller,
                    decoration: InputDecoration(
                      labelText: '密碼',
                      hintText: '請輸入密碼',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 110,
                child: ElevatedButton(
                  onPressed: () {
                    // 登入邏輯
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
                        colors: [Colors.blue, Colors.blueAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      constraints: BoxConstraints(minHeight: 45),
                      alignment: Alignment.center,
                      child: Text(
                        '登入',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 110,
                child: ElevatedButton(
                  onPressed: () {
                    // 登入邏輯
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
                        colors: [Colors.blue, Colors.blueAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        constraints: BoxConstraints(minHeight: 45),
                        alignment: Alignment.center,
                        child: Text(
                          '註冊',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FirebaseGoogleSignIn(),
            ],
          ),
        ),
      ),
    );
  }
}

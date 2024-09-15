import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/route/route.dart';
import 'package:todo/services/UserService.dart';
import 'package:intl/intl.dart'; // DataTime
import 'package:todo/models/ToDoList.dart';
import 'package:todo/widgets/DDLImport.dart';
import 'package:todo/widgets/TimeDatePicker.dart';
import 'package:todo/services/ToDoListService.dart';
import 'package:todo/models/ToDoList.dart';
import 'package:todo/widgets/List.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _emailError;
  String? _userNameError;
  String? _passwordError;
  String? _rePasswordError;

  final TextEditingController _useremail = TextEditingController();
  final TextEditingController _userfieldcontroller = TextEditingController();
  final TextEditingController _reuserpassword = TextEditingController();
  final TextEditingController _userpassword = TextEditingController();

  UserService userService = new UserService();

  // 驗證欄位空值
  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName 不得為空';
    }
    return null;
  }

  // 驗證用戶名是否重複
  String? _validateUserNameRe(String? userName) {
    bool isRe = userService.checkUserName(userName);
    String? isNull = _validateField(userName, '用戶名');
    if (isRe) {
      return '用戶名已存在，請重新命名';
    } else if (isNull != null) {
      return isNull;
    }
    return null;
  }

  // 密碼原則 < 7
  String? _validatePassword(String password) {
    String? isNull = _validateField(password, '密碼');
    if (password.trim().length <= 7) {
      return '密碼請輸入大於7碼';
    } else if (isNull != null) {
      return isNull;
    }
    return null;
  }

  // 判斷兩個密碼是否同樣
  String? _validatePasswordRe() {
    if (_userpassword.text != _reuserpassword.text) {
      return '密碼不匹配';
    }
    if (_userpassword.text.isEmpty || _reuserpassword.text.isEmpty) {
      return '請填入兩個密碼欄位';
    } else {
      return null;
    }
  }

  String? _validateEmail(String email) {
    String? isNull = _validateField(email, 'Email');
    if (isNull != null) {
      return isNull;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return '請輸入有效的電子郵件';
    } else {
      return null;
    }
  }

  bool _validateAll() {
    bool isValid = true;
    setState(() {
      _emailError = _validateEmail(_useremail.text);
      if (_emailError != null) isValid = false;

      _userNameError = _validateUserNameRe(_userfieldcontroller.text);
      if (_userNameError != null) isValid = false;

      _passwordError = _validatePassword(_userpassword.text);
      if (_passwordError != null) isValid = false;

      _rePasswordError = _validatePasswordRe();
      if (_rePasswordError != null) isValid = false;
    });

    return isValid;
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
                  child: Container(
                height: 70,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 350),
                  child: TextFormField(
                    controller: _useremail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: '請輸入您的Email',
                      border: OutlineInputBorder(),
                      errorText: _emailError,
                    ),
                  ),
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Container(
                height: 70,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 350),
                  child: TextFormField(
                    controller: _userfieldcontroller,
                    decoration: InputDecoration(
                      labelText: '用戶名',
                      hintText: '請輸入您的用戶名',
                      border: OutlineInputBorder(),
                      errorText: _userNameError,
                    ),
                  ),
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Container(
                height: 70,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 350),
                  child: TextFormField(
                    controller: _userpassword,
                    decoration: InputDecoration(
                      labelText: '密碼',
                      hintText: '請輸入密碼',
                      border: OutlineInputBorder(),
                      errorText: _passwordError,
                    ),
                  ),
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Container(
                height: 70,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 350),
                  child: TextFormField(
                    controller: _reuserpassword,
                    decoration: InputDecoration(
                      labelText: '驗證密碼',
                      hintText: '請再次輸入密碼',
                      border: OutlineInputBorder(),
                      errorText: _rePasswordError,
                    ),
                  ),
                ),
              )),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 110,
                child: ElevatedButton(
                  onPressed: () {
                    // 註冊邏輯
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
                        if (_validateAll()) {
                          UserService user = new UserService();
                          user.createUser(
                            name: _userfieldcontroller.text,
                            email: _useremail.text,
                            password: _userpassword.text,
                          );
                          String userId = user
                              .getUseridByUsername(_userfieldcontroller.text);
                          user.setUserToken(userId);
                        } else {
                          print('?');
                        }
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
                height: 35,
              ),
              Container(
                  child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: Text(
                  '已經有帳號了? 點選返回登入',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

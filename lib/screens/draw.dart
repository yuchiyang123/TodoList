import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/Auth/AuthService.dart';

class DrawerC extends StatefulWidget {
  const DrawerC({super.key});

  @override
  State<DrawerC> createState() => _DrawerCState();
}

class _DrawerCState extends State<DrawerC> {
  final auth = AuthService();
  bool _isLoginByGoogle = false;
  dynamic _userinfo = '';
  bool _isSignOut = false;

  @override
  void initState() {
    super.initState();
    _checkGoogleLoginIn();
    _getUserInfoByGooogle();
  }

  Future<void> _getUserInfoByGooogle() async {
    final UserInfo = await auth.getUserInfo();
    setState(() {
      _userinfo = UserInfo;
    });
  }

  Future<void> _checkGoogleLoginIn() async {
    final isLoggedInByGoogle = await auth.isLoggedInByGoogle();
    setState(() {
      _isLoginByGoogle = isLoggedInByGoogle;
    });
  }

  Widget convertGoogleImg(String url, {double size = 60}) {
    if (url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return Icon(
      Icons.account_circle,
      size: 100,
      color: Colors.grey,
    );
  }

  Widget _signOutfun() {
    auth.signOut();
    Navigator.of(context).pop();
    return SnackBar(
      content: Text('登出成功'),
      backgroundColor: Colors.red,
    );
  }

  void _showDialogPage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('登出'),
            content: Text('請問確定要登出嗎?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: _signOutfun,
                child: Text('確定'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 123, 180, 226), // 稍深一點的藍色
            ),
            child: _isLoginByGoogle
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '歡迎回來',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 8), // 添加一些間距
                      Row(
                        children: [
                          convertGoogleImg(_userinfo['photoURL']),
                          SizedBox(width: 8), // 在圖片和文字之間添加一些間距
                          Text(
                            _userinfo['displayName'] ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(
                    '測試',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
          ),
          Expanded(child: Container()),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            title: Text(
              '登出',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            onTap: () {
              _showDialogPage();
            },
          ),
        ],
      ),
    );
  }
}

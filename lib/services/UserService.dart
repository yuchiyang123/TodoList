import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:todo/Auth/AuthService.dart';

// 假設我們從之前的 artifact 導入 User 模型
import 'package:todo/models/User.dart';

class UserService {
  // 模擬數據庫
  final List<User> _users = [];

  // 獲取所有用戶
  List<User> getAllUsers() {
    return List.from(_users);
  }

  // 根據 ID 獲取用戶
  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null; // 如果沒找到用戶，返回 null
    }
  }

  // 創建新用戶
  User createUser({
    required String name,
    required String email,
    String? phoneNumber,
    UserStatus status = UserStatus.active,
    UserRole role = UserRole.user,
    required String password,
  }) {
    final newUser = User(
      id: _generateId(),
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      status: status,
      role: role,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      password: password,
    );
    _users.add(newUser);
    return newUser;
  }

  // 更新用戶信息
  User updateUser(User updatedUser) {
    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      return updatedUser;
    } else {
      throw Exception('User not found');
    }
  }

  // 檢查是否有該用戶名
  bool checkUserName(String? username) {
    try {
      _users.firstWhere((user) => user.name == username);
      return true;
    } catch (e) {
      return false;
    }
  }

  String getUseridByUsername(String username) {
    final isUser = checkUserName(username);
    if (isUser) {
      User userData = _users.firstWhere((user) => user.name == username);
      return userData.id;
    }
    return '';
  }

  // 更新用戶最後登錄時間
  void updateLastLogin(String id) {
    final user = getUserById(id);
    if (user != null) {
      user.updateLastLogin();
    }
  }

  // 根據狀態篩選用戶
  List<User> getUsersByStatus(UserStatus status) {
    return _users.where((user) => user.status == status).toList();
  }

  // 根據角色篩選用戶
  List<User> getUsersByRole(UserRole role) {
    return _users.where((user) => user.role == role).toList();
  }

  // 生成唯一 ID（簡單實現，實際應用中可能需要更復雜的邏輯）
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  // 生成 token
  String generateToken(String userId) {
    final now = DateTime.now();
    final expiryTime = now.add(Duration(hours: 24)); // Token 有效期為 24 小時
    final data =
        '$userId|${now.toIso8601String()}|${expiryTime.toIso8601String()}';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes);
  }

  // 為用戶設置 token
  void setUserToken(String userId) {
    AuthService userAuth = new AuthService();
    final user = getUserById(userId);
    if (user != null) {
      final token = generateToken(userId);
      user.setToken(token);
      userAuth.storeToken(token);
      updateUser(user);
    } else {
      throw Exception('User not found');
    }
  }

  // 驗證 token
  bool verifyToken(String userId, String token) {
    final user = getUserById(userId);
    if (user != null && user.token == token) {
      final parts = String.fromCharCodes(base64Url.decode(token)).split('|');
      if (parts.length == 3) {
        final expiryTime = DateTime.parse(parts[2]);
        return DateTime.now().isBefore(expiryTime);
      }
    }
    return false;
  }

  // 清除用戶 token
  void clearUserToken(String userId) {
    final user = getUserById(userId);
    if (user != null) {
      user.clearToken();
      updateUser(user);
    } else {
      throw Exception('User not found');
    }
  }

  // 根據 token 獲取用戶
  User? getUserByToken(String token) {
    try {
      return _users.firstWhere((user) => user.token == token);
    } catch (e) {
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

enum UserStatus { active, inactive, suspended }

enum UserRole { user, admin, superAdmin }

class User {
  final String id;
  final String name;
  final String email;
  String? phoneNumber;
  UserStatus status;
  UserRole role;
  final DateTime createdAt;
  DateTime lastLoginAt;
  String? token;
  String passwordHash; // 存储加密后的密码

  User(
      {required this.id,
      required this.name,
      required this.email,
      required String password, // 构造函数接收明文密码
      this.phoneNumber,
      this.status = UserStatus.active,
      this.role = UserRole.user,
      required this.createdAt,
      required this.lastLoginAt,
      this.token})
      : passwordHash = _hashPassword(password); // 初始化时加密密码

  // 静态方法用于加密密码
  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // 验证密码
  bool checkPassword(String password) {
    return passwordHash == _hashPassword(password);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: '', // 从 JSON 创建时不设置密码
      phoneNumber: json['phoneNumber'],
      status: UserStatus.values
          .firstWhere((e) => e.toString() == 'UserStatus.${json['status']}'),
      role: UserRole.values
          .firstWhere((e) => e.toString() == 'UserRole.${json['role']}'),
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
      token: json['token'],
    )..passwordHash = json['passwordHash']; // 直接设置密码哈希
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'status': status.toString().split('.').last,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'token': token,
      'passwordHash': passwordHash, // 存储加密后的密码
    };
  }

  void updateLastLogin() {
    lastLoginAt = DateTime.now();
  }

  void setToken(String newToken) {
    token = newToken;
  }

  void clearToken() {
    token = null;
  }

  // 更新密码
  void updatePassword(String newPassword) {
    passwordHash = _hashPassword(newPassword);
  }
}

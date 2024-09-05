import 'package:flutter/material.dart';

class Todolist {
  final int? id;
  final String title;
  final String? describe;
  final String createtime;
  final String? neetime;
  final String importance;
  final String status;
  final String? finishtime;
  final String tags;
  final bool isneedremind;
  final bool isreply;
  final String? replytime;
  final String creator;

  Todolist({
    this.id,
    required this.title,
    this.describe,
    required this.createtime,
    this.neetime,
    required this.importance,
    required this.status,
    this.finishtime,
    required this.tags,
    required this.isneedremind,
    required this.isreply,
    this.replytime,
    required this.creator,
  });

  // 將Todolist對象轉換為Map，用於插入到SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'describe': describe,
      'createtime': createtime,
      'neetime': neetime ?? null,
      'importance': importance,
      'status': status,
      'finishtime': finishtime ?? null,
      'tags': tags,
      'isneedremind': isneedremind ? 1 : 0,
      'isreply': isreply ? 1 : 0,
      'replytime': replytime,
      'creator': creator,
    };
  }

  // 從Map創建Todolist對象，用於從SQLite讀取數據
  factory Todolist.fromMap(Map<String, dynamic> map) {
    return Todolist(
      id: map['id'],
      title: map['title'],
      describe: map['describe'],
      createtime: map['createtime'],
      neetime: map['neetime'] != null ? (map['neetime']) : null,
      importance: map['importance'],
      status: map['status'],
      finishtime: map['finishtime'] != null ? (map['finishtime']) : null,
      tags: map['tags'],
      isneedremind: map['isneedremind'] == 1,
      isreply: map['isreply'] == 1,
      replytime: map['replytime'],
      creator: map['creator'],
    );
  }

  /// 輔助方法：將TimeOfDay轉換為字符串
  static String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  /// 輔助方法：將字符串轉換為TimeOfDay
  static TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/models/ToDoList.dart'; // 假設您的Todolist模型在這個文件中
import 'package:todo/Auth/AuthService.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<void> _getUserInfo() async {
    final UserInfo = await AuthService().getUserInfo();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todolist.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todolist(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        describe TEXT,
        createtime TEXT NOT NULL,
        neetime TEXT,
        importance TEXT NOT NULL,
        status TEXT NOT NULL,
        finishtime TEXT,
        tags TEXT NOT NULL,
        isneedremind INTEGER NOT NULL,
        isreply INTEGER NOT NULL,
        replytime TEXT,
        creator TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Todolist todolist) async {
    final db = await instance.database;
    return await db.insert('todolist', todolist.toMap());
  }

  Future<List<Todolist>> getAllTodolists() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('todolist');
    return List.generate(maps.length, (i) {
      return Todolist.fromMap(maps[i]);
    });
  }

  Future<Todolist?> getTodolistByid(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todolist',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Todolist.fromMap(maps.first);
    }
    return null;
  }

  /// 取得使用者的todoList
  Future<List<Todolist>?> getTodolistByUser(String UserName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todolist',
      where: 'creator = ? AND status = ?',
      whereArgs: [UserName, 'pending'],
    );

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Todolist.fromMap(maps[i]);
      });
    }
    return null;
  }

  Future<int> update(Todolist todolist) async {
    final db = await instance.database;
    return await db.update(
      'todolist',
      todolist.toMap(),
      where: 'id = ?',
      whereArgs: [todolist.id],
    );
  }

  /// 刪除
  Future<int> updataDel(int? id) async {
    final db = await instance.database;
    return await db.update(
      'todolist',
      {'status': 'delete'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 禁止使用
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'todolist',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

class ToDoListService {
  final _todoListController = StreamController<List<Todolist>>.broadcast();

  Stream<List<Todolist>> getTodolistStream(String userName) {
    loadTodolist(userName);
    return _todoListController.stream;
  }

  Future<void> loadTodolist(String userName) async {
    try {
      List<Todolist>? loadedList =
          await DatabaseHelper.instance.getTodolistByUser(userName);
      _todoListController.add(loadedList ?? []);
    } catch (e) {
      _todoListController.addError(e);
    }
  }

  Future<void> addTodoItem(Todolist newItem) async {
    await DatabaseHelper.instance.insert(newItem);
    //_loadTodolist('matthew'); // 重新加載數據
  }

  Future<void> updateTodoItem(Todolist updatedItem) async {
    await DatabaseHelper.instance.update(updatedItem);
    loadTodolist('matthew'); // 重新加載數據
  }

  Future<void> deleteTodoItem(int id) async {
    await DatabaseHelper.instance.delete(id);
    loadTodolist('matthew'); // 重新加載數據
  }

  void dispose() {
    _todoListController.close();
  }
}

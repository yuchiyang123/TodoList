import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/models/ToDoList.dart'; // 假設您的Todolist模型在這個文件中

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

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

  /// 123456
  Future<List<Todolist>?> getTodolistByUser(String UserName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todolist',
      where: 'creator = ?',
      whereArgs: [UserName],
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

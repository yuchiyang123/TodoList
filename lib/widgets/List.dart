import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todo/models/ToDoList.dart';
import 'package:todo/services/ToDoListService.dart';

final todoListKey = GlobalKey<_TodoListMainState>();

class TodoListMain extends StatefulWidget {
  TodoListMain({Key? key}) : super(key: key ?? todoListKey);

  @override
  _TodoListMainState createState() => _TodoListMainState();
}

class _TodoListMainState extends State<TodoListMain> {
  late final ToDoListService _todoListService;
  List<Todolist> _todoItems = [];

  @override
  void initState() {
    super.initState();
    _todoListService = ToDoListService();
  }

  @override
  void dispose() {
    _todoListService.dispose();
    super.dispose();
  }

  Future<void> _loadTodoItems() async {
    List<Todolist>? items =
        await DatabaseHelper.instance.getTodolistByUser('matthew');
    setState(() {
      _todoItems = items ?? [];
    });
  }

  void refreshList() {
    _loadTodoItems();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todolist>>(
      stream: _todoListService.getTodolistStream('matthew'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('發生錯誤：${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('沒有待辦事項'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildTodoItem(snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget _buildTodoItem(Todolist todo) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    todo.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getImportanceColor(todo.importance),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    todo.importance,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('時間: ${todo.createtime}'),
            Text('標籤: ${todo.tags}'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(todo.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    todo.status,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showMultiButtonDialog(context, todo.id);
                    },
                    icon: Icon(Icons.delete))
              ],
            )
          ],
        ),
      ),
    );
  }

  void showMultiButtonDialog(BuildContext context, int? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('刪除'),
          content: Text('您確定要刪除這則代辦事項嗎?'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('確定'),
              onPressed: () {
                // 執行操作
                DatabaseHelper.instance.updataDel(id);
                todoListKey.currentState?.refreshList();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color _getImportanceColor(String importance) {
    switch (importance.toLowerCase()) {
      case '高':
        return Colors.red;
      case '中':
        return Colors.orange;
      case '低':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'delete':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

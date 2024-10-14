import 'package:flutter/material.dart';
import 'package:todo/models/ToDoList.dart';
import 'package:todo/services/ToDoListService.dart';
import 'package:todo/Auth/AuthService.dart';
import 'package:todo/screens/ModifyPage.dart';

final todoListKey = GlobalKey<_TodoListMainState>();

class TodoListMain extends StatefulWidget {
  TodoListMain({Key? key}) : super(key: key ?? todoListKey);

  @override
  _TodoListMainState createState() => _TodoListMainState();
}

class _TodoListMainState extends State<TodoListMain> {
  final auth = AuthService();
  late final ToDoListService _todoListService;
  List<Todolist> _todoItems = [];

  dynamic _userInfo = '';
  bool _isUserInfoReady = false;

  Future<void> _getUserInfo() async {
    final userInfo = await auth.getUserInfo();
    setState(() {
      _userInfo = userInfo;
      _isUserInfoReady = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _todoListService = ToDoListService();
    _getUserInfo();
  }

  @override
  void dispose() {
    _todoListService.dispose();
    super.dispose();
  }

  Future<void> _loadTodoItems() async {
    List<Todolist>? items = await DatabaseHelper.instance
        .getTodolistByUser(_userInfo['displayName']);
    setState(() {
      _todoItems = items ?? [];
    });
  }

  void refreshList() {
    _loadTodoItems();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUserInfoReady) {
      return Row(
        children: [
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    } else {
      return StreamBuilder<List<Todolist>>(
        stream: _todoListService.getTodolistStream(_userInfo['displayName']),
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
            Text('時間: ${todo.createtime} ${todo.neetime}'),
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
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Modifypage(
                            pretitle: todo.title,
                            preimport: todo.importance,
                            pretags: todo.tags,
                            prestatus: todo.status,
                            predateTime: todo.createtime,
                            pretimeofday: todo.neetime,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.mode_edit),
                  ),
                  IconButton(
                    onPressed: () {
                      showMultiButtonDialog(context, todo.id);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ]),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // DataTime
import 'package:todo/models/ToDoList.dart';
import 'package:todo/widgets/DDLImport.dart';
import 'package:todo/widgets/TimeDatePicker.dart';
import 'package:todo/services/ToDoListService.dart';
import 'package:todo/models/ToDoList.dart';
import 'package:todo/widgets/List.dart';
import 'package:todo/Auth/AuthService.dart';

class Modifypage extends StatefulWidget {
  //const Modifypage({super.key});

  final String pretitle;
  final String preimport;
  final String pretags;
  final String prestatus;
  final String predateTime;
  final String? pretimeofday;

  const Modifypage({
    Key? key,
    required this.pretitle,
    required this.preimport,
    required this.pretags,
    required this.prestatus,
    required this.predateTime,
    required this.pretimeofday,
  }) : super(key: key);

  @override
  State<Modifypage> createState() => _ModifypageState();
}

class _ModifypageState extends State<Modifypage> {
  late TextEditingController _controller;
  String tagName = '';
  String importance = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? _errorText;
  dynamic _userinfo = '';
  bool isHasData = false;
  bool isUpdate = false;

  Future<void> _updateState() async {
    setState(() {
      isUpdate = true;
    });
  }

  Future<void> _getUserInfoByGoogle() async {
    final UserInfo = await AuthService().getUserInfo();
    setState(() {
      _userinfo = UserInfo;
      isHasData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _getUserInfoByGoogle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        value = widget.pretitle;
      } else {
        _errorText = null;
      }
    });
  }

  String? _updateTitle(String value) {
    String? preValue;
    setState(() {
      if (value.isEmpty) {
        preValue = widget.pretitle;
      } else {
        preValue = value;
      }
    });
    return preValue;
  }

  void _updateText(String newTagName) {
    setState(() {
      if (tagName.contains(newTagName)) {
        tagName = tagName.split(',').where((e) => e != newTagName).join(',');
      } else {
        tagName = tagName.isEmpty ? newTagName : '$tagName, $newTagName';
      }
    });
  }

  void _updateImportance(String newImportance) {
    setState(() {
      importance = newImportance;
    });
  }

  // 添加方法来更新日期
  void _updateTime(TimeOfDay time) {
    setState(() {
      selectedTime = time ?? TimeOfDay.now();
    });
  }

  void _updateDate(DateTime date) {
    setState(() {
      selectedDate = date ?? DateTime.now();
    });
  }

  Map<String, dynamic> getAllValues() {
    return {
      'title': _controller.text,
      'tags': tagName.isEmpty ? '無' : tagName,
      'date': selectedDate != null
          ? selectedDate.toString().split(' ')[0]
          : DateTime.now().toString().split(' ')[0], // 轉換為字符串
      'time': selectedTime != null
          ? selectedTime?.format(context)
          : TimeOfDay.now().format(context), // 使
      'importance': importance.isEmpty ? '中' : importance,
      'status': 'pending',
      'isneedremind': '0',
      'isreply': '0',
      'creator': _userinfo['displayName']
    };
  }

  Future<int> insertTodoList(BuildContext context) async {
    Map<String, dynamic> values = getAllValues();

    // 創建 Todolist 對象
    final todolist = Todolist(
      title: values['title'],
      describe: null, // getAllValues() 沒有提供 describe
      createtime: values['date'], // 使用當前時間作為創建時間
      neetime: values['time'],
      importance: values['importance'],
      status: values['status'],
      finishtime: null, // getAllValues() 沒有提供 finishtime
      tags: values['tags'],
      isneedremind: values['isneedremind'] == '1',
      isreply: values['isreply'] == '1',
      replytime: null, // getAllValues() 沒有提供 replytime
      creator: values['creator'],
    );

    return DatabaseHelper.instance.update(todolist);
  }

  void onSaveButtonTodoList(BuildContext context) async {
    final insertTodo = await insertTodoList(context);

    if (insertTodo > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('待辦事項已成功保存')),
      );
      Navigator.pop(context);
    } else {
      print('插入失敗');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失敗，請重試')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: (Text(
            '修改代辦',
          )),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  // 儲存
                  _updateTitle(_controller.text);
                  if (_errorText == null) {
                    onSaveButtonTodoList(context);
                    if (isHasData) {
                      List<Todolist>? updatedData = await DatabaseHelper
                          .instance
                          .getTodolistByUser(_userinfo['displayName']);
                      final a = await ToDoListService();
                      a.loadTodolist(_userinfo['displayName']);
                      todoListKey.currentState?.refreshList();
                    } else {
                      print('還沒更新');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_errorText!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.edit))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 從頭開始
            crossAxisAlignment: CrossAxisAlignment.center, //水平置中
            children: [
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 370),
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: widget.pretitle,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 177, 177, 177),
                            width: 1.4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Color.fromARGB(120, 0, 0, 0), width: 1.7),
                      ),
                    ),
                    onChanged: _validateInput,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: Text(
                    'Tags',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              Container(
                width: double.infinity, // 設置為無限大，意味占滿整個父容器(跟父容器一樣大)
                height: 150,
                padding: EdgeInsets.all(10),
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    border:
                        Border.all(color: Color.fromARGB(255, 179, 176, 176)),
                    borderRadius: BorderRadius.circular(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.tag_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                          Text(' 標籤 : $tagName'),
                        ],
                      ),
                    ),
                    Container(
                      height: 0.5,
                      color: Colors.black,
                      margin: EdgeInsets.only(top: 5),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Tag(onTagTap: _updateText),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('此事的重要性  ', style: TextStyle(fontSize: 16)),
                    CupertinoDropDownListImportant(
                      onImportant: _updateImportance,
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    TimePicker(
                      onTimeChanged: _updateTime,
                      preTime: widget.pretimeofday,
                    ),
                    DatePick(
                      onDateChanged: _updateDate,
                      preTime: widget.predateTime,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tag extends StatefulWidget {
  final Function(String) onTagTap;

  Tag({required this.onTagTap});

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  final List<TagData> tags = [
    TagData(name: '工作', color: Colors.blue),
    TagData(name: '個人', color: Colors.green),
    TagData(name: '緊急', color: Colors.red),
    TagData(name: '學習', color: Colors.orange),
    TagData(name: '健康', color: Colors.purple),
    TagData(name: '家庭', color: Colors.pink),
    TagData(name: '專案', color: Colors.teal),
    TagData(name: '會議', color: Colors.indigo),
    TagData(name: '購物', color: Colors.amber),
    TagData(name: '閱讀', color: Colors.brown),
  ];

  void _isTap(int index) {
    setState(() {
      tags[index].isTap = !tags[index].isTap;
    });
    widget.onTagTap(tags[index].name);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Expanded 主要是使用父容器的剩餘空間，如果要讓容器可以滑動的話
      child: SingleChildScrollView(
        // 讓容器可以變成可滑動的
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Wrap(
          spacing: 6,
          runSpacing: 8,
          children: tags
              .asMap()
              .entries
              .map((entry) => _buildTagChip(entry.key, entry.value))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTagChip(int index, TagData tag) {
    return Container(
        constraints: BoxConstraints(maxWidth: 65),
        child: Stack(
          children: [
            InkWell(
              onTap: () => _isTap(index),
              child: Chip(
                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // 減小點擊區域
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                label: Text(tag.name),
                backgroundColor: tag.color.withOpacity(0.2),
                labelStyle: TextStyle(color: tag.color),
              ),
            ),
            if (!tag.isTap)
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ))
          ],
        ));
  }
}

class TagData {
  final String name;
  final Color color;
  bool isTap;

  TagData({required this.name, required this.color, this.isTap = true});
}

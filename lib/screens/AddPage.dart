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

class Addpage extends StatefulWidget {
  const Addpage({super.key});

  @override
  State<Addpage> createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {
  late TextEditingController _controller;
  String tagName = '';
  String importance = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorText = '標題不得為空';
      } else {
        _errorText = null;
      }
    });
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
      'importance': importance.isEmpty ? '中' : importance
    };
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
          title: (Text('新增代辦')),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  // 儲存
                  _validateInput(_controller.text);
                  if (_errorText == null) {
                    Map<String, dynamic> allvalue = getAllValues();
                    print(allvalue);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_errorText!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.add))
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
                      hintText: '請輸入代辦事項..',
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
                    TimePicker(onTimeChanged: _updateTime),
                    DatePick(onDateChanged: _updateDate),
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

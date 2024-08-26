import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Addpage extends StatefulWidget {
  const Addpage({super.key});

  @override
  State<Addpage> createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {
  String tagName = '';

  void _updateText(String newTagName) {
    setState(() {
      if (tagName.contains(newTagName)) {
        tagName = tagName.split(',').where((e) => e != newTagName).join(',');
      } else {
        tagName = tagName.isEmpty ? newTagName : '$tagName,$newTagName';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('新增代辦')),
        centerTitle: true,
      ),
      body: Column(
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
                controller: TextEditingController(),
                decoration: InputDecoration(
                  hintText: '請輸入代辦事項..',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 177, 177, 177), width: 1.4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color.fromARGB(120, 0, 0, 0), width: 1.7),
                  ),
                ),
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
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border.all(color: Color.fromARGB(255, 179, 176, 176)),
                borderRadius: BorderRadius.circular(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
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

  final Function(String) onTagTap;

  Tag({required this.onTagTap});

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
          children: tags.map((tag) => _buildTagChip(tag)).toList(),
        ),
      ),
    );
  }

  Widget _buildTagChip(TagData tag) {
    return Container(
      constraints: BoxConstraints(maxWidth: 65),
      child: InkWell(
        onTap: () => onTagTap(tag.name),
        child: Chip(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 減小點擊區域
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          label: Text(tag.name),
          backgroundColor: tag.color.withOpacity(0.2),
          labelStyle: TextStyle(color: tag.color),
        ),
      ),
    );
  }
}

class TagData {
  final String name;
  final Color color;

  TagData({required this.name, required this.color});
}

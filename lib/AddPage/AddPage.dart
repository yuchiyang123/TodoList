import 'dart:ffi';

import 'package:flutter/material.dart';

class Addpage extends StatefulWidget {
  const Addpage({super.key});

  @override
  State<Addpage> createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {
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
            padding: EdgeInsets.all(12),
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
        ],
      ),
    );
  }
}

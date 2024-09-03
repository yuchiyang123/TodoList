import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatefulWidget {
  final Function(TimeOfDay) onTimeChanged;

  TimePicker({required this.onTimeChanged});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeChanged(_selectedTime); // 调用回调函数
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '請選擇時間: ${_selectedTime.format(context)}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _selectTime(context),
            child: Text('請選擇時間'),
          )
        ],
      ),
    );
  }
}

class DatePick extends StatefulWidget {
  final Function(DateTime) onDateChanged;

  const DatePick({Key? key, required this.onDateChanged}) : super(key: key);

  @override
  State<DatePick> createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('zh'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateChanged(_selectedDate); // 调用回调函数
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '選擇的日期: ${DateFormat('yyyy年MM月dd日', 'zh').format(_selectedDate)}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 18),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('選擇日期'),
          ),
        ],
      ),
    );
  }
}

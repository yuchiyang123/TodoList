import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatefulWidget {
  String? preTime;
  final Function(TimeOfDay) onTimeChanged;

  TimePicker({required this.onTimeChanged, this.preTime});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  //TimeOfDay _selectedTime = TimeOfDay.now();

  late TimeOfDay _selectedTime;

  void initState() {
    super.initState();
    _selectedTime = _getInitTimeOfData();
  }

  TimeOfDay _getInitTimeOfData() {
    if (widget.preTime != null && widget.preTime!.isNotEmpty) {
      TimeOfDay? _getPreTime = stringToTimeOfDay(widget.preTime!);
      return _getPreTime ?? TimeOfDay.now();
    }
    return TimeOfDay.now();
  }

  TimeOfDay? stringToTimeOfDay(String timeString) {
    try {
      // 移除所有空格
      timeString = timeString.replaceAll(' ', '');

      // 檢查是否包含 "上午" 或 "下午"
      bool isPM = timeString.startsWith('下午');

      // 移除 "上午" 或 "下午"
      timeString = timeString.replaceAll('上午', '').replaceAll('下午', '');

      final List<String> timeParts = timeString.split(':');
      if (timeParts.length == 2) {
        int hour = int.parse(timeParts[0]);
        final int minute = int.parse(timeParts[1]);

        // 處理下午的時間
        if (isPM && hour != 12) {
          hour += 12;
        }
        // 處理上午的 12 點（凌晨）
        if (!isPM && hour == 12) {
          hour = 0;
        }

        if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
      throw FormatException('Invalid time format');
    } catch (e) {
      print('無法轉換時間字符串: $timeString. 錯誤: $e');
      return null;
    }
  }

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
  String? preTime;

  final Function(DateTime) onDateChanged;

  DatePick({
    Key? key,
    required this.onDateChanged,
    this.preTime,
  }) : super(key: key);

  @override
  State<DatePick> createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _getInitDataTime();
  }

  DateTime _getInitDataTime() {
    if (widget.preTime != null && widget.preTime!.isNotEmpty) {
      DateTime? _dataTime = stringToDateTime(widget.preTime!);
      return _dataTime ?? DateTime.now();
    }
    return DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _selectedDate,
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

  DateTime? stringToDateTime(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      print("無法轉換日期時間字符串: $dateTimeString");
      return null;
    }
  }
}

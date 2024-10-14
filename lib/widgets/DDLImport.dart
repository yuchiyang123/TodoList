import 'package:flutter/cupertino.dart';

class CupertinoDropDownListImportant extends StatefulWidget {
  final String? preImport;
  final Function(String) onImportant;

  CupertinoDropDownListImportant({required this.onImportant, this.preImport});

  @override
  State<CupertinoDropDownListImportant> createState() =>
      _CupertinoDropDownListImportantState();
}

class _CupertinoDropDownListImportantState
    extends State<CupertinoDropDownListImportant> {
  String? selectedValue; // 預設選擇

  void initState() {
    super.initState();
    selectedValue = _getInitImport();
  }

  String? _getInitImport() {
    if (widget.preImport != null && widget.preImport!.isNotEmpty) {
      return widget.preImport ?? '中';
    }
    return '中';
  }

  final List<String> options = ['高', '中', '低'];

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Text(selectedValue!),
      onPressed: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32.0,
                scrollController: FixedExtentScrollController(
                  initialItem: options.indexOf(selectedValue!),
                ),
                onSelectedItemChanged: (int selectedIndex) {
                  setState(() {
                    selectedValue = options[selectedIndex];
                    widget.onImportant(selectedValue!);
                  });
                },
                children: List<Widget>.generate(options.length, (int index) {
                  return Center(
                    child: Text(
                      options[index],
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCategoryPicker(context, controller) {
  final list = ['バトル', 'JAM', 'ワークショップ', 'レッスン', 'コンテスト', '練習会', 'その他'];
  final _pickerItems = list.map((item) => Text(item)).toList();
  var selectedIndex = 0;

  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.white,
        height: 216,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: CupertinoPicker(
            itemExtent: 32,
            children: _pickerItems,
            onSelectedItemChanged: (int index) {
              selectedIndex = index;
            },
          ),
        ),
      );
    },
  ).then((_) {
    if (selectedIndex != null) {
      controller.value = TextEditingValue(text: list[selectedIndex]);
    }
  });
}

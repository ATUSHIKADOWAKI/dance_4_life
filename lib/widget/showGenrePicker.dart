import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showGenrePicker(context, controller) {
  final list = [
    'HIPHOP',
    'LOCKIN',
    'POPIN',
    'BREAKIN',
    'HOUSE',
    'ALLSTYLE',
    'その他'
  ];
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

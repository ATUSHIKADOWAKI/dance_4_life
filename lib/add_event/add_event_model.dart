import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEventModel extends ChangeNotifier {
  String? title;
  String? date;
  String? eventCategory;
  String? eventGenre;
  String? eventAddress;
  String? eventPlace;
  String? eventPrice;

  String? detail;
  File? imageFile;
  bool isLoading = false;
  final timestamp = DateTime.now();
  final textEditingController = TextEditingController();
  final genrePickerEditingController = TextEditingController();
  final categoryPickerEditingController = TextEditingController();

  var currentIndex = 0;

  final picker = ImagePicker();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setIndex(index) {
    currentIndex = index;
    notifyListeners();
  }

  Future getDate(BuildContext context) async {
    final initialDate = DateTime.now();

    final newDate = await showDatePicker(
      locale: const Locale("ja"),
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
    );

    if (newDate != null) {
      //選択した日付をTextFormFieldに設定
      textEditingController.text = DateFormat("yyyy年MM月dd日").format(newDate);
      date = textEditingController.text;
    } else {
      return;
    }
  }

  Future addEvent() async {
    eventCategory = categoryPickerEditingController.text;
    eventGenre = genrePickerEditingController.text;

    //「title=""」も「date!.isEmpt」yも一緒の意味
    if (title == null || title == "") {
      throw 'イベントのタイトルが空です。';
    }
    if (eventCategory == null || eventCategory!.isEmpty) {
      throw '日程が空です。';
    }
    if (eventGenre == null || eventGenre!.isEmpty) {
      throw 'ジャンルが空です。';
    }
    if (date == null || date == "") {
      throw '日程が空です。';
    }
    if (eventPlace == null || eventPlace!.isEmpty) {
      throw '開催場所が空です。';
    }
    if (eventAddress == null || eventAddress!.isEmpty) {
      throw '住所が空です。';
    }
    if (eventPrice == null || eventPrice!.isEmpty) {
      throw '参加料金が空です。';
    }
    if (detail == null || detail!.isEmpty) {
      throw '詳細が空です。';
    }

    final uid = await FirebaseAuth.instance.currentUser!.uid;

    final doc = FirebaseFirestore.instance.collection('event').doc();

    String? imgURL;

    //storageにアップロード nullじゃなければ
    if (imageFile != null) {
      final task = await FirebaseStorage.instance
          .ref('event/${doc.id}')
          .putFile(imageFile!);
      imgURL = await task.ref.getDownloadURL();
    }

    //FireStoreに追加
    await doc.set({
      'eventID': doc.id,
      'title': title,
      'eventCategory': eventCategory,
      'eventGenre': eventGenre,
      'eventPlace': eventPlace,
      'eventAddress': eventAddress,
      'eventPrice': eventPrice,
      'date': date,
      'detail': detail,
      'imgURL': imgURL,
      'timestamp': timestamp,
      'uid': uid,
    });
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}

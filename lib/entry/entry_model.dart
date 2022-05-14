import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EntryModel extends ChangeNotifier {
  EntryModel(id) {
    eventId = id;
  }
  String? user;
  String? rep;
  String? genre;
  bool isLoading = false;
  String? eventId;

  final timestamp = DateTime.now();
  final picker = ImagePicker();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  //ヌルチェック 空だったらFireStoreに入れたくない
  Future addEntry(String eventTitle, String eventDate) async {
    //「title=""」も「date!.isEmpt」yも一緒の意味
    if (user == null || user == "") {
      throw 'エントリー名が空です。';
    }
    if (rep == null || rep!.isEmpty) {
      throw '所属が空です。';
    }
    if (genre == null || genre!.isEmpty) {
      throw 'ジャンルが空です。。';
    }

    final doc = FirebaseFirestore.instance.collection('entry').doc();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    //FireStoreに追加
    await doc.set({
      'eventID': eventId,
      'uid': uid,
      'user': user,
      'rep': rep,
      'genre': genre,
      'timestamp': timestamp,
      'title': eventTitle,
      'eventDate': eventDate,
    });
  }
}

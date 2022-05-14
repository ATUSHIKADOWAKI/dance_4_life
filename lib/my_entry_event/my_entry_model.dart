import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/events.dart';

class MyEntryModel extends ChangeNotifier {
  List<MyEntryList> myEntryList = [];

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyEntryList() async {
    // Firestoreからコレクション'events'(QuerySnapshot)を取得してdocsに代入。
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('entry')
        .where('uid', isEqualTo: uid)
        .get();

    // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
    // map(): Listの各要素をBookに変換
    // toList(): Map()から返ってきたIterable→Listに変換する。
    final myEntryList = snapshot.docs.map((doc) => MyEntryList(doc)).toList();

    this.myEntryList = myEntryList;

    notifyListeners();
  }
}

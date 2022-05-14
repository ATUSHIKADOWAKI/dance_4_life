import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/events.dart';

class HostEventModel extends ChangeNotifier {
  List<HostEntryList> hostEntryList = [];

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchHostEventList() async {
    // Firestoreからコレクション'events'(QuerySnapshot)を取得してdocsに代入。
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('event')
        .where('uid', isEqualTo: uid)
        .get();
    // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
    // map(): Listの各要素をBookに変換
    // toList(): Map()から返ってきたIterable→Listに変換する。
    final hostEntryList =
        snapshot.docs.map((doc) => HostEntryList(doc)).toList();
    this.hostEntryList = hostEntryList;
    notifyListeners();
  }
}

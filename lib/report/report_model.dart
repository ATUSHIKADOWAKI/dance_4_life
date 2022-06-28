import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/events.dart';

class ReportModel extends ChangeNotifier {
  ReportModel(this.eventNum) {
    eventNum = eventNum;
  }
  List<Events> events = [];

  final timestamp = DateTime.now();
  String? username;
  String? reportContent;
  int eventNum;

  bool isLoading = false;

  void setReport(text) {
    reportContent = text;
    notifyListeners();
  }

  final reportEditingController = TextEditingController();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  bool isUpdated() {
    return reportContent != null;
  }

  Future<void> fetchEvents() async {
    // Firestoreからコレクション'events'(QuerySnapshot)を取得してdocsに代入。
    final docs = await FirebaseFirestore.instance
        .collection('event')
        .orderBy('timestamp', descending: true)
        .get();
    // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
    // map(): Listの各要素をBookに変換
    // toList(): Map()から返ってきたIterable→Listに変換する。
    final events = docs.docs.map((doc) => Events(doc)).toList();
    this.events = events;
    print(events);
    notifyListeners();
  }

  Future addReport() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      username = snapshot.get('username');
      FirebaseFirestore.instance.collection('report').add({
        'report': reportContent,
        'timestamp': timestamp,
        'uid': uid,
        'username': username,
        'title': events[eventNum].title,
        'eventID': events[eventNum].eventId,
        'date': events[eventNum].date,
      });
    });
  }
}

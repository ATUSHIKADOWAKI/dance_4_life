import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/events.dart';
import 'package:flutter/cupertino.dart';

class EventDetailModel extends ChangeNotifier {
  List<Events> events = [];

  bool isLoading = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
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

    notifyListeners();
  }

  Future addBlockList(
      String? eventTitle, String? eventDate, String? eventId) async {
    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('blockedContent')
        .doc(eventId);

    //FireStoreに追加
    await doc.set({
      'eventID': eventId,
      'title': eventTitle,
      'date': eventDate,
    });
    notifyListeners();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

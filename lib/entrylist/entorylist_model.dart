import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/events.dart';
import 'package:flutter/cupertino.dart';

class EntoryListModel extends ChangeNotifier {
  EntoryListModel(id) {
    documentId = id;
  }
  List<Events> events = [];
  List<Entry> entrylist = [];
  String? documentId;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> fetchEntryList(String eventTitle) async {
    print(eventTitle);
    // Firestoreからコレクション'events'(QuerySnapshot)を取得してdocsに代入。
    final entry = await FirebaseFirestore.instance
        .collection('entry')
        //todo isEqualTo:イベント名にしたい。
        .where('eventID', isEqualTo: documentId)
        .get();
    // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
    // map(): Listの各要素をBookに変換
    // toList(): Map()から返ってきたIterable→Listに変換する。
    final entrylist = entry.docs.map((doc) => Entry(doc)).toList();
    this.entrylist = entrylist;
    notifyListeners();
  }
}

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '../domain/events.dart';
import 'package:flutter/cupertino.dart';

class CalenderModel extends ChangeNotifier {
  List<Events> events = [];
  late int eventNum;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  //map <key, value>
  Map<DateTime, List> eventsList = {};

  bool isLoading = false;

  DateTime focusedDay = DateTime.now();
  late DateTime selectedDay;

  void setDayCalender(selectedDay, focusedDay) {
    this.selectedDay = selectedDay;
    this.focusedDay = focusedDay;
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

  Future<void> fetchEventsCalender() async {
    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

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

    for (int i = 0; i < events.length; i++) {
      int year = int.parse(events[i].date.toString().substring(0, 4));
      int month = int.parse(events[i].date.toString().substring(5, 7));
      int day = int.parse(events[i].date.toString().substring(8, 10));
      if (eventsList.containsKey(DateTime.utc(year, month, day))) {
        eventsList[DateTime.utc(year, month, day)]
            ?.add(events[i].title.toString());
      } else {
        eventsList[DateTime.utc(year, month, day)] = [
          events[i].title.toString()
        ];
      }
    }

    notifyListeners();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

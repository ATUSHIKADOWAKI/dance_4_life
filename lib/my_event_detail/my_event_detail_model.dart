import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MyEventDetailModel extends ChangeNotifier {
  MyEventDetailModel(id) {
    eventId = id;
  }
  String? title;
  String? date;
  String? detail;
  String? imgURL;
  String? eventId;

  String? eventAddress;
  String? eventCategory;
  String? eventGenre;
  String? eventPlace;
  String? eventPrice;

  bool isLoading = false;

  void fetchMyEventDetail() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('event').doc(eventId).get();
    final data = snapshot.data();
    this.title = data?['title'];
    this.date = data?['date'];
    this.detail = data?['detail'];
    this.imgURL = data?['imgURL'];

    this.eventAddress = data?['eventAddress'];
    this.eventCategory = data?['eventCategory'];
    this.eventGenre = data?['eventGenre'];
    this.eventPlace = data?['eventPlace'];
    this.eventPrice = data?['eventPrice'];

    notifyListeners();
  }
}

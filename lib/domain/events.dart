import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  String? eventId;
  String? title;
  String? date;
  String? imgURL;
  String? detail;
  //array is here.
  List<String?> blockUid = [];
  String? eventPlace;
  String? eventAddress;
  String? eventCategory;
  String? eventPrice;
  String? eventGenre;

  // String? eventID;

  Events(DocumentSnapshot doc) {
    eventId = doc.id;
    title = doc['title'];
    eventPlace = doc['eventPlace'];
    eventAddress = doc['eventAddress'];
    eventCategory = doc['eventCategory'];
    eventPrice = doc['eventPrice'];
    eventGenre = doc['eventGenre'];
    date = doc['date'];
    imgURL = doc['imgURL'];
    detail = doc['detail'];
    blockUid = doc['blockUid'];
    // eventID = doc['eventID'];
  }
}

class HostEntryList {
  String? eventId;
  String? title;
  String? date;
  String? imgURL;
  String? detail;

  String? eventPlace;
  String? eventAddress;
  String? eventCategory;
  String? eventPrice;
  String? eventGenre;

  HostEntryList(DocumentSnapshot doc) {
    eventId = doc.id;
    title = doc['title'];
    eventPlace = doc['eventPlace'];
    eventAddress = doc['eventAddress'];
    eventCategory = doc['eventCategory'];
    eventPrice = doc['eventPrice'];
    eventGenre = doc['eventGenre'];
    date = doc['date'];
    imgURL = doc['imgURL'];
    detail = doc['detail'];
  }
}

class MyEntryList {
  String? user;
  String? rep;
  String? genre;
  String? entryId;
  String? eventId;
  String? uid;
  String? title;
  String? eventDate;

  MyEntryList(DocumentSnapshot doc) {
    user = doc['user'];
    rep = doc['rep'];
    genre = doc['genre'];
    entryId = doc.id;
    eventId = doc['eventID'];
    uid = doc['uid'];
    title = doc['title'];
    eventDate = doc['eventDate'];
  }
}

class Entry {
  String? user;
  String? rep;
  // String? eventID;

  Entry(DocumentSnapshot doc) {
    user = doc['user'];
    rep = doc['rep'];
    // eventID = doc['eventID'];
  }
}

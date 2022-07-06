import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantapp2/domain/events.dart';
import 'package:flutter/cupertino.dart';

class EventCardModel extends ChangeNotifier {
  EventCardModel(this.eventID);
  List<BlockList> blockList = [];

  //イベントIDを引数で渡してきたもの。
  final String? eventID;
  bool isLoading = false;
  bool visible = true;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> checkBlockedContent() async {
    // Firestoreからコレクション'events'(QuerySnapshot)を取得してdocsに代入。
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('blockedContent')
        .get();

    final blockList = docs.docs.map((doc) => BlockList(doc)).toList();
    this.blockList = blockList;

    print(eventID);
    if (blockList[0].eventId == eventID) {
      visible = false;
    } else {
      visible = true;
    }
    notifyListeners();
  }
}

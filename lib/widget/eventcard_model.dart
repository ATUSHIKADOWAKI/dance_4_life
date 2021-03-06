import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantapp2/domain/events.dart';
import 'package:flutter/cupertino.dart';

class EventCardModel extends ChangeNotifier {
  EventCardModel(this.eventID);
  List<BlockList> blockList = [];
  List<String> blockListID = [];

  //イベントIDを引数で渡してきたもの。
  final String? eventID;
  bool isLoading = false;
  bool visible = true;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> checkBlockedContent() async {
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('blockedContent')
        .get();

    final blockList = docs.docs.map((doc) => BlockList(doc)).toList();
    this.blockList = blockList;

    //everyで全ての要素をチェック？

    blockList.forEach((block) => blockListID
        .add(block.eventId.toString())); // => banana pineapple watermelon
    //todo forEachでリストに追加してみる。
    print(blockListID);
    // var isBlocked =
    //     blockList.every((blockContent) => blockContent.eventId == eventID);

    if (blockListID.contains(eventID)) {
      visible = false;
    } else {
      visible = true;
    }
    notifyListeners();
  }
}

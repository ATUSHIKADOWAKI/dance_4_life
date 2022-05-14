import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'entorylist_model.dart';
import '../widget/entrycard.dart';

class EntoryList extends StatelessWidget {
  // final docRef = FirebaseFirestore.instance.doc('date');
  EntoryList(this.eventTitle, this.id);
  String eventTitle;
  String id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EntoryListModel>(
      // createでfetchBooks()も呼び出すようにしておく。
      create: (_) => EntoryListModel(id)..fetchEntryList(eventTitle.toString()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('エントリーリスト'),
        ),
        body: Center(
          child: Consumer<EntoryListModel>(builder: (context, model, child) {
            // final events = model.events;
            final entryList = model.entrylist;

            return SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 10),
                //画像とか日付とか
                // Text(
                //   events[eventNum].title.toString(),
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10),
                // Text(
                //   events[eventNum].date.toString(),
                // ),
                const SizedBox(height: 10),
                for (int i = 0; i < entryList.length; i++) ...{
                  EntryCard(user: entryList[i].user, rep: entryList[i].rep),
                }

                // EntryCard(user: 'ボブチャンチン', rep: 'Waseda Breakers'),
                // EntryCard(user: 'Marcio', rep: 'Flying Steps'),
                // EntryCard(user: 'JOY', rep: 'Dark Wave'),
                // EntryCard(user: 'クリキン', rep: 'DefClans'),
                // EntryCard(user: 'Issei', rep: 'Found Nation'),
                // EntryCard(user: '岡村隆史', rep: 'ナインティナイン'),
                // EntryCard(user: 'Lilou', rep: 'Red Bull BC One ALL Stars'),
                // const SizedBox(height: 10),
              ]),
            );
          }),
        ),
      ),
    );
  }
}

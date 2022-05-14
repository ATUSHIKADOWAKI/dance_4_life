import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:plantapp2/my_entry_edit/my_entry_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/events.dart';
import 'my_event_detail_model.dart';
import '../entrylist/entorylist_page.dart';

class MyEventDetailPage extends StatelessWidget {
  // final docRef = FirebaseFirestore.instance.doc('date');
  MyEventDetailPage(this.myEntryList);
  final MyEntryList myEntryList;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyEventDetailModel>(
      // createでfetchBooks()も呼び出すようにしておく。
      create: (_) =>
          MyEventDetailModel(myEntryList.eventId)..fetchMyEventDetail(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('詳細'),
        ),
        body: Center(
          child: Consumer<MyEventDetailModel>(builder: (context, model, child) {
            // final events = model.events;

            return SingleChildScrollView(
              child: Column(children: [
                Container(
                  child: model.imgURL != null || model.imgURL == ""
                      ? Image.network(
                          model.imgURL.toString(),
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/images/noimage.png'),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  'イベント名',
                  style: TextStyle(color: Colors.white70),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    model.title.toString(),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  'ジャンル',
                  style: TextStyle(color: Colors.white70),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    model.eventGenre.toString(),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  '日程',
                  style: TextStyle(color: Colors.white70),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    model.date.toString(),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  '場所名',
                  style: TextStyle(color: Colors.white70),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    model.eventPlace.toString(),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  '住所',
                  style: TextStyle(color: Colors.white70),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text("GoogleMapへ移動しますか？"),
                            content: null,
                            actions: <Widget>[
                              // ボタン領域
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                  child: Text("OK"),
                                  onPressed: () async {
                                    List<Location> locations =
                                        await locationFromAddress(
                                      model.eventAddress.toString(),
                                    );
                                    print(locations.first.latitude);
                                    print(locations.first.longitude);
                                    final url =
                                        'https://www.google.com/maps/search/?api=1&query=${locations.first.latitude},${locations.first.longitude}';
                                    launch(url, forceSafariVC: false);
                                  }),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      model.eventAddress.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  '参加料金',
                  style: TextStyle(color: Colors.white70),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    model.eventPrice.toString(),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  '詳細',
                  style: TextStyle(color: Colors.white70),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    model.detail.toString(),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.teal),
                  ),
                  onPressed: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EntoryList(
                          model.title.toString(), model.eventId.toString());
                    }))
                  },
                  child: Text(
                    "エントリーリスト",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.teal),
                  ),
                  onPressed: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MyEntryEditPage(myEntryList);
                    }))
                  },
                  child: Text(
                    "エントリー内容を変更する",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
            );
          }),
        ),
      ),
    );
  }
}

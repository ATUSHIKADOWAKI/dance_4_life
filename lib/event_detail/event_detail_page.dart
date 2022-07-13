import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:plantapp2/entry/entry_page.dart';
import 'package:plantapp2/report/report_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../entrylist/entorylist_page.dart';
import '../rootpage.dart';
import 'event_detail_model.dart';

class EventDetail extends StatelessWidget {
  EventDetail(this.eventNum);
  int eventNum;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventDetailModel>(
      create: (_) => EventDetailModel()..fetchEvents(),
      child: Consumer<EventDetailModel>(builder: (context, model, child) {
        final events = model.events;
        return Scaffold(
          appBar: AppBar(
            title: Text('詳細'),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text(
                            "不適切なコンテンツですか？",
                            textAlign: TextAlign.center,
                          ),
                          content: null,
                          actions: <Widget>[
                            // ボタン領域
                            Column(
                              children: [
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                        child: const Text(
                                          "ブロックする",
                                        ),
                                        onPressed: () async {
                                          try {
                                            model.startLoading();
                                            await model.addBlockList(
                                                events[eventNum].title,
                                                events[eventNum].date,
                                                events[eventNum].eventId);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RootPage(),
                                              ),
                                            );
                                            final snackBar = SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                'ブロックリストに追加しました。',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } catch (e) {
                                            final snackBar = SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                e.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } finally {
                                            model.endLoading();
                                          }
                                        }),
                                    TextButton(
                                        child: const Text(
                                          "通報する",
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportPage(eventNum),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.report))
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  child: events[eventNum].imgURL != null ||
                          events[eventNum].imgURL == ""
                      ? Image.network(
                          events[eventNum].imgURL.toString(),
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/images/noimage.png'),
                ),
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
                    events[eventNum].title.toString(),
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
                    events[eventNum].eventGenre.toString(),
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
                    events[eventNum].date.toString(),
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
                    events[eventNum].eventPlace.toString(),
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
                                      events[eventNum].eventAddress.toString(),
                                    );

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
                      events[eventNum].eventAddress.toString(),
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
                    events[eventNum].eventPrice.toString(),
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
                    events[eventNum].detail.toString(),
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
                      return EntoryList(events[eventNum].title.toString(),
                          events[eventNum].eventId.toString());
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
                      return EntryPage(
                          events[eventNum].title.toString(),
                          events[eventNum].eventId.toString(),
                          events[eventNum].date.toString());
                    }))
                  },
                  child: Text(
                    "エントリーする",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
            ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plantapp2/calendar/calendar_page.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';
import 'event_detail/event_detail_page.dart';
import 'widget/eventcard.dart';
import 'calendar/calendar_page.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      // createでfetchBooks()も呼び出すようにしておく。
      create: (_) => MainModel()..fetchEvents(),
      child: Consumer<MainModel>(builder: (context, model, child) {
        final events = model.events;

        return Scaffold(
          appBar: AppBar(
            title: Text('イベント一覧'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.calendar_month),
                onPressed: () {
                  showModalBottomSheet(
                      //モーダルの背景の色、透過
                      backgroundColor: Colors.transparent,
                      //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            margin: EdgeInsets.only(top: 64),
                            decoration: const BoxDecoration(
                              //モーダル自体の色
                              color: Colors.white,
                              //角丸にする
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: CalendarPage());
                      });
                },
                disabledColor: Colors.white,
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < events.length; i++) ...{
                    EventCard(
                      imgURL: events[i].imgURL,
                      title: events[i].title,
                      date: events[i].date,
                      eventID: events[i].eventId,
                      // blockUid: events[i].blockUid,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetail(i),
                          ),
                        );
                      },
                    ),
                  }
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

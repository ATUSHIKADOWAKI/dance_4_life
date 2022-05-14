import 'package:flutter/material.dart';
import 'package:plantapp2/my_event_detail/my_event_detail_page.dart';
import 'package:provider/provider.dart';
import 'my_entry_model.dart';

class MyEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyEntryModel>(
      // createでfetchBooks()も呼び出すようにしておく。
      create: (_) => MyEntryModel()..fetchMyEntryList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('エントリー済みイベント'),
        ),
        body: Center(
          child: Consumer<MyEntryModel>(builder: (context, model, child) {
            final myEntryList = model.myEntryList;
            return SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 10),
                for (int i = 0; i < myEntryList.length; i++) ...{
                  Card(
                    child: ListTile(
                      title: Text(myEntryList[i].title.toString()),
                      subtitle: Text(myEntryList[i].eventDate.toString()),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return MyEventDetailPage(myEntryList[i]);
                        }));
                      },
                    ),
                  ),
                }
              ]),
            );
          }),
        ),
      ),
    );
  }
}

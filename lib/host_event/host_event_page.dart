import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantapp2/edit_event/edit_event_page.dart';
import 'package:provider/provider.dart';
import 'host_event_model.dart';

class HostEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HostEventModel>(
      // createでfetchBooks()も呼び出すようにしておく。
      create: (_) => HostEventModel()..fetchHostEventList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('主催イベントリスト'),
        ),
        body: Center(
          child: Consumer<HostEventModel>(builder: (context, model, child) {
            final hostEntryList = model.hostEntryList;

            return SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 10),
                for (int i = 0; i < hostEntryList.length; i++) ...{
                  Card(
                    child: ListTile(
                      title: Text(hostEntryList[i].title.toString()),
                      subtitle: Text(hostEntryList[i].date.toString()),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditEventPage(
                                hostEntryList[i],
                              ),
                            ));
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

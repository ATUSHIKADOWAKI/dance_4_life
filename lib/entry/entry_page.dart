import 'package:flutter/material.dart';
import 'package:plantapp2/domain/events.dart';
import 'package:provider/provider.dart';
import 'entry_model.dart';

class EntryPage extends StatelessWidget {
  EntryPage(this.eventTitle, this.eventId, this.eventDate);
  String eventTitle;
  String eventDate;
  String eventId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EntryModel>(
      create: (_) => EntryModel(eventId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('エントリーページ'),
        ),
        body: Center(
            child: Consumer<EntryModel>(builder: (context, model, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(eventTitle),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'エントリー名',
                      ),
                      onChanged: (text) {
                        model.user = text;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'レペゼン',
                      ),
                      onChanged: (text) {
                        model.rep = text;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ジャンル',
                      ),
                      onChanged: (text) {
                        model.genre = text;
                      },
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal),
                      ),
                      //エラーキャッチ
                      onPressed: () async {
                        try {
                          model.startLoading();
                          await model.addEntry(eventTitle, eventDate);
                          Navigator.popUntil(context, (route) => route.isFirst);
                          final snackBar = SnackBar(
                            backgroundColor: Colors.teal,
                            content: Text(
                              'エントリーしました。',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } catch (e) {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              e.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } finally {
                          model.endLoading();
                        }
                      },
                      child: Text(
                        "エントリー",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              //isLoadingがtrueの時だけ動く
              if (model.isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          );
        })),
      ),
    );
  }
}

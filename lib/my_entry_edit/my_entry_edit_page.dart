import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../domain/events.dart';
import '../rootpage.dart';
import 'my_entry_edit_model.dart';

class MyEntryEditPage extends StatelessWidget {
  MyEntryEditPage(this.myEntryList);
  final MyEntryList myEntryList;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyEntryEditModel>(
      create: (_) => MyEntryEditModel(myEntryList.user, myEntryList.rep,
          myEntryList.genre, myEntryList.entryId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('エントリー内容編集'),
        ),
        body: Center(
            child: Consumer<MyEntryEditModel>(builder: (context, model, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: model.userEditingController,
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
                      controller: model.repEditingController,
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
                      controller: model.genreEditingController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ジャンル',
                      ),
                      onChanged: (text) {
                        model.genre = text;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal),
                      ),
                      //エラーキャッチ
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("エントリー内容を更新しますか？"),
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
                                      try {
                                        model.startLoading();
                                        await model.updateEntry();
                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                            'エントリー内容を更新しました。',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } catch (e) {
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            e.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } finally {
                                        model.endLoading();
                                      }
                                    }),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "エントリー内容更新",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      //エラーキャッチ
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("削除の確認。"),
                              content: Text("エントリーキャンセル後は取り消すことができません。"
                                  "本当によろしいですか？"),
                              actions: <Widget>[
                                // ボタン領域
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'エントリーをキャンセルしました。',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      model.deleteEntry();
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                    }),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "エントリーキャンセル",
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

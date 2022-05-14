import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:plantapp2/domain/events.dart';
import 'package:provider/provider.dart';
import '../rootpage.dart';
import '../widget/showCategoryPicker.dart';
import '../widget/showGenrePicker.dart';
import 'edit_event_model.dart';

class EditEventPage extends StatelessWidget {
  EditEventPage(this.hostEntryList);
  final HostEntryList hostEntryList;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditEventModel>(
      create: (_) => EditEventModel(
          hostEntryList.title,
          hostEntryList.eventCategory,
          hostEntryList.eventGenre,
          hostEntryList.date,
          hostEntryList.eventPlace,
          hostEntryList.eventAddress,
          hostEntryList.eventPrice,
          hostEntryList.detail,
          hostEntryList.eventId,
          hostEntryList.imgURL),
      child: Scaffold(
        appBar: AppBar(
          title: Text('イベント編集'),
        ),
        body: GestureDetector(
          //画面外タップを検知するために必要、入力画面以外を触るとキーボード閉じる。
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
              child: Consumer<EditEventModel>(builder: (context, model, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: SizedBox(
                          width: 200,
                          height: 160,
                          child: (() {
                            if (model.imageFile != null) {
                              return Image.file(
                                model.imageFile!,
                                fit: BoxFit.cover,
                              );
                            } else if (model.imgURL.toString() == 'null') {
                              return Image.asset(
                                'assets/images/noimage.png',
                                fit: BoxFit.cover,
                              );
                            } else {
                              return Image.network(
                                model.imgURL.toString(),
                                fit: BoxFit.cover,
                              );
                            }
                          })(),
                        ),
                        onTap: () async {
                          await model.pickImage();
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: model.titleEditingController,
                        decoration: InputDecoration(
                          hintText: 'イベント名',
                          hintStyle: const TextStyle(fontSize: 12),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onChanged: (text) {
                          model.title = text;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: model.categoryPickerEditingController,
                        decoration: InputDecoration(
                          hintText: 'イベントカテゴリー',
                          hintStyle: const TextStyle(fontSize: 12),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          showCategoryPicker(
                              context, model.categoryPickerEditingController);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: model.genrePickerEditingController,
                        decoration: InputDecoration(
                          hintText: 'ジャンル',
                          hintStyle: const TextStyle(fontSize: 12),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          showGenrePicker(
                              context, model.genrePickerEditingController);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: model.dateEditingController,
                        decoration: InputDecoration(
                          hintText: '日程',
                          hintStyle: const TextStyle(fontSize: 12),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          model.getDate(context);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: model.eventPlaceEditingController,
                        decoration: InputDecoration(
                          hintText: '開催場所名',
                          hintStyle: const TextStyle(fontSize: 12),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onChanged: (text) {
                          model.eventPlace = text;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: model.eventAddressEditingController,
                        decoration: InputDecoration(
                          hintText: '住所',
                          hintStyle: const TextStyle(fontSize: 12),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onChanged: (text) {
                          model.eventAddress = text;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: model.eventPriceEditingController,
                        decoration: InputDecoration(
                          hintText: '参加料金',
                          hintStyle: const TextStyle(fontSize: 12),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onChanged: (text) {
                          model.eventPrice = text;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: model.detailEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'イベント詳細',
                          hintStyle: const TextStyle(fontSize: 12),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onChanged: (text) {
                          model.detail = text;
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
                                title: Text("イベントを更新しますか？"),
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
                                          await model.updateEvent();
                                          Navigator.popUntil(context,
                                              (route) => route.isFirst);
                                          final snackBar = SnackBar(
                                            backgroundColor: Colors.teal,
                                            content: Text(
                                              'イベントを更新しました。',
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
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          "イベント更新",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        //エラーキャッチ
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("イベントを削除しますか？"),
                                content: Text("削除は取り消すことができません。"
                                    "本当によろしいですか？。"),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                      child: Text("Delete"),
                                      onPressed: () async {
                                        try {
                                          model.startLoading();
                                          await model.deleteEvent();
                                          await model.deleteEntryAll();
                                          Navigator.popUntil(context,
                                              (route) => route.isFirst);
                                          final snackBar = SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              'イベントを削除しました。',
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
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          "イベント削除",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
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
      ),
    );
  }
}

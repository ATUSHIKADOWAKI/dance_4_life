import 'package:flutter/material.dart';
import 'package:plantapp2/report/report_model.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatelessWidget {
  ReportPage(this.eventNum);
  int eventNum;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReportModel>(
      create: (_) => ReportModel(eventNum)..fetchEvents(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('通報'),
          //こここ
        ),
        body: Center(
          child: Consumer<ReportModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('通報するイベント名:　${model.events[eventNum].title}'),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: model.reportEditingController,
                          decoration: InputDecoration(
                              hintText: '通報理由', hintMaxLines: 3),
                          onChanged: (text) {
                            model.setReport(text);
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, //ボタンの背景色
                          ),
                          onPressed: model.isUpdated()
                              ? () async {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: const Text(
                                          "通報しますか？",
                                          textAlign: TextAlign.center,
                                        ),
                                        content: null,
                                        actions: <Widget>[
                                          // ボタン領域
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    child: const Text("戻る"),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  TextButton(
                                                      child: const Text(
                                                        "通報する",
                                                      ),
                                                      onPressed: () async {
                                                        model.startLoading();
                                                        try {
                                                          await model
                                                              .addReport();
                                                          Navigator.popUntil(
                                                              context,
                                                              (route) => route
                                                                  .isFirst);
                                                          final snackBar =
                                                              SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                              '通報しました。',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        } catch (e) {
                                                          final snackBar =
                                                              SnackBar(
                                                            backgroundColor:
                                                                Colors.black54,
                                                            content: Text(
                                                              e.toString(),
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        } finally {
                                                          model.endLoading();
                                                        }
                                                      }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              : null,
                          child: const Text('通報する'),
                        )
                      ],
                    ),
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plantapp2/login/login_page.dart';
import 'package:plantapp2/register/register_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('会員登録'),
        ),
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          onChanged: (value) {
                            model.setUserName(value);
                          },
                          decoration: const InputDecoration(
                            // filled: true,
                            hintText: 'ユーザ名',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          onChanged: (email) {
                            model.setEmail(email);
                          },
                          decoration: const InputDecoration(
                            // filled: true,
                            hintText: 'メールアドレス',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          onChanged: (password) {
                            model.setPassword(password);
                          },
                          decoration: const InputDecoration(
                            // filled: true,
                            hintText: 'パスワード',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text(
                                      "登録前にご確認ください。",
                                      textAlign: TextAlign.center,
                                    ),
                                    content: null,
                                    actions: <Widget>[
                                      // ボタン領域
                                      Column(
                                        children: [
                                          Text(
                                            '利用規約 & プライバシーポリシーを\nご理解の上ご利用ください。',
                                            textAlign: TextAlign.center,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              model.launchUrl();
                                            },
                                            child: Text(
                                              '利用規約 & プライバシーポリシー',
                                              style: TextStyle(
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                child: const Text("同意しない"),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                              TextButton(
                                                  child: const Text(
                                                    "同意する",
                                                  ),
                                                  onPressed: () async {
                                                    model.startLoading();
                                                    try {
                                                      await model.signUp();
                                                      Navigator.of(context)
                                                          .pop(LoginPage());
                                                      final snackBar = SnackBar(
                                                        backgroundColor:
                                                            Colors.teal,
                                                        content: Text(
                                                          model.infoText,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    } catch (e) {
                                                      final snackBar = SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text(
                                                          e.toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
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
                            },
                            child: Text('登録する'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ],
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

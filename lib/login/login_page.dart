import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:plantapp2/register/register_page.dart';
import 'package:plantapp2/rootpage.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Center(
          child: Consumer<LoginModel>(builder: (context, model, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
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
                        child: TextFormField(
                          obscureText: model.isObscure,
                          onChanged: (password) {
                            model.setPassword(password);
                          },
                          decoration: const InputDecoration(
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
                              model.startLoading();
                              try {
                                await model.login();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RootPage(),
                                  ),
                                );
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.teal,
                                  content: Text(
                                    model.infoText,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } catch (e) {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'ログインできません。',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } finally {
                                model.endLoading();
                              }
                            },
                            child: Text('ログイン'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          width: 300,
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              //todo　ログインチェック
                              if (FirebaseAuth.instance.currentUser != null) {
                                print('ログインしている');
                                print(FirebaseAuth.instance.currentUser?.email);
                              } else {
                                print('ログインしていない');
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Text('アカウントをお持ちでない方はこちら'),
                            style: ElevatedButton.styleFrom(),
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

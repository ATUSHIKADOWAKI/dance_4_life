import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantapp2/host_event/host_event_page.dart';
import 'package:plantapp2/login/login_page.dart';
import 'package:plantapp2/my_entry_event/my_entry_page.dart';
import 'package:plantapp2/profile/profile_page_model.dart';
import 'package:provider/provider.dart';

import '../profile_edit/profile_edit_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfilePageModel>(
      create: (_) => ProfilePageModel()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィール'),
        ),
        endDrawer: Consumer<ProfilePageModel>(builder: (context, model, child) {
          return SafeArea(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  bottomLeft: const Radius.circular(20)),
              child: Drawer(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const header(),
                          ListTile(
                            title: const Text("エントリー済みイベント"),
                            leading: Icon(
                              Icons.event_note,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyEntryPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text("主催イベントの編集"),
                            leading: Icon(
                              Icons.edit,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HostEventPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text("利用規約 & プライバシーポリシー"),
                            leading: Icon(
                              Icons.description_outlined,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onTap: () {
                              model.launchUrl();
                            },
                          ),
                          ListTile(
                            title: const Text("ブロックリスト"),
                            leading: Icon(
                              Icons.block,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HostEventPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text("ログアウト"),
                            leading: Icon(
                              Icons.exit_to_app,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("ログアウトしますか？"),
                                    content: null,
                                    actions: <Widget>[
                                      // ボタン領域
                                      TextButton(
                                        child: const Text("戻る"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                          child: const Text("ログアウトする"),
                                          onPressed: () async {
                                            model.startLoading();
                                            try {
                                              await model.signOut();
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginPage()),
                                                  (_) => false);
                                              final snackBar = SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  model.infoText,
                                                  style: const TextStyle(
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
                                                  ));
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage(),
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text("アカウント削除"),
                            tileColor: Colors.red,
                            leading: Icon(
                              Icons.report,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("アカウントを削除しますか？"),
                                    content: null,
                                    actions: <Widget>[
                                      Text('アカウント削除は取り消すことはできません。'), // ボタン領域,
                                      TextButton(
                                        child: const Text("戻る"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                          child: const Text("アカウントを削除する。"),
                                          onPressed: () async {
                                            model.startLoading();
                                            try {
                                              await model.deleteUser();
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginPage()),
                                                  (_) => false);
                                              final snackBar = SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  "アカウントを削除しました。",
                                                  style: const TextStyle(
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
                                                  ));
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage(),
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        body: Consumer<ProfilePageModel>(builder: (context, model, child) {
          return Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage: NetworkImage(model.imgURL.toString()),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("プロフィールを編集しますか？"),
                                content: null,
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("戻る"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                      child: const Text("編集する"),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileEditPage(
                                                    model.username,
                                                    model.rep,
                                                    model.genre,
                                                    model.imgURL),
                                          ),
                                        );
                                      }),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'プロフィールを編集する',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                      Text(
                        model.username ?? '',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        model.rep == null || model.rep == 'null'
                            ? 'レペゼンなし'
                            : model.rep.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        model.genre == null || model.genre == 'null'
                            ? 'ジャンルなし'
                            : model.genre.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class header extends StatelessWidget {
  const header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      width: double.infinity,
      child: DrawerHeader(
        child: Text(
          '編集画面',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(color: Colors.teal),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plantapp2/profile_edit/profile_edit_model.dart';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatelessWidget {
  ProfileEditPage(this.username, this.genre, this.rep, this.imgURL);
  final String? username;
  final String? genre;
  final String? rep;
  final String? imgURL;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileEditModel>(
      create: (_) => ProfileEditModel(username, rep, genre, imgURL),
      child: Scaffold(
        appBar: AppBar(
          title: Text('プロフィール編集'),
          //こここ
        ),
        body: Center(
          child: Consumer<ProfileEditModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 150,
                            height: 150,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: (() {
                              if (model.imageFile != null) {
                                return Image.file(
                                  model.imageFile!,
                                  fit: BoxFit.cover,
                                );
                              } else if (imgURL.toString() == 'null') {
                                return Image.asset(
                                  'assets/images/noimage.png',
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Image.network(
                                  imgURL.toString(),
                                  fit: BoxFit.cover,
                                );
                              }
                            })(),
                          ),
                          onTap: () async {
                            await model.pickImage();
                          },
                        ),
                        TextField(
                          controller: model.usernameController,
                          decoration: InputDecoration(hintText: 'ユーザーネーム'),
                          onChanged: (text) {
                            model.setUserName(text);
                          },
                        ),
                        TextField(
                          controller: model.repController,
                          decoration: InputDecoration(hintText: 'レペゼン'),
                          onChanged: (text) {
                            model.setRep(text);
                          },
                        ),
                        TextField(
                          controller: model.genreController,
                          decoration: InputDecoration(hintText: 'ジャンル'),
                          onChanged: (text) {
                            model.setGenre(text);
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal, //ボタンの背景色
                          ),
                          onPressed: model.isUpdated()
                              ? () async {
                                  model.startLoading();
                                  try {
                                    await model.updateProfile();
                                    print(model.isLoading);
                                    Navigator.of(context).pop();
                                    final snackBar = SnackBar(
                                      backgroundColor: Colors.teal,
                                      content: Text(
                                        'プロフィールを更新しました。',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } catch (e) {
                                    final snackBar = SnackBar(
                                      backgroundColor: Colors.black54,
                                      content: Text(
                                        e.toString(),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } finally {
                                    model.endLoading();
                                    print(model.isLoading);
                                  }
                                }
                              : null,
                          child: const Text('更新する'),
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

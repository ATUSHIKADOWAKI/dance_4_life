import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterModel extends ChangeNotifier {
  // final titleController = TextEditingController();
  // final authController = TextEditingController();

  String infoText = 'アカウントが登録されました';
  String email = '';
  String password = '';
  String? username;
  String imgURL = '';

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setUserName(String username) {
    this.username = username;
    notifyListeners();
  }

  Future launchUrl() async {
    var url = "https://plantapp-eae67.web.app/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'アクセスできません。';
    }
  }

  Future signUp() async {
    // this.email = titleController.text;
    // this.password = authController.text;

    if (this.email == null || this.email == "") {
      throw 'メールアドレスが空です。';
    }
    if (this.password == null || this.password.isEmpty) {
      throw 'パスワードが空です。';
    }
    if (this.username == null || this.username!.isEmpty) {
      throw 'ユーザ名が空です。';
    }

    final auth = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = auth.user;
    if (user != null) {
      final uid = user.uid;
      final doc = FirebaseFirestore.instance.collection('users').doc(uid);
      await doc.set({
        'uid': uid,
        'email': email,
        'username': username,
      });
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginModel extends ChangeNotifier {
  // final titleController = TextEditingController();
  // final authController = TextEditingController();

  String infoText = 'ログインしました。';
  String email = '';
  String password = '';

  bool isLoading = false;
  bool isObscure = true;

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

  void setObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future login() async {
    if (email != null && password != null) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    }
  }
}

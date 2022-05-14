import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditModel extends ChangeNotifier {
  ProfileEditModel(this.username, this.genre, this.rep, this.imgURL) {
    usernameController.text = username!;
    repController.text = rep.toString();
    genreController.text = genre.toString();
    imgURL = imgURL;
  }
  String? username;
  String? imgURL;
  String? genre;
  String? rep;
  File? imageFile;
  bool isLoading = false;

  final usernameController = TextEditingController();
  final genreController = TextEditingController();
  final repController = TextEditingController();

  final picker = ImagePicker();

  void setUserName(String username) {
    this.username = username;
    notifyListeners();
  }

  void setGenre(String genre) {
    this.genre = genre;
    notifyListeners();
  }

  void setRep(String rep) {
    this.rep = rep;
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  bool isUpdated() {
    return username != null;
  }

  Future updateProfile() async {
    if (imageFile != null) {
      final doc = FirebaseFirestore.instance.collection('users').doc();

      final task = await FirebaseStorage.instance
          .ref('event/${doc.id}')
          .putFile(imageFile!);
      imgURL = await task.ref.getDownloadURL();
    }

    this.username = usernameController.text;
    this.genre = genreController.text;
    this.rep = repController.text;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'username': username,
      'rep': rep,
      'genre': genre,
      'imgURL': imgURL,
    });
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}

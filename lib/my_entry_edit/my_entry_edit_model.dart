import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyEntryEditModel extends ChangeNotifier {
  MyEntryEditModel(user, rep, genre, entryId) {
    userEditingController.text = user!;
    repEditingController.text = rep.toString();
    genreEditingController.text = genre.toString();
    documentId = entryId;
  }

  bool isLoading = false;

  String? user;
  String? rep;
  String? genre;
  String? documentId;

  final userEditingController = TextEditingController();
  final repEditingController = TextEditingController();
  final genreEditingController = TextEditingController();

  final picker = ImagePicker();

  void setUser(String user) {
    this.user = user;
    notifyListeners();
  }

  void setRep(String rep) {
    this.rep = rep;
    notifyListeners();
  }

  void setGenre(String genre) {
    this.genre = genre;
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
    return user != null;
  }

  Future updateEntry() async {
    print(documentId);

    this.user = userEditingController.text;
    this.rep = repEditingController.text;
    this.genre = genreEditingController.text;
    await FirebaseFirestore.instance
        .collection('entry')
        .doc(documentId)
        .update({
      'user': user,
      'rep': rep,
      'genre': genre,
    });
  }

  Future deleteEntry() {
    return FirebaseFirestore.instance
        .collection('entry')
        .doc(documentId)
        .delete();
  }
}

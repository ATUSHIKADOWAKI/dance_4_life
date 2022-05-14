import 'package:flutter/material.dart';

class EntryCard extends StatelessWidget {
  EntryCard({this.user, this.rep});
  final String? user, rep;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("$user"),
        subtitle: Text("$rep"),
      ),
    );
  }
}

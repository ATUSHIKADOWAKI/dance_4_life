import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firstpage.dart';
import 'add_event/add_event_page.dart';
import 'package:provider/provider.dart';
import 'main_model.dart';
import 'profile/profile_page.dart';

class RootPage extends StatelessWidget {
  // final docRef = FirebaseFirestore.instance.doc('date');
  final List<Widget> _pageList = <Widget>[
    FirstPage(),
    SecondPage(),
    ProfilePage()
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      // createでfetchBooks()も呼び出すようにしておく。
      create: (_) => MainModel()..fetchEvents(),
      child: Consumer<MainModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              body: _pageList[model.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.black,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.event_note),
                      label: 'Event List',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.edit),
                      label: 'Create an Event',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.face),
                        label: 'Profile',
                        backgroundColor: Colors.white),
                  ],
                  currentIndex: currentIndex,
                  selectedItemColor: Colors.amber[800],
                  unselectedItemColor: Colors.white70,

                  //todo ログイン確認
                  onTap: (index) {
                    if (FirebaseAuth.instance.currentUser != null) {
                    } else {}
                    model.currentIndex = index;
                    currentIndex = model.currentIndex;
                  }),
            ),
          ],
        );
      }),
    );
  }
}

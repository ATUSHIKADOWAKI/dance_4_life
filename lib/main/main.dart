import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantapp2/login/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("en"),
          const Locale("ja"),
        ],
        locale: const Locale('ja'),
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (_) => LoginPage(),
          // '/': (_) => RootPage(),
        });
  }
}

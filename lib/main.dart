import 'package:brighter_bee/app_screens/create_post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_screens/full_post.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
          accentIconTheme: Theme.of(context).accentIconTheme.copyWith(
                color: Colors.white,
              ),
          textSelectionColor: Color.fromRGBO(57, 171, 219, 0.7),
          textSelectionHandleColor: Color.fromRGBO(57, 171, 219, 1.0),
          buttonColor: Colors.black,
          accentColor: Colors.blue,
          primaryColor: Colors.white,
          primaryTextTheme: Theme.of(context)
              .primaryTextTheme
              .apply(bodyColor: Colors.black)),
      darkTheme: ThemeData.dark().copyWith(
          accentIconTheme: Theme.of(context).accentIconTheme.copyWith(
                color: Colors.white,
              ),
          textSelectionColor: Color.fromRGBO(57, 171, 219, 0.7),
          textSelectionHandleColor: Color.fromRGBO(57, 171, 219, 1.0),
          buttonColor: Colors.white,
          accentColor: Colors.blue,
          primaryColor: Colors.black,
          primaryTextTheme: Theme.of(context)
              .primaryTextTheme
              .apply(bodyColor: Colors.white)),
      // home: FirebaseAuthDemo(),
      home: CreatePost(),
    );
  }
}

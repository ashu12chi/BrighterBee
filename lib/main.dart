import 'package:brighter_bee/app_screens/post_card_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_screens/community_home.dart';

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
          accentColor: Colors.deepOrange,
          primaryColor: Colors.white,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
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
          accentColor: Colors.deepOrange,
          primaryColor: Colors.black,
          primaryTextTheme: Theme.of(context)
              .primaryTextTheme
              .apply(bodyColor: Colors.white)),
      // home: CreatePost(),
      // home: PostUI.test(),
      //home: PostCardView(),
      home: CommunityHome()
      // home: Comment(
      //     'Computing',
      //     '2020 October 12, 01:17 PM',
      //     '1602488875571',
      //     '1602488875571',
      //     'ashu12_chi',
      //     'Check post, with Photo. Adding some text to just make it larger ;)',
      //     'nisiddharth',
      //     false),
    );
  }
}
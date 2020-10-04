import 'package:brighter_bee/app_screens/create_post.dart';
import 'package:flutter/material.dart';

main() => runApp(MyApp());

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
          accentColor: Colors.black,
          primaryColor: Colors.white,
          primaryTextTheme: Theme.of(context)
              .primaryTextTheme
              .apply(bodyColor: Colors.black)),
      darkTheme: ThemeData.dark().copyWith(
          accentIconTheme: Theme.of(context).accentIconTheme.copyWith(
                color: Colors.white,
              ),
          accentColor: Colors.white,
          primaryColor: Colors.black,
          primaryTextTheme: Theme.of(context)
              .primaryTextTheme
              .apply(bodyColor: Colors.white)),
      home: CreatePost(),
    );
  }
}

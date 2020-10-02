import 'package:brighter_bee/app_screens/feed.dart';
import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      debugShowCheckedModeBanner: false,
      home: Container(),
    );
  }
}

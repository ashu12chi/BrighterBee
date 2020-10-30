import 'package:brighter_bee/app_screens/feed.dart';
import 'package:brighter_bee/authentication/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/*
* @author: Ashutosh Chitranshi, Nishchal Siddharth Pandey
* 1 October, 2020
* This file is entry point to the app: themes and home screens declared here.
*/

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
              color: Colors.black,
            ),
        textSelectionColor: Color.fromRGBO(57, 171, 219, 0.7),
        textSelectionHandleColor: Color.fromRGBO(57, 171, 219, 1.0),
        tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
            labelColor: Colors.deepOrange, unselectedLabelColor: Colors.black),
        buttonColor: Colors.black,
        dividerColor: Colors.black12,
        accentColor: Colors.deepOrange,
        primaryColor: Colors.white,
        dialogTheme: Theme.of(context).dialogTheme.copyWith(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'OpenSans'),
            contentTextStyle: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'OpenSans')),
        // backgroundColor: Colors.white,
        // scaffoldBackgroundColor: Colors.white,
        errorColor: Color.fromRGBO(176, 0, 32, 1),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
            iconTheme: Theme.of(context).iconTheme, shadowColor: Colors.white),
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'OpenSans'),
        primaryTextTheme: Theme.of(context)
            .primaryTextTheme
            .apply(bodyColor: Colors.black, fontFamily: 'OpenSans'),
      ),
      // dark theme
      darkTheme: ThemeData.dark().copyWith(
          accentIconTheme: Theme.of(context).accentIconTheme.copyWith(
                color: Color.fromRGBO(226, 226, 226, 1),
              ),
          textSelectionColor: Color.fromRGBO(57, 171, 219, 0.7),
          textSelectionHandleColor: Color.fromRGBO(57, 171, 219, 1.0),
          dividerColor: Colors.white60,
          buttonColor: Color.fromRGBO(226, 226, 226, 1),
          errorColor: Color.fromRGBO(207, 102, 121, 1),
          accentColor: Colors.deepOrangeAccent,
          primaryColor: Color.fromRGBO(18, 18, 18, 1),
          backgroundColor: Color.fromRGBO(18, 18, 18, 1),
          // #121212
          scaffoldBackgroundColor: Color.fromRGBO(18, 18, 18, 1),
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
                color: Color.fromRGBO(31, 31, 31, 1), // #1F1F1F
              ),
          cardColor: Color.fromRGBO(31, 31, 31, 1),
          dialogTheme: Theme.of(context).dialogTheme.copyWith(
              backgroundColor: Color.fromRGBO(31, 31, 31, 1),
              titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'OpenSans'),
              contentTextStyle:
                  TextStyle(fontSize: 16, fontFamily: 'OpenSans')),
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Color.fromRGBO(226, 226, 226, 1),
              fontFamily: 'OpenSans'),
          primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
              bodyColor: Color.fromRGBO(226, 226, 226, 1),
              fontFamily: 'OpenSans'),
          tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.white)),
      home: (FirebaseAuth.instance.currentUser == null ||
              !FirebaseAuth.instance.currentUser.emailVerified)
          ? SignIn()
          : Feed(FirebaseAuth.instance.currentUser),
      themeMode: ThemeMode.system,
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

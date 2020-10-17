import 'package:brighter_bee/authentication/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
        buttonColor: Colors.black,
        dividerColor: Colors.black12,
        accentColor: Colors.deepOrange,
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        errorColor: Color.fromRGBO(176, 0, 32, 1),
        appBarTheme: Theme.of(context)
            .appBarTheme
            .copyWith(iconTheme: Theme.of(context).iconTheme),
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Roboto'),
        primaryTextTheme: Theme.of(context)
            .primaryTextTheme
            .apply(bodyColor: Colors.black, fontFamily: 'Roboto'),
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
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Color.fromRGBO(226, 226, 226, 1),
              fontFamily: 'Roboto'),
          primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
              bodyColor: Color.fromRGBO(226, 226, 226, 1),
              fontFamily: 'Roboto'),
          tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.white)),
      // home: CreatePost(),
      // home: PostUI.test(),
      //home: CreatePost(),
      //home: MessagingWidget(),
      home: SignIn(),
      themeMode: ThemeMode.system,
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

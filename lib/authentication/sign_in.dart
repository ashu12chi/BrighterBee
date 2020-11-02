import 'package:brighter_bee/app_screens/feed.dart';
import 'package:brighter_bee/authentication/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password.dart';

/*
* @author: Anushka Srivastava
* 19 October, 2020
* This file has code for sign-in user
*/

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(), child: withEmailPassword())));
  }

  Widget withEmailPassword() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100),
            Container(
              child: const Text(
                'Log in to BrighterBee',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: _emailController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.grey,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).buttonColor),
                ),
              ),
              validator: (value) {
                if (value.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) return 'Enter valid email';
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                prefixIcon: Icon(
                  Icons.vpn_key,
                  color: Colors.grey,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).buttonColor),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) return 'Password cannot be empty';
                return null;
              },
              obscureText: !_passwordVisible,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              alignment: Alignment.center,
              child: FlatButton(
                  child: Text("Continue"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(hours: 1),
                        content: Row(
                          children: <Widget>[
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Signing in...")
                          ],
                        ),
                      ));
                      _signInWithEmailAndPassword();
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey))),
            ),
            Container(
              child: FlatButton(
                child: Text(
                  "New to BrighterBee? Register here",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textColor: Theme.of(context).accentColor,
                onPressed: () => _pushPage(context, Register()),
              ),
              alignment: Alignment.center,
            ),
            Container(
              child: FlatButton(
                child: Text(
                  "Forgot password?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textColor: Theme.of(context).accentColor,
                onPressed: () => _pushPage(context, ForgotPassword()),
              ),
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        _scaffoldKey.currentState.hideCurrentSnackBar();
        print("email not verified..." + (_emailController.text));
        _signOut();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Please verify email first, email has been sent.'),
        ));
        return;
      }

      String username = user.displayName;
      await setNameInSharedPreference(username);

      FirebaseFirestore instance = FirebaseFirestore.instance;
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

      _scaffoldKey.currentState.hideCurrentSnackBar();
      print("signed in..." + (_emailController.text));
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Signed in!'),
      ));

      String deviceId = await _firebaseMessaging.getToken();
      await instance.collection('users/$username/tokens').doc(deviceId).set({});

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Feed(user)));
    } catch (e) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      print("Sign in failed..." + (_emailController.text));
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Sign in failed! Please check credentials.'),
      ));
    }
  }

  setNameInSharedPreference(String username) async {
    String name = (await FirebaseFirestore.instance
            .collection('users')
            .doc(username)
            .get())
        .data()['name'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', name);
  }

  void _signOut() async {
    await _auth.signOut();
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}

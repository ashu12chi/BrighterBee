import 'package:brighter_bee/app_screens/profile.dart';
import 'package:brighter_bee/app_screens/settings.dart' as settings;
import 'package:brighter_bee/app_screens/user_app_screens/user_communities.dart';
import 'package:brighter_bee/app_screens/user_app_screens/user_drafts.dart';
import 'package:brighter_bee/app_screens/user_app_screens/user_following.dart';
import 'package:brighter_bee/app_screens/user_app_screens/user_saved.dart';
import 'package:brighter_bee/app_screens/user_search.dart';
import 'package:brighter_bee/authentication/sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// @author: Ashutosh Chitranshi
// Oct 12, 2020
// This will be used for displaying extra section

class Extra extends StatefulWidget {
  @override
  _ExtraState createState() => _ExtraState();
}

class _ExtraState extends State<Extra> {
  User user;
  String username;
  String displayName;
  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    displayName = username = user.displayName;
    getNameFromSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          AppBar(
            title: Text('Menu', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search users',
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserSearch()));
                },
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(user.displayName)));
                  },
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(user.photoURL),
                            radius: 26.0,
                            backgroundColor: Colors.grey,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              displayName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Text(
                              'See your profile',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15.0),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                      elevation: 4,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserCommunities()));
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.people),
                                Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text('Your Communities'))
                              ])))),
              SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                      elevation: 4,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserFollowing(username)));
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.person),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text('Following'),
                                )
                              ]))))
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 2 - 10,
              child: Card(
                elevation: 4,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => UserSaved()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.bookmark),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Saved'),
                        )
                      ],
                    )),
              ),
            ),
            SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 2 - 10,
                child: Card(
                    elevation: 4,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Drafts()));
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.drafts),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Drafts'),
                              )
                            ]))))
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8, right: 8),
            child: SizedBox(
              width: double.infinity,
              height: 67,
              child: Card(
                elevation: 4,
                child: InkWell(
                    onTap: () async {
                      await launch(
                          'https://github.com/NPDevs/BrighterBee/issues');
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 8,
                        ),
                        Icon(Icons.help),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            'Help & Support',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 67,
                child: Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  settings.Settings()));
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 8,
                        ),
                        Icon(Icons.settings),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            'Settings',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 67,
                child: Card(
                  elevation: 4,
                  child: InkWell(
                      onTap: () {
                        _signOut().whenComplete(() {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          Icon(Icons.exit_to_app),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              'Logout',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          )
                        ],
                      )),
                ),
              )),
        ],
      ),
    );
  }

  // This will help in getting name from shared preference
  getNameFromSharedPreference() async {
    SharedPreferences.getInstance().then((value) => {
          setDisplayName(value.getString('fullName')),
        });
  }

  // This will help in setting display name
  setDisplayName(String str) {
    setState(() {
      displayName = str;
    });
  }

  // This will sign out the user
  Future _signOut() async {
    Fluttertoast.showToast(msg: 'Signing out...');
    String deviceId = await FirebaseMessaging().getToken();
    await FirebaseFirestore.instance
        .collection('users/$username/tokens')
        .doc(deviceId)
        .delete();
    await _auth.signOut();
  }
}

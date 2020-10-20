import 'package:brighter_bee/app_screens/profile.dart';
import 'package:brighter_bee/app_screens/user_search.dart';
import 'package:brighter_bee/authentication/sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        title: Text('Menu'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            iconSize: 30.0,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserSearch()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(user.displayName)));
              },
              child: Card(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user.photoURL),
                      radius: 30.0,
                      backgroundColor: Colors.grey,
                    ),
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
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.people),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Communities'),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Following'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.bookmark),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Saved'),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.drafts),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Drafts'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: SizedBox(
                width: double.infinity,
                height: 67,
                child: Card(
                  elevation: 8,
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
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 67,
              child: Card(
                elevation: 8,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.settings),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Settings and Privacy',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 67,
              child: Card(
                elevation: 8,
                child: InkWell(
                    onTap: () {
                      _signOut().whenComplete(() {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SignIn()));
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getNameFromSharedPreference() async {
    SharedPreferences.getInstance().then((value) => {
          setDisplayName(value.getString('fullName')),
        });
  }

  setDisplayName(String str) {
    setState(() {
      displayName = str;
    });
  }

  Future _signOut() async {
    await _auth.signOut();
  }
}

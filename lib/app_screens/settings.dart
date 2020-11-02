import 'dart:io';

import 'package:brighter_bee/app_screens/about.dart';
import 'package:brighter_bee/authentication/delete_user.dart';
import 'package:brighter_bee/authentication/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

// @author: Ashutosh Chitranshi
// Oct 12, 2020
// This will be used for displaying settings in extra section

class _SettingsState extends State<Settings> {
  bool adminNotification = true;
  int feedOrder = 0; // 0 for time,1 for upvotes, 2 for views
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          InkWell(
            onTap: () async {
              await clearCache(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
              child: Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.delete),
                    ),
                    Text(
                      'Clear cached data',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            onTap: () async {
              await showDeletionConfirmation();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
              child: Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.warning),
                    ),
                    Text(
                      'Delete your account',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            onTap: () async {
              const url =
                  'https://github.com/NPDevs/BrighterBee/blob/master/LICENSE';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
              child: Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.policy),
                    ),
                    Text(
                      'Licence',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Text('GNU GPL v3')
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => About()));
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
              child: Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.info_outline),
                    ),
                    Text(
                      'About',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Text('BrighterBee v0.7')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show options in the bottom sheet
  showOptions() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: LimitedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                          Icons.access_time,
                          size: 30,
                          color: feedOrder == 0
                              ? Theme.of(context).accentColor
                              : Colors.grey,
                        )),
                        Text(
                          'Time',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.arrow_upward,
                            size: 30,
                            color: feedOrder == 1
                                ? Theme.of(context).accentColor
                                : Colors.grey,
                          ),
                          onPressed: () {}),
                      Text(
                        'Upvotes',
                        style: TextStyle(fontSize: 14),
                      )
                    ]),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                          Icons.visibility,
                          size: 30,
                          color: feedOrder == 2
                              ? Theme.of(context).accentColor
                              : Colors.grey,
                        )),
                        Text(
                          'Views',
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                          Icons.whatshot,
                          size: 30,
                          color: feedOrder == 2
                              ? Theme.of(context).accentColor
                              : Colors.grey,
                        )),
                        Text(
                          'Hot',
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  // This will clear cache
  clearCache(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Clear"),
        onPressed: () async {
          String appDir = (await getTemporaryDirectory()).path;
          Directory(appDir).delete(recursive: true);
          Fluttertoast.showToast(msg: "Cache cleared");
          Navigator.pop(context);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete cache?"),
      content: Text("Doing this might slow down loading of some images..."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // This will show deletion confirmation
  showDeletionConfirmation() async {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Delete my account",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).errorColor)),
        onPressed: () async {
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: Duration(hours: 1),
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
                SizedBox(
                  width: 15,
                ),
                Text("Deleting account...")
              ],
            ),
          ));
          await deleteUser(FirebaseAuth.instance.currentUser.displayName);
          Navigator.of(context).pop();
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignIn()));
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete your account?"),
      content: Text(
          "Doing this will remove all your account data. Posts, comments and replies will be left behind.\nThis is the ONLY warning."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

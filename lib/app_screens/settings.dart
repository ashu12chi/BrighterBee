import 'dart:io';

import 'package:brighter_bee/app_screens/about.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool adminNotification = true;
  int feedOrder = 0; // 0 for time,1 for upvotes, 2 for views
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.notifications_active),
                    ),
                    Text(
                      'Allow admin notifications',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Switch(
                    value: adminNotification,
                    activeColor: Theme.of(context).accentColor,
                    onChanged: (value) {
                      setState(() {
                        adminNotification = value;
                        print(adminNotification);
                      });
                    })
              ],
            ),
          ),
          InkWell(
            onTap: showOptions,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
              child: Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.calendar_today),
                    ),
                    Text(
                      'News Feed Preference',
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
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

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
}

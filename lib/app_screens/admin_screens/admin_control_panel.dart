import 'package:brighter_bee/app_screens/admin_screens/add_admins.dart';
import 'package:brighter_bee/app_screens/admin_screens/view_admins.dart';
import 'package:brighter_bee/app_screens/admin_screens/view_community_reports.dart';
import 'package:brighter_bee/app_screens/admin_screens/view_post_reports.dart';
import 'package:brighter_bee/app_screens/admin_screens/view_user_reports.dart';
import 'package:brighter_bee/helpers/community_delete.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// @author: Ashutosh Chitranshi
// 20 Oct, 2020
// This will be used for displaying settings in community to the creator

class AdminControlPanel extends StatefulWidget {
  final community;

  AdminControlPanel(this.community);

  @override
  _AdminControlPanelState createState() => _AdminControlPanelState(community);
}

class _AdminControlPanelState extends State<AdminControlPanel> {
  final community;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _AdminControlPanelState(this.community);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
        'Admin Control Panel',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('communities')
              .doc(community)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CachedNetworkImage(
                        imageUrl: snapshot.data['photoUrl'],
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Card(
                              elevation: 8,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddAdmins(community)));
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 20,
                                            right: 20),
                                        child: Text(
                                          'Add admins',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Icon(Icons.person_add)
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Card(
                                elevation: 8,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewAdmins(community)));
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 20,
                                            right: 20),
                                        child: Text(
                                          'View admins',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Icon(Icons.person)
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Card(
                              elevation: 8,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewPostReports(community)));
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 20,
                                            right: 20),
                                        child: Text(
                                          'View Post Reports',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Icon(Icons.report)
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: community == 'BrighterBee'
                                ? Card(
                                    elevation: 8,
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewCommunityReports()));
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 8.0,
                                                  left: 20,
                                                  right: 20),
                                              child: Text(
                                                'View Community Reports',
                                                style: TextStyle(fontSize: 16),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Icon(Icons.report)
                                          ],
                                        )),
                                  )
                                : Card(
                                    elevation: 8,
                                    child: InkWell(
                                        onTap: () async {
                                          await showCommunityDeletionConfirmation();
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 8.0,
                                                  left: 20,
                                                  right: 20),
                                              child: Text(
                                                'Delete Community',
                                                style: TextStyle(fontSize: 16),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Icon(Icons.delete_forever)
                                          ],
                                        )),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Center(
                          child: community == 'BrighterBee'
                              ? Card(
                                  elevation: 8,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewUserReports()));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                bottom: 8.0,
                                                left: 20,
                                                right: 20),
                                            child: Text(
                                              'View User Reports',
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Icon(Icons.report)
                                        ],
                                      )),
                                )
                              : Container()),
                    ),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  // This will show community deletion confirmation
  showCommunityDeletionConfirmation() async {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Delete",
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
                Text("Deleting community...")
              ],
            ),
          ));
          await deleteCommunity(community);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete comment?"),
      content: Text("Doing this will delete the community with all its posts."),
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

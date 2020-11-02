/*
* @author: Nishchal Siddharth Pandey
* 21 October, 2020. 11:57 PM IST
*
* This file shows list of communities current user is member of.
 */

import 'package:brighter_bee/helpers/community_join_leave_report_admin.dart';
import 'package:brighter_bee/widgets/community_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCommunities extends StatefulWidget {
  @override
  _UserCommunitiesState createState() => _UserCommunitiesState();
}

class _UserCommunitiesState extends State<UserCommunities> {
  User user;
  FirebaseFirestore instance;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    instance = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Member of',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Swipe ➱ right to leave', style: TextStyle(fontSize: 14))
        ])),
        body: StreamBuilder<DocumentSnapshot>(
            stream:
                instance.collection('users').doc(user.displayName).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data['communityCount'],
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(snapshot.data['communityList'][index]),
                        child: CommunityCard(
                            snapshot.data['communityList'][index]),
                        background: slideRightBackground(),
                        confirmDismiss: (direction) async {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      "Are you sure you want to leave ${snapshot.data['communityList'][index]} community?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).buttonColor),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "Leave",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).errorColor),
                                      ),
                                      onPressed: () async {
                                        await handleLeave(
                                            snapshot.data['communityList']
                                                [index],
                                            user.displayName);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          return res;
                        },
                      );
                    });
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Widget slideRightBackground() {
    return Container(
      color: Theme.of(context).errorColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            Text(
              " Leave",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

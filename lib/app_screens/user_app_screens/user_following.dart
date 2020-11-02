/*
* @author: Nishchal Siddharth Pandey
* 21 October, 2020. 11:57 PM IST
*
* This file shows list of users provided user is following.
 */

import 'package:brighter_bee/helpers/user_follow_unfollow_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/user_card.dart';

class UserFollowing extends StatefulWidget {
  final String _username;

  UserFollowing(this._username);

  @override
  _UserFollowingState createState() => _UserFollowingState(_username);
}

class _UserFollowingState extends State<UserFollowing> {
  String username;
  FirebaseFirestore instance;

  _UserFollowingState(this.username);

  @override
  void initState() {
    super.initState();
    instance = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Following',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Swipe ➱ right to unfollow', style: TextStyle(fontSize: 14))
        ])),
        body: StreamBuilder<DocumentSnapshot>(
            stream: instance.collection('users').doc(username).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data['followingCount'],
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(snapshot.data['followingList'][index]),
                        child: UserCard(snapshot.data['followingList'][index]),
                        background: slideRightBackground(),
                        confirmDismiss: (direction) async {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      "Are you sure you want to unfollow?"),
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
                                        "Unfollow",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).errorColor),
                                      ),
                                      onPressed: () async {
                                        await handleUnfollow(
                                            username,
                                            snapshot.data['followingList']
                                                [index]);
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
              Icons.person_remove,
              color: Colors.white,
            ),
            Text(
              " Unfollow",
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

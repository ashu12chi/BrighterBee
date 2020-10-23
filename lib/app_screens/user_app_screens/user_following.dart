/*
* @author: Nishchal Siddharth Pandey
* 21 October, 2020. 11:57 PM IST
*
* This file shows list of users provided user is following.
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserFollowing extends StatefulWidget {
  String _username;

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
            title: Text(
          'Following',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        body: StreamBuilder<DocumentSnapshot>(
            stream: instance.collection('users').doc(username).snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data['followingCount'],
                  itemBuilder: (context, index) {
                    String community = snapshot.data['followingList'][index];
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(community, style: TextStyle(fontSize: 18)),
                          Divider()
                        ]);
                  });
            }));
  }
}

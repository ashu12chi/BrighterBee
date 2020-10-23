/*
* @author: Nishchal Siddharth Pandey
* 21 October, 2020. 11:57 PM IST
*
* This file shows list of communities current user is member of.
 */

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
            title: Text(
          'Member of',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        body: StreamBuilder<DocumentSnapshot>(
            stream:
                instance.collection('users').doc(user.displayName).snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data['communityCount'],
                  itemBuilder: (context, index) {
                    String community = snapshot.data['communityList'][index];
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

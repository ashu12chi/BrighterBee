import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// @author: Nishchal Siddharth Pandey
// Oct 20, 2020
// This will be used for posts of a user saved in community

class UserSavedInCommunity extends StatefulWidget {
  final String _community;

  UserSavedInCommunity(this._community);

  _UserSavedInCommunity createState() => _UserSavedInCommunity(_community);
}

class _UserSavedInCommunity extends State<UserSavedInCommunity> {
  String community;
  String username;
  FirebaseFirestore instance;

  _UserSavedInCommunity(this.community);

  @override
  void initState() {
    super.initState();
    username = FirebaseAuth.instance.currentUser.displayName;
    instance = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Saved in $community',
                style: TextStyle(fontWeight: FontWeight.bold))),
        body: FutureBuilder<QuerySnapshot>(
            future: instance
                .collection('users/$username/posts/saved/$community')
                .orderBy('time')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.data != null)
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return PostCardView(
                          community, snapshot.data.docs[index].id, false);
                    });
              else
                return CircularProgressIndicator();
            }));
  }
}

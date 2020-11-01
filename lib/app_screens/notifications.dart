import 'package:brighter_bee/widgets/notification_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// @author: Nishchal Siddharth Pandey
// Oct 12, 2020
// This will be used for displaying notification section

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with AutomaticKeepAliveClientMixin {
  String username;
  FirebaseFirestore instance;

  @override
  void initState() {
    super.initState();
    instance = FirebaseFirestore.instance;
    username = FirebaseAuth.instance.currentUser.displayName;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(children: [
                AppBar(
                  title: Text('Notifications',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: instance
                        .collection('users/$username/notifications')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot documentSnapshot =
                                    snapshot.data.docs[index];
                                String id = documentSnapshot.id;
                                int postRelated =
                                    documentSnapshot.data()['postRelated'];
                                return NotificationCard(id, postRelated);
                              });
                    })
              ]))),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

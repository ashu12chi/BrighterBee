import 'package:brighter_bee/widgets/notification_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              instance.collection('users/$username/notifications').snapshots(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data.docs[index];
                      String id = documentSnapshot.id;
                      int postRelated = documentSnapshot.data()['postRelated'];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (postRelated == 1)
                                      ? getPostObject()
                                      : getProfileObject()));
                        },
                        child: NotificationCard(id, postRelated),
                      );
                    });
          }),
    );
  }

  getProfileObject() {}

  getPostObject() {}

  @override
  bool get wantKeepAlive => true;
}

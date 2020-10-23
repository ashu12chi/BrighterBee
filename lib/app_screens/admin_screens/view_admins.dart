import 'package:brighter_bee/helpers/community_join_leave.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../user_card.dart';
import '../profile.dart';

class ViewAdmins extends StatefulWidget {
  final community;
  ViewAdmins(this.community);
  @override
  _ViewAdminsState createState() => _ViewAdminsState(community);
}

class _ViewAdminsState extends State<ViewAdmins> {
  final community;
  _ViewAdminsState(this.community);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Admins',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('communities')
              .doc(community)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            print('28: ashu12_chi');
            print(snapshot.data['admin'].length);
            return ListView.builder(
              itemCount: snapshot.data['admin'].length,
              itemBuilder: (context, index) {
                print(snapshot.data['admin'][index]);
                return Dismissible(
                  key: Key(snapshot.data['admin'][index]),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Profile(snapshot.data['admin'][index])));
                    },
                    child: UserCard(snapshot.data['admin'][index]),
                  ),
                  background: slideRightBackground(),
                  confirmDismiss: (direction) async {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "Are you sure you want to remove this member as Admin ?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "Remove",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  await handleRemoveAdmin(
                                      community, snapshot.data['admin'][index]);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                    return res;
                  },
                );
              },
            );
          }),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
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
              " Remove",
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

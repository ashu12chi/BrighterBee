import 'package:brighter_bee/helpers/community_join_leave_report_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/user_card.dart';
import '../profile.dart';

// @author: Ashutosh Chitranshi
// 21 Oct, 2020
// This will be used for viewing admins from the control.

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
            return ListView.builder(
              physics: BouncingScrollPhysics(),
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
                                  style: TextStyle(
                                      color: Theme.of(context).buttonColor),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "Remove",
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor),
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

  // This will show slide right background
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

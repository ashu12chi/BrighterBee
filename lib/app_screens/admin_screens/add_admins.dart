import 'package:brighter_bee/helpers/community_join_leave_report_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/user_card.dart';
import '../profile.dart';

// @author: Ashutosh Chitranshi
// 20 Oct, 2020
// This will be used in admin control panel of a community for adding new admins in the app

class AddAdmins extends StatefulWidget {
  final community;

  AddAdmins(this.community);

  @override
  _AddAdminsState createState() => _AddAdminsState(community);
}

class _AddAdminsState extends State<AddAdmins> {
  final community;

  _AddAdminsState(this.community);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Admins',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('communities')
              .doc(community)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.exists) {
              print('28: ashu12_chi');
              print(snapshot.data['members'].length);
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data['members'].length,
                itemBuilder: (context, index) {
                  print(snapshot.data['members'][index]);
                  return (snapshot.data['admin']
                          .contains(snapshot.data['members'][index]))
                      ? Container()
                      : Dismissible(
                          key: Key(snapshot.data['members'][index]),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile(
                                          snapshot.data['members'][index])));
                            },
                            child: UserCard(snapshot.data['members'][index]),
                          ),
                          background: slideRightBackground(),
                          confirmDismiss: (direction) async {
                            final bool res = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                        "Are you sure you want to add this member as Admin ?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .buttonColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        onPressed: () async {
                                          await handleAddAdmin(community,
                                              snapshot.data['members'][index]);
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
            }
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            child: CircleAvatar(
                              radius: 30,
                            ),
                            baseColor: Colors.grey,
                            highlightColor: Colors.black12,
                          ),
                        ),
                        Shimmer.fromColors(
                          child: Card(
                            child: Text('Name of User Name of User '),
                            shape: RoundedRectangleBorder(),
                          ),
                          baseColor: Colors.grey,
                          highlightColor: Colors.black12,
                        )
                      ],
                    ),
                  );
                });
          }),
    );
  }

  // slide right widget

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.person_add,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              " Accept",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
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

import 'package:brighter_bee/app_screens/profile.dart';
import 'package:brighter_bee/helpers/community_join_leave_report_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/user_card.dart';

// @author: Ashutosh Chitranshi
// 21 Oct, 2020
// This will be used for verifying users.

class VerifyUser extends StatefulWidget {
  final community;

  VerifyUser(this.community);

  @override
  _VerifyUserState createState() => _VerifyUserState(community);
}

class _VerifyUserState extends State<VerifyUser> {
  final community;
  bool processing;

  void intiState() {
    super.initState();
    processing = false;
  }

  _VerifyUserState(this.community);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Users',
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
            print(snapshot.data['pendingMembers'].length);
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data['pendingMembers'].length,
              itemBuilder: (context, index) {
                print(snapshot.data['pendingMembers'][index]);
                return Dismissible(
                  key: Key(snapshot.data['pendingMembers'][index]),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(
                                  snapshot.data['pendingMembers'][index])));
                    },
                    child: UserCard(snapshot.data['pendingMembers'][index]),
                  ),
                  background: slideRightBackground(),
                  secondaryBackground: slideLeftBackground(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final bool res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                                  Text("Are you sure you want to reject ?"),
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
                                    "Reject",
                                    style: TextStyle(
                                        color: Theme.of(context).errorColor),
                                  ),
                                  onPressed: () async {
                                    //if(processing)
                                    //return;
                                    await handleJoinReject(community,
                                        snapshot.data['pendingMembers'][index]);
                                    //processing = false;
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                      return res;
                    }
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Are you sure you want to accept ?"),
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
                                  "Accept",
                                  style: TextStyle(color: Colors.green),
                                ),
                                onPressed: () async {
                                  await handleJoinAccept(community,
                                      snapshot.data['pendingMembers'][index]);
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
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            Text(
              " Accept",
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

  // This will show slide left background
  Widget slideLeftBackground() {
    return Container(
      color: Theme.of(context).errorColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Reject",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}

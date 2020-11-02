import 'package:brighter_bee/app_screens/community_screens/community_home.dart';
import 'package:brighter_bee/helpers/community_join_leave_report_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// @author: Ashutosh Chitranshi
// Oct 30, 2020
// This will be used for joining hidden private communities

class JoinCommunity extends StatefulWidget {
  @override
  _JoinCommunityState createState() => _JoinCommunityState();
}

class _JoinCommunityState extends State<JoinCommunity> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Join Hidden Community',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter joining code',
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).buttonColor),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              alignment: Alignment.center,
              child: FlatButton(
                  child: Text("Join"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey)),
                  onPressed: () async {
                    String community = _controller.text.trim();
                    final snapShot = await FirebaseFirestore.instance
                        .collection('communities')
                        .doc(community)
                        .get();
                    if (snapShot != null && snapShot.exists) {
                      print(snapShot['visibility']);
                      if (snapShot['visibility'] == 0) {
                        Fluttertoast.showToast(
                            msg: 'Enter valid community name');
                      } else {
                        bool member = snapShot['members'].contains(
                            FirebaseAuth.instance.currentUser.displayName);
                        if (snapShot['creator'] ==
                            FirebaseAuth.instance.currentUser.displayName)
                          member = true;
                        if (member) {
                          Fluttertoast.showToast(msg: 'Already a member');
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommunityHome(community)));
                          return;
                        }
                        await handleJoinRequest(community,
                            FirebaseAuth.instance.currentUser.displayName);
                        await handleJoinAccept(community,
                            FirebaseAuth.instance.currentUser.displayName);
                        Fluttertoast.showToast(msg: 'Community Joining done');
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CommunityHome(community)));
                      }
                    } else {
                      Fluttertoast.showToast(msg: 'Enter valid community name');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

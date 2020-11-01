import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:brighter_bee/live_stream/start_live.dart';
import 'package:brighter_bee/live_stream/upvote_downvote_livestream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call.dart';

/*
* @author: Ashutosh Chitranshi
* This will be used for displaying currently active live streams and navigation to them
*/

class LiveList extends StatefulWidget {
  final String community;

  LiveList(this.community);

  @override
  _LiveListState createState() => _LiveListState(community);
}

class _LiveListState extends State<LiveList> {
  String community;

  _LiveListState(this.community);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Streaming',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartLive(community)));
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('communities')
              .doc(community)
              .collection('live')
              .orderBy('upvotes', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  if (documentSnapshot['downvotes'] > 8) return Container();
                  return Dismissible(
                    key: Key(documentSnapshot.id),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallPage(
                                  channelName: documentSnapshot.id,
                                  role: ClientRole.Audience,
                                  name: documentSnapshot['title'],
                                  community: community,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 20),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            documentSnapshot['photoUrl']),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${documentSnapshot['title']}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          'upvotes: ${documentSnapshot['upvotes']} downvotes: ${documentSnapshot['downvotes']}')
                                    ])
                              ],
                            ),
                          ),
                        )
                      ],
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
                                    Text("Are you sure you want to downvote ?"),
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
                                      "Downvote",
                                      style: TextStyle(
                                          color: Theme.of(context).errorColor),
                                    ),
                                    onPressed: () async {
                                      //if(processing)
                                      //return;
                                      await downVote(
                                          community,
                                          documentSnapshot.id,
                                          FirebaseAuth
                                              .instance.currentUser.displayName,
                                          documentSnapshot['upvoters'].contains(
                                              FirebaseAuth.instance.currentUser
                                                  .displayName),
                                          documentSnapshot['downvoters']
                                              .contains(FirebaseAuth.instance
                                                  .currentUser.displayName));
//                                    //processing = false;
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
                              content:
                                  Text("Are you sure you want to upvote ?"),
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
                                    "Upvote",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onPressed: () async {
                                    await upVote(
                                        community,
                                        documentSnapshot.id,
                                        FirebaseAuth
                                            .instance.currentUser.displayName,
                                        documentSnapshot['upvoters'].contains(
                                            FirebaseAuth.instance.currentUser
                                                .displayName),
                                        documentSnapshot['downvoters'].contains(
                                            FirebaseAuth.instance.currentUser
                                                .displayName));
//                                    //processing = false;
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                      return res;
                    },
                  );
                });
          }),
    );
  }

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
              Icons.arrow_upward,
              color: Colors.white,
            ),
            Text(
              " Upvote",
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

  Widget slideLeftBackground() {
    return Container(
      color: Theme.of(context).errorColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.arrow_downward,
              color: Colors.white,
            ),
            Text(
              " Downvote",
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

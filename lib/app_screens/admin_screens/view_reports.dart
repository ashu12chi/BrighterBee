import 'package:brighter_bee/helpers/delete_post.dart';
import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewReports extends StatefulWidget {
  final community;

  ViewReports(this.community);

  @override
  _ViewReportsState createState() => _ViewReportsState(community);
}

class _ViewReportsState extends State<ViewReports> {
  final community;

  _ViewReportsState(this.community);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('View Reports', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('communities')
              .doc(community)
              .collection('posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  int reports = documentSnapshot['reports'];
                  if (reports > 0) {
                    return Dismissible(
                        key: Key(documentSnapshot.id),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Reports: $reports',
                              style: TextStyle(fontSize: 18),
                            ),
                            PostCardView(community, documentSnapshot.id)
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
                                    content: Text(
                                        "Are you sure you want to reject ?"),
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
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          //if(processing)
                                          //return;
                                          await deletePost(
                                              community,
                                              documentSnapshot.id,
                                              documentSnapshot['creator']);
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
                                      Text("Are you sure you want to accept ?"),
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
                                        "Remove reports",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('communities')
                                            .doc(community)
                                            .collection('posts')
                                            .doc(documentSnapshot.id)
                                            .update({'reports': 0});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          return res;
                        });
                  }
                  return Container();
                },
              );
            }
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
              Icons.check,
              color: Colors.white,
            ),
            Text(
              " Remove Reports",
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
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete post",
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

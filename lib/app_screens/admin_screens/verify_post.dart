import 'package:brighter_bee/app_screens/post_ui.dart';
import 'package:brighter_bee/helpers/delete_post.dart';
import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// @author: Ashutosh Chitranshi
// 21 Oct, 2020
// This will be used for verifying posts.

class VerifyPost extends StatefulWidget {
  final commuinty;

  VerifyPost(this.commuinty);

  @override
  _VerifyPostState createState() => _VerifyPostState(commuinty);
}

class _VerifyPostState extends State<VerifyPost> {
  final community;

  _VerifyPostState(this.community);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('communities')
              .doc(community)
              .collection('posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                print(documentSnapshot.id);
                if (documentSnapshot['isVerified'] == false &&
                    documentSnapshot['creator'] !=
                        FirebaseAuth.instance.currentUser.displayName) {
                  return Dismissible(
                    key: Key(documentSnapshot.id),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PostUI(community, documentSnapshot.id)));
                      },
                      child:
                          PostCardView(community, documentSnapshot.id, false),
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
                                    await FirebaseFirestore.instance
                                        .collection('communities')
                                        .doc(community)
                                        .collection('posts')
                                        .doc(documentSnapshot.id)
                                        .update({'isVerified': true});
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                      return res;
                    },
                  );
                }
                return Container();
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

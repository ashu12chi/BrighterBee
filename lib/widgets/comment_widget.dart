import 'package:brighter_bee/app_screens/comment.dart';
import 'package:brighter_bee/app_screens/profile.dart';
import 'package:brighter_bee/app_screens/user_app_screens/edit_comment.dart';
import 'package:brighter_bee/helpers/comment_delete_and_report.dart';
import 'package:brighter_bee/helpers/upvote_downvote_comment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*
* @author: Nishchal Siddharth Pandey
* 14 October, 2020
* This file returns widget to be used in cards for comments and replies.
*/

class CommentWidget extends StatefulWidget {
  final String _username;
  final String _community;
  final String _parentPostKey;
  final String _commKey;
  final String _parentKey;
  final bool _isReply;

  CommentWidget(this._community, this._parentPostKey, this._commKey,
      this._parentKey, this._username, this._isReply);

  _CommentWidget createState() => _CommentWidget(
      _community, _parentPostKey, _commKey, _parentKey, _username, _isReply);
}

class _CommentWidget extends State<CommentWidget> {
  String username;
  String community;
  String parentPostKey;
  String commKey;
  String parentKey;
  bool processing = false;
  bool isReply;

  _CommentWidget(this.community, this.parentPostKey, this.commKey,
      this.parentKey, this.username, this.isReply);

  @override
  void initState() {
    super.initState();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('communities/$community/posts/$parentPostKey/comments' +
                (isReply ? '/$parentKey/replies' : ''))
            .doc(commKey)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Row(
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
                SizedBox(
                  width: 15,
                ),
                Text('Loading data... Please Wait...')
              ],
            );
          try {
            String creator = snapshot.data['creator'];
            int downvotes = snapshot.data['downvotes'];
            int reports = snapshot.data['reports'];
            if (downvotes > 10 || reports > 5) return Container();
            int upvotes = snapshot.data['upvotes'];
            bool upvoted = snapshot.data['upvoters'].contains(username);
            bool downvoted = snapshot.data['downvoters'].contains(username);
            bool reported = snapshot.data['reporters'].contains(username);
            int replyCount;
            if (!isReply) replyCount = snapshot.data['replyCount'];
            String text = snapshot.data['text'];
            var time = snapshot.data['time'];
            var lastModified = snapshot.data['lastModified'];
            String dateLong = formatDate(
                DateTime.fromMillisecondsSinceEpoch(time),
                [yyyy, ' ', M, ' ', dd, ', ', hh, ':', nn, ' ', am]);
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(creator)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Row(
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: <Widget>[
                            CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.grey),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Loading data... Please Wait...')
                          ],
                        ),
                      ],
                    );
                  // String fullName = snapshot.data['name'];
                  String profilePicUrl = snapshot.data['photoUrl'];
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(profilePicUrl),
                              radius: 10.0,
                              backgroundColor: Colors.grey,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Profile(creator)));
                            },
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    child: Text(creator,
                                        // fullName.substring(
                                        //     0, fullName.indexOf(' ')),
                                        style: TextStyle(fontSize: 14.0)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Profile(creator)));
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    dateLong,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  )
                                ],
                              )),
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.more_horiz),
                              alignment: Alignment.topRight,
                              onPressed: () {
                                print(creator);
                                showOptions(
                                    creator,
                                    dateLong,
                                    text,
                                    text,
                                    reported,
                                    isReply,
                                    parentPostKey,
                                    parentKey,
                                    commKey);
                              },
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(TextSpan(
                            text: '',
                            children: text.split(' ').map((w) {
                              return w.startsWith('@') && w.length > 1
                                  ? TextSpan(
                                      text: ' ' + w,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () => openProfile(w))
                                  : TextSpan(
                                      text: ' ' + w,
                                      style: TextStyle(fontSize: 14));
                            }).toList())),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            upvotes.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: (upvoted
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).buttonColor),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (processing) return;
                              processing = true;
                              if (isReply) {
                                await upvote(
                                    community,
                                    username,
                                    upvoted,
                                    downvoted,
                                    parentPostKey,
                                    parentKey,
                                    commKey,
                                    isReply);
                              } else {
                                await upvote(
                                    community,
                                    username,
                                    upvoted,
                                    downvoted,
                                    parentPostKey,
                                    commKey,
                                    commKey,
                                    isReply);
                              }
                              processing = false;
                            },
                            icon: Icon(
                              Icons.arrow_upward,
                              size: 18,
                            ),
                            color: (upvoted
                                ? Theme.of(context).accentColor
                                : Theme.of(context).buttonColor),
                          ),
                          Text(
                            downvotes.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: (downvoted
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).buttonColor),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (processing) return;
                              processing = true;
                              if (isReply) {
                                await downvote(
                                    community,
                                    username,
                                    upvoted,
                                    downvoted,
                                    parentPostKey,
                                    parentKey,
                                    commKey,
                                    isReply);
                              } else {
                                await downvote(
                                    community,
                                    username,
                                    upvoted,
                                    downvoted,
                                    parentPostKey,
                                    commKey,
                                    commKey,
                                    isReply);
                              }
                              processing = false;
                            },
                            icon: Icon(Icons.arrow_downward, size: 18),
                            color: (downvoted
                                ? Theme.of(context).accentColor
                                : Theme.of(context).buttonColor),
                          ),
                          isReply
                              ? new Container()
                              : Container(
                                  child: Row(children: [
                                  SizedBox(width: 10),
                                  Text(
                                    replyCount.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).buttonColor),
                                  ),
                                  SizedBox(width: 10)
                                ])),
                          isReply
                              ? Container()
                              : IconButton(
                                  onPressed: () {
                                    comment(
                                        community,
                                        dateLong,
                                        commKey,
                                        parentPostKey,
                                        username,
                                        text,
                                        creator,
                                        true,
                                        '@$creator ');
                                  },
                                  icon: Icon(Icons.reply, size: 18),
                                  color: Theme.of(context).buttonColor,
                                ),
                          Spacer(),
                          (lastModified != time)
                              ? Text('Edited  ',
                                  style: TextStyle(color: Colors.grey))
                              : Container()
                        ],
                      )
                    ],
                  );
                });
          } catch (e) {
            return Container();
          }
        });
  }

  comment(
      String community,
      String dateLong,
      String parentKey,
      String parentPostKey,
      String username,
      String title,
      String creator,
      bool isReply,
      String initialText) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext) => Comment(
                community,
                dateLong,
                parentKey,
                parentPostKey,
                username,
                title,
                creator,
                isReply,
                initialText)));
  }

  openProfile(String userTag) async {
    Fluttertoast.showToast(
        msg: "Loading...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
    userTag = userTag.replaceAll(RegExp('[^A-Za-z0-9]'), '');
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userTag).get();
    if (doc == null || !doc.exists) {
      Fluttertoast.showToast(
          msg: "User doesn't exist",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
      return;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Profile(userTag)));
    debugPrint('Profile opened!');
  }

  showOptions(
      String creator,
      String dateLong,
      String initialText,
      String title,
      bool reported,
      bool isReply,
      String postKey,
      String commentKey,
      String replyKey) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: LimitedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FirebaseAuth.instance.currentUser.displayName == creator
                        ? Column(
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditComment(
                                                community,
                                                dateLong,
                                                parentKey,
                                                parentPostKey,
                                                username,
                                                title,
                                                creator,
                                                isReply,
                                                initialText,
                                                commKey)));
                                  },
                                  icon: Icon(Icons.edit,
                                      size: 30,
                                      color: Theme.of(context).buttonColor)),
                              Text(
                                'Edit',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          )
                        : reported
                            ? Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.report,
                                        size: 30, color: Colors.green),
                                    onPressed: () async {
                                      if (isReply) {
                                        await undoReplyReport(
                                            community,
                                            postKey,
                                            commentKey,
                                            replyKey,
                                            username);
                                      } else
                                        await undoCommentReport(community,
                                            postKey, replyKey, username);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    'Remove Report',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.report,
                                          size: 30, color: Colors.red),
                                      onPressed: () async {
                                        if (isReply) {
                                          await replyReport(community, postKey,
                                              commentKey, replyKey, username);
                                        } else
                                          await commentReport(community,
                                              postKey, replyKey, username);
                                        Navigator.pop(context);
                                      }),
                                  Text(
                                    'Report',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                    FirebaseAuth.instance.currentUser.displayName == creator
                        ? Column(
                            children: <Widget>[
                              IconButton(
                                  onPressed: () async {
                                    await showCommentDeletionConfirmation(
                                        creator);
                                  },
                                  icon: Icon(Icons.delete,
                                      size: 30,
                                      color: Theme.of(context).buttonColor)),
                              Text(
                                'Delete',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            );
          });
        });
  }

  showCommentDeletionConfirmation(String creator) async {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Delete",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).errorColor)),
        onPressed: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: 'Deleting comment...');
          await deleteComment(community, parentPostKey,
              isReply ? parentKey : commKey, commKey, isReply, creator);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete comment?"),
      content: Text("Doing this will delete the comment" +
          (isReply ? '.' : ' and all its replies.')),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

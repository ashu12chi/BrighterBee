import 'package:brighter_bee/app_screens/comment.dart';
import 'package:brighter_bee/app_screens/profile.dart';
import 'package:brighter_bee/helpers/upvote_downvote_comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  String username;
  String community;
  String parentPostKey;
  String commKey;
  String parentKey;
  bool isReply;

  CommentWidget(this.community, this.parentPostKey, this.commKey,
      this.parentKey, this.username, this.isReply);

  _CommentWidget createState() => _CommentWidget(
      community, parentPostKey, commKey, parentKey, username, isReply);
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
          String creator = snapshot.data['creator'];
          int downvotes = snapshot.data['downvotes'];
          int upvotes = snapshot.data['upvotes'];
          bool upvoted = snapshot.data['upvoters'].contains(username);
          bool downvoted = snapshot.data['downvoters'].contains(username);
          int replyCount;
          if (!isReply) replyCount = snapshot.data['replyCount'];
          String text = snapshot.data['text'];
          var time = snapshot.data['time'];
          String dateLong = formatDate(
              DateTime.fromMillisecondsSinceEpoch(time),
              [yyyy, ' ', M, ' ', dd, ', ', hh, ':', nn, ' ', am]);
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Colors.grey,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            creator,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(width: 10),
                          Text(
                            dateLong,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          )
                        ],
                      )),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.more_horiz),
                      alignment: Alignment.topRight,
                    ),
                  )
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
                              style: TextStyle(color: Colors.blue),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () => Profile(),
                            )
                          : TextSpan(
                              text: ' ' + w, style: TextStyle(fontSize: 14));
                    }).toList())),
              ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     text,
              //     style: TextStyle(fontSize: 14),
              //   ),
              // ),
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
                        await upvote(community, username, upvoted, downvoted,
                            parentPostKey, parentKey, commKey, isReply);
                      } else {
                        await upvote(community, username, upvoted, downvoted,
                            parentPostKey, commKey, commKey, isReply);
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
                        await downvote(community, username, upvoted, downvoted,
                            parentPostKey, parentKey, commKey, isReply);
                      } else {
                        await downvote(community, username, upvoted, downvoted,
                            parentPostKey, commKey, commKey, isReply);
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
                                color: Theme
                                    .of(context)
                                    .buttonColor),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              comment(community, dateLong, commKey,
                                  parentPostKey, username, text, creator, true);
                            },
                            icon: Icon(Icons.reply, size: 18),
                            color: Theme.of(context).buttonColor,
                          )
                        ])),
                ],
              )
            ],
          );
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
      bool isReply) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext) => Comment(community, dateLong, parentKey,
                parentPostKey, username, title, creator, isReply)));
  }
}

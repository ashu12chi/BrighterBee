import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  String username;
  String community;
  String parentPostKey;
  String commKey;

  CommentCard(this.community, this.parentPostKey, this.commKey, this.username);

  _CommentCard createState() =>
      _CommentCard(community, parentPostKey, commKey, username);
}

class _CommentCard extends State<CommentCard> {
  String username;
  String community;
  String parentPostKey;
  String commKey;
  bool processing;

  _CommentCard(this.community, this.parentPostKey, this.commKey, this.username);

  @override
  Widget build(BuildContext context) {
    print('NSP communities/$community/posts/$parentPostKey/comments/$commKey');
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('communities/$community/posts/$parentPostKey/comments')
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
          print('NSP' + snapshot.toString());
          String creator = snapshot.data['creator'];
          int downvotes = snapshot.data['downvoters'].length;
          int upvotes = snapshot.data['upvoters'].length;
          bool upvoted = snapshot.data['upvoters'].contains(username);
          bool downvoted = snapshot.data['downvoters'].contains(username);
          int replyCount = snapshot.data['replyCount'];
          String text = snapshot.data['text'];
          var time = snapshot.data['time'];
          String dateLong = formatDate(
              DateTime.fromMillisecondsSinceEpoch(time),
              [yyyy, ' ', MM, ' ', dd, ', ', hh, ':', nn, ' ', am]);
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 18.0,
                            backgroundColor: Colors.grey,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                children: <Widget>[
                                  Text(creator,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  Text(
                                    dateLong,
                                    style: TextStyle(color: Colors.grey),
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
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              text,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            upvotes.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: (upvoted
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).buttonColor),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (processing) return;
                              processing = true;
                              // await upvote(community, key,
                              //     username, upvoted, downvoted);
                              processing = false;
                            },
                            icon: Icon(Icons.arrow_upward),
                            color: (upvoted
                                ? Theme.of(context).accentColor
                                : Theme.of(context).buttonColor),
                          ),
                          Text(
                            downvotes.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: (downvoted
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).buttonColor),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (processing) return;
                              processing = true;
                              // await downvote(community, key,
                              //     username, upvoted, downvoted);
                              processing = false;
                            },
                            icon: Icon(Icons.arrow_downward),
                            color: (downvoted
                                ? Theme.of(context).accentColor
                                : Theme.of(context).buttonColor),
                          ),
                          SizedBox(width: 10),
                          Text(
                            replyCount.toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.comment),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

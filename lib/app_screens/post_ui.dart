import 'dart:convert';

import 'package:brighter_bee/app_screens/comment.dart';
import 'package:brighter_bee/helpers/upvote_downvote_post.dart';
import 'package:brighter_bee/widgets/video_player.dart';
import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:brighter_bee/widgets/comments_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:zefyr/zefyr.dart';

class PostUI extends StatefulWidget {
  String _community;
  String _postKey;
  String _username;

  PostUI(this._community, this._postKey, this._username);

  @override
  _PostState createState() => _PostState(_community, _postKey, _username);
}

class _PostState extends State<PostUI> {
  String community;
  String key;
  String username;
  bool processing;

  _PostState(this.community, this.key, this.username);

  @override
  void initState() {
    super.initState();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('communities/$community/posts')
              .doc(key)
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
            var time = snapshot.data['time'];
            int upvotes = snapshot.data['upvotes'];
            int downvotes = snapshot.data['downvotes'];
            String title = snapshot.data['title'];
            int views = snapshot.data['viewers'].length;
            int commentCount = snapshot.data['commentCount'];
            int mediaType = snapshot.data['mediaType'];
            bool upvoted = snapshot.data['upvoters'].contains(username);
            bool downvoted = snapshot.data['downvoters'].contains(username);
            if (!snapshot.data['viewers'].contains(username))
              addToViewers(community, key, username);
            String mediaUrl;
            if (mediaType > 0) mediaUrl = snapshot.data['mediaUrl'];
            String content = snapshot.data['content'];
            NotusDocument document =
                NotusDocument.fromJson(jsonDecode(content));
            String dateLong = formatDate(
                DateTime.fromMillisecondsSinceEpoch(time),
                [yyyy, ' ', MM, ' ', dd, ', ', hh, ':', nn, ' ', am]);

            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(creator)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Row(
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
                        ));
                  String name1 = snapshot.data['name'];

                  return SafeArea(
                      child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: CircleAvatar(
                                radius: 18.0,
                                backgroundColor: Colors.grey,
                              )),
                          Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                          name1.substring(
                                              0, name1.indexOf(' ')),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold)),
                                      Icon(Icons.arrow_right),
                                      Text(community,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Text(
                                    dateLong,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              )),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.more_horiz),
                            alignment: Alignment.topRight,
                            onPressed: showOptions,
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 15, left: 15),
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: ZefyrView(
                            document: document,
                            imageDelegate: MyAppZefyrImageDelegate(),
                          ),
                        ),
                        (mediaType == 0)
                            ? Container()
                            : (mediaType == 2)
                                ? VideoPlayer(mediaUrl)
                                : Image.network(
                                    mediaUrl,
                                    width: double.infinity,
                                    height: 250,
                                  ),
                        Divider(
                          color: Theme.of(context).buttonColor,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 15, left: 15),
                              child: Text(
                                'Comments',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        CommentsList(community, key, username),
                      ]))),
                      Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
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
                                  await upvote(community, key, username,
                                      upvoted, downvoted);
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
                                  await downvote(community, key, username,
                                      upvoted, downvoted);
                                  processing = false;
                                },
                                icon: Icon(Icons.arrow_downward),
                                color: (downvoted
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).buttonColor),
                              ),
                              Text(
                                views.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.remove_red_eye),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Text(
                                  commentCount.toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  comment(community, dateLong, key, username,
                                      title, creator, false);
                                },
                                child: Text(
                                  'Comment',
                                  style: TextStyle(fontSize: 15),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                        color: Theme.of(context).buttonColor)),
                              ),
                            ],
                          ))
                    ],
                  ));
                });
          }),
    );
  }

  comment(String community, String dateLong, String key, String username,
      String title, String creator, bool isReply) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext) => Comment(community, dateLong, key, key,
                username, title, creator, isReply)));
  }

  showOptions() {
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
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.share,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Share',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.bookmark,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Save article',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.report,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Report',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}

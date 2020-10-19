import 'dart:convert';

import 'package:brighter_bee/app_screens/post_ui.dart';
import 'package:brighter_bee/helpers/upvote_downvote_post.dart';
import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class PostCardView extends StatefulWidget {
  String community;
  String key1;

  PostCardView(this.community, this.key1);

  @override
  _PostState createState() => _PostState(community, key1);
}

class _PostState extends State<PostCardView> {
  String community;
  String key;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String username;
  bool processing;

  FocusNode _focusNode;

  _PostState(this.community, this.key);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    username = _auth.currentUser.displayName;
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          String name = snapshot.data['creator'];
          int mediaType = snapshot.data['mediaType'];
          int views = snapshot.data['viewers'].length;
          int downvotes = snapshot.data['downvoters'].length;
          int upvotes = snapshot.data['upvoters'].length;
          bool upvoted = snapshot.data['upvoters'].contains(username);
          bool downvoted = snapshot.data['downvoters'].contains(username);
          int commentCount = snapshot.data['commentCount'];
          String title = snapshot.data['title'];
          String mediaUrl =
              'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/thumbnails%2Fthumbnail_video_default.png?alt=media&token=110cba28-6dd5-4656-8eca-cbefe9cce925';
          if (mediaType == 1) mediaUrl = snapshot.data['mediaUrl'];
          var time = snapshot.data['time'];
          String dateLong = formatDate(
              DateTime.fromMillisecondsSinceEpoch(time),
              [yyyy, ' ', MM, ' ', dd, ', ', hh, ':', nn, ' ', am]);
          String content = snapshot.data['content'];
          final document1 = NotusDocument.fromJson(jsonDecode(content));
          final editor = new ZefyrEditor(
            autofocus: false,
            padding: EdgeInsets.all(0),
            focusNode: _focusNode,
            controller: ZefyrController(document1),
            imageDelegate: CardZefyrImageDelegate(),
            mode: ZefyrMode.view,
            physics: NeverScrollableScrollPhysics(),
          );
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(name)
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
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Loading data... Please Wait...')
                        ],
                      ),
                    ],
                  );
                String name1 = snapshot.data['name'];
                //return Text('Loading data.. Please Wait..');
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Card(
                          elevation: 8,
                          child: InkWell(
                            onTap: openPost,
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
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Text(
                                                      name1.substring(0,
                                                          name1.indexOf(' ')),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0)),
                                                  Icon(Icons.arrow_right),
                                                  Text(community,
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                              Text(
                                                dateLong,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )
                                            ],
                                          )),
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(Icons.more_horiz),
                                          alignment: Alignment.topRight,
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              15.0)),
                                                ),
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter state) {
                                                    return SingleChildScrollView(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: LimitedBox(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: <Widget>[
                                                            Column(
                                                              children: <
                                                                  Widget>[
                                                                IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .share,
                                                                        size:
                                                                            30,
                                                                        color: Theme.of(context)
                                                                            .buttonColor)),
                                                                Text(
                                                                  'Share',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: <
                                                                  Widget>[
                                                                IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .bookmark,
                                                                        size:
                                                                            30,
                                                                        color: Theme.of(context)
                                                                            .buttonColor)),
                                                                Text(
                                                                  'Save article',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            ),
                                                            username == name
                                                                ? Column(
                                                                    children: <
                                                                        Widget>[
                                                                      IconButton(
                                                                          icon: Icon(
                                                                              Icons.delete,
                                                                              size: 30,
                                                                              color: Theme.of(context).buttonColor),
                                                                        onPressed: (){

                                                                        },
                                                                      ),
                                                                      Text(
                                                                        'Delete',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Column(
                                                                    children: <
                                                                        Widget>[
                                                                      IconButton(
                                                                          icon: Icon(
                                                                              Icons.report,
                                                                              size: 30,
                                                                              color: Theme.of(context).buttonColor)),
                                                                      Text(
                                                                        'Report',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                                    ],
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8),
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 105,
                                    child: ZefyrScaffold(
                                      child: editor,
                                    ),
                                  ),
                                  mediaType == 0
                                      ? Container()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Image.network(
                                                mediaUrl,
                                                fit: BoxFit.fill,
                                                height: 200,
                                              ),
                                            ],
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
                                          await downvote(community, key,
                                              username, upvoted, downvoted);
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
                                      SizedBox(width: 10),
                                      Text(
                                        commentCount.toString(),
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.comment),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                );
              });
        });
  }

  openPost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                PostUI(community, key, username)));
    debugPrint('Post opened!');
  }
}

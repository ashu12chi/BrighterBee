import 'dart:convert';

import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class PostCardView extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostCardView> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('communities/Computing/posts/posted/2020-10-07')
              .doc('1602068390865')
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
            print(snapshot.data);
            String name = snapshot.data['creator'];
            int mediaType = snapshot.data['mediaType'];
            int views = snapshot.data['views'];
            int downvotes = snapshot.data['downvotes'];
            int upvotes = snapshot.data['upvotes'];
            String title = snapshot.data['title'];
            String community = 'Computing';
            String mediaUrl =
                'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/thumbnails%2Fthumbnail_video_default.png?alt=media&token=110cba28-6dd5-4656-8eca-cbefe9cce925';
            if (mediaType == 1) mediaUrl = snapshot.data['mediaUrl'];
            var time = snapshot.data['time'];
            String date = formatDate(DateTime.fromMillisecondsSinceEpoch(time),
                [yyyy, '-', mm, '-', dd]);
            print(name);
            print(mediaType);
            print(date);
            print(views);
            print(mediaType);
            print(mediaUrl);
            print(title);
            print(upvotes);
            print(downvotes);
            String content = snapshot.data['content'];
            print(jsonDecode(content));
            final document1 = NotusDocument.fromJson(jsonDecode(content));
            print(document1);
            final editor = new ZefyrEditor(
              padding: EdgeInsets.all(0),
              focusNode: _focusNode,
              controller: ZefyrController(document1),
              imageDelegate: MyAppZefyrImageDelegate(),
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
                  String name1 = snapshot.data['name'];
                  //return Text('Loading data.. Please Wait..');
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 8.0, right: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Card(
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
                                                Text(name1,
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
                                              date,
                                              style:
                                              TextStyle(color: Colors.grey),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_upward),
                                    ),
                                    Text(
                                      downvotes.toString(),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_downward),
                                    ),
                                    Text(
                                      views.toString(),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Text(
                                        '108',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'Comments',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          side: BorderSide(
                                              color: Theme
                                                  .of(context)
                                                  .buttonColor)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()
      ..insert("Loading...\n");
    return NotusDocument.fromDelta(delta);
  }
}

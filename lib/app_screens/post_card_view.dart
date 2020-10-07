import 'dart:convert';

import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class PostUI extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostUI> {
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
              .collection('posts')
              .document('1601924732454')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading data.. Please Wait..');
            print(snapshot.data['creator']);
            String name = snapshot.data['creator'];
            String community = snapshot.data['time'].toString();
            int downvote = snapshot.data['downvote'];
            int upvote = snapshot.data['upvote'];
            String title = snapshot.data['title'];
            int views = snapshot.data['views'];
            int mediatype = snapshot.data['mediaType'];
            String mediaUrl = null;
            if (mediatype > 0) mediaUrl = snapshot.data['mediaUrl'];
            print(mediaUrl);
            String content = snapshot.data['content'];
            //print(jsonDecode(content));
            final document1 = NotusDocument.fromJson(jsonDecode(content));
            //print(document1);
            final editor = new ZefyrEditor(
              focusNode: _focusNode,
              controller: ZefyrController(document1),
              imageDelegate: MyAppZefyrImageDelegate(),
              mode: ZefyrMode.view,
            );
            int timestamp = 1601924732454;
            var date = new DateTime.fromMillisecondsSinceEpoch(timestamp)
                .toString()
                .substring(0, 16);
            print(date);
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .document(name)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Text('Loading data.. Please Wait..');
                  String name1 = snapshot.data['name'];
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('communities')
                          .document(community)
                          .snapshots(),
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, left: 8.0, right: 8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.grey,
                                  ),
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
                                                      color: Colors.black,
                                                      fontSize: 16.0)),
                                              Icon(Icons.arrow_right),
                                              Text(community)
                                            ],
                                          ),
                                          Text(
                                            date,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      )),
                                  IconButton(
                                    icon: Icon(Icons.more_horiz),
                                    alignment: Alignment.topRight,
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: ZefyrScaffold(
                                  child: editor,
                                ),
                              ),
                              mediatype == 0
                                  ? Container()
                                  : Image.network(
                                      mediaUrl,
                                      width: double.infinity,
                                      height: 250,
                                    ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    upvote.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_upward),
                                  ),
                                  Text(
                                    downvote.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_downward),
                                  ),
                                  Text(
                                    views.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Text(
                                      '6',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  FlatButton(
                                    child: Text(
                                      '  Comments  ',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(color: Colors.black)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                });
          }),
    );
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("ashu12_chi\nThis is a sample post\n");
    return NotusDocument.fromDelta(delta);
  }
}

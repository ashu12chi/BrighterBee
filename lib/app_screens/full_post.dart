import 'dart:io';

import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class FullPost extends StatefulWidget {
  @override
  _FullPost createState() => _FullPost();
}

class _FullPost extends State<FullPost> {
  ZefyrController _controller;
  TextEditingController titleController = TextEditingController();
  FocusNode _focusNode;
  String displayName = 'Nishchal Siddharth';
  String username = 'nisiddharth';
  String noticeText = "Add media to your post";
  String mediaURL;
  int mediaType = 0; // 0 for none, 1 for image, 2 for video
  File media;
  QuerySnapshot result;
  Set selected;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Future<void> initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final editor = new ZefyrField(
      focusNode: _focusNode,
      controller: _controller,
      imageDelegate: MyAppZefyrImageDelegate(),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Enter text Here...',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
      ),
    );

    Firebase.initializeApp();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Create Post',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Post',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        displayName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      MaterialButton(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.people),
                              Text('Communities'),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                          textColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.grey))),
                    ],
                  ),
                )
              ],
            ),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter title here',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ZefyrScaffold(
                child: editor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }
}

import 'dart:convert';
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
  TextEditingController titleController = TextEditingController();
  String displayName = 'Nishchal Siddharth';
  String username = 'nisiddharth';
  String mediaURL;
  int mediaType = 0; // 0 for none, 1 for image, 2 for video
  File media;
  String key = "1601924732454";
  QuerySnapshot result;
  Set selected;
  NotusDocument document;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Future<void> initState() {
    super.initState();
    _loadDocument().then((doc) {
      setState(() {
        document = doc;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    final view = new ZefyrView(
      imageDelegate: MyAppZefyrImageDelegate(),
      document: document,

    );

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
                  radius: 15.0,
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
                    ],
                  ),
                )
              ],
            ),
            Text('Enter title here',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Expanded(
              child: (document == null)
              ? Center(child: CircularProgressIndicator())
              : ZefyrScaffold(
                child: view,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<NotusDocument> _loadDocument() async {
    String s = "[{\"insert\":\"Attention\",\"attributes\":{\"b\":true}},{\"insert\":\"\\n\",\"attributes\":{\"heading\":1}},{\"insert\":\"You've been runnin' round, runnin' round, runnin' round throwin' that dirt all on my name\\n'Cause you knew that I, knew that I, knew that I'd call you up\\nYou've been going round, going round, going round every party in L.A.\\n'Cause you knew that I, knew that I, knew that I'd be at one, oh\\nI know that dress is karma, perfume regret\"},{\"insert\":\"\\n\",\"attributes\":{\"block\":\"quote\"}},{\"insert\":\"You got me thinking 'bout when you were mine, oh\\nAnd now I'm all up on ya, what you expect?\\nBut you're not coming home with me tonight\\nYou just want attention, you don't want my heart\\nMaybe you just hate the thought of me with someone new\\nYeah, you just want attention, I knew from the start\\nYou're just making sure I'm never gettin' over you\\n\\n-\"},{\"insert\":\" Charlie Puth\",\"attributes\":{\"i\":true}},{\"insert\":\"\\n\"}]";
    // final Delta delta = Delta()..insert("\n");
    // return document = NotusDocument.fromDelta(delta);
    return NotusDocument.fromJson(jsonDecode(s));
  }
}

import 'dart:convert';

import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  ZefyrController _controller;
  FocusNode _focusNode;
  String username = 'Nishchal Siddharth';
  QuerySnapshot result;
  List<CheckBoxData> checkboxDataList = [];
  Set selected;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Future<void> initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  initializeList() async {
    result =
        await FirebaseFirestore.instance.collection('communities').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    int i = 0;
    documents.forEach((element) {
      checkboxDataList.add(new CheckBoxData(
          id: i.toString(), displayId: element.documentID, checked: false));
      ++i;
    });
    selected = new Set();
  }

  @override
  Widget build(BuildContext context) {
    final editor = new ZefyrEditor(
      focusNode: _focusNode,
      controller: _controller,
      imageDelegate: MyAppZefyrImageDelegate(),
    );

    Firebase.initializeApp();
    // initializeList();

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
            onPressed: checkPostable,
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            FlatButton(
              child: Text(
                'Add to your post',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            IconButton(
              icon: Icon(Icons.image),
            ),
            IconButton(
              icon: Icon(Icons.video_call),
            )
          ],
        ),
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
                        username,
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
                            side: BorderSide(color: Colors.grey)),
                        onPressed: showCommunities,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: ZefyrScaffold(
                child: editor,
              ),
            )
          ],
        ),
      ),
    );
  }

  showCommunities() {
    if (checkboxDataList.length == 0) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        behavior: SnackBarBehavior.floating,
        content: new Row(
          children: <Widget>[
            new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
            SizedBox(
              width: 15,
            ),
            new Text("Populating List...")
          ],
        ),
      ));
      initializeList().whenComplete(() => showCommunities());
    } else {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter state) {
              return SingleChildScrollView(
                child: LimitedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: checkboxDataList.map<Widget>(
                      (data) {
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CheckboxListTile(
                                value: data.checked,
                                title: Text(data.displayId),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool val) {
                                  if (val) {
                                    selected.add(data.displayId);
                                  } else {
                                    selected.remove(data.displayId);
                                  }
                                  state(() {
                                    data.checked = !data.checked;
                                  });
                                },
                                activeColor: Theme.of(context).accentColor,
                                checkColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  communityChecked(int n) {}

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("What's on your mind?\n");
    return NotusDocument.fromDelta(delta);
  }

  checkPostable() {
    if (selected.length == 0) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('No communities selected.'),
      ));
      return false;
    }
    String content = jsonEncode(_controller.document);
    if (content.length == 0) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('No text written.'),
      ));
      return false;
    }
  }

  addToDatabase() {}
}

class CheckBoxData {
  String id;
  String displayId;
  bool checked;

  CheckBoxData({
    this.id,
    this.displayId,
    this.checked,
  });

  factory CheckBoxData.fromJson(Map<String, dynamic> json) => CheckBoxData(
        id: json["id"] == null ? null : json["id"],
        displayId: json["displayId"] == null ? null : json["displayId"],
        checked: json["checked"] == null ? null : json["checked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "displayId": displayId == null ? null : displayId,
        "checked": checked == null ? null : checked,
      };
}

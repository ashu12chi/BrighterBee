import 'dart:convert';
import 'dart:io';

import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
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
  List<CheckBoxData> checkboxDataList = [];
  List selected;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  initializeList() async {
    result = await FirebaseFirestore.instance.collection('communities').get();
    final List<DocumentSnapshot> documents = result.docs;
    int i = 0;
    documents.forEach((element) {
      checkboxDataList.add(CheckBoxData(
          id: i.toString(), displayId: element.id, checked: false));
      ++i;
    });
    selected = List();
  }

  @override
  Widget build(BuildContext context) {
    final editor = ZefyrField(
      focusNode: _focusNode,
      controller: _controller,
      imageDelegate: MyAppZefyrImageDelegate(),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Enter text Here...',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).buttonColor),
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
            onPressed: checkPostableAndPost,
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
                            side: BorderSide(color: Colors.grey)),
                        onPressed: showCommunities,
                      ),
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
                  borderSide: BorderSide(color: Theme.of(context).buttonColor),
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
      bottomNavigationBar: BottomAppBar(child: createBottomBar()),
    );
  }

  createBottomBar() {
    if (mediaType == 0) {
      return Row(
        children: <Widget>[
          SizedBox(
            width: 15,
          ),
          Text(
            '$noticeText',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () {
              _showImagePicker(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              _showVideoPicker(context);
            },
          )
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          SizedBox(
            width: 15,
          ),
          Text(
            '$noticeText',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                noticeText = "Add media to your post";
                mediaType = 0;
                mediaURL = null;
                media = null;
              });
            },
          )
        ],
      );
    }
  }

  showCommunities() {
    if (checkboxDataList.length == 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(hours: 1),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
            SizedBox(
              width: 15,
            ),
            Text("Populating List...")
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
                                activeColor: Theme.of(context).buttonColor,
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

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  checkPostableAndPost() {
    if (selected == null || selected.length == 0) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('No communities selected.'),
      ));
      return false;
    }
    String title = titleController.text;
    if (title.length == 0) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Title in empty.'),
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
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(hours: 1),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
          SizedBox(
            width: 15,
          ),
          Text("Uploading...")
        ],
      ),
    ));
    addToDatabase();
    return true;
  }

  addToDatabase() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    String key = time.toString();
    final instance = FirebaseFirestore.instance;
    mediaURL = null;
    if (mediaType != 0) await uploadMedia(key);
    List<String> titleSearchList = List();
    String temp = "";
    for (int i = 0; i < titleController.text.length; i++) {
      temp = temp + titleController.text[i];
      titleSearchList.add(temp);
    }
    selected.forEach((community) {
      instance.collection('communities/$community/posts').doc(key).set({
        "creator": username,
        "mediaType": mediaType,
        "mediaUrl": mediaURL,
        "key": key,
        "title": titleController.text,
        "content": jsonEncode(_controller.document),
        "viewers": [],
        "time": time,
        "upvoters": [],
        "downvoters": [],
        "titleSearch": titleSearchList
      }).then((action) {
        debugPrint("successful posting in community!");

        instance.collection('users/$username/posts').doc('posted').update({
          community: FieldValue.arrayUnion([key])
        }).then((value) {
          debugPrint('successful posting in user');
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Upload complete!'),
          ));
          Navigator.pop(context);
        });
      });
    });
  }

  uploadMedia(String key) async {
    StorageUploadTask uploadTask;
    if (mediaType == 1)
      uploadTask =
          FirebaseStorage.instance.ref().child('IMG_$key.jpg').putFile(media);
    else if (mediaType == 2)
      uploadTask =
          FirebaseStorage.instance.ref().child('VID_$key.mp4').putFile(media);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    mediaURL = await storageSnap.ref.getDownloadURL();
    debugPrint("successful media upload!");
    return mediaURL;
  }

  _showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
                  child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('From Gallery'),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          )));
        });
  }

  _imageFromGallery() async {
    final file = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 1024,
        maxWidth: 1024,
        imageQuality: 90);
    if (file == null) return null;
    media = File(file.path);
    setState(() {
      noticeText = "Image selected for upload!";
      mediaType = 1;
    });
  }

  _imageFromCamera() async {
    final file = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 1024,
        maxWidth: 1024,
        imageQuality: 90);
    if (file == null) return null;
    media = File(file.path);
    setState(() {
      noticeText = "Image selected for upload!";
      mediaType = 1;
    });
  }

  _showVideoPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
                  child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('From Gallery'),
                onTap: () {
                  _videoFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Camera'),
                onTap: () {
                  _videoFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          )));
        });
  }

  _videoFromGallery() async {
    final file = await ImagePicker().getVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 30),
    );
    if (file == null) return null;
    media = File(file.path);
    setState(() {
      noticeText = "Video selected for upload!";
      mediaType = 2;
    });
  }

  _videoFromCamera() async {
    final file = await ImagePicker().getVideo(
      source: ImageSource.camera,
      maxDuration: Duration(seconds: 30),
    );
    if (file == null) return null;
    media = File(file.path);
    setState(() {
      noticeText = "Video selected for upload!";
      mediaType = 2;
    });
  }
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

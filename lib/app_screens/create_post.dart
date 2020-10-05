import 'dart:convert';
import 'dart:io';

import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:image/image.dart' as Im;

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
  String photoURI;
  String mediaURL;
  File image;
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
    result = await FirebaseFirestore.instance.collection('communities').get();
    final List<DocumentSnapshot> documents = result.docs;
    int i = 0;
    documents.forEach((element) {
      checkboxDataList.add(new CheckBoxData(
          id: i.toString(), displayId: element.id, checked: false));
      ++i;
    });
    selected = new Set();
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
            Row(
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
                  onPressed: selectVideo,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  showCommunities() {
    if (checkboxDataList.length == 0) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(hours: 1),
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
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(hours: 1),
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
          SizedBox(
            width: 15,
          ),
          new Text("Uploading...")
        ],
      ),
    ));
    addToDatabase();
    return true;
  }

  addToDatabase() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    String key = time.toString();
    bool mediaPresent = (image != null);
    final instance = FirebaseFirestore.instance;
    if (mediaPresent) await uploadImage(key);
    instance.collection('posts').doc(key).set({
      "creator": username,
      "mediaPresent": mediaPresent,
      "mediaUrl": mediaURL,
      "title": titleController.text,
      "content": jsonEncode(_controller.document),
      "upvote": 0,
      "downvote": 0,
      "views": 0,
      "time": time
    }).then((action) {
      debugPrint("success 1!");

      String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

      instance
          .collection("users/" + username + "/posts")
          .doc(key)
          .set({}).then((value) {
        debugPrint("success 3!");
        viewPost();
      });

      selected.forEach((element) {
        instance
            .collection("communities/" + element + "/" + date)
            .doc(key)
            .set({}).then((value) {
          debugPrint("success 2!");
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Upload complete!'),
          ));
        });
      });
    });
  }

  uploadImage(String key) async {
    // await compressImage(key);
    StorageUploadTask uploadTask =
        FirebaseStorage.instance.ref().child('post_$key.jpg').putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    mediaURL = await storageSnap.ref.getDownloadURL();
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
    final file = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 600,
        maxWidth: 600,
        imageQuality: 85);
    if (file == null) return null;
    photoURI = file.uri.toString();
    image = file;
    debugPrint(photoURI);
    setState(() {
      noticeText = "Image selected for upload!";
    });
    return file.uri.toString();
  }

  _imageFromCamera() async {
    final file = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 600,
        maxWidth: 600,
        imageQuality: 85);
    if (file == null) return null;
    photoURI = file.uri.toString();
    image = file;
    debugPrint(photoURI);
    setState(() {
      noticeText = "Image selected for upload!";
    });
    return file.uri.toString();
  }

  selectVideo() async {}

  viewPost() {}

  // compressImage(String key) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   Im.Image imageFile = Im.decodeImage(image.readAsBytesSync());
  //   final compressedImageFile = File('$path/img_$key.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
  //   setState(() {
  //     image = compressedImageFile;
  //   });
  // }
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

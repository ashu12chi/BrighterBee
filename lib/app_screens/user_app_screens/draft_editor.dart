import 'dart:convert';
import 'dart:io';

import 'package:brighter_bee/app_screens/user_app_screens/user_drafts.dart';
import 'package:brighter_bee/helpers/draft_db_helper.dart';
import 'package:brighter_bee/helpers/hotness_calculator.dart';
import 'package:brighter_bee/helpers/path_helper.dart';
import 'package:brighter_bee/helpers/send_verification_notifications.dart';
import 'package:brighter_bee/models/post.dart';
import 'package:brighter_bee/models/post_entry.dart';
import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zefyr/zefyr.dart';

// @author: Nishchal Siddharth Pandey
// Oct 20, 2020
// This will be used for editing drafts

class DraftEditor extends StatefulWidget {
  final Post _post;

  DraftEditor(this._post);

  @override
  _DraftEditorState createState() => _DraftEditorState(_post);
}

class _DraftEditorState extends State<DraftEditor> {
  Post post;
  ZefyrController _controller;
  TextEditingController titleController;
  FocusNode _focusNode;
  User user;
  String displayName;
  String username;
  String noticeText;
  String mediaURL;
  int mediaType = 0; // 0 for none, 1 for image, 2 for video
  File media;
  List<RadioButtonData> radioButtonDataList;
  String community;
  int selectedId = -1;
  List listOfMedia;
  String fileName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ZefyrField editor;

  _DraftEditorState(this.post);

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    displayName = username = user.displayName;
    getNameFromSharedPreference();
    mediaType = 0;
    final document = NotusDocument.fromJson(jsonDecode(post.content));
    _controller = ZefyrController(document);
    titleController = TextEditingController();
    _focusNode = FocusNode();
    noticeText = "Add media to your post";
    radioButtonDataList = [];
    titleController.text = post.title;
    initializeList();
    listOfMedia = post.listOfMedia;
  }

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  initializeList() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .get();
    int i = 0;
    community = post.community;
    result.data()['communityList'].forEach((element) {
      if (element == community) selectedId = i;
      radioButtonDataList.add(RadioButtonData(
          id: i.toString(), displayId: element, selected: false));
      ++i;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    editor = ZefyrField(
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

    _controller.document.changes.listen((NotusChange change) {
      final undoDelta = change.change.invert(change.before);
      final insertDelta = change.change;

      for (final operation in insertDelta.toList()) {
        if (operation.isInsert && operation.hasAttribute('embed')) {
          final embedPath = operation.attributes['embed']['source'] as String;
          print('File: $embedPath');
          String filePath = embedPath.replaceAll(
              new RegExp(
                  r'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/'),
              '');
          filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
          filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
          print('File: $filePath');
          if (!listOfMedia.contains(filePath)) listOfMedia.add(filePath);
        }
      }

      for (final operation in undoDelta.toList()) {
        if (operation.isInsert && operation.hasAttribute('embed')) {
          final embedPath = operation.attributes['embed']['source'] as String;
          print('File: $embedPath');
          String filePath = embedPath.replaceAll(
              new RegExp(
                  r'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/'),
              '');
          filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
          filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
          StorageReference storageReference = FirebaseStorage.instance.ref();
          storageReference.child(filePath).delete().then((_) {
            print('Successfully deleted $filePath storage item');
            listOfMedia.remove(filePath);
          });
        }
      }
    });

    return WillPopScope(
        onWillPop: _handleOnWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              title: Text('Create Post',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              actions: <Widget>[
                FlatButton(
                    child: Text('Save',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey)),
                    onPressed: () async {
                      await saveDraft();
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Drafts()));
                    }),
                FlatButton(
                    child: Text('Post',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor)),
                    onPressed: checkPostableAndPost),
              ]),
          body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user.photoURL),
                      radius: 30.0,
                      backgroundColor: Colors.grey),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(displayName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0)),
                            MaterialButton(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.people),
                                    SizedBox(width: 8),
                                    Text(community == null
                                        ? 'Communities'
                                        : community),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(color: Colors.grey)),
                                onPressed: showCommunities)
                          ]))
                ]),
                TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Enter title here',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).buttonColor)))),
                SizedBox(height: 10),
                Expanded(child: ZefyrScaffold(child: editor))
              ])),
          bottomNavigationBar: BottomAppBar(child: createBottomBar()),
        ));
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
              listOfMedia.remove(fileName);
              setState(() {
                noticeText = "Add media to your post";
                mediaType = 0;
                mediaURL = null;
                media = null;
                fileName = null;
              });
            },
          )
        ],
      );
    }
  }

  showCommunities() {
    if (radioButtonDataList.length == 0) {
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
              return LimitedBox(
                  child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    activeColor: Theme.of(context).accentColor,
                    value: index,
                    groupValue: selectedId,
                    onChanged: (ind) => setState(() {
                      selectedId = ind;
                      community = radioButtonDataList[index].displayId;
                      debugPrint('selected: $community');
                      Navigator.pop(context);
                    }),
                    title: Text(radioButtonDataList[index].displayId),
                  );
                },
                itemCount: radioButtonDataList.length,
              ));
            });
          });
    }
  }

  checkPostableAndPost() {
    if (community == null || community.length == 0) {
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
        content: Text('Title is empty.'),
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
    instance.collection('communities/$community/posts').doc(key).set({
      "creator": username,
      "mediaType": mediaType,
      "mediaUrl": mediaURL,
      "title": titleController.text,
      "content": jsonEncode(_controller.document),
      "viewers": [],
      "time": time,
      "upvoters": [],
      "weight": 0,
      "downvoters": [],
      "downvotes": 0,
      "upvotes": 0,
      "views": 0,
      "titleSearch": titleSearchList,
      "commentCount": 0,
      "lastModified": time,
      "listOfMedia": listOfMedia,
      "isVerified": false,
      'reports': 0,
      'reporters': [],
      "community": community,
    }).then((action) async {
      debugPrint("successful posting in community!");

      await sendVerificationNotifications(community, key, username);
      await updateHotness(community, key);
      await deletePostFromDb(post.time);

      debugPrint('successful posting in user');
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Upload complete!'),
      ));

      await instance.collection('users/$username/posts').doc('posted').update({
        community: FieldValue.arrayUnion([key])
      });
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Drafts()));
    });
  }

  uploadMedia(String key) async {
    StorageUploadTask uploadTask;
    fileName = getFileName(media);
    if (mediaType == 1) {
      fileName = 'posts/IMG_$key$fileName';
      uploadTask =
          FirebaseStorage.instance.ref().child(fileName).putFile(media);
    } else if (mediaType == 2) {
      fileName = 'posts/VID_$key$fileName';
      uploadTask =
          FirebaseStorage.instance.ref().child(fileName).putFile(media);
    }
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    mediaURL = await storageSnap.ref.getDownloadURL();
    debugPrint("successful media upload!");
    if (!listOfMedia.contains(fileName)) listOfMedia.add(fileName);
    return mediaURL;
  }

  _showImagePicker(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
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
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    if (file == null) return null;
    media = File(file.path);
    debugPrint(file.path);
    setState(() {
      noticeText = "Image selected for upload!";
      mediaType = 1;
    });
  }

  _imageFromCamera() async {
    final file = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 2160,
        maxWidth: 2160,
        imageQuality: 90);
    if (file == null) return null;
    media = File(file.path);
    debugPrint(media.path);
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

  getNameFromSharedPreference() async {
    SharedPreferences.getInstance().then((value) => {
          setDisplayName(value.getString('fullName')),
        });
  }

  setDisplayName(String str) {
    setState(() {
      displayName = str;
    });
  }

  Future<bool> _handleOnWillPop() {
    debugPrint('Popped');
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
                'Do you want to save this post as draft?\n\nWarning: separately attached media will NOT be saved.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'No',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  if (community == null || community.length == 0) {
                    _scaffoldKey.currentState.hideCurrentSnackBar();
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('No communities selected.'),
                    ));
                    Navigator.of(context).pop();
                    return false;
                  }
                  String title = titleController.text;
                  if (title.length == 0) {
                    _scaffoldKey.currentState.hideCurrentSnackBar();
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Title is empty.'),
                    ));
                    Navigator.of(context).pop();
                    return false;
                  }
                  String content = jsonEncode(_controller.document);
                  if (content.length == 0) {
                    _scaffoldKey.currentState.hideCurrentSnackBar();
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('No text written.'),
                    ));
                    Navigator.of(context).pop();
                    return false;
                  }
                  await saveDraft();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Drafts()));
                },
                /*Navigator.of(context).pop(true)*/
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  saveDraft() async {
    int time = post.time;
    Post newPost = Post(
        creator: username,
        isVerified: false,
        community: community,
        time: time,
        commentCount: 0,
        content: jsonEncode(_controller.document),
        downvoters: [],
        downvotes: 0,
        lastModified: time,
        listOfMedia: listOfMedia,
        mediaType: 0,
        mediaUrl: mediaURL,
        title: titleController.text,
        titleSearch: [],
        upvoters: [],
        upvotes: 0,
        viewers: [],
        views: 0);
    debugPrint(jsonEncode(newPost.toJson()));
    PostEntry postEntry =
        PostEntry(text: jsonEncode(newPost.toJson()), time: time);
    await insertPostInDb(postEntry);
  }
}

class RadioButtonData {
  String id;
  String displayId;
  bool selected;

  RadioButtonData({
    this.id,
    this.displayId,
    this.selected,
  });

  factory RadioButtonData.fromJson(Map<String, dynamic> json) =>
      RadioButtonData(
        id: json["id"] == null ? null : json["id"],
        displayId: json["displayId"] == null ? null : json["displayId"],
        selected: json["selected"] == null ? null : json["selected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "displayId": displayId == null ? null : displayId,
        "selected": selected == null ? null : selected,
      };
}

import 'dart:convert';
import 'dart:io';

import 'package:brighter_bee/helpers/path_helper.dart';
import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';

/*
* @author: Nishchal Siddharth Pandey
* 1 October, 2020
* This file has UI and code for creating a new post.
*/

class EditPost extends StatefulWidget {
  String _community;
  String _postKey;
  String _username;
  String _displayName;
  String _mediaURL;
  int _mediaType;
  List _listOfMedia;
  String _oldTitle;
  String _content;

  EditPost(
      this._community,
      this._postKey,
      this._username,
      this._displayName,
      this._mediaURL,
      this._mediaType,
      this._listOfMedia,
      this._oldTitle,
      this._content);

  @override
  _EditPostState createState() => _EditPostState(
      _community,
      _postKey,
      _username,
      _displayName,
      _mediaURL,
      _mediaType,
      _listOfMedia,
      _oldTitle,
      _content);
}

class _EditPostState extends State<EditPost> {
  ZefyrController _controller;
  TextEditingController titleController;
  FocusNode _focusNode;
  User user;
  String community;
  String postKey;
  String displayName;
  String username;
  String noticeText;
  String mediaURL;
  int mediaType = 0; // 0 for none, 1 for image, 2 for video
  File media;
  List listOfMedia;
  String oldTitle;
  String fileName;
  String content;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ZefyrField editor;
  NotusDocument document;

  _EditPostState(
      this.community,
      this.postKey,
      this.username,
      this.displayName,
      this.mediaURL,
      this.mediaType,
      this.listOfMedia,
      this.oldTitle,
      this.content);

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (mediaType == 0)
      noticeText = "Add media to your post";
    else if (mediaType == 1)
      noticeText = "Image selected for upload!";
    else
      noticeText = "Video selected for upload!";
    document = NotusDocument.fromJson(jsonDecode(content));
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    titleController = TextEditingController();
    titleController.text = oldTitle;
  }

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (username != user.displayName) {
      return Scaffold(
          body: Center(
              child: Text('!! You are not authorised to edit this post !!',
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).errorColor),
                  textAlign: TextAlign.center)));
    }
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Post', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          FlatButton(
            child: Text('Update',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor)),
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
                  backgroundImage: CachedNetworkImageProvider(user.photoURL),
                  radius: 20.0,
                  backgroundColor: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        displayName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Text(community)
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
              if (mediaURL != null) {
                String filePath1 = mediaURL.replaceAll(
                    new RegExp(
                        r'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/'),
                    '');
                filePath1 = filePath1.replaceAll(new RegExp(r'%2F'), '/');
                filePath1 = filePath1.replaceAll(new RegExp(r'(\?alt).*'), '');
                StorageReference storageReference =
                    FirebaseStorage.instance.ref();
                storageReference.child(filePath1).delete().then((_) {
                  print('Successfully deleted $filePath1 storage item');
                  listOfMedia.remove(filePath1);
                });
              } else {
                listOfMedia.remove(fileName);
              }
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

  checkPostableAndPost() {
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
          Text("Updating...")
        ],
      ),
    ));
    addToDatabase();
    return true;
  }

  addToDatabase() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    final instance = FirebaseFirestore.instance;
    if (mediaURL == null && mediaType != 0) await uploadMedia(postKey);
    List<String> titleSearchList = List();
    String titleInLower = titleController.text.toLowerCase();
    String temp = "";
    for (int i = 0; i < titleInLower.length; i++) {
      temp = temp + titleInLower[i];
      titleSearchList.add(temp);
    }
    instance.collection('communities/$community/posts').doc(postKey).update({
      "mediaType": mediaType,
      "mediaUrl": mediaURL,
      "title": titleController.text,
      "content": jsonEncode(_controller.document),
      "titleSearch": titleSearchList,
      "lastModified": time,
      "listOfMedia": listOfMedia,
    }).then((action) async {
      debugPrint("successful posting in community!");

      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Upload complete!'),
      ));
      Navigator.pop(context);
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
}

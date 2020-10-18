import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String username;
  String photoUrl;
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  int _radioPrivacy = 0;
  int _radioVisibility = 0;
  int _radioPosts = 0;
  int _radioVerification = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String noticeText = "Add Cover Photo";
  int mediaType = 0; // 0 for none, 1 for image, 2 for video
  File media;

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioPrivacy = value;
      debugPrint('value 1: $_radioPrivacy');
    });
  }

  void _handleRadioValueChange2(int value) {
    setState(() {
      _radioVisibility = value;
      debugPrint('value 2: $_radioVisibility');
    });
  }

  void _handleRadioValueChange3(int value) {
    setState(() {
      _radioPosts = value;
      debugPrint('value 3: $_radioPosts');
    });
  }

  void _handleRadioValueChange4(int value) {
    setState(() {
      _radioVerification = value;
      debugPrint('value 4: $_radioVerification');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Create Community',
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name your community',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).buttonColor),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: aboutController,
                decoration: InputDecoration(
                  hintText: 'Write description of your community',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).buttonColor),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Cover Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          mediaType == 0
              ? FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add_box,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          noticeText,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    _showImagePicker(context);
                  },
                )
              : Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      '$noticeText',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          noticeText = "Add Cover Photo";
                          mediaType = 0;
                          photoUrl = null;
                          media = null;
                        });
                      },
                    )
                  ],
                ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Privacy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: _radioPrivacy,
                onChanged: _handleRadioValueChange1,
                activeColor: Theme.of(context).accentColor,
              ),
              Row(
                children: [
                  Icon(Icons.public),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: new Text(
                      'Public',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              new Radio(
                value: 1,
                groupValue: _radioPrivacy,
                onChanged: _handleRadioValueChange1,
                activeColor: Theme.of(context).accentColor,
              ),
              Row(
                children: [
                  Icon(Icons.lock),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: new Text(
                      'Private',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Visibility',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: _radioVisibility,
                onChanged: _handleRadioValueChange2,
                activeColor: Theme.of(context).accentColor,
              ),
              Row(
                children: [
                  Icon(Icons.visibility),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: new Text(
                      'Visible',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              new Radio(
                value: 1,
                groupValue: _radioVisibility,
                onChanged: _handleRadioValueChange2,
                activeColor: Theme.of(context).accentColor,
              ),
              Row(
                children: [
                  Icon(Icons.visibility_off),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: new Text(
                      'Hidden',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Posts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: _radioPosts,
                onChanged: _handleRadioValueChange3,
                activeColor: Theme.of(context).accentColor,
              ),
              Row(
                children: [
                  Icon(Icons.person),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: new Text(
                      'Admin',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              new Radio(
                value: 1,
                groupValue: _radioPosts,
                onChanged: _handleRadioValueChange3,
                activeColor: Theme.of(context).accentColor,
              ),
              Row(
                children: [
                  Icon(Icons.people),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: new Text(
                      'Everyone',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Verification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: _radioVerification,
                onChanged: _handleRadioValueChange4,
                activeColor: Theme.of(context).accentColor,
              ),
              Row(
                children: [
                  Icon(Icons.person),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: new Text(
                      'Admin',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              new Radio(
                value: 1,
                groupValue: _radioVerification,
                onChanged: _handleRadioValueChange4,
                activeColor: Theme.of(context).accentColor,
              ),
              Row(
                children: [
                  Icon(Icons.people),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: new Text(
                      'Everyone',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: createCommunity,
              child: Text('Create Community',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 18)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Theme.of(context).accentColor)),
            ),
          )
        ],
      ),
    );
  }

  createCommunity() async {
    String commName = nameController.text;
    if (commName.isEmpty || RegExp("[^a-z^A-Z^0-9]+").hasMatch(commName) || commName.length < 3 || commName.length > 25) {
      await showAlertDialog(context);
      return;
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
    try {
      username = FirebaseAuth.instance.currentUser.displayName;
      FirebaseFirestore instance = FirebaseFirestore.instance;

      final snapShot =
          await instance.collection('communities').doc(commName).get();
      if (snapShot != null && snapShot.exists) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        print("Failed, community name exists.");
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Community name already exists. Try different.'),
        ));
        return;
      }

      String about = aboutController.text;
      int time = DateTime.now().millisecondsSinceEpoch;

      if (mediaType == 1) await uploadMedia(commName);

      List<String> nameSearchList = List();
      String temp = "";
      for (int i = 0; i < commName.length; i++) {
        temp = temp + commName[i];
        nameSearchList.add(temp);
      }

      instance.collection('communities').doc(commName).set({
        'name': commName,
        'about': about,
        'photoUrl': photoUrl,
        'privacy': _radioPrivacy,
        'visibility': _radioVisibility,
        'posts': _radioPosts,
        'verification': _radioVerification,
        'nameSearch': nameSearchList,
        'creationTime': time,
      });

      instance.collection('communities/$commName/admins').doc(username).set({});

      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Community creation done.'),
      ));
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Community creation failed.'),
      ));
    }
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

  uploadMedia(String key) async {
    StorageUploadTask uploadTask;
    if (mediaType == 1)
      uploadTask = FirebaseStorage.instance
          .ref()
          .child('coverPhotos/$key.jpg')
          .putFile(media);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    photoUrl = await storageSnap.ref.getDownloadURL();
    debugPrint("Successful media upload!");
    return photoUrl;
  }

  showAlertDialog(BuildContext context) async {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Community name should be alphanumeric"),
      content: Text("No special characters or spaces allowed. Length should be between 3 and 25 (inclusive)"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

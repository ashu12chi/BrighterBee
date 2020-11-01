import 'dart:io';

import 'package:brighter_bee/widgets/edit_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// @author: Ashutosh Chitranshi
// Oct 17, 2020
// This will be used for editing details of a community

class EditCommunityDetails extends StatefulWidget {
  final community;

  EditCommunityDetails(this.community);

  @override
  _EditCommunityDetailsState createState() =>
      _EditCommunityDetailsState(community);
}

class _EditCommunityDetailsState extends State<EditCommunityDetails> {
  final community;
  int _radioPrivacy = -1;
  int _radioVisibility = -1;
  int _radioPosts = -1;
  int _radioVerification = -1;
  String about;
  String mediaUrl;

  File _imageFile;
  String url;

  _EditCommunityDetailsState(this.community);

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

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = community + DateTime.now().toIso8601String() + '.jpg';
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('coverPhotos/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    url = await taskSnapshot.ref.getDownloadURL();
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('communities')
              .doc(community)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            if (about == null) about = snapshot.data['about'];
            if (mediaUrl == null) mediaUrl = snapshot.data['photoUrl'];
            if (_radioPrivacy == -1) _radioPrivacy = snapshot.data['privacy'];
            if (_radioPosts == -1) _radioPosts = snapshot.data['posts'];
            if (_radioVisibility == -1)
              _radioVisibility = snapshot.data['visibility'];
            if (_radioVerification == -1)
              _radioVerification = snapshot.data['verification'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  Text(
                    'Cover Photo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _imageFile == null
                              ? Image.network(
                                  snapshot.data['photoUrl'],
                                  fit: BoxFit.fill,
                                  height: 200,
                                )
                              : Image.file(_imageFile),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Container(
                      height: 1.0,
                      width: double.infinity,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'About',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditText(about)))
                              .then((value) {
                            //print(value);
                            setState(() {
                              about = value;
                              print(about);
                            });
                          });
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 10.0, right: 10, bottom: 5),
                    child: Center(
                        child: Text(
                      about,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Container(
                      height: 1.0,
                      width: double.infinity,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Text(
                    'Privacy',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Container(
                      height: 1.0,
                      width: double.infinity,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Text(
                    'Visibility',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Container(
                      height: 1.0,
                      width: double.infinity,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Text(
                    'Posts',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Container(
                      height: 1.0,
                      width: double.infinity,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Text(
                    'Verification',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Container(
                      height: 1.0,
                      width: double.infinity,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text("Save Details"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey)),
                      onPressed: () async {
                        if (_imageFile != null) {
                          await uploadImageToFirebase(context);
                          await FirebaseFirestore.instance
                              .collection('communities')
                              .doc(community)
                              .update({
                            'about': about,
                            'photoUrl': url,
                            'privacy': _radioPrivacy,
                            'verification': _radioVerification,
                            'posts': _radioPosts,
                            'visibility': _radioVisibility
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection('communities')
                              .doc(community)
                              .update({
                            'about': about,
                            'privacy': _radioPrivacy,
                            'verification': _radioVerification,
                            'posts': _radioPosts,
                            'visibility': _radioVisibility
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call.dart';

/*
* @author: Ashutosh Chitranshi
* This file will be used to Start new live stream.
* Creator of stream needs to provide title and image file for the stream
*/

class StartLive extends StatefulWidget {
  final String community;

  StartLive(this.community);

  @override
  _StartLiveState createState() => _StartLiveState(community);
}

class _StartLiveState extends State<StartLive> {
  String community;
  File _imageFile;
  String url;
  TextEditingController _controller;

  _StartLiveState(this.community);

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = DateTime.now().toIso8601String() + '.jpg';
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('liveStream/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    url = await taskSnapshot.ref.getDownloadURL();
    print(url);
  }

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start new Live',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 40, left: 8, right: 8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter title of your stream',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).buttonColor),
                  ),
                ),
              )),
          InkWell(
            onTap: () {
              print('ashu12');
              pickImage();
            },
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
              width: 200,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: _imageFile == null
                        ? AssetImage('assets/empty.jpg')
                        : AssetImage(_imageFile.path),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top: 16.0),
              alignment: Alignment.center,
              child: FlatButton(
                child: Text("Start Streaming"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey)),
                onPressed: () async {
                  print('101 : clicked');
                  if (_imageFile == null) {
                    Fluttertoast.showToast(
                        msg: 'Image not selected',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1);
                  }
                  if (_controller.text.length == 0) {
                    Fluttertoast.showToast(
                        msg: "Title can't be empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1);
                  }
                  print('118 clicked');
                  Fluttertoast.showToast(
                      msg: "Wait...Live is about to start",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1);
                  await uploadImageToFirebase(context);
                  await _handleCameraAndMic();
                  String name = DateTime.now().toIso8601String();
                  await FirebaseFirestore.instance
                      .collection('communities')
                      .doc(community)
                      .collection('live')
                      .doc(name)
                      .set({
                    'title': _controller.text,
                    'photoUrl': url,
                    'upvotes': 0,
                    'downvotes': 0,
                    'upvoters': [],
                    'downvoters': []
                  });
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallPage(
                        channelName: name,
                        role: ClientRole.Broadcaster,
                        name: _controller.text,
                        community: community,
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await [Permission.microphone, Permission.camera].request();
  }
}

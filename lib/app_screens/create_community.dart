import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text(
          'Create Community',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          FlatButton(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add_box,
                  size: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Add Cover Photo',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            onPressed: () {},
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

  createCommunity() {
    username = FirebaseAuth.instance.currentUser.displayName;
    String commName = nameController.text;
    String about = aboutController.text;
    int time = DateTime.now().millisecondsSinceEpoch;
    List<String> nameSearchList = List();
    String temp = "";
    for (int i = 0; i < commName.length; i++) {
      temp = temp + commName[i];
      nameSearchList.add(temp);
    }

    FirebaseFirestore instance = FirebaseFirestore.instance;
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
  }
}

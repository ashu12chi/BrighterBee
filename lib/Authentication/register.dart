import 'dart:io';

import 'package:brighter_bee/app_screens/feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'database.dart';

String abc = "abcd";
String url;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameText = TextEditingController();
  final TextEditingController _mottoText = TextEditingController();
  bool _passwordVisible;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _imageFile;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
    url = await taskSnapshot.ref.getDownloadURL();
    print(url);
    String anu = abc;
    print(anu);
  }

  bool _isSuccess;
  String _userEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameText.dispose();
    _mottoText.dispose();
    _displayName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Create an account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200, height: 200,
                    // height: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: _imageFile != null
                          ? Image.file(_imageFile)
                          : FlatButton(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                        ),
                        onPressed: pickImage,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _displayName,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Full Name *',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme
                            .of(context)
                            .buttonColor),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Enter valid name';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email *',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme
                            .of(context)
                            .buttonColor),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty ||
                          !RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) return 'Enter valid email';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme
                            .of(context)
                            .buttonColor),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 8)
                        return 'Password should have more than 8 characters';
                      return null;
                    },
                    obscureText: !_passwordVisible,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameText,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Username *',
                      prefixIcon: Icon(
                        Icons.verified_user,
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme
                            .of(context)
                            .buttonColor),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.contains('[^A-Za-z0-9]') ||
                          value.length < 3)
                        return 'Enter valid username of length more than 3';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _mottoText,
                    decoration: InputDecoration(
                      labelText: 'Your motto',
                      prefixIcon: Icon(
                        Icons.speaker_notes,
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme
                            .of(context)
                            .buttonColor),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    alignment: Alignment.center,
                    child: FlatButton(
                        child: Text("Register"),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(hours: 1),
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text("Registering...")
                                ],
                              ),
                            ));
                            _registerAccount(context);
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: OutlineButton(
              child: Text("upload"),
              onPressed: () {
                uploadImageToFirebase(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _registerAccount(BuildContext context) async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    await DatabaseService(uid: user.uid).updateUserData(_emailController.text,
        _displayName.text, _usernameText.text, url, _mottoText.text);

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      _scaffoldKey.currentState.hideCurrentSnackBar();
      print("Database updated...");
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Registration complete!'),
      ));
      await user.updateProfile(displayName: _displayName.text, photoURL: url);
      final user1 = _auth.currentUser;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              Feed(
                user: user1,
              )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              Feed(
                user: user1,
              )));
    } else {
      _isSuccess = false;
    }
  }
}

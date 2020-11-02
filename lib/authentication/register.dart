import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'upload_user_database.dart';

/*
* @author: Anushka Srivastava
* 19 October, 2020
* This file has code for registering user
*/

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
  final TextEditingController _currentCityText = TextEditingController();
  final TextEditingController _hometownText = TextEditingController();
  final TextEditingController _websiteText = TextEditingController();
  bool _passwordVisible;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _imageFile;
  String url;

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
    String fileName = _usernameText.text + '.jpg';
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilePics/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    url = await taskSnapshot.ref.getDownloadURL();
    print(url);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameText.dispose();
    _mottoText.dispose();
    _displayName.dispose();
    _websiteText.dispose();
    _hometownText.dispose();
    _currentCityText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Create an account',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                            BorderSide(color: Theme.of(context).buttonColor),
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
                            BorderSide(color: Theme.of(context).buttonColor),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
                            BorderSide(color: Theme.of(context).buttonColor),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 8)
                        return 'Password should have atleast 8 characters';
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
                            BorderSide(color: Theme.of(context).buttonColor),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty ||
                          RegExp("[^a-z^A-Z^0-9]+").hasMatch(value) ||
                          value.length < 3 ||
                          value.length > 20)
                        return 'Enter valid username of length atleast 3 and atmost 20';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _currentCityText,
                    decoration: InputDecoration(
                      labelText: 'Current city',
                      prefixIcon: Icon(
                        Icons.home,
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).buttonColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _hometownText,
                    decoration: InputDecoration(
                      labelText: 'Hometown',
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).buttonColor),
                      ),
                    ),
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
                            BorderSide(color: Theme.of(context).buttonColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _websiteText,
                    decoration: InputDecoration(
                      labelText: 'Website',
                      prefixIcon: Icon(
                        Icons.link,
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).buttonColor),
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

  void _registerAccount(BuildContext context) async {
    try {
      FirebaseFirestore instance = FirebaseFirestore.instance;
      final snapShot =
          await instance.collection('users').doc(_usernameText.text).get();
      if (snapShot != null && snapShot.exists) {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        print("Failed, username exists.");
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Username already exists. Try different.'),
        ));
        return;
      }

      await uploadImageToFirebase(context);
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      await DatabaseService(uid: user.uid).updateUserData(
          _emailController.text,
          _displayName.text,
          _usernameText.text,
          url,
          _mottoText.text,
          _websiteText.text,
          _hometownText.text,
          _currentCityText.text);

      if (user != null) {
        if (!user.emailVerified) await user.sendEmailVerification();
        _scaffoldKey.currentState.hideCurrentSnackBar();
        print("Database updated...");
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Registration complete!'),
        ));
        await user.updateProfile(
            displayName: _usernameText.text, photoURL: url);
        await _auth.signOut();
        await showAlertDialog(context);
        Navigator.of(context).pop();
      } else {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        print("Failed...");
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Registration failed'),
        ));
      }
    } catch (e) {
      print('Exception occurred' + e.toString());
      _scaffoldKey.currentState.hideCurrentSnackBar();
      print("Failed...");
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content:
            Text('Registration failed. Email ID or username already exists!'),
      ));
    }
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
      title: Text("Email verification link sent"),
      content: Text("Please verify your email to finish account set-up."),
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

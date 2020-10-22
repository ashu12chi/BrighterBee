/*
* @author: Nishchal Siddharth Pandey
* 21 October, 2020. 11:57 PM IST
*
* This will help in resetting user login password.
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Reset password',
              style: TextStyle(fontWeight: FontWeight.bold))),
      key: _scaffoldKey,
      body: Builder(builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            withEmail(),
          ],
        );
      }),
    );
  }

  Widget withEmail() {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: const Text(
                          'Enter your email and press continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        alignment: Alignment.center,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).buttonColor),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) return 'Enter valid email';
                          return null;
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16.0),
                        alignment: Alignment.center,
                        child: FlatButton(
                            child: Text("Continue"),
                            onPressed: () async {
                              await _auth.sendPasswordResetEmail(
                                  email: _emailController.text);
                              await showAlertDialog(context);
                              Navigator.of(context).pop();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.grey))),
                      )
                    ]))));
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
      title: Text("Password reset link sent"),
      content: Text(
          "Please follow the instructions in email to reset your password."),
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

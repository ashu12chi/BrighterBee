import 'package:flutter/material.dart';

class VerifyUser extends StatefulWidget {
  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(),
    );
  }
}

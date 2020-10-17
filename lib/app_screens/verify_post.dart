import 'package:flutter/material.dart';

class VerifyPost extends StatefulWidget {
  @override
  _VerifyPostState createState() => _VerifyPostState();
}

class _VerifyPostState extends State<VerifyPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(),
    );
  }
}

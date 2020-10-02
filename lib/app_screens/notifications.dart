import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
          ),
        ],
      ),
    );
  }
}

import 'package:brighter_bee/app_screens/communities.dart';
import 'package:brighter_bee/app_screens/extra.dart';
import 'package:brighter_bee/app_screens/home.dart';
import 'package:brighter_bee/app_screens/notifications.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3, color: Colors.blue)),
          tabs: <Widget>[
            new Tab(
              icon: Icon(
                Icons.home,
                color: Colors.black54,
              ),
            ),
            new Tab(
              icon: Icon(Icons.people, color: Colors.black54),
            ),
            new Tab(
              icon: Icon(Icons.notifications, color: Colors.black54),
            ),
            new Tab(
              icon: Icon(Icons.view_headline, color: Colors.black54),
            )
          ],
        ),
        title: Text(
          'BrighterBee',
          style: TextStyle(
              fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      body: TabBarView(
        children: <Widget>[Home(), Communities(), Notifications(), Extra()],
        controller: _controller,
      ),
    );
  }
}

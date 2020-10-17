import 'dart:async';

import 'package:brighter_bee/app_screens/communities.dart';
import 'package:brighter_bee/app_screens/extra.dart';
import 'package:brighter_bee/app_screens/home.dart';
import 'package:brighter_bee/app_screens/notifications.dart';
import 'package:brighter_bee/app_screens/post_search.dart';
import 'package:brighter_bee/app_screens/post_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  final User user;

  const Feed({Key key, this.user}) : super(key: key);

  @override
  _FeedState createState() => _FeedState(user);
}

class _FeedState extends State<Feed> with TickerProviderStateMixin {
  TabController _controller;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  User user;
  String username;

  _FeedState(this.user) {
    username = user.displayName;
  }

  void initState() {
    super.initState();
    // _firebaseMessaging.getToken().then((value) => print("Dev token: $value"));
    _controller = TabController(initialIndex: 0, length: 4, vsync: this);
    _controller.addListener(_handleTabSelection);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {});
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );

    //Needed by iOS only
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    //Getting the token from FCM
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {});
    });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Got: $username");
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            iconSize: 30.0,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostSearch()));
            },
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicator: UnderlineTabIndicator(
              borderSide:
                  BorderSide(width: 3, color: Theme.of(context).accentColor)),
          tabs: <Widget>[
            new Tab(
              icon: Icon(
                Icons.home,
              ),
            ),
            new Tab(
              icon: Icon(
                Icons.people,
              ),
            ),
            new Tab(
              icon: Icon(
                Icons.notifications,
              ),
            ),
            new Tab(
              icon: Icon(
                Icons.view_headline,
              ),
            )
          ],
        ),
        title: Text(
          'BrighterBee',
          style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
      body: TabBarView(
        children: <Widget>[Home(), Communities(), Notifications(), Extra()],
        controller: _controller,
      ),
    );
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final MessageBean item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }

  final Map<String, MessageBean> _items = <String, MessageBean>{};

  MessageBean _itemForMessage(Map<String, dynamic> message) {
    //If the message['data'] is non-null, we will return its value, else return map message object
    final dynamic data = message['data'] ?? message;
    final String itemId = data['id'];
    final MessageBean item = _items.putIfAbsent(
        itemId, () => MessageBean(itemId: itemId))
      ..status = data['status'];
    return item;
  }
}

class MessageBean {
  MessageBean({this.itemId});

  final String itemId;

  StreamController<MessageBean> _controller =
      StreamController<MessageBean>.broadcast();

  Stream<MessageBean> get onChanged => _controller.stream;

  String _status;

  String get status => _status;

  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};

  Route<void> get route {
    final String routeName = '/detail/$itemId';
    print('oct 15');
    print(routeName);
    String community = itemId.substring(0, itemId.indexOf(','));
    String temp = routeName.substring(routeName.indexOf(',') + 1);
    String postID = temp.substring(0, temp.indexOf(','));
    temp = temp.substring(temp.indexOf(',') + 1);
    String creator = temp;
    print(community);
    print(postID);
    print(creator);
    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => PostUI(community, postID, creator),
      ),
    );
  }
}

import 'package:brighter_bee/app_screens/community_home.dart';
import 'package:brighter_bee/app_screens/create_community.dart';
import 'package:flutter/material.dart';

import 'community_search.dart';
import 'discover_community.dart';

class Communities extends StatefulWidget {
  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Communities', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            iconSize: 30.0,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CommunitySearch()));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.people,
                    ),
                    Text(
                      'Added',
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey)),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      // TODO: Change this
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext) => DiscoverCommunity()));
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.explore,
                    ),
                    Text(
                      'Discover',
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey)),
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.add_circle,
                    ),
                    Text(
                      'Create',
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateGroup()));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey)),
              )
            ],
          )
          // TODO : Future builder here for displaying communities
        ],
      ),
    );
  }
}

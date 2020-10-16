import 'package:brighter_bee/app_screens/community_home.dart';
import 'package:flutter/material.dart';

import 'community_search.dart';

class Communities extends StatefulWidget {
  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Communities',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search,color: Colors.grey,),
            iconSize: 30.0,
            onPressed: (){
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
                      color: Colors.black,
                    ),
                    Text(
                      'Added',
                      style: TextStyle(color: Colors.black),
                    )
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
                      Icons.explore,
                      color: Colors.black,
                    ),
                    Text(
                      'Discover',
                      style: TextStyle(color: Colors.black),
                    )
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
                      color: Colors.black,
                    ),
                    Text(
                      'Create',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
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

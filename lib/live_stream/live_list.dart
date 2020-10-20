import 'package:brighter_bee/live_stream/start_live.dart';
import 'package:flutter/material.dart';

class LiveList extends StatefulWidget {
  String community;
  LiveList(this.community);
  @override
  _LiveListState createState() => _LiveListState(community);
}

class _LiveListState extends State<LiveList> {
  String community;
  _LiveListState(this.community);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Streaming'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartLive(community)));
            },
          )
        ],
      ),
      body: ListView(

      ),
    );
  }
}
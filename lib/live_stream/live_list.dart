import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:brighter_bee/live_stream/start_live.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call.dart';

// @author: Ashutosh Chitranshi
// This will be used for displaying currently active live streams and navigation to them

class LiveList extends StatefulWidget {
  final String community;
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('communities').doc(community).collection('live').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index) {
              DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
              print(documentSnapshot['photoUrl']);
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallPage(
                            channelName: documentSnapshot.id,
                            role: ClientRole.Audience,
                            name: documentSnapshot['title'],
                            community: community,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 20),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: NetworkImage(documentSnapshot['photoUrl']),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Text(documentSnapshot['title'],style: TextStyle(fontSize: 20),)
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          );
        }
      ),
    );
  }
  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
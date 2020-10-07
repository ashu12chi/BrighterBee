import 'dart:convert';
import 'dart:io';

import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class PostUI extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostUI> {
  ZefyrController _controller;
  FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('communities').document('Computing').collection('posts').document('posted').collection('2020-10-07').document('1602068390865').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return Text('Loading data.. Please Wait..');
            print(snapshot.data);
            String name = snapshot.data['creator'];
            int mediatype = snapshot.data['mediaType'];
            int views = snapshot.data['views'];
            int downvotes = snapshot.data['downvotes'];
            int upvotes = snapshot.data['upvotes'];
            String title = snapshot.data['title'];
            String mediaUrl = 'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/thumbnails%2Fthumbnail_video_default.png?alt=media&token=110cba28-6dd5-4656-8eca-cbefe9cce925';
            if(mediatype == 1)
              mediaUrl = snapshot.data['mediaUrl'];
            int timestamp = 1602068390865;
            var date = new DateTime.fromMillisecondsSinceEpoch(timestamp).toString().substring(0,16);
            print(name);
            print(mediatype);
            print(date);
            print(views);
            print(mediatype);
            print(mediaUrl);
            print(title);
            print(upvotes);
            print(downvotes);
            String content = snapshot.data['content'];
            print(jsonDecode(content));
            final document1 = NotusDocument.fromJson(jsonDecode(content));
            print(document1);
            final editor = new ZefyrEditor(
              focusNode: _focusNode,
              controller: ZefyrController(document1),
              imageDelegate: MyAppZefyrImageDelegate(),
              mode: ZefyrMode.view,
              physics: NeverScrollableScrollPhysics(),
            );
            //return Text('Loading data.. Please Wait..');
//            print(snapshot.data['creator']);
//            String name = snapshot.data['creator'];
//            String community = snapshot.data['time'].toString();
//            int downvote = snapshot.data['downvote'];
//            int upvote = snapshot.data['upvote'];
//            String title = snapshot.data['title'];
//            int views = snapshot.data['views'];
//            int mediatype = snapshot.data['mediaType'];
//            String mediaUrl = null;
//            if(mediatype > 0)
//              mediaUrl = snapshot.data['mediaUrl'];
//            print(mediaUrl);
//            String content = snapshot.data['content'];
//            //print(jsonDecode(content));
//            final document1 = NotusDocument.fromJson(jsonDecode(content));
//            //print(document1);
//            final editor = new ZefyrEditor(
//              focusNode: _focusNode,
//              controller: ZefyrController(document1),
//              imageDelegate: MyAppZefyrImageDelegate(),
//              mode: ZefyrMode.view,
//            );
//            int timestamp = 1601924732454;
//            var date = new DateTime.fromMillisecondsSinceEpoch(timestamp).toString().substring(0,16);
//            print(date);
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').document(name).snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData)
                    return Text('Loading data.. Please Wait..');
                  String name1 = snapshot.data['name'];
                  //return Text('Loading data.. Please Wait..');
                  return Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 8.0, right: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Card (
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.grey,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(name1,
                                                    style: TextStyle( fontSize: 16.0)),
                                                Icon(Icons.arrow_right),
                                                Text('Computing')
                                              ],
                                            ),
                                            Text(
                                              date,
                                              style: TextStyle(color: Colors.grey),
                                            )
                                          ],
                                        )),
                                    Expanded (
                                      child: IconButton(
                                        icon: Icon(Icons.more_horiz),
                                        alignment: Alignment.topRight,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(
                                  height: 100,
                                  child: ZefyrScaffold(
                                    child: editor,
                                  ),
                                ),
                                mediatype == 0?Container():Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Image.network(mediaUrl,fit:BoxFit.fill,height: 200,),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      upvotes.toString(),
                                      style: TextStyle( fontSize: 15),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_upward),
                                    ),
                                    Text(
                                      downvotes.toString(),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_downward),
                                    ),
                                    Text(
                                      views.toString(),
                                      style: TextStyle( fontSize: 15),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                                      child: Text(
                                        '6',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    FlatButton(
                                      child: Text(
                                        '  Comments  ',
                                        style: TextStyle(color: Colors.grey, fontSize: 15),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          side: BorderSide(color: Colors.black)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            );
          }
      ),
    );
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("ashu12_chi\nThis is a sample post\n");
    return NotusDocument.fromDelta(delta);
  }

}

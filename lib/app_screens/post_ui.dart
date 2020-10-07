import 'dart:convert';

import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:zefyr/zefyr.dart';

class PostUI extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostUI> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('communities/Computing/posts/posted/2020-10-07')
              .doc('1602068390865')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Loading data... Please Wait...')
                ],
              );
            ;
            print(snapshot.data['creator']);
            String community = 'Computing';
            String name = snapshot.data['creator'];
            var time = snapshot.data['time'];
            int upvotes = snapshot.data['upvotes'];
            int downvotes = snapshot.data['downvotes'];
            String title = snapshot.data['title'];
            int views = snapshot.data['views'];
            int mediaType = snapshot.data['mediaType'];
            String mediaUrl;
            if (mediaType > 0) mediaUrl = snapshot.data['mediaUrl'];
            print(mediaUrl);
            String content = snapshot.data['content'];
            final document1 = NotusDocument.fromJson(jsonDecode(content));
            String date = formatDate(DateTime.fromMillisecondsSinceEpoch(time),
                [yyyy, '-', mm, '-', dd]);
            debugPrint(date);

            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(name)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Row(
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text('Loading data... Please Wait...')
                      ],
                    );
                  String name1 = snapshot.data['name'];

                  return SafeArea(
                      child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: CircleAvatar(
                                radius: 18.0,
                                backgroundColor: Colors.grey,
                              )),
                          Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                          name1.substring(
                                              0, name1.indexOf(' ')),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold)),
                                      Icon(Icons.arrow_right),
                                      Text(community,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              )),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.more_horiz),
                            alignment: Alignment.topRight,
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 15, left: 15),
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                              padding: EdgeInsets.only(
                                  right: 15, left: 15, bottom: 15),
                              child: Column(children: <Widget>[
                                ZefyrView(
                                  document: document1,
                                  imageDelegate: MyAppZefyrImageDelegate(),
                                ),
                                mediaType == 0
                                    ? Container(
                                        child: Row(
                                        children: <Widget>[
                                          CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                              'Loading media... Please Wait...')
                                        ],
                                      ))
                                    : Image.network(
                                        mediaUrl,
                                        width: double.infinity,
                                        height: 250,
                                      ),
                              ]))),
                      Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            children: <Widget>[
                              Text(
                                upvotes.toString(),
                                style: TextStyle(fontSize: 15),
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
                                style: TextStyle(fontSize: 15),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_red_eye),
                              ),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Text(
                                  '108',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              FlatButton(
                                child: Text(
                                  'Comment',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                        color: Theme.of(context).buttonColor)),
                              ),
                            ],
                          ))
                    ],
                  ));
                });
          }),
    );
  }
}

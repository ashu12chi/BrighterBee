import 'dart:convert';

import 'package:brighter_bee/app_screens/comment.dart';
import 'package:brighter_bee/app_screens/photo_viewer.dart';
import 'package:brighter_bee/app_screens/profile.dart';
import 'package:brighter_bee/helpers/delete_post.dart';
import 'package:brighter_bee/helpers/save_post.dart';
import 'package:brighter_bee/helpers/upvote_downvote_post.dart';
import 'package:brighter_bee/app_screens/user_app_screens/edit_post.dart';
import 'package:brighter_bee/widgets/video_player.dart';
import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:brighter_bee/widgets/comments_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zefyr/zefyr.dart';

class PostUI extends StatefulWidget {
  String _community;
  String _postKey;
  String _username;

  PostUI(this._community, this._postKey, this._username);

  @override
  _PostState createState() => _PostState(_community, _postKey, _username);
}

class _PostState extends State<PostUI> {
  String community;
  String postKey;
  String username;
  bool processing;
  int num = 0;

  _PostState(this.community, this.postKey, this.username);

  @override
  void initState() {
    super.initState();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('communities/$community/posts')
              .doc(postKey)
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
            String creator = snapshot.data['creator'];
            var time = snapshot.data['time'];
            var lastModified = snapshot.data['lastModified'];
            int upvotes = snapshot.data['upvotes'];
            int downvotes = snapshot.data['downvotes'];
            String title = snapshot.data['title'];
            int views = snapshot.data['viewers'].length;
            int commentCount = snapshot.data['commentCount'];
            int mediaType = snapshot.data['mediaType'];
            List listOfMedia = snapshot.data['listOfMedia'];
            bool upvoted = snapshot.data['upvoters'].contains(username);
            bool downvoted = snapshot.data['downvoters'].contains(username);
            if (!snapshot.data['viewers'].contains(username))
              addToViewers(community, postKey, username);
            String mediaUrl;
            if (mediaType > 0) mediaUrl = snapshot.data['mediaUrl'];
            String content = snapshot.data['content'];
            NotusDocument document =
                NotusDocument.fromJson(jsonDecode(content));
            String dateLong = formatDate(
                DateTime.fromMillisecondsSinceEpoch(time),
                [yyyy, ' ', MM, ' ', dd, ', ', hh, ':', nn, ' ', am]);

            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(creator)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Row(
                          children: <Widget>[
                            CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.grey),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Loading data... Please Wait...')
                          ],
                        ));
                  String fullName = snapshot.data['name'];
                  String profilePicUrl = snapshot.data['photoUrl'];

                  return SafeArea(
                      child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: InkWell(
                                child: CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(profilePicUrl),
                                  radius: 16.0,
                                  backgroundColor: Colors.grey,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Profile(creator)));
                                },
                              )),
                          Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      InkWell(
                                        child: Text(
                                            fullName.substring(
                                                0, fullName.indexOf(' ')),
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Profile(creator)));
                                        },
                                      ),
                                      Icon(Icons.arrow_right),
                                      Text(community,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Text(
                                    dateLong,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              )),
                          Spacer(),
                          Column(children: [
                            IconButton(
                              icon: Icon(Icons.more_horiz),
                              alignment: Alignment.topRight,
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.0)),
                                    ),
                                    builder: (BuildContext context) {
                                      return buildBottomSheet(
                                          creator,
                                          fullName,
                                          mediaUrl,
                                          mediaType,
                                          listOfMedia,
                                          title,
                                          content);
                                    });
                              },
                            ),
                            (lastModified != time)
                                ? Text('Edited  ',
                                    style: TextStyle(color: Colors.grey))
                                : Container()
                          ])
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
                              child: Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: ZefyrView(
                            document: document,
                            imageDelegate: MyAppZefyrImageDelegate(),
                          ),
                        ),
                        (mediaType == 0)
                            ? Container()
                            : (mediaType == 2)
                                ? VideoPlayer(mediaUrl)
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PhotoViewer(mediaUrl)));
                                    },
                                    child: Image.network(
                                      mediaUrl,
                                      width: double.infinity,
                                      height: 250,
                                    )),
                        Divider(
                          color: Theme.of(context).buttonColor,
                        ),
                        CommentsList(community, postKey, username)
                      ]))),
                      Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            children: <Widget>[
                              Text(
                                upvotes.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: (upvoted
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).buttonColor),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (processing) return;
                                  processing = true;
                                  await upvote(community, postKey, username,
                                      upvoted, downvoted);
                                  processing = false;
                                },
                                icon: Icon(Icons.arrow_upward),
                                color: (upvoted
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).buttonColor),
                              ),
                              Text(
                                downvotes.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: (downvoted
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).buttonColor),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (processing) return;
                                  processing = true;
                                  await downvote(community, postKey, username,
                                      upvoted, downvoted);
                                  processing = false;
                                },
                                icon: Icon(Icons.arrow_downward),
                                color: (downvoted
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).buttonColor),
                              ),
                              Text(
                                views.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.remove_red_eye),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Text(
                                  commentCount.toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  comment(community, dateLong, postKey,
                                      username, title, creator, false);
                                },
                                child: Text(
                                  'Comment',
                                  style: TextStyle(fontSize: 15),
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

  comment(String community, String dateLong, String key, String username,
      String title, String creator, bool isReply) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext) => Comment(community, dateLong, key, key,
                username, title, creator, isReply)));
  }

  showOptions() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: LimitedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.share,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Share',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.bookmark,
                              size: 30, color: Theme.of(context).buttonColor),
                          onPressed: () async {
                            bool result =
                                await savePost(username, community, postKey);
                            Fluttertoast.showToast(
                                msg: result
                                    ? 'Post saved'
                                    : 'Post removed from save list');
                          }),
                      Text(
                        'Save article',
                        style: TextStyle(fontSize: 14),
                      )
                    ]),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.report,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Report',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  buildBottomSheet(String creator, String displayName, String mediaURL,
      int mediaType, List listOfMedia, String oldTitle, String content) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: LimitedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.share,
                          size: 30, color: Theme.of(context).buttonColor)),
                  Text(
                    'Share',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              (creator == username)
                  ? Column(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditPost(
                                      community,
                                      postKey,
                                      username,
                                      displayName,
                                      mediaURL,
                                      mediaType,
                                      listOfMedia,
                                      oldTitle,
                                      content)));
                            },
                            icon: Icon(Icons.edit,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Edit post',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.bookmark,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Save article',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
              username == creator
                  ? Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete,
                              size: 30, color: Theme.of(context).buttonColor),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await showDeletionConfirmation();
                          },
                        ),
                        Text(
                          'Delete',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.report,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Report',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )
            ],
          ),
        ),
      );
    });
  }

  showDeletionConfirmation() async {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Delete"),
        onPressed: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => DeletePost(community, postKey, username)));
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete post?"),
      content: Text("Doing this will remove all records of this post!"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

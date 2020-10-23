import 'dart:convert';

import 'package:brighter_bee/app_screens/post_ui.dart';
import 'package:brighter_bee/app_screens/profile.dart';
import 'package:brighter_bee/app_screens/user_app_screens/edit_post.dart';
import 'package:brighter_bee/helpers/delete_post.dart';
import 'package:brighter_bee/helpers/upvote_downvote_post.dart';
import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:zefyr/zefyr.dart';

/*
* @author: Ashutosh Chitranshi, Nishchal Siddharth Pandey
* 13 October, 2020
* This file returns widget to be placed in Card for use in feeds.
*/

class PostCardView extends StatefulWidget {
  String _community;
  String _postKey;

  PostCardView(this._community, this._postKey);

  @override
  _PostState createState() => _PostState(_community, _postKey);
}

class _PostState extends State<PostCardView> {
  String community;
  String postKey;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String username;
  bool processing;

  FocusNode _focusNode;

  _PostState(this.community, this.postKey);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    username = _auth.currentUser.displayName;
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          int mediaType = snapshot.data['mediaType'];
          int views = snapshot.data['viewers'].length;
          int downvotes = snapshot.data['downvoters'].length;
          int upvotes = snapshot.data['upvoters'].length;
          bool upvoted = snapshot.data['upvoters'].contains(username);
          bool downvoted = snapshot.data['downvoters'].contains(username);
          int commentCount = snapshot.data['commentCount'];
          String title = snapshot.data['title'];
          List listOfMedia = snapshot.data['listOfMedia'];
          String mediaUrl =
              'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/thumbnails%2Fthumbnail_video_default.png?alt=media&token=110cba28-6dd5-4656-8eca-cbefe9cce925';
          if (mediaType == 1) mediaUrl = snapshot.data['mediaUrl'];
          var time = snapshot.data['time'];
          String dateLong = formatDate(
              DateTime.fromMillisecondsSinceEpoch(time),
              [yyyy, ' ', MM, ' ', dd, ', ', hh, ':', nn, ' ', am]);
          String content = snapshot.data['content'];
          final document1 = NotusDocument.fromJson(jsonDecode(content));
          final editor = new ZefyrEditor(
            autofocus: false,
            padding: EdgeInsets.all(0),
            focusNode: _focusNode,
            controller: ZefyrController(document1),
            imageDelegate: CardZefyrImageDelegate(),
            mode: ZefyrMode.view,
            physics: NeverScrollableScrollPhysics(),
          );
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(creator)
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
                      Row(
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
                      ),
                    ],
                  );
                String fullName = snapshot.data['name'];
                String profilePicUrl = snapshot.data['photoUrl'];
                //return Text('Loading data.. Please Wait..');
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Card(
                          elevation: 8,
                          child: InkWell(
                            onTap: openPost,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      InkWell(
                                        child: CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  profilePicUrl),
                                          radius: 16.0,
                                          backgroundColor: Colors.grey,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Profile(creator)));
                                        },
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                        fullName.substring(
                                                            0,
                                                            fullName
                                                                .indexOf(' ')),
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  Profile(
                                                                      creator)));
                                                    },
                                                  ),
                                                  Icon(Icons.arrow_right),
                                                  Text(community,
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                              Text(
                                                dateLong,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )
                                            ],
                                          )),
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(Icons.more_horiz),
                                          alignment: Alignment.topRight,
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              15.0)),
                                                ),
                                                builder:
                                                    (BuildContext context) {
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
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8),
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 105,
                                      child: IgnorePointer(
                                        child: ZefyrScaffold(
                                          child: editor,
                                        ),
                                      )),
                                  mediaType == 0
                                      ? Container()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Image.network(
                                                mediaUrl,
                                                fit: BoxFit.fill,
                                                height: 200,
                                              ),
                                            ],
                                          ),
                                        ),
                                  Row(
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
                                          await upvote(community, postKey,
                                              username, upvoted, downvoted);
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
                                          await downvote(community, postKey,
                                              username, upvoted, downvoted);
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
                                      SizedBox(width: 10),
                                      Text(
                                        commentCount.toString(),
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.comment),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                );
              });
        });
  }

  deletePostHandler() async {
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
          ProgressDialog pr = ProgressDialog(context,
              type: ProgressDialogType.Normal,
              isDismissible: false,
              showLogs: true);
          pr.style(
            message: 'Deleting Post...',
            messageTextStyle: TextStyle(fontSize: 18),
            borderRadius: 2.0,
            progressWidget: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
            elevation: 8.0,
          );
          await pr.show();
          await deletePost(community, postKey, username);
          await pr.hide();
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

  openPost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                PostUI(community, postKey, username)));
    debugPrint('Post opened!');
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
                            await deletePostHandler();
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
}

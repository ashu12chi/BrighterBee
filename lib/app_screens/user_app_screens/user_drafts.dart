import 'dart:convert';

import 'package:brighter_bee/app_screens/user_app_screens/draft_editor.dart';
import 'package:brighter_bee/helpers/draft_db_helper.dart';
import 'package:brighter_bee/models/post.dart';
import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

// @author: Nishchal Siddharth Pandey
// Oct 20, 2020
// This will be used for displaying drafts of a user in extra section

class Drafts extends StatefulWidget {
  @override
  _DraftsState createState() => _DraftsState();
}

class _DraftsState extends State<Drafts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Drafts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Swipe ➱ right to delete', style: TextStyle(fontSize: 14))
      ])),
      body: FutureBuilder(
          future: getPostsListFromDb(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Post post =
                        Post.fromJson(jsonDecode(snapshot.data[index].text));
                    final document =
                        NotusDocument.fromJson(jsonDecode(post.content));
                    final editor = new ZefyrEditor(
                      autofocus: false,
                      padding: EdgeInsets.all(0),
                      focusNode: FocusNode(),
                      controller: ZefyrController(document),
                      imageDelegate: MyAppZefyrImageDelegate(),
                      mode: ZefyrMode.view,
                      physics: NeverScrollableScrollPhysics(),
                    );
                    String dateLong = formatDate(
                        DateTime.fromMillisecondsSinceEpoch(post.time),
                        [yyyy, ' ', MM, ' ', dd, ', ', hh, ':', nn, ' ', am]);
                    return Dismissible(
                        key: Key(post.title),
                        background: slideRightBackground(),
                        confirmDismiss: (direction) async {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      Text("Are you sure you want to delete?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).buttonColor),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).errorColor),
                                      ),
                                      onPressed: () async {
                                        await deletePostFromDb(post.time);
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  ],
                                );
                              });
                          return res;
                        },
                        child: Card(
                            elevation: 8,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DraftEditor(post)));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Text(post.community,
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
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            child: Text(
                                              post.title,
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
                                          ))
                                    ])))));
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Theme.of(context).errorColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.person_remove,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

import 'dart:io';

import 'package:brighter_bee/widgets/comment_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

/*
* @author: Nishchal Siddharth Pandey
* 14 October, 2020
* This file has returns list of replies to be placed under comments in ExpandingTile.
*/

class RepliesList extends StatefulWidget {
  final String community;
  final String postKey;
  final String commKey;
  final String username;

  RepliesList(this.community, this.postKey, this.commKey, this.username);

  @override
  _RepliesList createState() =>
      _RepliesList(community, postKey, commKey, username);
}

class _RepliesList extends State<RepliesList> {
  String community;
  String postKey;
  String commKey;
  String username;

  _RepliesList(this.community, this.postKey, this.commKey, this.username);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(
              "communities/$community/posts/$postKey/comments/$commKey/replies")
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              debugPrint('NSP replies');
              return Card(
                  elevation: 8,
                  child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: CommentWidget(
                          community,
                          postKey,
                          snapshot.data.docs[index]['commKey'],
                          commKey,
                          username,
                          true)));
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class CommentListBloc {
  String community;
  String postKey;
  String commKey;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;
  BehaviorSubject<bool> showIndicatorController;
  BehaviorSubject<List<DocumentSnapshot>> commentController;

  CommentListBloc(this.community, this.postKey, this.commKey) {
    commentController = BehaviorSubject<List<DocumentSnapshot>>();
  }

  Stream<List<DocumentSnapshot>> get commentStream => commentController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList() async {
    try {
      documentList = (await FirebaseFirestore.instance
              .collection(
                  "communities/$community/posts/$postKey/comments/$commKey/replies")
              .limit(10)
              .get())
          .docs;
      print(documentList);
      commentController.sink.add(documentList);
    } on SocketException {
      commentController.sink
          .addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      commentController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextComments() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore.instance
              .collection(
                  "communities/$community/posts/$postKey/comments/$commKey/replies")
              .startAfterDocument(documentList[documentList.length - 1])
              .limit(10)
              .get())
          .docs;
      documentList.addAll(newDocumentList);
      commentController.sink.add(documentList);
    } on SocketException {
      commentController.sink
          .addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      commentController.sink.addError(e);
    }
  }

  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    commentController.close();
    showIndicatorController.close();
  }
}

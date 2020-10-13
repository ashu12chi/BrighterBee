import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class CommentsList extends StatefulWidget {
  @override
  _CommentsList createState() => _CommentsList();
}

class _CommentsList extends State<CommentsList> {
  CommentListBloc commentListBloc;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    commentListBloc = CommentListBloc();
    commentListBloc.fetchFirstList();
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      commentListBloc.fetchNextComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase firestore pagination"),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: commentListBloc.commentStream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              controller: controller,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                          child: Text(snapshot.data[index]["rank"].toString())),
                      title: Text(snapshot.data[index]["title"]),
                    ),
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class CommentListBloc {
  bool showIndicator = false;
  List<DocumentSnapshot> documentList;
  BehaviorSubject<bool> showIndicatorController;
  BehaviorSubject<List<DocumentSnapshot>> commentController;

  MovieListBloc() {
    commentController = BehaviorSubject<List<DocumentSnapshot>>();
  }

  Stream<List<DocumentSnapshot>> get commentStream => commentController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList() async {
    try {
      documentList = (await FirebaseFirestore.instance
              .collection("/communities/Mathematics/posts/")
              .orderBy("rank")
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
              .collection("movies")
              .orderBy("rank")
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

import 'package:brighter_bee/helpers/comment_delete_and_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

/*
* @author: Nishchal Siddharth Pandey
* 20 October, 2020
* This file has UI and code for post deletion.
*/

class DeletePost extends StatefulWidget {
  String _community;
  String _postKey;
  String _creator;

  DeletePost(this._community, this._postKey, this._creator);

  @override
  _DeletePostState createState() =>
      _DeletePostState(_community, _postKey, _creator);
}

class _DeletePostState extends State<DeletePost> {
  String community;
  String postKey;
  String creator;

  _DeletePostState(this.community, this.postKey, this.creator);

  @override
  Widget build(BuildContext context) {
    deletePost(community, postKey, creator)
        .then((value) => Navigator.of(context).pop());
    return Scaffold(
        body: Center(
            child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          "Deleting Post...",
          style: TextStyle(fontSize: 18),
        )
      ],
    )));
  }
}

Future<void> deletePost(
    String community, String postKey, String creator) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  StorageReference storageReference = FirebaseStorage.instance.ref();

  DocumentSnapshot postDoc = await instance
      .collection('communities/$community/posts')
      .doc(postKey)
      .get();
  List mediaList = postDoc.data()['listOfMedia'];
  mediaList.forEach((element) async {
    await storageReference.child(element).delete();
    print('Successfully deleted $element storage item');
  });
  var commentsSnap = await instance
      .collection('communities/$community/posts/$postKey/comments')
      .get();
  final List<DocumentSnapshot> comments = commentsSnap.docs;
  comments.forEach((comment) async {
    String creator = comment.data()['creator'];
    await deleteComment(
        community, postKey, comment.id, "reply", false, creator);
  });
  List upvoters = postDoc.data()['upvoters'];
  upvoters.forEach((element) {
    instance.collection('users/$element/posts').doc('upvoted').update({
      community: FieldValue.arrayRemove([postKey])
    });
  });
  List downvoters = postDoc.data()['downvoters'];
  downvoters.forEach((element) {
    instance.collection('users/$element/posts').doc('downvoted').update({
      community: FieldValue.arrayRemove([postKey])
    });
  });
  instance.collection('users/$creator/posts').doc('posted').update({
    community: FieldValue.arrayRemove([postKey])
  });
  await instance
      .collection('communities/$community/posts')
      .doc(postKey)
      .delete();
}

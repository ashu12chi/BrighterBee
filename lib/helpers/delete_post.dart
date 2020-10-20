import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DeletePost extends StatefulWidget {
  @override
  _DeletePostState createState() => _DeletePostState();
}

class _DeletePostState extends State<DeletePost> {
  @override
  Widget build(BuildContext context) {
    return null;
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
  var result = await instance
      .collection('communities/$community/posts/$postKey/comments')
      .get();
  final List<DocumentSnapshot> documents = result.docs;
  documents.forEach((element) async {
    String creator = element.data()['creator'];
    await instance
        .collection('users/$creator/comments')
        .doc(element.id)
        .delete();
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

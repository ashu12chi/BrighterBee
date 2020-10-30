import 'package:cloud_firestore/cloud_firestore.dart';

deleteComment(String community, String parentPost, String comment, String reply,
    bool isReply, String creator) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  // if is head comment delete all replies and entry from creator
  if (!isReply) {
    // replies
    List<QueryDocumentSnapshot> replies = (await instance
            .collection(
                'communities/$community/posts/$parentPost/comments/$comment/replies')
            .get())
        .docs;
    replies.forEach((replyId) async {
      await instance
          .collection(
              'communities/$community/posts/$parentPost/comments/$comment/replies')
          .doc(replyId.id)
          .delete();
    });

    //user
    await instance.collection('users/$creator/comments').doc(comment).delete();
  }
  await instance
      .collection('communities/$community/posts/$parentPost/comments' +
          (isReply ? '/$comment/replies' : ''))
      .doc(isReply ? reply : comment)
      .delete();

  // decrement
  await instance.runTransaction((transaction) async {
    DocumentReference postRef =
        instance.collection('communities/$community/posts').doc(parentPost);
    transaction.update(postRef, {'commentCount': FieldValue.increment(-1)});
    if (isReply) {
      postRef = instance
          .collection('communities/$community/posts/$parentPost/comments')
          .doc(comment);
      transaction.update(postRef, {'replyCount': FieldValue.increment(-1)});
    }
  });
}

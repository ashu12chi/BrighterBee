import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*
* @author: Nishchal Siddharth Pandey
* 14 October, 2020
* This file has code for managing upvotes, downvotes and comments on a post.
*/

upvote(String community, String username, bool upvoted, bool downvoted,
    String postKey, String commKey, String replyKey, bool isReply) async {
  if (upvoted) {
    await undoUpvote(community, username, upvoted, downvoted, postKey, commKey,
        replyKey, isReply);
    return;
  }
  if (downvoted) {
    await undoDownvote(community, username, upvoted, downvoted, postKey,
        commKey, replyKey, isReply);
    // return;
  }
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef = instance
        .collection('communities/$community/posts/$postKey/comments' +
            (isReply ? '/$commKey/replies' : ''))
        .doc(isReply ? replyKey : commKey);
    transaction.update(postRef, {
      'upvoters': FieldValue.arrayUnion([username]),
      'upvotes': FieldValue.increment(1),
    });
  });

  debugPrint('Upvoted!');
}

downvote(String community, String username, bool upvoted, bool downvoted,
    String postKey, String commKey, String replyKey, bool isReply) async {
  if (downvoted) {
    undoDownvote(community, username, upvoted, downvoted, postKey, commKey,
        replyKey, isReply);
    return;
  }
  if (upvoted) {
    await undoUpvote(community, username, upvoted, downvoted, postKey, commKey,
        replyKey, isReply);
    // return;
  }
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef = instance
        .collection('communities/$community/posts/$postKey/comments' +
            (isReply ? '/$commKey/replies' : ''))
        .doc(isReply ? replyKey : commKey);
    transaction.update(postRef, {
      'downvoters': FieldValue.arrayUnion([username]),
      'downvotes': FieldValue.increment(1),
    });
  });

  debugPrint('Downvoted!');
}

undoUpvote(String community, String username, bool upvoted, bool downvoted,
    String postKey, String commKey, String replyKey, bool isReply) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef = instance
        .collection('communities/$community/posts/$postKey/comments' +
            (isReply ? '/$commKey/replies' : ''))
        .doc(isReply ? replyKey : commKey);
    transaction.update(postRef, {
      'upvoters': FieldValue.arrayRemove([username]),
      'upvotes': FieldValue.increment(-1),
    });
  });

  debugPrint('Upvote undone!');
}

undoDownvote(String community, String username, bool upvoted, bool downvoted,
    String postKey, String commKey, String replyKey, bool isReply) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef = instance
        .collection('communities/$community/posts/$postKey/comments' +
            (isReply ? '/$commKey/replies' : ''))
        .doc(isReply ? replyKey : commKey);
    transaction.update(postRef, {
      'downvoters': FieldValue.arrayRemove([username]),
      'downvotes': FieldValue.increment(-1),
    });
  });

  debugPrint('Downvote undone!');
}

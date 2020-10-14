import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

upvote(String community, String key, String username, bool upvoted,
    bool downvoted) async {
  if (upvoted) {
    await undoUpvote(community, key, username, upvoted, downvoted);
    return;
  }
  if (downvoted) {
    await undoDownvote(community, key, username, upvoted, downvoted);
    // return;
  }
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef =
        instance.collection('communities/$community/posts').doc(key);
    await transaction.update(postRef, {
      'upvoters': FieldValue.arrayUnion([username]),
      'upvotes': FieldValue.increment(1),
    });
    DocumentReference userRef =
        instance.collection('users/$username/posts').doc('upvoted');
    await transaction.update(userRef, {
      community: FieldValue.arrayUnion([key])
    });
  });

  debugPrint('Upvoted!');
}

downvote(String community, String key, String username, bool upvoted,
    bool downvoted) async {
  if (downvoted) {
    undoDownvote(community, key, username, upvoted, downvoted);
    return;
  }
  if (upvoted) {
    await undoUpvote(community, key, username, upvoted, downvoted);
    // return;
  }
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef =
    instance.collection('communities/$community/posts').doc(key);
    await transaction.update(postRef, {
      'downvoters': FieldValue.arrayUnion([username]),
      'downvotes': FieldValue.increment(1),
    });
    DocumentReference userRef =
    instance.collection('users/$username/posts').doc('downvoted');
    await transaction.update(userRef, {
      community: FieldValue.arrayUnion([key])
    });
  });

  debugPrint('Downvoted!');
}

undoUpvote(String community, String key, String username, bool upvoted,
    bool downvoted) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef =
    instance.collection('communities/$community/posts').doc(key);
    await transaction.update(postRef, {
      'upvoters': FieldValue.arrayRemove([username]),
      'upvotes': FieldValue.increment(-1),
    });
    DocumentReference userRef =
    instance.collection('users/$username/posts').doc('upvoted');
    await transaction.update(userRef, {
      community: FieldValue.arrayRemove([key])
    });
  });

  debugPrint('Upvote undone!');
}

undoDownvote(String community, String key, String username, bool upvoted,
    bool downvoted) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef =
    instance.collection('communities/$community/posts').doc(key);
    await transaction.update(postRef, {
      'downvoters': FieldValue.arrayRemove([username]),
      'downvotes': FieldValue.increment(-1),
    });
    DocumentReference userRef =
    instance.collection('users/$username/posts').doc('downvoted');
    await transaction.update(userRef, {
      community: FieldValue.arrayRemove([key])
    });
  });

  debugPrint('Downvote undone!');
}

addToViewers(String community, String key, String username) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef =
        instance.collection('communities/$community/posts').doc(key);
    await transaction.update(postRef, {
      'viewers': FieldValue.arrayUnion([username])
    });
  });

  debugPrint('Added as viewer!');
}

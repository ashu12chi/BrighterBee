import 'package:brighter_bee/helpers/hotness_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*
* @author: Nishchal Siddharth Pandey,Ashutosh Chitranshi
* 14 October, 2020
* This file has code for managing upvote/ downvote/ reporting actions on a post..
*/

upvote(String community, String key, String username, bool upvoted,
    bool downvoted) async {
  debugPrint('Check');
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
    transaction.update(postRef, {
      'upvoters': FieldValue.arrayUnion([username]),
      'upvotes': FieldValue.increment(1),
    });
    DocumentReference userRef =
        instance.collection('users/$username/posts').doc('upvoted');
    transaction.update(userRef, {
      community: FieldValue.arrayUnion([key])
    });
    await updateHotness(community, key);
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
    transaction.update(postRef, {
      'downvoters': FieldValue.arrayUnion([username]),
      'downvotes': FieldValue.increment(1),
    });
    DocumentReference userRef =
        instance.collection('users/$username/posts').doc('downvoted');
    transaction.update(userRef, {
      community: FieldValue.arrayUnion([key])
    });
    await updateHotness(community, key);
  });

  debugPrint('Downvoted!');
}

report(String community, String key, String username) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef = instance
        .collection('communities')
        .doc(community)
        .collection('posts')
        .doc(key);
    transaction.update(postRef, {
      'reporters': FieldValue.arrayUnion([username]),
      'reports': FieldValue.increment(1)
    });
  });
}

undoUpvote(String community, String key, String username, bool upvoted,
    bool downvoted) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef =
        instance.collection('communities/$community/posts').doc(key);
    transaction.update(postRef, {
      'upvoters': FieldValue.arrayRemove([username]),
      'upvotes': FieldValue.increment(-1),
    });
    DocumentReference userRef =
        instance.collection('users/$username/posts').doc('upvoted');
    transaction.update(userRef, {
      community: FieldValue.arrayRemove([key])
    });
    await updateHotness(community, key);
  });

  debugPrint('Upvote undone!');
}

undoDownvote(String community, String key, String username, bool upvoted,
    bool downvoted) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef =
        instance.collection('communities/$community/posts').doc(key);
    transaction.update(postRef, {
      'downvoters': FieldValue.arrayRemove([username]),
      'downvotes': FieldValue.increment(-1),
    });
    DocumentReference userRef =
        instance.collection('users/$username/posts').doc('downvoted');
    transaction.update(userRef, {
      community: FieldValue.arrayRemove([key])
    });
    await updateHotness(community, key);
  });

  debugPrint('Downvote undone!');
}

undoReport(String community, String key, String username) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef = instance
        .collection('communities')
        .doc(community)
        .collection('posts')
        .doc(key);
    transaction.update(postRef, {
      'reporters': FieldValue.arrayRemove([username]),
      'reports': FieldValue.increment(-1)
    });
  });
}

addToViewers(String community, String key, String username) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference postRef =
        instance.collection('communities/$community/posts').doc(key);
    transaction.update(postRef, {
      'viewers': FieldValue.arrayUnion([username]),
      'views': FieldValue.increment(1),
    });
    await updateHotness(community, key);
  });

  debugPrint('Added as viewer!');
}

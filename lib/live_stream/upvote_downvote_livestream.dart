// @author: Ashutosh Chitranshi
// Nov 1, 2020
// This will be helper used for upvoting and downvoting live stream

import 'package:cloud_firestore/cloud_firestore.dart';

upVote(String community, String streamId, String username, bool upvoted,
    bool downvoted) async {
  if (upvoted) return;
  if (downvoted) {
    await undoDownVote(community, streamId, username, upvoted, downvoted);
  }
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference liveRef = instance
        .collection('communities')
        .doc(community)
        .collection('live')
        .doc(streamId);
    transaction.update(liveRef, {
      'upvotes': FieldValue.increment(1),
      'upvoters': FieldValue.arrayUnion([username])
    });
  });
}

downVote(String community, String streamId, String username, bool upvoted,
    bool downvoted) async {
  if (downvoted) return;
  if (upvoted) {
    await undoUpVote(community, streamId, username, upvoted, downvoted);
  }
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference liveRef = instance
        .collection('communities')
        .doc(community)
        .collection('live')
        .doc(streamId);
    transaction.update(liveRef, {
      'downvotes': FieldValue.increment(1),
      'downvoters': FieldValue.arrayUnion([username])
    });
  });
}

undoDownVote(String community, String streamId, String username, bool upvoted,
    bool downvoted) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference liveRef = instance
        .collection('communities')
        .doc(community)
        .collection('live')
        .doc(streamId);
    transaction.update(liveRef, {
      'downvotes': FieldValue.increment(-1),
      'downvoters': FieldValue.arrayRemove([username])
    });
  });
}

undoUpVote(String community, String streamId, String username, bool upvoted,
    bool downvoted) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference liveRef = instance
        .collection('communities')
        .doc(community)
        .collection('live')
        .doc(streamId);
    transaction.update(liveRef, {
      'upvotes': FieldValue.increment(-1),
      'upvoters': FieldValue.arrayRemove([username])
    });
  });
}

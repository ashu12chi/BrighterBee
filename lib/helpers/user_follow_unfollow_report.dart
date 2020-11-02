import 'package:cloud_firestore/cloud_firestore.dart';

/*
* @author: Nishchal Siddharth Pandey,Ashutosh Chitranshi
* 19 October, 2020
* This file has code for follow/unfollow and report/undo report of a user
*/

handleFollow(String me, String user) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference userRef = instance.collection('users').doc(user);
    transaction.update(userRef, {
      'followersList': FieldValue.arrayUnion([me]),
      'followersCount': FieldValue.increment(1)
    });
    DocumentReference meRef = instance.collection('users').doc(me);
    transaction.update(meRef, {
      'followingList': FieldValue.arrayUnion([user]),
      'followingCount': FieldValue.increment(1)
    });
  });

  int time = DateTime.now().millisecondsSinceEpoch;
  String notificationId =
      (await instance.collection('pendingUserNotification').add({
    'title': "$me started following you!",
    'creator': me,
    'receiver': user,
    'body': 'Tap to open app',
    'community': 'BrighterBee',
    'time': time
  }))
          .id;
  await instance
      .collection('users/$user/notifications')
      .doc(notificationId)
      .set({'postRelated': 0, 'time': time});
}

handleUnfollow(String me, String user) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference userRef = instance.collection('users').doc(user);
    transaction.update(userRef, {
      'followersList': FieldValue.arrayRemove([me]),
      'followersCount': FieldValue.increment(-1)
    });
    DocumentReference meRef = instance.collection('users').doc(me);
    transaction.update(meRef, {
      'followingList': FieldValue.arrayRemove([user]),
      'followingCount': FieldValue.increment(-1)
    });
  });
}

undoReport(String reported, String username) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference ref = instance.collection('users').doc(reported);
    transaction.update(ref, {
      'reporters': FieldValue.arrayRemove([username]),
      'reports': FieldValue.increment(-1)
    });
  });
}

report(String reported, String username) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference ref = instance.collection('users').doc(reported);
    transaction.update(ref, {
      'reporters': FieldValue.arrayUnion([username]),
      'reports': FieldValue.increment(1)
    });
  });
}

import 'package:cloud_firestore/cloud_firestore.dart';

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

  // TODO user follow notifications

  // String notificationId = (await instance.collection('notification').add({
  //   'title': "$me started following you!",
  //   'creator': me,
  //   'receiver': user,
  // }))
  //     .id;
  // await instance
  //     .collection('users/$user/notifications')
  //     .doc(notificationId)
  //     .set({});
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

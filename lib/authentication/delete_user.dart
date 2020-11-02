import 'package:brighter_bee/helpers/community_join_leave_report_admin.dart';
import 'package:brighter_bee/helpers/user_follow_unfollow_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/*
* @author: Nishchal Siddharth Pandey
* 19 October, 2020
* This file has code for deleting a user
*/

deleteUser(String username) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  // deleting tokens
  List<QueryDocumentSnapshot> tokens =
      (await instance.collection('users/$username/tokens').get()).docs;
  tokens.forEach((token) async {
    await instance.collection('users/$username/tokens').doc(token.id).delete();
  });

  // deleting notifications
  List<QueryDocumentSnapshot> notifications =
      (await instance.collection('users/$username/notifications').get()).docs;
  notifications.forEach((notification) async {
    String id = notification.id;
    await instance.collection('users/$username/notifications').doc(id).delete();
    await instance.collection('notification').doc(id).delete();
  });

  // into user data
  DocumentSnapshot user =
      await instance.collection('users').doc(username).get();

  // remove from communities
  List communities = user.get('communityList');
  communities.forEach((community) async {
    await handleLeave(community, username);
  });

  // remove following
  List following = user.get('followingList');
  following.forEach((party) async {
    await handleUnfollow(username, party);
  });

  // remove followers
  List followers = user.get('followersList');
  followers.forEach((user) async {
    await handleUnfollow(user, username);
  });

  // delete Profile Picture
  StorageReference storageReference = FirebaseStorage.instance.ref();
  await storageReference.child('profilePics/$username.jpg').delete();

  // delete account document
  await instance.collection('users').doc(username).delete();

  // delete account registration
  await FirebaseAuth.instance.currentUser.delete();
}

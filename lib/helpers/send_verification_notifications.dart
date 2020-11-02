import 'package:cloud_firestore/cloud_firestore.dart';

/*
* @author: Nishchal Siddharth Pandey
* 19 October, 2020
* This file has code for sending verification notifications
*/

Future<void> sendVerificationNotifications(
    String community, String postKey, String creator) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  DocumentSnapshot communityData =
      await instance.collection('communities').doc(community).get();
  List adminList = communityData.data()['admin'];
  adminList.add(communityData.data()['creator']);

  adminList.forEach((admin) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    String notificationId = (await instance.collection('notification').add({
      'title': "$creator posted in $community community",
      'body': 'Tap to verify the post',
      'community': community,
      'creator': creator,
      'postId': postKey,
      'receiver': admin,
      'time': time
    }))
        .id;
    await instance
        .collection('users/$admin/notifications')
        .doc(notificationId)
        .set({'postRelated': 1, 'time': time});
  });
}

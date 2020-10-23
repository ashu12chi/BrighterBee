import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> sendVerificationNotifications(
    String community, String postKey, String creator) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  DocumentSnapshot communityData =
      await instance.collection('communities').doc(community).get();
  List adminList = communityData.data()['admin'];
  adminList.add(communityData.data()['creator']);

  adminList.forEach((admin) async {
    String notificationId = (await instance.collection('notification').add({
      'title': "$creator posted in $community community",
      'body': 'Tap to verify the post',
      'community': community,
      'creator': creator,
      'postId': postKey,
      'receiver': admin,
      'time': DateTime.now().millisecondsSinceEpoch
    }))
        .id;
    await instance
        .collection('users/$admin/notifications')
        .doc(notificationId)
        .set({'postRelated': 1});
  });
}

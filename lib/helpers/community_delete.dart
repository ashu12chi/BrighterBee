import 'package:brighter_bee/helpers/community_join_leave.dart';
import 'package:brighter_bee/helpers/delete_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

deleteCommunity(final String community) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> posts =
      (await instance.collection('communities/$community/posts').get()).docs;
  posts.forEach((post) async {
    await deletePost(community, post.id, post.get('creator'));
  });
  DocumentSnapshot communityDoc =
      await instance.collection('communities').doc(community).get();
  List members = communityDoc.get('members');
  members.add(communityDoc.get('creator'));
  members.forEach((member) async {
    await handleLeave(community, member);
  });
  await instance.collection('communities').doc(community).delete();
}

import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> savePost(String username, String community, String postKey) async {
  if (await doesSaveExist(username, community, postKey)) {
    undoSavePost(username, community, postKey);
    return false;
  } else {
    int time = DateTime.now().millisecondsSinceEpoch;
    await FirebaseFirestore.instance
        .collection('users/$username/posts/saved/$community')
        .doc(postKey)
        .set({'time': time});
    return true;
  }
}

undoSavePost(String username, String community, String postKey) async {
  await FirebaseFirestore.instance
      .collection('users/$username/posts/saved/$community')
      .doc(postKey)
      .delete();
}

Future<bool> doesSaveExist(
    String username, String community, String postKey) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users/$username/posts/saved/$community')
      .doc(postKey)
      .get();
  return !(snapshot == null || !snapshot.exists);
}

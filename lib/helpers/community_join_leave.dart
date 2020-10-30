import 'package:cloud_firestore/cloud_firestore.dart';

handleJoinAccept(String community, String user) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference userRef = instance.collection('users').doc(user);
    transaction.update(userRef, {
      'communityCount': FieldValue.increment(1),
      'communityList': FieldValue.arrayUnion([community])
    });
    DocumentReference communityRef =
        instance.collection('communities').doc(community);
    transaction.update(communityRef, {
      'members': FieldValue.arrayUnion([user]),
      'pendingMembers': FieldValue.arrayRemove([user]),
      'memberCount': FieldValue.increment(1)
    });
  });
}

handleJoinRequest(String community, String user) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference communityRef =
        instance.collection('communities').doc(community);
    transaction.update(communityRef, {
      'pendingMembers': FieldValue.arrayUnion([user])
    });
  });
}

handleJoinReject(String community, String user) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference communityRef =
        instance.collection('communities').doc(community);
    transaction.update(communityRef, {
      'pendingMembers': FieldValue.arrayRemove([user])
    });
  });
}

handleLeave(String community, String user) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference userRef = instance.collection('users').doc(user);
    transaction.update(userRef, {
      'communityCount': FieldValue.increment(-1),
      'communityList': FieldValue.arrayRemove([community])
    });
    DocumentReference communityRef =
        instance.collection('communities').doc(community);
    transaction.update(communityRef, {
      'members': FieldValue.arrayRemove([user]),
      'memberCount': FieldValue.increment(-1),
      'admin': FieldValue.arrayRemove([user])
    });
  });
}

handleAddAdmin(String community, String user) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference communityRef =
        instance.collection('communities').doc(community);
    transaction.update(communityRef, {
      'admin': FieldValue.arrayUnion([user])
    });
  });
}

handleRemoveAdmin(String community, String user) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference communityRef =
        instance.collection('communities').doc(community);
    transaction.update(communityRef, {
      'admin': FieldValue.arrayRemove([user])
    });
  });
}

handleCommunityCreate(String community, String user) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference userRef = instance.collection('users').doc(user);
    transaction.update(userRef, {
      'communityCount': FieldValue.increment(1),
      'communityList': FieldValue.arrayUnion([community])
    });
    DocumentReference communityRef =
        instance.collection('communities').doc(community);
    transaction.update(communityRef, {'memberCount': FieldValue.increment(1)});
  });
}

report(String community, String username) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference Ref = instance.collection('communities').doc(community);
    transaction.update(Ref, {
      'reporters': FieldValue.arrayUnion([username]),
      'reports': FieldValue.increment(1)
    });
  });
}

undoReport(String community, String username) async {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  await instance.runTransaction((transaction) async {
    DocumentReference Ref = instance.collection('communities').doc(community);
    transaction.update(Ref, {
      'reporters': FieldValue.arrayRemove([username]),
      'reports': FieldValue.increment(-1)
    });
  });
}

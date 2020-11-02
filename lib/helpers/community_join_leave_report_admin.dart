import 'package:cloud_firestore/cloud_firestore.dart';


// @author: Ashutosh Chitranshi
// Oct 15, 2020
// This helper is useful in making a join request in a community by any user, accepting/rejecting join
// request by admin, also useful in making new admins/ removing admins from control panel

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
  int time = DateTime.now().millisecondsSinceEpoch;
  DocumentSnapshot communityDoc =
      await instance.collection('communities').doc(community).get();
  List admins = communityDoc.get('admin');
  admins.add(communityDoc.get('creator'));
  admins.forEach((admin) async {
    String id = (await instance.collection('pendingUserNotification').add({
      'title': "$user requests membership in $community",
      'body': 'Tap to allow',
      'community': community,
      'creator': user,
      'receiver': admin,
      'time': time
    }))
        .id;
    await instance
        .collection('users/$admin/notifications')
        .doc(id)
        .set({'postRelated': 0, 'time': time});
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<void> updateUserData(String email, String name, String username,
      String url, String motto,String website,String homeTown,String currentCity) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    List<String> nameSearchList = List();
    String temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i];
      nameSearchList.add(temp);
    }
    await instance.collection('authData').doc(uid).set({
      'name': name,
      'username': username,
      'photoUrl': url,
    });
    await instance.collection('users').doc(username).set({
      'name': name,
      'username': username,
      'nameSearch':nameSearchList,
      'photoUrl': url,
      'motto': motto,
      'website': website,
      'homeTown': homeTown,
      'currentCity': currentCity,
      'time': time
    });
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String deviceId = await _firebaseMessaging.getToken();
    final snapShot =
        await instance.collection('users/$username/tokens').doc(deviceId).get();

    if (snapShot == null && !snapShot.exists) {
      await instance.collection('users/$username/tokens').doc(deviceId).set({});
    }
  }
}

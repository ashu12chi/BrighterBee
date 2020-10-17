import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<void> updateUserData(String email, String name, String username,
      String url, String motto) async {
    await instance.collection('authData').doc(uid).set({
      'name': name,
      'username': username,
      'photoUrl': url,
    });
    await instance.collection('users').doc(username).set({
      'name': name,
      'username': username,
      'photoUrl': url,
      'motto': motto,
    });
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String deviceId = await _firebaseMessaging.getToken();
    await instance.collection('users/$username/tokens').doc(username).set({
      'name': name,
      'username': username,
      'photoUrl': url,
      'motto': motto,
      'email': email,
    });
    final snapShot =
        await instance.collection('users/$username/tokens').doc(deviceId).get();

    if (snapShot == null && !snapShot.exists) {
      await instance.collection('users/$username/tokens').doc(deviceId).set({});
    }
  }
}

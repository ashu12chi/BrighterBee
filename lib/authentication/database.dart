import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<void> updateUserData(
      String email,
      String name,
      String username,
      String url,
      String motto,
      String website,
      String homeTown,
      String currentCity) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    List<String> nameSearchList = List();
    String temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i];
      nameSearchList.add(temp);
    }
    await instance.collection('users').doc(username).set({
      'name': name,
      'username': username,
      'nameSearch': nameSearchList,
      'photoUrl': url,
      'motto': motto,
      'website': website,
      'homeTown': homeTown,
      'currentCity': currentCity,
      'time': time
    });
    await instance.collection('users/$username/posts').doc('posted').set({});
  }
}

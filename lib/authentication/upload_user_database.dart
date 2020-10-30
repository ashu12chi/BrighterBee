import 'package:cloud_firestore/cloud_firestore.dart';

/*
* @author: Nishchal Siddharth Pandey
* 17 October, 2020
* This file has code for uploading user data to firestore.
*/

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
      nameSearchList.add(temp.toLowerCase());
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
      'time': time,
      'email': email,
      'followersList': [],
      'followingList': [],
      'communityList': [],
      'followersCount': 0,
      'followingCount': 0,
      'communityCount': 0,
      'reports': 0,
      'reporters': []
    });
    await instance.collection('users/$username/posts').doc('posted').set({});
    await instance.collection('users/$username/posts').doc('upvoted').set({});
    await instance.collection('users/$username/posts').doc('downvoted').set({});
  }
}

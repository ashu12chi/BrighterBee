import 'package:cloud_firestore/cloud_firestore.dart';

/*
* @author: Nishchal Siddharth Pandey
* 12 October, 2020
* This file helps manage user data to and from firestore database.
*/

class User {
  final String currentCity, homeTown, motto, photoUrl, name, username, website;
  final List<String> nameSearch;
  final int time;

  User(
      {this.currentCity,
      this.homeTown,
      this.motto,
      this.photoUrl,
      this.name,
      this.username,
      this.nameSearch,
      this.time,
      this.website});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        currentCity: doc['currentCity'],
        homeTown: doc['homeTown'],
        motto: doc['motto'],
        photoUrl: doc['photoURL'],
        name: doc['name'],
        username: doc['username'],
        nameSearch: doc['nameSearch'],
        time: doc['time'],
        website: doc['website']);
  }
}

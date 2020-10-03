import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email, photoUrl, displayName, bio;

  User({
        this.email,
        this.displayName,
        this.photoUrl,
        this.bio});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        email: doc['email'],
        displayName: doc['displayName'],
        photoUrl: doc['photoURL'],
        bio: doc['bio']);
  }
}

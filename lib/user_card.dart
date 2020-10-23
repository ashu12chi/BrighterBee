import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final username;
  UserCard(this.username);
  @override
  _UserCardState createState() => _UserCardState(username);
}

class _UserCardState extends State<UserCard> {
  final username;
  _UserCardState(this.username);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          return Card(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data['photoUrl']),
                    radius: 50,
                  ),
                ),
                Text(
                  snapshot.data['name'],
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          );
        });
  }
}

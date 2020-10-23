import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final _username;
  UserCard(this._username);
  @override
  _UserCardState createState() => _UserCardState(_username);
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
                    backgroundImage:
                        CachedNetworkImageProvider(snapshot.data['photoUrl']),
                    radius: 30,
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

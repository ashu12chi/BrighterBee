import 'package:brighter_bee/app_screens/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// @author: Ashutosh Chitranshi
// Oct 21, 2020
// This is UserCard can be used at various places according to the need for displaying user
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
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(username)));
                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            snapshot.data['photoUrl']),
                        radius: 30,
                      ),
                    ),
                    Text(
                      snapshot.data['name'],
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                )),
          );
        });
  }
}

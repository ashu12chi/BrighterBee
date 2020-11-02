import 'package:brighter_bee/app_screens/community_screens/community_home.dart';
import 'package:brighter_bee/app_screens/community_screens/community_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// @author: Ashutosh Chitranshi
// 25 Oct,2020
// This is community card can be used in various places according to the requirement while
// displaying a list

class CommunityCard extends StatefulWidget {
  final _community;

  CommunityCard(this._community);

  @override
  _CommunityCardState createState() => _CommunityCardState(_community);
}

class _CommunityCardState extends State<CommunityCard> {
  final community;

  _CommunityCardState(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('communities')
            .doc(community)
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
                      builder: (context) => CommunityHome(community)));
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(snapshot.data['photoUrl']),
                    radius: 40,
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data['name'],
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        snapshot.data['about'],
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
        });
  }
}

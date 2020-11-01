import 'package:brighter_bee/app_screens/community_screens/community_home.dart';
import 'package:brighter_bee/app_screens/community_screens/join_community.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/* @author: Ashutosh Chitranshi
   21-10-2020 14:31
   This will be used for discovering communities from community tab
*/

class DiscoverCommunity extends StatefulWidget {
  @override
  _DiscoverCommunityState createState() => _DiscoverCommunityState();
}

class _DiscoverCommunityState extends State<DiscoverCommunity> {
  final String username = FirebaseAuth.instance.currentUser.displayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover communities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              tooltip: 'Join community',
              icon: Icon(Icons.group_add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => JoinCommunity()));
              })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('communities').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.docs.isNotEmpty)
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot communitySnapshot =
                        snapshot.data.docs[index];
                    bool isHidden = (communitySnapshot.get('privacy') == 1) &&
                        (communitySnapshot.get('visibility') == 1);
                    bool isMember =
                        communitySnapshot.get('members').contains(username) ||
                            (communitySnapshot.get('creator') == username);
                    if (isMember || !isHidden) {
                      return Card(
                        elevation: 8,
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommunityHome(communitySnapshot.id)));
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 20),
                                  width: 100,
                                  height: 100,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Image(
                                        image: AssetImage('assets/empty.jpg')),
                                    imageUrl:
                                        communitySnapshot.data()['photoUrl'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        communitySnapshot.id,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        communitySnapshot['about'],
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                      );
                    } else
                      return Container();
                  });
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            child: Card(
                              child: Container(
                                height: 100,
                                width: 100,
                              ),
                            ),
                            baseColor: Colors.grey,
                            highlightColor: Colors.black12,
                          ),
                        ),
                        Column(
                          children: [
                            Shimmer.fromColors(
                              child: Card(
                                child: Text('Name of User'),
                                shape: RoundedRectangleBorder(),
                              ),
                              baseColor: Colors.grey,
                              highlightColor: Colors.black12,
                            ),
                            Shimmer.fromColors(
                              child: Card(
                                child: Text('Name of User name of user'),
                                shape: RoundedRectangleBorder(),
                              ),
                              baseColor: Colors.grey,
                              highlightColor: Colors.black12,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                });
          }),
    );
  }
}

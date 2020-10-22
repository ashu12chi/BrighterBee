import 'package:brighter_bee/app_screens/community_screens/community_home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/* @author: Ashutosh Chitranshi
   21-10-2020 14:31
   This will be used for discovering communities from community tab
*/

class DiscoverCommunity extends StatefulWidget {
  @override
  _DiscoverCommunityState createState() => _DiscoverCommunityState();
}

class _DiscoverCommunityState extends State<DiscoverCommunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover communities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('communities').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  print(documentSnapshot.id);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommunityHome(documentSnapshot.id)));
                    },
                    child: Card(
                      elevation: 8,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 20),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: documentSnapshot['photoUrl'] == null
                                      ? AssetImage('assets/empty.jpg')
                                      : CachedNetworkImageProvider(
                                          documentSnapshot.data()['photoUrl'],
                                        ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  documentSnapshot.id,
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  documentSnapshot['about'],
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

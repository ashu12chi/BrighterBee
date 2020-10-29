import 'package:brighter_bee/app_screens/user_app_screens/user_saved_in_community.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserSaved extends StatefulWidget {
  _UserSavedState createState() => _UserSavedState();
}

class _UserSavedState extends State<UserSaved> {
  User user;
  String username;
  FirebaseFirestore instance;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    username = user.displayName;
    instance = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Saved posts',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: FutureBuilder<DocumentSnapshot>(
          future: instance.collection('users').doc(username).get(),
          builder: (context, snapshot1) {
            // user data
            if (snapshot1.data != null) {
              return ListView.builder(
                  itemCount: snapshot1.data['communityCount'],
                  itemBuilder: (context, index) {
                    String community = snapshot1.data['communityList'][index];

                    return FutureBuilder<QuerySnapshot>(
                      future: instance
                          .collection('users/$username/posts/saved/$community')
                          .get(),
                      builder: (context, snapshot2) {
                        if (snapshot2.data != null) {
                          int savedCount = snapshot2.data.docs.length;
                          return FutureBuilder(
                              future: instance
                                  .collection('communities')
                                  .doc(community)
                                  .get(),
                              builder: (context, snapshot) {
                                // community data
                                if (snapshot.data != null) {
                                  return Card(
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        UserSavedInCommunity(
                                                            community)));
                                          },
                                          child: Row(children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            snapshot.data[
                                                                'photoUrl']),
                                                    radius: 40)),
                                            Flexible(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  Text(community,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 3),
                                                  Text(
                                                      'Saved posts: $savedCount',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  SizedBox(height: 3),
                                                  Text(snapshot.data['about'],
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.grey),
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis)
                                                ]))
                                          ])));
                                } else
                                  return CircularProgressIndicator();
                              });
                        } else
                          return CircularProgressIndicator();
                      },
                    );
                  });
            } else
              return CircularProgressIndicator();
          }),
    );
  }
}

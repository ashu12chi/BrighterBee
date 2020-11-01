import 'package:brighter_bee/app_screens/admin_screens/verify_post.dart';
import 'package:brighter_bee/app_screens/admin_screens/verify_user.dart';
import 'package:brighter_bee/app_screens/community_screens/edit_community_details.dart';
import 'package:brighter_bee/widgets/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// @author: Ashutosh Chitranshi
// Oct 10, 2020
// This is profile of community and will be used to display certain information regarding community
// E.g. Visibility, privacy, Verification and creator

class CommunityProfile extends StatefulWidget {
  final community;

  CommunityProfile(this.community);

  @override
  _CommunityProfileState createState() => _CommunityProfileState(community);
}

class _CommunityProfileState extends State<CommunityProfile> {
  final community;
  String mediaUrl;
  String about;
  String creator;
  int privacy;
  int visibility;
  int posts;
  int verification;

  _CommunityProfileState(this.community);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        community,
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('communities')
                .doc(community)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();
              about = snapshot.data['about'];
              mediaUrl = snapshot.data['photoUrl'];
              posts = snapshot.data['posts'];
              visibility = snapshot.data['visibility'];
              privacy = snapshot.data['privacy'];
              verification = snapshot.data['verification'];
              creator = snapshot.data['creator'];
              return ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Text('About',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      about,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(privacy == 0 ? Icons.public : Icons.lock),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Privacy',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(visibility == 0
                            ? Icons.visibility
                            : Icons.visibility_off),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Visibility',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(posts == 1 ? Icons.people : Icons.person),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Posts',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(verification == 1 ? Icons.people : Icons.person),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Verification',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  FirebaseAuth.instance.currentUser.displayName == creator
                      ? Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Container(
                            height: 1.0,
                            width: double.infinity,
                            color: Colors.black12,
                          ),
                        )
                      : Container(),
                  FirebaseAuth.instance.currentUser.displayName == creator
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: FlatButton(
                            child: Text(
                              'Edit details',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditCommunityDetails(community)));
                            },
                          ),
                        )
                      : Container(),
                  FirebaseAuth.instance.currentUser.displayName == creator
                      ? Padding(padding: EdgeInsets.only(top: 8.0, bottom: 8.0))
                      : ((verification == 1 &&
                                  (snapshot.data['members']).contains(
                                      FirebaseAuth
                                          .instance.currentUser.displayName)) ||
                              snapshot.data['admin'].contains(FirebaseAuth
                                  .instance.currentUser.displayName))
                          ? Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0))
                          : Container(),
                  FirebaseAuth.instance.currentUser.displayName == creator
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: FlatButton(
                            child: Text(
                              'Verify Users',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VerifyUser(community)));
                            },
                          ),
                        )
                      : ((verification == 1 &&
                                  (snapshot.data['members']).contains(
                                      FirebaseAuth
                                          .instance.currentUser.displayName)) ||
                              snapshot.data['admin'].contains(FirebaseAuth
                                  .instance.currentUser.displayName))
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: FlatButton(
                                child: Text(
                                  'Verify Users',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).accentColor),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: Theme.of(context).accentColor)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VerifyUser(community)));
                                },
                              ),
                            )
                          : Container(),
                  FirebaseAuth.instance.currentUser.displayName == creator
                      ? Padding(padding: EdgeInsets.only(top: 8.0, bottom: 8.0))
                      : ((posts == 1 &&
                                  (snapshot.data['members']).contains(
                                      FirebaseAuth
                                          .instance.currentUser.displayName)) ||
                              snapshot.data['admin'].contains(FirebaseAuth
                                  .instance.currentUser.displayName))
                          ? Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Container(
                                height: 1.0,
                                width: double.infinity,
                                color: Colors.black12,
                              ),
                            )
                          : Container(),
                  FirebaseAuth.instance.currentUser.displayName == creator
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: FlatButton(
                            child: Text(
                              'Verify Posts',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VerifyPost(community)));
                            },
                          ),
                        )
                      : ((posts == 1 &&
                                  (snapshot.data['members']).contains(
                                      FirebaseAuth
                                          .instance.currentUser.displayName)) ||
                              snapshot.data['admin'].contains(FirebaseAuth
                                  .instance.currentUser.displayName))
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: FlatButton(
                                child: Text(
                                  'Verify Posts',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).accentColor),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: Theme.of(context).accentColor)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VerifyPost(community)));
                                },
                              ),
                            )
                          : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Container(
                      height: 1.0,
                      width: double.infinity,
                      color: Colors.black12,
                    ),
                  ),
                  UserCard(creator)
                ],
              );
            }),
      ),
    );
  }
}

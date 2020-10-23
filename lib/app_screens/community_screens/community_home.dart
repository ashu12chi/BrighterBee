import 'package:brighter_bee/app_screens/admin_screens/admin_control_pannel.dart';
import 'package:brighter_bee/helpers/community_join_leave.dart';
import 'package:brighter_bee/live_stream/live_list.dart';
import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'community_profile.dart';

class CommunityHome extends StatefulWidget {
  final community;

  CommunityHome(this.community);

  @override
  _CommunityHomeState createState() => _CommunityHomeState(community);
}

class _CommunityHomeState extends State<CommunityHome> {
  final community;
  String mediaUrl;
  String about;
  String creator;
  int privacy;
  int members;
  int visibility;
  int posts;
  int verification;
  bool processing;

  void initState() {
    super.initState();
    processing = false;
  }

  _CommunityHomeState(this.community);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          community,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.ondemand_video,
                color: Theme.of(context).buttonColor),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LiveList(community)));
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).buttonColor),
          ),
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Theme.of(context).buttonColor,
            ),
            onPressed: showOptions,
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('communities')
              .doc(community)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            mediaUrl = snapshot.data['photoUrl'];
            about = snapshot.data['about'];
            privacy = snapshot.data['privacy'];
            posts = snapshot.data['posts'];
            visibility = snapshot.data['visibility'];
            members = snapshot.data['memberCount'];
            verification = snapshot.data['verification'];
            creator = snapshot.data['creator'];
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CachedNetworkImage(
                        imageUrl: mediaUrl,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                  Center(
                      child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CommunityProfile(community)));
                      },
                      child: Column(
                        children: [
                          Text(
                            community,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                privacy == 0 ? Icons.public : Icons.lock,
                                color: Colors.grey,
                                size: 15,
                              ),
                              Text(
                                privacy == 0
                                    ? ' Public group  '
                                    : ' Private group ',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              Text(
                                '$members Members',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: FirebaseAuth.instance.currentUser.displayName ==
                            creator
                        ? FlatButton(
                            child: Text(
                              'Control Panel',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            minWidth: double.infinity,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdminControlPanel(community)));
                            },
                          )
                        : (snapshot.data['pendingMembers'].contains(
                                FirebaseAuth.instance.currentUser.displayName))
                            ? FlatButton(
                                child: Text(
                                  'Pending request',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).accentColor),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                        color: Theme.of(context).accentColor)),
                                minWidth: double.infinity,
                              )
                            : (snapshot.data['admin'].contains(FirebaseAuth
                                    .instance.currentUser.displayName))
                                ? FlatButton(
                                    child: Text(
                                      'Leave as Admin',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).accentColor),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).accentColor)),
                                    minWidth: double.infinity,
                                    onPressed: () {
                                      handleRemoveAdmin(
                                          community,
                                          FirebaseAuth.instance.currentUser
                                              .displayName);
                                    },
                                  )
                                : (snapshot.data['members'].contains(
                                        FirebaseAuth
                                            .instance.currentUser.displayName))
                                    ? Container()
                                    : FlatButton(
                                        child: Text(
                                          'Join Community',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .accentColor)),
                                        minWidth: double.infinity,
                                        onPressed: () async {
                                          if (processing) return;
                                          await handleJoinRequest(
                                              community,
                                              FirebaseAuth.instance.currentUser
                                                  .displayName);
                                          processing = false;
                                        },
                                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Container(
                      height: 5.0,
                      width: double.infinity,
                      color: Colors.black12,
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('communities')
                        .doc(community)
                        .collection('posts')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot documentSnapshot =
                                    snapshot.data.docs[index];
                                return Column(
                                  children: [
                                    PostCardView(
                                        community, documentSnapshot.id),
                                  ],
                                );
                              },
                            );
                    },
                  )
                ],
              ),
            );
          }),
    );
  }

  showOptions() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: LimitedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.share,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Share',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            onPressed: () async {
                              if (FirebaseAuth
                                      .instance.currentUser.displayName ==
                                  creator) {
                                Fluttertoast.showToast(
                                    msg:
                                        'Creator can not leave their community');
                                return;
                              }
                              await handleLeave(
                                  community,
                                  FirebaseAuth
                                      .instance.currentUser.displayName);
                            },
                            icon: Icon(Icons.exit_to_app,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Leave Community',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.report,
                                size: 30,
                                color: Theme.of(context).buttonColor)),
                        Text(
                          'Report',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}

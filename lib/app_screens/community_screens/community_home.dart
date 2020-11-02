import 'dart:io';

import 'package:brighter_bee/app_screens/admin_screens/admin_control_panel.dart';
import 'package:brighter_bee/app_screens/community_screens/post_search_in_community.dart';
import 'package:brighter_bee/helpers/community_join_leave_report_admin.dart';
import 'package:brighter_bee/live_stream/live_list.dart';
import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart';
import 'package:share/share.dart';

import 'community_profile.dart';

// @author: Ashutosh Chitranshi
// Oct 10, 2020
// This is home page of a community, all it's post is displayed in community home.

class CommunityHome extends StatefulWidget {
  final community;

  CommunityHome(this.community);

  @override
  _CommunityHomeState createState() => _CommunityHomeState(community);
}

class _CommunityHomeState extends State<CommunityHome> {
  final community;
  String username;
  String mediaUrl;
  String about;
  String creator;
  int privacy;
  int memberCount;
  int visibility;
  int posts;
  int verification;
  bool processing;
  bool reported;
  List members;
  PostListBloc postListBloc;
  ScrollController controller = ScrollController();
  int selectedSort;

  void initState() {
    super.initState();
    processing = false;
    selectedSort = 0;
    username = FirebaseAuth.instance.currentUser.displayName;
  }

  void scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      postListBloc.fetchNextPosts();
    }
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
            tooltip: 'Start live stream',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LiveList(community)));
            },
          ),
          IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search posts in $community',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PostSearchInCommunity(community)));
              }),
          IconButton(
            tooltip: 'More options',
            icon: Icon(
              Icons.more_horiz,
              color: Theme.of(context).buttonColor,
            ),
            onPressed: () {
              showOptions(creator, username, reported);
            },
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
            memberCount = snapshot.data['memberCount'];
            members = snapshot.data['members'];
            verification = snapshot.data['verification'];
            creator = snapshot.data['creator'];
            reported = snapshot.data['reporters'].contains(username);
            postListBloc = PostListBloc(selectedSort, community);
            postListBloc.fetchFirstList();
            controller.addListener(scrollListener);

            bool isPrivate = privacy == 1;
            bool isMember = members.contains(username) || (creator == username);

            return RefreshIndicator(
                onRefresh: postListBloc.fetchFirstList,
                child: SingleChildScrollView(
                  controller: controller,
                  physics: BouncingScrollPhysics(),
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
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Text(
                                    '$memberCount Members',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
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
                                    FirebaseAuth
                                        .instance.currentUser.displayName))
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
                                            color:
                                                Theme.of(context).accentColor)),
                                    minWidth: double.infinity,
                                  )
                                : (snapshot.data['admin'].contains(FirebaseAuth
                                        .instance.currentUser.displayName))
                                    ? FlatButton(
                                        child: Text(
                                          'Leave as Admin',
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
                                        onPressed: () {
                                          handleRemoveAdmin(
                                              community,
                                              FirebaseAuth.instance.currentUser
                                                  .displayName);
                                        },
                                      )
                                    : (snapshot.data['members'].contains(
                                            FirebaseAuth.instance.currentUser
                                                .displayName))
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
                                                  FirebaseAuth.instance
                                                      .currentUser.displayName);
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
                      (!isPrivate || isMember)
                          ? Column(children: [
                              SingleChildScrollView(
                                  padding: EdgeInsets.all(8),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ChoiceChip(
                                        selectedColor:
                                            Theme.of(context).accentColor,
                                        elevation: 10,
                                        onSelected: (value) {
                                          setState(() {
                                            selectedSort = 0;
                                          });
                                        },
                                        label: Text('Latest',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor)),
                                        selected: selectedSort == 0,
                                      ),
                                      SizedBox(width: 5),
                                      ChoiceChip(
                                        selectedColor:
                                            Theme.of(context).accentColor,
                                        elevation: 10,
                                        onSelected: (value) {
                                          setState(() {
                                            selectedSort = 1;
                                          });
                                        },
                                        label: Text('Hot',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor)),
                                        selected: selectedSort == 1,
                                      ),
                                      SizedBox(width: 5),
                                      ChoiceChip(
                                        selectedColor:
                                            Theme.of(context).accentColor,
                                        elevation: 10,
                                        onSelected: (value) {
                                          setState(() {
                                            selectedSort = 2;
                                          });
                                        },
                                        label: Text('Most upvoted',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor)),
                                        selected: selectedSort == 2,
                                      ),
                                      SizedBox(width: 5),
                                      ChoiceChip(
                                        selectedColor:
                                            Theme.of(context).accentColor,
                                        elevation: 10,
                                        onSelected: (value) {
                                          setState(() {
                                            selectedSort = 3;
                                          });
                                        },
                                        label: Text('Most viewed',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor)),
                                        selected: selectedSort == 3,
                                      ),
                                    ],
                                  )),
                              StreamBuilder<List<DocumentSnapshot>>(
                                stream: postListBloc.postStream,
                                builder: (context, snapshot) {
                                  return snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot documentSnapshot =
                                                snapshot.data[index];
                                            return PostCardView(community,
                                                documentSnapshot.id, true);
                                          },
                                        );
                                },
                              )
                            ])
                          : Center(
                              child: Text(
                                  'Community is private, join to view posts',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            )
                    ],
                  ),
                ));
          }),
    );
  }

  // This will help in building bottom sheet
  showOptions(String creator, String username, bool reported) {
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
                                size: 30, color: Theme.of(context).buttonColor),
                            onPressed: () async {
                              String msg =
                                  'Check out this community I found on BrighterBee: $community . BrighterBee is an app to share your ideas among a community of people of your type, download the app here: https://bit.ly/35uR0uy';
                              await Share.share(msg);
                              Navigator.pop(context);
                            }),
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
                    (username == creator || community == 'BrighterBee')
                        ? Container()
                        : reported
                            ? Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.report,
                                        size: 30, color: Colors.green),
                                    onPressed: () async {
                                      await undoReport(community, username);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    'Remove Report',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.report,
                                        size: 30,
                                        color: Theme.of(context).errorColor),
                                    onPressed: () async {
                                      await report(community, username);
                                      Navigator.pop(context);
                                    },
                                  ),
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

class PostListBloc {
  int selectedSort;
  String community;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;
  BehaviorSubject<bool> showIndicatorController;
  BehaviorSubject<List<DocumentSnapshot>> postController;

  PostListBloc(this.selectedSort, this.community) {
    showIndicatorController = BehaviorSubject<bool>();
    postController = BehaviorSubject<List<DocumentSnapshot>>();
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get postStream => postController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList() async {
    if (!showIndicator) {
      try {
        updateIndicator(true);
        documentList = (await getQuery().limit(5).get()).docs;
        postController.sink.add(documentList);
        updateIndicator(false);
      } on SocketException {
        updateIndicator(false);
        postController.sink.addError(SocketException("No Internet Connection"));
      } catch (e) {
        print(e.toString());
        updateIndicator(false);
        postController.sink.addError(e);
      }
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextPosts() async {
    if (!showIndicator) {
      try {
        updateIndicator(true);
        List<DocumentSnapshot> newDocumentList = (await getQuery()
                .startAfterDocument(documentList[documentList.length - 1])
                .limit(5)
                .get())
            .docs;
        documentList.addAll(newDocumentList);
        postController.sink.add(documentList);
        updateIndicator(false);
      } on SocketException {
        updateIndicator(false);
        postController.sink.addError(SocketException("No Internet Connection"));
      } catch (e) {
        updateIndicator(false);
        print(e.toString());
        postController.sink.addError(e);
      }
    }
  }

  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    postController.close();
    showIndicatorController.close();
  }

  /*
  * 0 -> latest
  * 1 -> hot
  * 2 -> most upvoted
  * 3 -> most viewed
   */

  Query getQuery() {
    switch (selectedSort) {
      case 0:
        return FirebaseFirestore.instance
            .collection('communities/$community/posts')
            .where('isVerified', isEqualTo: true)
            .orderBy('time', descending: true);
        break;
      case 1:
        return FirebaseFirestore.instance
            .collection('communities/$community/posts')
            .where('isVerified', isEqualTo: true)
            .orderBy('weight', descending: true);
        break;
      case 2:
        return FirebaseFirestore.instance
            .collection('communities/$community/posts')
            .where('isVerified', isEqualTo: true)
            .orderBy('upvotes', descending: true);
        break;
      case 3:
        return FirebaseFirestore.instance
            .collection('communities/$community/posts')
            .where('isVerified', isEqualTo: true)
            .orderBy('views', descending: true);
        break;
    }
    debugPrint('Unexpected sorting selected');
    return null;
  }
}

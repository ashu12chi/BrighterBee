import 'dart:io';

import 'package:brighter_bee/app_screens/admin_screens/admin_control_panel.dart';
import 'package:brighter_bee/helpers/community_join_leave.dart';
import 'package:brighter_bee/live_stream/live_list.dart';
import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart';

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
  PostListBloc postListBloc;
  ScrollController controller = ScrollController();
  int selectedSort;

  void initState() {
    super.initState();
    processing = false;
    selectedSort = 0;
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

            postListBloc = PostListBloc(selectedSort, community);
            postListBloc.fetchFirstList();
            controller.addListener(scrollListener);

            return RefreshIndicator(
                onRefresh: postListBloc.fetchFirstList,
                child: SingleChildScrollView(
                  controller: controller,
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
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Text(
                                    '$members Members',
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
                      SingleChildScrollView(
                          padding: EdgeInsets.all(8),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChoiceChip(
                                selectedColor: Theme.of(context).accentColor,
                                elevation: 10,
                                onSelected: (value) {
                                  setState(() {
                                    selectedSort = 0;
                                  });
                                },
                                label: Text('Latest',
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor)),
                                selected: selectedSort == 0,
                              ),
                              SizedBox(width: 5),
                              ChoiceChip(
                                selectedColor: Theme.of(context).accentColor,
                                elevation: 10,
                                onSelected: (value) {
                                  setState(() {
                                    selectedSort = 1;
                                  });
                                },
                                label: Text('Hot',
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor)),
                                selected: selectedSort == 1,
                              ),
                              SizedBox(width: 5),
                              ChoiceChip(
                                selectedColor: Theme.of(context).accentColor,
                                elevation: 10,
                                onSelected: (value) {
                                  setState(() {
                                    selectedSort = 2;
                                  });
                                },
                                label: Text('Most upvoted',
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor)),
                                selected: selectedSort == 2,
                              ),
                              SizedBox(width: 5),
                              ChoiceChip(
                                selectedColor: Theme.of(context).accentColor,
                                elevation: 10,
                                onSelected: (value) {
                                  setState(() {
                                    selectedSort = 3;
                                  });
                                },
                                label: Text('Most viewed',
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor)),
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
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot documentSnapshot =
                                        snapshot.data[index];
                                    return PostCardView(
                                        community, documentSnapshot.id);
                                  },
                                );
                        },
                      )
                    ],
                  ),
                ));
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
    try {
      documentList = (await getQuery().limit(5).get()).docs;
      postController.sink.add(documentList);
    } on SocketException {
      postController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      postController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextPosts() async {
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
      postController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      postController.sink.addError(e);
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

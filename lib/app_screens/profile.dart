import 'dart:io';

import 'package:brighter_bee/app_screens/photo_viewer.dart';
import 'package:brighter_bee/app_screens/user_app_screens/edit_details.dart';
import 'package:brighter_bee/app_screens/user_app_screens/user_posts_search.dart';
import 'package:brighter_bee/helpers/user_follow_unfollow_report.dart';
import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

// @author: Nishchal Siddharth Pandey,Ashutosh Chitranshi
// Oct 12, 2020
// This will be used for displaying profile of a user

class Profile extends StatefulWidget {
  final String _username;

  Profile(this._username);

  @override
  _ProfileState createState() => _ProfileState(_username);
}

class _ProfileState extends State<Profile> {
  User user;
  String username;
  bool processing;
  int selectedSort;
  PostListBloc postListBloc;
  ScrollController controller = ScrollController();
  int previousSnapshotLength;

  _ProfileState(this.username);

  @override
  void initState() {
    super.initState();
    processing = false;
    user = FirebaseAuth.instance.currentUser;
    selectedSort = 0;
    previousSnapshotLength = 0;
  }

  void scrollListener() {
    if (controller.position.extentAfter < 400) {
      debugPrint('At bottom!');
      postListBloc.fetchNextPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserPostSearch(username)));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey)),
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Search posts by $username',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('communities').get(),
            builder: (context, snapshot) {
              if (snapshot.data == null) return CircularProgressIndicator();
              List publicCommunities = [];
              List<QueryDocumentSnapshot> docs = snapshot.data.docs;
              docs.forEach((doc) {
                if (doc.get('privacy') == 0) publicCommunities.add(doc.id);
              });

              return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(username)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      postListBloc = PostListBloc(
                          selectedSort, publicCommunities, username);
                      postListBloc.fetchFirstList();
                      controller.addListener(scrollListener);
                      return ListView(
                        physics: BouncingScrollPhysics(),
                        controller: controller,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PhotoViewerCached(snapshot.data
                                              .data()['photoUrl'])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        snapshot.data.data()['photoUrl']),
                                    radius: 150.0,
                                    backgroundColor: Colors.grey,
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Center(
                                child: Text(
                              snapshot.data.data()['name'],
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            child: Center(
                                child: Text('(@$username)',
                                    softWrap: true,
                                    style: TextStyle(fontSize: 18))),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Center(
                                child: Text(
                              snapshot.data.data()['motto'],
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Container(
                              height: 1.0,
                              width: double.infinity,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.home),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      'Lives in ${snapshot.data['currentCity']}, India',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      'From ${snapshot.data['homeTown']}, India',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.access_time),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      'Joined ${DateTime.fromMillisecondsSinceEpoch(snapshot.data['time']).year}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.check_box),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      'Followed by ${snapshot.data['followersCount']} people',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.wallet_membership),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      'Member of ${snapshot.data['communityCount']} communities',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                String url = snapshot.data['website']
                                    .replaceAll('https://', '')
                                    .replaceAll('http://', '');
                                url = Uri.https('', url).toString();
                                try {
                                  await launch(url);
                                } catch (e) {
                                  Fluttertoast.showToast(
                                      msg: 'Cannot launch: $url');
                                  debugPrint(e);
                                }
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 8),
                                  child: Row(children: <Widget>[
                                    Icon(Icons.link),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            child: Text(
                                                snapshot.data['website'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    decoration: TextDecoration
                                                        .underline))))
                                  ]))),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8, bottom: 8),
                            child: (username == user.displayName)
                                ? FlatButton(
                                    child: Text(
                                      'Edit details',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).accentColor),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).accentColor)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditDetails()));
                                    },
                                  )
                                : (snapshot.data['followersList']
                                        .contains(user.displayName))
                                    ? FlatButton(
                                        child: Text(
                                          'Unfollow $username',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .accentColor)),
                                        onPressed: () async {
                                          if (processing) return;
                                          processing = true;
                                          await handleUnfollow(
                                              user.displayName, username);
                                          processing = false;
                                        },
                                      )
                                    : FlatButton(
                                        child: Text(
                                          'Follow $username',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .accentColor)),
                                        onPressed: () async {
                                          if (processing) return;
                                          processing = true;
                                          await handleFollow(
                                              user.displayName, username);
                                          processing = false;
                                        },
                                      ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: (username != user.displayName)
                                ? snapshot.data['reporters']
                                        .contains(user.displayName)
                                    ? FlatButton(
                                        child: Text(
                                          'Remove Report',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Colors.green)),
                                        onPressed: () async {
                                          await undoReport(
                                              username, user.displayName);
                                        },
                                      )
                                    : FlatButton(
                                        child: Text(
                                          'Report User',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .accentColor)),
                                        onPressed: () async {
                                          await report(
                                              username, user.displayName);
                                        },
                                      )
                                : Container(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              height: 1.0,
                              width: double.infinity,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Public posts by @$username',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Container(
                              height: 1.0,
                              width: double.infinity,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
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
                                            color:
                                                Theme.of(context).buttonColor)),
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
                                            color:
                                                Theme.of(context).buttonColor)),
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
                                            color:
                                                Theme.of(context).buttonColor)),
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
                                            color:
                                                Theme.of(context).buttonColor)),
                                    selected: selectedSort == 3,
                                  ),
                                ],
                              )),
                          StreamBuilder<List<DocumentSnapshot>>(
                            stream: postListBloc.postStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              else {
                                int presentLength = snapshot.data.length;
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot documentSnapshot =
                                          snapshot.data[index];
                                      String id = documentSnapshot.id;
                                      debugPrint('${snapshot.data.length}');
                                      return Column(children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: PostCardView(
                                                documentSnapshot
                                                    .get('community'),
                                                id,
                                                true)),
                                        (index != snapshot.data.length - 1)
                                            ? Container()
                                            : buildProgressIndicator(
                                                presentLength)
                                      ]);
                                    });
                              }
                            },
                          )
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  });
            }));
  }

  buildProgressIndicator(int presentLength) {
    if (presentLength != previousSnapshotLength) {
      previousSnapshotLength = presentLength;
      return CircularProgressIndicator();
    } else {
      return Container();
    }
  }
}

class PostListBloc {
  final int selectedSort;
  final List publicCommunities;
  final String username;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;
  BehaviorSubject<bool> showIndicatorController;
  BehaviorSubject<List<DocumentSnapshot>> postController;

  PostListBloc(this.selectedSort, this.publicCommunities, this.username) {
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
        updateIndicator(false);
        print(e.toString());
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
        postController.sink.addError(SocketException("No Internet Connection"));
      } catch (e) {
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
    if (username == FirebaseAuth.instance.currentUser.displayName)
      switch (selectedSort) {
        case 0:
          return FirebaseFirestore.instance
              .collectionGroup('posts')
              .where('isVerified', isEqualTo: true)
              .where('creator', isEqualTo: username)
              .orderBy('time', descending: true);
          break;
        case 1:
          return FirebaseFirestore.instance
              .collectionGroup('posts')
              .where('isVerified', isEqualTo: true)
              .where('creator', isEqualTo: username)
              .orderBy('weight', descending: true);
          break;
        case 2:
          return FirebaseFirestore.instance
              .collectionGroup('posts')
              .where('isVerified', isEqualTo: true)
              .where('creator', isEqualTo: username)
              .orderBy('upvotes', descending: true);
          break;
        case 3:
          return FirebaseFirestore.instance
              .collectionGroup('posts')
              .where('isVerified', isEqualTo: true)
              .where('creator', isEqualTo: username)
              .orderBy('views', descending: true);
          break;
      }
    else
      switch (selectedSort) {
        case 0:
          return FirebaseFirestore.instance
              .collectionGroup('posts')
              .where('isVerified', isEqualTo: true)
              .where('community', whereIn: publicCommunities)
              .where('creator', isEqualTo: username)
              .orderBy('time', descending: true);
          break;
        case 1:
          return FirebaseFirestore.instance
              .collectionGroup('posts')
              .where('isVerified', isEqualTo: true)
              .where('community', whereIn: publicCommunities)
              .where('creator', isEqualTo: username)
              .orderBy('weight', descending: true);
          break;
        case 2:
          return FirebaseFirestore.instance
              .collectionGroup('posts')
              .where('isVerified', isEqualTo: true)
              .where('community', whereIn: publicCommunities)
              .where('creator', isEqualTo: username)
              .orderBy('upvotes', descending: true);
          break;
        case 3:
          return FirebaseFirestore.instance
              .collectionGroup('posts')
              .where('isVerified', isEqualTo: true)
              .where('community', whereIn: publicCommunities)
              .where('creator', isEqualTo: username)
              .orderBy('views', descending: true);
          break;
      }
    debugPrint('Unexpected sorting selected');
    return null;
  }
}

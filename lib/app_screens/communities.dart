import 'dart:io';

import 'package:brighter_bee/app_screens/community_screens/create_community.dart';
import 'package:brighter_bee/app_screens/user_app_screens/user_communities.dart';
import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'community_screens/community_search.dart';
import 'community_screens/discover_community.dart';


// @author : Ashutosh Chitranshi, Nishchal Siddharth Pandey
// Oct 6, 2020
// This is community tab of the app

class Communities extends StatefulWidget {
  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities>
    with AutomaticKeepAliveClientMixin {
  User user;
  int selectedSort;
  List memberOf;
  PostListBloc postListBloc;
  ScrollController controller = ScrollController();
  int previousSnapshotLength;

  @override
  void initState() {
    super.initState();
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
    super.build(context);
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.displayName)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        memberOf = snapshot.data.data()['communityList'];
        postListBloc = PostListBloc(selectedSort, memberOf);
        postListBloc.fetchFirstList();
        controller.addListener(scrollListener);
        return RefreshIndicator(
            onRefresh: postListBloc.fetchFirstList,
            child: SingleChildScrollView(
                controller: controller,
                physics: BouncingScrollPhysics(),
                child: Column(children: [
                  AppBar(
                    title: Text('Communities',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.search),
                        tooltip: 'Search communities',
                        iconSize: 30.0,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommunitySearch()));
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserCommunities()));
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.people,
                            ),
                            Text(
                              'Added',
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey)),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext) =>
                                      DiscoverCommunity()));
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.explore,
                            ),
                            Text(
                              'Discover',
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey)),
                      ),
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add_circle,
                            ),
                            Text(
                              'Create',
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateGroup()));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey)),
                      )
                    ],
                  ),
                  SingleChildScrollView(
                      padding: EdgeInsets.all(8),
                      physics: BouncingScrollPhysics(),
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
                      if (snapshot.connectionState == ConnectionState.waiting)
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
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: PostCardView(
                                        documentSnapshot.get('community'),
                                        id,
                                        true)),
                                (index != snapshot.data.length - 1)
                                    ? Container()
                                    : buildProgressIndicator(presentLength)
                              ]);
                            });
                      }
                    },
                  ),
                ])));
      },
    ));
  }

  buildProgressIndicator(int presentLength) {
    if (presentLength != previousSnapshotLength) {
      previousSnapshotLength = presentLength;
      return CircularProgressIndicator();
    } else {
      return Container();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class PostListBloc {
  int selectedSort;
  List memberOf;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;
  BehaviorSubject<bool> showIndicatorController;
  BehaviorSubject<List<DocumentSnapshot>> postController;

  PostListBloc(this.selectedSort, this.memberOf) {
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
    switch (selectedSort) {
      case 0:
        return FirebaseFirestore.instance
            .collectionGroup('posts')
            .where('isVerified', isEqualTo: true)
            .where('community', whereIn: memberOf)
            .orderBy('time', descending: true);
        break;
      case 1:
        return FirebaseFirestore.instance
            .collectionGroup('posts')
            .where('isVerified', isEqualTo: true)
            .where('community', whereIn: memberOf)
            .orderBy('weight', descending: true);
        break;
      case 2:
        return FirebaseFirestore.instance
            .collectionGroup('posts')
            .where('isVerified', isEqualTo: true)
            .where('community', whereIn: memberOf)
            .orderBy('upvotes', descending: true);
        break;
      case 3:
        return FirebaseFirestore.instance
            .collectionGroup('posts')
            .where('isVerified', isEqualTo: true)
            .where('community', whereIn: memberOf)
            .orderBy('views', descending: true);
        break;
    }
    debugPrint('Unexpected sorting selected');
    return null;
  }
}

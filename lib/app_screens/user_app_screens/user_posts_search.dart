import 'dart:io';

import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UserPostSearch extends StatefulWidget {
  final String _username;

  UserPostSearch(this._username);

  @override
  _UserPostSearchState createState() => _UserPostSearchState(_username);
}

class _UserPostSearchState extends State<UserPostSearch> {
  TextEditingController searchController = TextEditingController();
  User user;
  String username;
  List publicCommunities;
  PostListBloc postListBloc;
  ScrollController controller = ScrollController();
  int previousSnapshotLength;

  _UserPostSearchState(this.username);

  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    searchController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (controller.position.extentAfter < 400) {
      debugPrint('At bottom!');
      postListBloc.fetchNextPosts();
    }
  }

  searchBarListener() {
    setState(() {
      postListBloc = PostListBloc(
          searchController.text.toLowerCase(), publicCommunities, username);
    });
    postListBloc.fetchFirstList();
  }

  void initState() {
    super.initState();
    previousSnapshotLength = 0;
    searchController.addListener(searchBarListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search posts of $username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('communities').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                if (snapshot.data == null) return CircularProgressIndicator();
                publicCommunities = [];
                List<QueryDocumentSnapshot> docs = snapshot.data.docs;
                docs.forEach((doc) {
                  if (doc.get('privacy') == 0) publicCommunities.add(doc.id);
                });
                postListBloc = PostListBloc(searchController.text.toLowerCase(),
                    publicCommunities, username);
                postListBloc.fetchFirstList();
                controller.addListener(scrollListener);
                return StreamBuilder<List<DocumentSnapshot>>(
                    stream: postListBloc.postStream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        int presentLength = snapshot.data.length;
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            controller: controller,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot =
                                  snapshot.data[index];
                              String id = documentSnapshot.id;
                              debugPrint('${snapshot.data.length}');
                              return Column(
                                children: [
                                  PostCardView(
                                    documentSnapshot.data()['community'],
                                    id,
                                    false,
                                  ),
                                  (index != snapshot.data.length - 1)
                                      ? Container()
                                      : buildProgressIndicator(presentLength)
                                ],
                              );
                            });
                      } else {
                        return Container();
                      }
                    });
              }
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
  List publicCommunities;
  String searchText;
  String username;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;
  BehaviorSubject<bool> showIndicatorController;
  BehaviorSubject<List<DocumentSnapshot>> postController;

  PostListBloc(this.searchText, this.publicCommunities, this.username) {
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
        documentList = (await getQuery().limit(10).get()).docs;
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
                .limit(10)
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

  Query getQuery() {
    return FirebaseFirestore.instance
        .collectionGroup('posts')
        .where('isVerified', isEqualTo: true)
        .where('community', whereIn: publicCommunities)
        .where('titleSearch', arrayContains: searchText)
        .where('creator', isEqualTo: username)
        .orderBy('time', descending: true);
  }
}

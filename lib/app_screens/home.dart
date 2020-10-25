import 'package:brighter_bee/app_screens/create_post.dart';
import 'package:brighter_bee/app_screens/profile.dart';
import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> memberOf = ["Mathematics", "Physics"];
    return Scaffold(
        body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(user.photoURL),
                        radius: 25.0,
                        backgroundColor: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Profile(user.displayName)));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        height: 55.0,
                        child: FlatButton(
                          child: Text(
                            'Write something here...           ',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 18.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreatePost()));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('posts')
                    .where('isVerified', isEqualTo: true)
                    .where('community', whereIn: memberOf)
                    .orderBy('time', descending: true)
                    .limit(10)
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
                            String id = documentSnapshot.id;
                            return PostCardView(
                                documentSnapshot.get('community'), id);
                          });
                },
              ),
            ])));
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:brighter_bee/live_stream/live_list.dart';
import 'package:brighter_bee/widgets/post_card_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'community_profile.dart';

class CommunityHome extends StatefulWidget {
  final community;
  final mediaUrl;
  final about;
  final int privacy;
  final int members;
  final int visibility;
  final int posts;
  final int verification;


  CommunityHome(this.community,this.mediaUrl,this.privacy,this.members,this.visibility,this.posts,this.verification,this.about);

  @override
  _CommunityHomeState createState() => _CommunityHomeState(community,mediaUrl,privacy,members,visibility,posts,verification,about);
}

class _CommunityHomeState extends State<CommunityHome> {
  final community;
  final mediaUrl;
  final about;
  int privacy;
  int members;
  int visibility;
  int posts;
  int verification;

  _CommunityHomeState(this.community,this.mediaUrl,this.privacy,this.members,this.visibility,this.posts,this.verification,this.about);

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
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    mediaUrl,
                    fit: BoxFit.fill,
                    height: 200,
                  ),
                ],
              ),
            ),
            Center(
                child: Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommunityProfile(community,mediaUrl,privacy,members,visibility,posts,verification,about)));
                },
                child: Column(
                  children: [
                    Text(
                      community,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          privacy==0?Icons.public:Icons.lock,
                          color: Colors.grey,
                          size: 15,
                        ),
                        Text(
                          privacy==0?' Public group  ':' Private group ',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          '$members Members',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )),
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
                              PostCardView(community, documentSnapshot.id),
                            ],
                          );
                        },
                      );
              },
            )
          ],
        ),
      ),
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

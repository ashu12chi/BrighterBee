import 'package:brighter_bee/app_screens/post_card_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'community_profile.dart';

class CommunityHome extends StatefulWidget {
  @override
  _CommunityHomeState createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHome> {

  String mediaUrl = 'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/thumbnails%2Fthumbnail_video_default.png?alt=media&token=110cba28-6dd5-4656-8eca-cbefe9cce925';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search,color: Colors.grey,),),
          IconButton(
            icon: Icon(Icons.more_horiz,color: Colors.grey,),
            onPressed: showOptions,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding:
              const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
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
                child: Card (
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CommunityProfile()));
                    },
                    child: Column(
              children: [
                    Text('Mathematics',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.public,color: Colors.grey,size: 15,),
                        Text(' Public group  ',style: TextStyle(color: Colors.grey,fontSize: 15),),
                        Text('12 Members',style: TextStyle(color: Colors.grey,fontSize: 15),)
                      ],
                    )
              ],
            ),
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                height: 5.0,
                width: double.infinity,
                color: Colors.black12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:4.0,right: 4.0),
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: FlatButton(
                  child: Text('Write something here...',style: TextStyle(color: Colors.grey,fontSize: 18),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.black12),
                  ),
                  onPressed: (){

                  },
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('communities').doc('Mathematics').collection('posts').snapshots(),
              builder: (context,snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                  child: CircularProgressIndicator(),
                ):ListView.builder(
                  //scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                    snapshot.data.docs[index];
                    print(documentSnapshot.id);
                    print('112');
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Container(
                              height: 5.0,
                              width: double.infinity,
                              color: Colors.black12,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: SizedBox(
                              height: 530,
                              child: PostCardView('Mathematics',documentSnapshot.id)
                            ),
                          ),
                        ],
                      );
                  //return Text('ashu12_chi');
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
                  child: LimitedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.share,size: 30,color: Colors.black,)),
                            Text('Share',style: TextStyle(fontSize: 18),),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.exit_to_app,size: 30,color: Colors.black,)),
                            Text('Leave Community',style: TextStyle(fontSize: 18),),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.report,size: 30,color: Colors.black,)),
                            Text('Report',style: TextStyle(fontSize: 18),),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }
}

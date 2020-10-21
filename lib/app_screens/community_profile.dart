import 'package:brighter_bee/app_screens/edit_community_details.dart';
import 'package:brighter_bee/app_screens/verify_post.dart';
import 'package:brighter_bee/app_screens/verify_user.dart';
import 'package:flutter/material.dart';

class CommunityProfile extends StatefulWidget {

  final community;
  final mediaUrl;
  final about;
  final int privacy;
  final int members;
  final int visibility;
  final int posts;
  final int verification;


  CommunityProfile(this.community,this.mediaUrl,this.privacy,this.members,this.visibility,this.posts,this.verification,this.about);

  @override
  _CommunityProfileState createState() => _CommunityProfileState(community,mediaUrl,privacy,members,visibility,posts,verification,about);
}

class _CommunityProfileState extends State<CommunityProfile> {

  final community;
  final mediaUrl;
  final about;
  final int privacy;
  final int members;
  final int visibility;
  final int posts;
  final int verification;


  _CommunityProfileState(this.community,this.mediaUrl,this.privacy,this.members,this.visibility,this.posts,this.verification,this.about);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(community)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Text('About',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                  Icon(privacy==0?Icons.public:Icons.lock),
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
                  Icon(visibility==0?Icons.visibility:Icons.visibility_off),
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
                  Icon(posts==1?Icons.people:Icons.person),
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
                  Icon(verification==1?Icons.people:Icons.person),
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
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.black12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: FlatButton(
                child: Text(
                  'Edit details',
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).accentColor),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Theme.of(context).accentColor)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditCommunityDetails(community)));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.black12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: FlatButton(
                child: Text(
                  'Verify Posts',
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).accentColor),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Theme.of(context).accentColor)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VerifyPost()));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.black12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: FlatButton(
                child: Text(
                  'Verify Users',
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).accentColor),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Theme.of(context).accentColor)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VerifyUser()));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Theme.of(context).dividerColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 3 - 10,
                  child: Card(),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 3 - 10,
                  child: Card(),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 3 - 10,
                  child: Card(),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.black12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

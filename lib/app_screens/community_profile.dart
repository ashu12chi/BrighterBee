import 'package:brighter_bee/app_screens/edit_community_details.dart';
import 'package:brighter_bee/app_screens/verify_post.dart';
import 'package:brighter_bee/app_screens/verify_user.dart';
import 'package:flutter/material.dart';

class CommunityProfile extends StatefulWidget {
  @override
  _CommunityProfileState createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<CommunityProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mathematics')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Text('About',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "This group is for propagating information regarding Mathematics and it's changing word.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.public),
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
                  Icon(Icons.visibility),
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
                  Icon(Icons.people),
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
                  Icon(Icons.person),
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
                          builder: (context) => EditCommunityDetails()));
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

import 'package:brighter_bee/app_screens/edit_details.dart';
import 'package:brighter_bee/app_screens/photo_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  String _username;

  Profile(this._username);

  @override
  _ProfileState createState() => _ProfileState(_username);
}

class _ProfileState extends State<Profile> {
  String username;
  _ProfileState(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.grey)),
          child: Row(
            children: <Widget>[
              Icon(Icons.search),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Search',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(username)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PhotoViewer(snapshot.data['photoUrl'])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              snapshot.data['photoUrl']),
                          radius: 150.0,
                          backgroundColor: Colors.grey,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    snapshot.data['name'],
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Center(
                      child: Text(
                    snapshot.data['motto'],
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 18),
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.home),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
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
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.check_box),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Text(
                            'Followed by 108 people',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.link),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Text(
                            snapshot.data['website'],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 8, bottom: 8),
                  child: (username ==
                          FirebaseAuth.instance.currentUser.displayName)
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
                                  color: Theme.of(context).accentColor)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditDetails()));
                          },
                        )
                      : FlatButton(
                          child: Text(
                            'Follow $username',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).accentColor),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditDetails()));
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
                Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                    child: Text(
                      'Communities',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
                    child: Text(
                      '23 communities',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    )),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width / 3 - 10,
                        child: Center(
                            child: Text(
                          'Flutter',
                          overflow: TextOverflow.ellipsis,
                        ))),
                    SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width / 3 - 10,
                        child: Center(
                            child: Text(
                          'Github',
                          softWrap: true,
                        ))),
                    SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width / 3 - 10,
                        child: Center(
                            child: Text(
                          'NP Devs',
                          softWrap: true,
                        )))
                  ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width / 3 - 10,
                        child: Center(
                            child: Text(
                          'Flutter',
                          softWrap: true,
                        ))),
                    SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width / 3 - 10,
                        child: Center(
                            child: Text(
                          'Github',
                          softWrap: true,
                        ))),
                    SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width / 3 - 10,
                        child: Center(
                            child: Text(
                          'NP Devs',
                          softWrap: true,
                        )))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Colors.black12,
                  ),
                ),
              ],
            );
          }),
    );
  }
}

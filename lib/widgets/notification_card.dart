import 'package:brighter_bee/app_screens/admin_screens/verify_user.dart';
import 'package:brighter_bee/app_screens/post_ui.dart';
import 'package:brighter_bee/app_screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// @author: Nishchal Sidddharth Pandey
// Oct 24, 2020
// This is notification card, will be used in displaying notification in list

class NotificationCard extends StatefulWidget {
  final String _key;
  final int _postRelated;

  NotificationCard(this._key, this._postRelated);

  @override
  _NotificationCardState createState() =>
      _NotificationCardState(_key, _postRelated);
}

class _NotificationCardState extends State<NotificationCard> {
  final String key;
  final int postRelated;

  _NotificationCardState(this.key, this.postRelated);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(
                postRelated == 1 ? 'notification' : 'pendingUserNotification')
            .doc(key)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Card(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  child: Card(
                    child: Text('User posted in Community'),
                    shape: RoundedRectangleBorder(),
                  ),
                  baseColor: Colors.grey,
                  highlightColor: Colors.black12,
                ),
                Shimmer.fromColors(
                  child: Card(
                    child: Text('Tap to verify the post'),
                    shape: RoundedRectangleBorder(),
                  ),
                  baseColor: Colors.grey,
                  highlightColor: Colors.black12,
                ),
                Shimmer.fromColors(
                  child: Card(
                    child: Text('2020 October 24, 11:54 AM'),
                    shape: RoundedRectangleBorder(),
                  ),
                  baseColor: Colors.grey,
                  highlightColor: Colors.black12,
                )
              ],
            ));
          return Card(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (postRelated == 1)
                              ? PostUI(snapshot.data.data()['community'],
                                  snapshot.data.data()['postId'])
                              : (snapshot.data.get('community') ==
                                      'BrighterBee')
                                  ? Profile(snapshot.data.get('creator'))
                                  : VerifyUser(
                                      snapshot.data.data()['community'])));
                },
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data['title'],
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            snapshot.data['body'],
                            style: TextStyle(color: Colors.grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            formatDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.data['time']),
                                [
                                  yyyy,
                                  ' ',
                                  MM,
                                  ' ',
                                  dd,
                                  ', ',
                                  hh,
                                  ':',
                                  nn,
                                  ' ',
                                  am
                                ]),
                            style: TextStyle(color: Colors.grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }
}

getProfileObject() {}

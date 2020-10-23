import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final String _key;
  final bool _postRelated;

  NotificationCard(this._key, this._postRelated);

  @override
  _NotificationCardState createState() =>
      _NotificationCardState(_key, _postRelated);
}

class _NotificationCardState extends State<NotificationCard> {
  final String key;
  final bool postRelated;
  _NotificationCardState(this.key, this.postRelated);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(
                postRelated ? 'notification' : 'pendingUserNotification')
            .doc(key)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          return Card(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data['title'],
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        snapshot.data['body'],
                        style: TextStyle(fontSize: 15, color: Colors.grey),
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
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

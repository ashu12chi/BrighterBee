import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*
* @author: Nishchal Siddharth Pandey
* 12 October, 2020
* This file has UI and code for commenting on a post or replying to a comment.
*/

class Comment extends StatefulWidget {
  String community;
  String dateLong;
  String postKey;
  String parentPostKey;
  String username;
  String title;
  String creator;
  bool isReply; // whether parent to this comment will be a comment or a post.

  Comment(this.community, this.dateLong, this.postKey, this.parentPostKey,
      this.username, this.title, this.creator, this.isReply);

  @override
  _Comment createState() => _Comment(community, dateLong, postKey,
      parentPostKey, username, title, creator, isReply);
}

class _Comment extends State<Comment> {
  String community;
  String dateLong;
  String key;
  String parentPostKey;
  String username;
  String title;
  String creator;
  bool isReply;
  TextEditingController textInputController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> users = [], words = [];
  String str = '';

  _Comment(this.community, this.dateLong, this.key, this.parentPostKey,
      this.username, this.title, this.creator, this.isReply);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Theme.of(context).buttonColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          isReply ? 'Reply to comment' : 'Add comment',
        ),
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Post',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: postComment,
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(children: <Widget>[
            Row(
              children: [
                Text(creator,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_right),
                Text(community,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    dateLong,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Expanded(
                child: TextField(
                    maxLines: 100,
                    controller: textInputController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: isReply ? 'Your reply' : 'Your comment',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                    onChanged: (val) {
                      setState(() {
                        words = val.split(' ');
                        str = words.length > 0 &&
                                words[words.length - 1].startsWith('@')
                            ? words[words.length - 1]
                            : '';
                      });
                    })),
          ])),
    );
  }

  postComment() async {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(hours: 1),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
          SizedBox(
            width: 15,
          ),
          Text("Posting...")
        ],
      ),
    ));
    var time = DateTime.now().millisecondsSinceEpoch;
    String commKey = 'C' + time.toString();
    FirebaseFirestore instance = FirebaseFirestore.instance;
    String commentText = textInputController.text;
    if (isReply) {
      await instance
          .collection(
              'communities/$community/posts/$parentPostKey/comments/$key/replies')
          .doc(commKey)
          .set({
        'time': time,
        'text': commentText,
        'creator': username,
        'upvoters': [],
        'upvotes': 0,
        'downvotes': 0,
        'downvoters': [],
        'commKey': commKey
      });
      await instance.runTransaction((transaction) async {
        DocumentReference postRef = instance
            .collection('communities/$community/posts')
            .doc(parentPostKey);
        transaction.update(postRef, {'commentCount': FieldValue.increment(1)});
        postRef = instance
            .collection('communities/$community/posts/$parentPostKey/comments')
            .doc(key);
        transaction.update(postRef, {'replyCount': FieldValue.increment(1)});
      });
      if (creator.compareTo(username) != 0) {
        String notificationId = (await instance.collection('notification').add({
          'title': "Your comment in $community has a reply",
          'body': commentText,
          'community': community,
          'creator': username,
          'postId': parentPostKey,
          'receiver': creator,
          'time': time
        }))
            .id;
        await instance
            .collection('users/$creator/notifications')
            .doc(notificationId)
            .set({});
      }
    } else {
      await instance
          .collection('communities/$community/posts/$parentPostKey/comments')
          .doc(commKey)
          .set({
        'time': time,
        'text': commentText,
        'creator': username,
        'upvoters': [],
        'upvotes': 0,
        'downvotes': 0,
        'downvoters': [],
        'commKey': commKey,
        'replyCount': 0,
      });
      await instance.runTransaction((transaction) async {
        DocumentReference postRef = instance
            .collection('communities/$community/posts')
            .doc(parentPostKey);
        transaction.update(postRef, {'commentCount': FieldValue.increment(1)});
      });
      if (creator.compareTo(username) != 0) {
        String notificationId = (await instance.collection('notification').add({
          'title': "Your post in $community has a comment",
          'body': commentText,
          'community': community,
          'creator': username,
          'postId': parentPostKey,
          'receiver': creator,
          'time': time
        }))
            .id;
        await instance
            .collection('users/$creator/notifications')
            .doc(notificationId)
            .set({'postRelated': 1});
      }
      await instance.collection('users/$username/comments').doc(commKey).set({
        'community': community,
        'commKey': commKey,
        'isReply': isReply,
        'parentPost': parentPostKey,
        'parent': key,
      });
    }

    commentText.split(' ').map((w) async {
      if (w.startsWith('@') && w.length > 1) {
        w = w.replaceAll('[^A-Za-z0-9]', '');
        if (w.compareTo(username) != 0) {
          String notificationId =
              (await instance.collection('notification').add({
            'title': "$username tagged you in a comment",
            'body': commentText,
            'community': community,
            'creator': username,
            'postId': parentPostKey,
            'receiver': w,
            'time': time
          }))
                  .id;
          await instance
              .collection('users/$w/notifications')
              .doc(notificationId)
              .set({'postRelated': 1});
        }
      }
    });

    _scaffoldKey.currentState.hideCurrentSnackBar();
    Navigator.pop(context);
  }
}

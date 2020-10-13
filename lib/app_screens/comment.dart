import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  String community;
  String dateLong;
  String postKey;
  String parentPostKey;
  String username;
  String title;
  String creator;
  bool isReply;

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
            )),
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
    var time = DateTime
        .now()
        .millisecondsSinceEpoch;
    String commKey = 'C' + time.toString();
    FirebaseFirestore instance = FirebaseFirestore.instance;
    if (isReply) {
      await instance
          .collection(
          'communities/$community/posts/$parentPostKey/comments/$key/replies')
          .doc(commKey)
          .set({
        'time': time,
        'text': textInputController.text,
        'creator': username,
        'parent': key,
        'community': community,
        'parentPost': parentPostKey,
        'upvoters': [],
        'downvoters': [],
        'commKey': commKey
      });
      await instance.runTransaction((transaction) async {
        DocumentReference postRef = instance
            .collection('communities/$community/posts')
            .doc(parentPostKey);
        await transaction
            .update(postRef, {'commentCount': FieldValue.increment(1)});
        postRef = instance
            .collection('communities/$community/posts/$parentPostKey/comments')
            .doc(key);
        await transaction
            .update(postRef, {'replyCount': FieldValue.increment(1)});
      });
    } else {
      await instance
          .collection('communities/$community/posts/$parentPostKey/comments')
          .doc(commKey)
          .set({
        'time': time,
        'text': textInputController.text,
        'creator': username,
        'parent': key,
        'community': community,
        'parentPost': parentPostKey,
        'upvoters': [],
        'downvoters': [],
        'commKey': commKey,
        'replyCount': 0,
      });
      await instance.runTransaction((transaction) async {
        DocumentReference postRef = instance
            .collection('communities/$community/posts')
            .doc(parentPostKey);
        await transaction
            .update(postRef, {'commentCount': FieldValue.increment(1)});
      });
    }

    await instance.collection('users/$username/comments').doc(commKey).set({
      'community': community,
      'commKey': commKey,
      'isReply': isReply,
      'parentPost': parentPostKey,
      'parent': key,
    });

    _scaffoldKey.currentState.hideCurrentSnackBar();
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  String community;
  String dateLong;
  String postKey;
  String username;
  String title;
  String creator;
  bool isComment;

  Comment(this.community, this.dateLong, this.postKey, this.username,
      this.title, this.creator, this.isComment);

  @override
  _Comment createState() => _Comment(
      community, dateLong, postKey, username, title, creator, isComment);
}

class _Comment extends State<Comment> {
  String community;
  String dateLong;
  String key;
  String username;
  String title;
  String creator;
  bool isComment;
  TextEditingController textInputController;

  _Comment(this.community, this.dateLong, this.key, this.username, this.title,
      this.creator, this.isComment);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isComment ? 'Reply to comment' : 'Add comment',
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
                hintText: isComment ? 'Your reply' : 'Your comment',
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

  postComment() {}
}

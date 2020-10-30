import 'package:brighter_bee/helpers/hotness_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*
* @author: Nishchal Siddharth Pandey
* 12 October, 2020
* This file has UI and code for updating comment on a post or reply on a comment.
*/

class EditComment extends StatefulWidget {
  final String _community;
  final String _dateLong;
  final String _postKey;
  final String _parentPostKey;
  final String _username;
  final String _title;
  final String _creator;
  final bool
      isReply; // whether parent to this comment will be a comment or a post.
  final String _initialText;
  final String _keyOfThis;

  EditComment(
      this._community,
      this._dateLong,
      this._postKey,
      this._parentPostKey,
      this._username,
      this._title,
      this._creator,
      this.isReply,
      this._initialText,
      this._keyOfThis);

  @override
  _EditComment createState() => _EditComment(
      _community,
      _dateLong,
      _postKey,
      _parentPostKey,
      _username,
      _title,
      _creator,
      isReply,
      _initialText,
      _keyOfThis);
}

class _EditComment extends State<EditComment> {
  String community;
  String dateLong;
  String key;
  String parentPostKey;
  String username;
  String title;
  String creator;
  bool isReply;
  String initialText;
  String keyOfThis;

  TextEditingController textInputController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> users = [], words = [];
  String str = '';

  @override
  void initState() {
    super.initState();
    textInputController.text = initialText;
  }

  _EditComment(
      this.community,
      this.dateLong,
      this.key,
      this.parentPostKey,
      this.username,
      this.title,
      this.creator,
      this.isReply,
      this.initialText,
      this.keyOfThis);

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
        title: Text(isReply ? 'Edit reply' : 'Edit comment',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Update',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor),
            ),
            onPressed: updateComment,
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
                    'Original: $title',
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
                    autofocus: true,
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
                        focusedErrorBorder: InputBorder.none),
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

  updateComment() async {
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
          Text("Updating comment...")
        ],
      ),
    ));
    var time = DateTime.now().millisecondsSinceEpoch;
    FirebaseFirestore instance = FirebaseFirestore.instance;
    String commentText = textInputController.text;
    if (isReply) {
      await instance
          .collection(
              'communities/$community/posts/$parentPostKey/comments/$key/replies')
          .doc(keyOfThis)
          .update({
        'lastModified': time,
        'text': commentText,
      });
    } else {
      await instance
          .collection('communities/$community/posts/$parentPostKey/comments')
          .doc(keyOfThis)
          .update({
        'lastModified': time,
        'text': commentText,
      });
    }
    _scaffoldKey.currentState.hideCurrentSnackBar();
    Navigator.pop(context);
  }
}

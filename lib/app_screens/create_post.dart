import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }
  @override
  Widget build(BuildContext context) {
    final editor = new ZefyrEditor(
      focusNode: _focusNode,
      controller: _controller,
      imageDelegate: MyAppZefyrImageDelegate(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton(
            child: Text('Post',style: TextStyle(color: Colors.black,fontSize: 18),),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            FlatButton(
              child: Text('Add to your post',style: TextStyle(color: Colors.black,fontSize: 18.0),),
                onPressed: () {
                  showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                    return Container(
                        child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: <Widget>[
                                FlatButton(
                                  child: Text('Add Image',style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  onPressed: () {

                                  },
                                ),
                                FlatButton(
                                  child: Text('Add Video',style: TextStyle(color: Colors.black,fontSize: 18.0),),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  onPressed: () {

                                  },
                                ),
                              ],
                            )
                        )
                    );
                  });
                }
            ),
            IconButton(icon: Icon(Icons.image),),
            IconButton(icon: Icon(Icons.video_call),)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(radius: 30.0,backgroundColor: Colors.grey,),
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Column(
                    children: <Widget>[
                      Text('Ashutosh Chitranshi',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),),
                      MaterialButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.people),
                            Text('Communities'),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                        textColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.grey)
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
              Expanded (
              child: ZefyrScaffold(
                child: editor,
              ),
            )
          ],
        ),
      ),
    );
  }
  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("What's on your mind?\n");
    return NotusDocument.fromDelta(delta);
  }
}

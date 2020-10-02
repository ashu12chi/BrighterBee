import 'package:brighter_bee/providers/zefyr_image_delegate.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
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
      mode: ZefyrMode.view,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top:30.0,left: 8.0,right: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(radius: 20.0,backgroundColor: Colors.grey,),
                Padding(
                  padding: const EdgeInsets.only(left:5.0),
                  child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Ashutosh Chitranshi',style: TextStyle(color: Colors.black,fontSize: 16.0)),
                            Icon(Icons.arrow_right),
                            Text('NP Devs')
                          ],
                        ),
                        Text('02/10/2020 18:54                  ',style: TextStyle(color: Colors.grey),)
                  ],
                )
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  alignment: Alignment.topRight,
                )
              ],
            ),
            Expanded (
              child: ZefyrScaffold(
                child: editor,
              ),
            ),
            Row(
              children: <Widget>[
                Text('24',style: TextStyle(color: Colors.black,fontSize: 15),),
                IconButton(icon:Icon(Icons.arrow_upward),),
                Text('11',style: TextStyle(color: Colors.black,fontSize: 15),),
                IconButton(icon:Icon(Icons.arrow_downward),),
                Text('53',style: TextStyle(color: Colors.black,fontSize: 15),),
                IconButton(icon:Icon(Icons.remove_red_eye),),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8),
                  child: Text('6',style: TextStyle(color: Colors.black,fontSize: 15),),
                ),
                FlatButton(
                  child: Text('  Comments  ',style: TextStyle(color: Colors.grey,fontSize: 15),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black)
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("ashu12_chi\nThis is a sample post\n");
    return NotusDocument.fromDelta(delta);
  }
}

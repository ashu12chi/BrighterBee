import 'package:flutter/material.dart';

/*
* @author : Ashutosh Chitranshi
* 19-10-2020 08:28
* This widget will be helpful in editing text
*/

class EditText extends StatefulWidget {
  final String startValue;

  EditText(this.startValue);

  @override
  _EditTextState createState() => _EditTextState(startValue);
}

class _EditTextState extends State<EditText> {
  String startValue;
  TextEditingController _controller;

  _EditTextState(this.startValue);

  void initState() {
    super.initState();
    _controller = TextEditingController(text: startValue);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, startValue);
        return Future.value(false);
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 40, left: 8, right: 8),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).buttonColor),
                    ),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: FlatButton(
                      child: Text("Save Changes"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey)),
                      onPressed: () {
                        Navigator.pop(context, _controller.text);
                      }),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: FlatButton(
                      child: Text("Discard Changes"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey)),
                      onPressed: () {
                        Navigator.pop(context, startValue);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

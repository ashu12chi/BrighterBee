import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _Test createState() => _Test();
}

class _Test extends State<Test> {
  TextEditingController ctrl;
  List<String> users = ['Naveen', 'Ram', 'Satish', 'Some Other'], words = [];
  String str = '';
  List<String> coments = [];

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Comment',
            hintStyle: TextStyle(color: Colors.black),
            suffixIcon: IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  if (ctrl.text.isNotEmpty)
                    setState(() {
                      coments.add(ctrl.text);
                    });
                }),
          ),
          style: TextStyle(
            color: Colors.black,
          ),
          onChanged: (val) {
            setState(() {
              words = val.split(' ');
              str = words.length > 0 && words[words.length - 1].startsWith('@')
                  ? words[words.length - 1]
                  : '';
            });
          }),
      str.length > 1
          ? ListView(
              shrinkWrap: true,
              children: users.map((s) {
                if (('@' + s).contains(str))
                  return ListTile(
                      title: Text(
                        s,
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        String tmp = str.substring(1, str.length);
                        setState(() {
                          str = '';
                          ctrl.text += s
                              .substring(s.indexOf(tmp) + tmp.length, s.length)
                              .replaceAll(' ', '_');
                        });
                      });
                else
                  return SizedBox();
              }).toList())
          : SizedBox(),
      SizedBox(height: 25),
      coments.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: coments.length,
              itemBuilder: (con, ind) {
                return Text.rich(
                  TextSpan(
                      text: '',
                      children: coments[ind].split(' ').map((w) {
                        return w.startsWith('@') && w.length > 1
                            ? TextSpan(
                                text: ' ' + w,
                                style: TextStyle(color: Colors.blue),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => showProfile(w),
                              )
                            : TextSpan(
                                text: ' ' + w,
                                style: TextStyle(color: Colors.black));
                      }).toList()),
                );
              },
            )
          : SizedBox()
    ])));
  }

  showProfile(String s) {
    showDialog(
        context: context,
        builder: (con) => AlertDialog(
            title: Text('Profile of $s'),
            content: Text('Show the user profile !')));
  }
}

import 'package:brighter_bee/app_screens/user_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Extra extends StatefulWidget {
  @override
  _ExtraState createState() => _ExtraState();
}

class _ExtraState extends State<Extra> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search,color: Colors.grey,),
            iconSize: 30.0,
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserSearch()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Ashutosh Chitranshi',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      Text(
                        'See your profile\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t',
                        style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.black12,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.people),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Communities'),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Following'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.bookmark),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Saved'),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.drafts),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Drafts'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: SizedBox(
                width: double.infinity,
                height: 67,
                child: Card(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.help),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          'Help & Support',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 67,
              child: Card(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Settings and Privacy',
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 67,
              child: Card(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

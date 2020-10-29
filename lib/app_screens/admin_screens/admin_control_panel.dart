import 'package:brighter_bee/app_screens/admin_screens/add_admins.dart';
import 'package:brighter_bee/app_screens/admin_screens/view_admins.dart';
import 'package:brighter_bee/app_screens/admin_screens/view_reports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminControlPanel extends StatefulWidget {
  final community;

  AdminControlPanel(this.community);

  @override
  _AdminControlPanelState createState() => _AdminControlPanelState(community);
}

class _AdminControlPanelState extends State<AdminControlPanel> {
  final community;

  _AdminControlPanelState(this.community);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Admin Control Panel',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('communities')
              .doc(community)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          snapshot.data['photoUrl'],
                          fit: BoxFit.fill,
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Card(
                              elevation: 8,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddAdmins(community)));
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 20,
                                            right: 20),
                                        child: Text(
                                          'Add admins',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Icon(Icons.person_add)
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Card(
                                elevation: 8,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewAdmins(community)));
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 20,
                                            right: 20),
                                        child: Text(
                                          'View admins',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Icon(Icons.person)
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Card(
                              elevation: 8,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewReports(community)));
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 20,
                                            right: 20),
                                        child: Text(
                                          'View Reports',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Icon(Icons.report)
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Card(
                              elevation: 8,
                              child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 20,
                                            right: 20),
                                        child: Text(
                                          'Delete Community',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Icon(Icons.delete_forever)
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

import 'package:brighter_bee/app_screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// @author: Ashutosh Chitranshi
// Oct 20, 2020
// This is for searching users from extra section

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  TextEditingController searchController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    super.dispose();
  }

  void initState() {
    searchController.addListener(() {
      print(searchController.text);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search users',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: (searchController.text != "" &&
                    searchController.text != null)
                ? FirebaseFirestore.instance
                    .collection('users')
                    .where('nameSearch',
                        arrayContains: searchController.text.toLowerCase())
                    .snapshots()
                : FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: Container(),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data.docs[index];
                        print(documentSnapshot['name']);
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Profile(documentSnapshot.id)));
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                child: SizedBox(
                                  height: 40,
                                  child: Text(
                                    documentSnapshot['name'],
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                                child: Container(
                                  height: 1.0,
                                  width: double.infinity,
                                  color: Theme.of(context).dividerColor,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
            }));
  }
}

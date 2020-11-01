import 'package:brighter_bee/app_screens/community_screens/community_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// @author: Nishchal Siddharth Pandey
// Oct 12, 2020
// This will be used for searching posts in community

class CommunitySearch extends StatefulWidget {
  @override
  _CommunitySearchState createState() => _CommunitySearchState();
}

class _CommunitySearchState extends State<CommunitySearch> {
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
                  hintText: 'Search communities',
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
            stream:
                (searchController.text != "" && searchController.text != null)
                    ? FirebaseFirestore.instance
                        .collection('communities')
                        .where('nameSearch',
                            arrayContains: searchController.text.toLowerCase())
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('communities')
                        .snapshots(),
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
                        print(documentSnapshot.id);
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CommunityHome(documentSnapshot.id)));
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                child: SizedBox(
                                  height: 40,
                                  child: Text(
                                    documentSnapshot.id,
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

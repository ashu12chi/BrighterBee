import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostSearch extends StatefulWidget {
  @override
  _PostSearchState createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch> {
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
                hintText: 'Search',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
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
        stream: (searchController.text != "" && searchController.text != null)
            ? FirebaseFirestore.instance
                .collection('communities')
                .doc('Mathematics')
                .collection('posts')
                .doc('posted')
                .collection('2020-10-10')
                .where('titleSearch', arrayContains: searchController.text)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('communities')
                .doc('Mathematics')
                .collection('posts')
                .doc('posted')
                .collection('2020-10-10')
                .snapshots(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];
                    print(documentSnapshot['title']);
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: SizedBox(
                        height: 50,
                        child: Card(
                            child: Center(
                          child: Text(
                            documentSnapshot['title'],
                            style: TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// @author: Ashutosh Chitranshi
// 18-10-2020 17:05
// This will be used for editing details of the user

class EditDetails extends StatefulWidget {
  @override
  _EditDetailsState createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  String username;
  FirebaseAuth _auth = FirebaseAuth.instance;
  void initState() {
    super.initState();
    username = _auth.currentUser.displayName;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile',),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(username).snapshots(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting?CircularProgressIndicator():Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Text('Profile Picture',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                Container(
                  margin: EdgeInsets.only(top:20,bottom: 20,left: 40,right: 40),
                  width: 200,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: snapshot.connectionState==ConnectionState.waiting?CircularProgressIndicator():NetworkImage(snapshot.data['photoUrl']),
                        fit: BoxFit.fill
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Motto',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    IconButton(icon: Icon(Icons.edit),)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 10.0, right: 10,bottom: 5),
                  child: Center(
                      child: Text(
                        snapshot.data['motto'],
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.home),
                    IconButton(icon: Icon(Icons.edit),)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 10.0, right: 10,bottom: 5),
                  child: Center(
                      child: Text(
                        'Lives in ${snapshot.data['homeTown']}, India',
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.location_on),
                    IconButton(icon: Icon(Icons.edit),)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 10.0, right: 10,bottom: 5),
                  child: Center(
                      child: Text(
                        'From ${snapshot.data['currentCity']}, India',
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.link),
                    IconButton(icon: Icon(Icons.edit),)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 10.0, right: 10,bottom: 5),
                  child: Center(
                      child: Text(
                        snapshot.data['website'],
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: FlatButton(
                      child: Text("Save Details"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey))),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

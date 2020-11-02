/*
* @author: Nishchal Siddharth Pandey
* 14 October, 2020
* This file helps manage Post entry data to and from firestore database.
*/

class PostEntry {
  int time;
  String text;

  PostEntry({this.time, this.text});

  Map<String, dynamic> toMap() {
    return {'time': time, 'text': text};
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*
* @author: Ashutosh Chitranshi
* Oct 28,2020
* This is helpful in calculating formula for hotness for displaying posts in feed/profile
 */

double calculateHotness(
    int time, int downvotes, int upvotes, int views, int comments) {
  int ans = comments + 4 * upvotes - 2 * downvotes + views;
  double value = log(time % 100000) / log(10);
  print(ans);
  print(value);
  return ans + value;
}

Future<double> updateHotness(String community, String postKey) async {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('communities/$community/posts')
      .doc(postKey);
  try {
    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        throw Exception('Post doesn\'t exist');
      }
      int time = snapshot.data()['time'];
      int downvotes = snapshot.data()['time'];
      int upvotes = snapshot.data()['time'];
      int views = snapshot.data()['time'];
      int comments = snapshot.data()['time'];

      double hotnessValue =
          calculateHotness(time, downvotes, upvotes, views, comments);

      transaction.update(documentReference, {'weight': hotnessValue});
      return hotnessValue;
    });
  } catch (e) {
    debugPrint('Failed to update post weight: ' + e.toString());
    return -1;
  }
}

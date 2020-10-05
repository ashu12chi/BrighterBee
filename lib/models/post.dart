import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String creator, mediaUrl, title, content, key;
  final int upvote, downvote, views, time, mediaType;

  Post(
      {this.creator,
      this.mediaUrl,
      this.title,
      this.content,
      this.upvote,
      this.downvote,
      this.views,
      this.time,
      this.key,
      this.mediaType});

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      creator: doc['creator'],
      mediaUrl: doc['mediaUrl'],
      title: doc['title'],
      content: doc['content'],
      upvote: doc['upvote'],
      downvote: doc['downvote'],
      views: doc['views'],
      time: doc['time'],
      key: doc['key'],
      mediaType: doc['mediaType'],
    );
  }
}

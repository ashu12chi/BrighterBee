import 'package:cloud_firestore/cloud_firestore.dart';

/*
* @author: Nishchal Siddharth Pandey
* 3 October, 2020
* This file helps manage post data to and from firestore database.
*/

class Post {
  final String creator, mediaUrl, title, content;
  final int upvotes,
      downvotes,
      views,
      time,
      mediaType,
      commentCount,
      lastModified;
  final List<String> upvoters, downvoters, viewers, listOfMedia, titleSearch;

  Post({
    this.creator,
    this.mediaUrl,
    this.title,
    this.content,
    this.upvotes,
    this.downvotes,
    this.views,
    this.time,
    this.mediaType,
    this.downvoters,
    this.upvoters,
    this.listOfMedia,
    this.commentCount,
    this.lastModified,
    this.titleSearch,
    this.viewers,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      creator: doc['creator'],
      mediaUrl: doc['mediaUrl'],
      title: doc['title'],
      content: doc['content'],
      upvotes: doc['upvotes'],
      downvotes: doc['downvotes'],
      views: doc['views'],
      time: doc['time'],
      mediaType: doc['mediaType'],
      downvoters: doc['downvoters'],
      upvoters: doc['upvoters'],
      listOfMedia: doc['listOfMedia'],
      commentCount: doc['commentCount'],
      lastModified: doc['lastModified'],
      titleSearch: doc['titleSearch'],
      viewers: doc['viewers'],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

/*
* @author: Nishchal Siddharth Pandey
* 3 October, 2020
* This file helps manage post data to and from firestore and sqlite databases.
*/

class Post {
  final String creator, mediaUrl, title, content, community;
  final int upvotes,
      downvotes,
      views,
      time,
      mediaType,
      commentCount,
      lastModified;
  final List upvoters, downvoters, viewers, listOfMedia, titleSearch;
  final bool isVerified;
  final double weight;

  Post(
      {this.creator,
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
      this.isVerified,
      this.community,
      this.weight});

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
        community: doc['community'],
        isVerified: doc['isVerified'],
        weight: doc['weight']);
  }

  Map<String, dynamic> toJson() => {
        'creator': creator,
        'mediaUrl': mediaUrl,
        'title': title,
        'content': content,
        'upvotes': upvotes,
        'downvotes': downvotes,
        'views': views,
        'time': time,
        'mediaType': mediaType,
        'downvoters': downvoters,
        'upvoters': upvoters,
        'listOfMedia': listOfMedia,
        'commentCount': commentCount,
        'lastModified': lastModified,
        'titleSearch': titleSearch,
        'viewers': viewers,
        'community': community,
        'isVerified': isVerified,
        'weight': weight
      };

  factory Post.fromJson(Map<String, dynamic> map) {
    return Post(
        creator: map['creator'],
        mediaUrl: map['mediaUrl'],
        title: map['title'],
        content: map['content'],
        upvotes: map['upvotes'],
        downvotes: map['downvotes'],
        views: map['views'],
        time: map['time'],
        mediaType: map['mediaType'],
        downvoters: map['downvoters'],
        upvoters: map['upvoters'],
        listOfMedia: map['listOfMedia'],
        commentCount: map['commentCount'],
        lastModified: map['lastModified'],
        titleSearch: map['titleSearch'],
        viewers: map['viewers'],
        community: map['community'],
        isVerified: map['isVerified'],
        weight: map['weight']);
  }
}

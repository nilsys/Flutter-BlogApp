import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/util/constants.dart' as constants;
import 'package:timeago/timeago.dart' as timeago;

class Post {
  String id;
  String name;
  String username;
  String date;
  String title;
  String content;
  String image;
  int likes;
  bool liked;
  String userId;
  Post(
      {this.id,
      this.name,
      this.username,
      this.date,
      this.title,
      this.content,
      this.image,
      this.likes,
      this.userId,
      this.liked});

  Post.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map[constants.name];
    username = map[constants.userName];
    // Date conversion Needed!!
    title = map[constants.title];
    content = map[constants.content];
    image = map[constants.img];

    likes = map[constants.likes];
    date = _ago(map[constants.timestamp]);
    liked = false;
    userId = map[constants.uid]; 

  }

  _ago(Timestamp t) {
    return timeago.format(t.toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      constants.uid :userId,
      constants.name: name,
      constants.id: id,
      constants.userName: username,
      constants.title: title,
      constants.content: content,
      constants.img: image,
      constants.likes: likes,
      constants.timestamp: FieldValue.serverTimestamp()
    };
  }
}

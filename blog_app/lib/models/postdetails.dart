import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/util/constants.dart' as constants;

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
  Post(
      {this.id,
      this.name,
      this.username,
      this.date,
      this.title,
      this.content,
      this.image,
      this.likes,
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
  }

  Map<String, dynamic> toMap() {
    return {
      constants.name: name,
      constants.id: id,
      constants.userName: username,
      constants.title: title,
      constants.content: content,
      constants.img: image,
      constants.likes: likes , 
      constants.timestamp : FieldValue.serverTimestamp() 
    };
  }
}

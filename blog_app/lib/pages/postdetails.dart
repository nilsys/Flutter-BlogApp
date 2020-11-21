import 'package:flutter/material.dart';

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

  Post({this.id, this.name, this.username, this.date, this.title, this.content, this.image, this.likes, this.liked});
}